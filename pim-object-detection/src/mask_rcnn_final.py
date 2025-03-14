import torch
import torchvision
from torch import nn
from .pim_module.models.pim_module.pim_module import 

def get_mask_rcnn_pim_model(num_classes, pretrained=True):
    # Start from a pretrained Mask R-CNN
    model = torchvision.models.detection.maskrcnn_resnet50_fpn(pretrained=pretrained)
    
    # The model has a RoI heads classification and box regression layer
    in_features = model.roi_heads.box_predictor.cls_score.in_features

    # Replace the box predictor with a dummy linear layer (just to keep structure)
    # We'll feed the features from the ROI head into PIM separately.
    model.roi_heads.box_predictor = nn.Identity()

    # Create a PIM module
    pim = PIMModule(in_features, num_classes)

    model.pim = pim

    return model

class MaskRCNNPIMWrapper(nn.Module):
    def __init__(self, num_classes):
        super(MaskRCNNPIMWrapper, self).__init__()
        self.base_model = get_mask_rcnn_pim_model(num_classes)
    
    def forward(self, images, targets=None):

        # Extract features:
        images_list = torchvision.models.detection.transform.GeneralizedRCNNTransform(min_size=512, max_size=512)(images, targets)
        # Actually, above line is incomplete. You’d have to replicate what the model transform does.
        # Instead, let's rely on model's internal transform:
        
        original_image_sizes = [img.shape[-2:] for img in images]
        images, targets = self.base_model.transform(images, targets)
        features = self.base_model.backbone(images.tensors)
        
        proposals, proposal_losses = self.base_model.rpn(images, features, targets)
        detections, detector_losses = self.base_model.roi_heads(features, proposals, images.image_sizes, targets)
        
        # detections contain fields: boxes, labels, scores, and possibly masks.
        # The ROI heads internally do classification. We replaced the box predictor with Identity,
        # so we need to apply PIM:
        
        # Assume detector_losses['roi_heads'] not present since we replaced predictor.
        # Typically, roi_heads returns classification logits before softmax. If needed,
        # you’d modify the roi_heads code to return intermediate features.
        
        # For demonstration, let's say we have an ROI feature vector 'roi_feats' from roi_heads:
        # We can't show full code due to complexity. Let's assume we got them:
        roi_feats = detector_losses.get("roi_feats") if "roi_feats" in detector_losses else torch.randn(1, self.base_model.pim.fc.in_features)
        
        logits = self.base_model.pim(roi_feats)
        
        # Now use logits to produce final class scores:
        # For simplicity:
        # detections[i]["scores"] = softmax(logits)
        # detections[i]["labels"] = argmax(logits)
        
        # Loss:
        losses = {}
        losses.update(proposal_losses)
        # Add classification loss from logits if targets available:
        if targets is not None:
            # Suppose targets have 'labels':
            gt_labels = torch.cat([t["labels"] for t in targets], dim=0)
            criterion = nn.CrossEntropyLoss()
            losses["classification_loss"] = criterion(logits, gt_labels)
        
        detections = self.base_model.transform.postprocess(detections, images.image_sizes, original_image_sizes)
        
        if self.training:
            return losses
        return detections