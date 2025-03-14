import torch
import argparse
from torch.utils.data import DataLoader
from datasets.four_leaf_clovers import FourLeafCloversDataset
from models.mask_rcnn_pim import MaskRCNNPIMWrapper
from datasets.transforms import DetectionTransforms

def test_model(model, data_loader, device):
    model.eval()
    all_predictions = []
    for images, targets in data_loader:
        images = list(img.to(device) for img in images)
        with torch.no_grad():
            outputs = model(images)  # predictions
        all_predictions.extend(outputs)
    # Compute evaluation metrics (mAP, accuracy, etc.)
    # This depends on your evaluation metrics and ground truth data format.

def main():
    parser = argparse.ArgumentParser(description="Test Mask R-CNN + PIM model")
    parser.add_argument("--data-root", type=str, required=True)
    parser.add_argument("--annotations", type=str, required=True)
    parser.add_argument("--checkpoint", type=str, required=True)
    parser.add_argument("--batch-size", type=int, default=2)
    parser.add_argument("--subset", type=int, default=None)
    args = parser.parse_args()

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    transform = DetectionTransforms(resize=(512, 512))
    dataset = FourLeafCloversDataset(
        root=args.data_root,
        annotations=args.annotations,
        transform=transform,
        subset=args.subset
    )
    data_loader = DataLoader(dataset, batch_size=args.batch_size, shuffle=False, collate_fn=lambda x: tuple(zip(*x)))

    # Initialize model (with the number of classes used during training)
    num_classes = 5
    model = MaskRCNNPIMWrapper(num_classes=num_classes)
    model.load_state_dict(torch.load(args.checkpoint, map_location=device))
    model.to(device)

    test_model(model, data_loader, device)

if __name__ == "__main__":
    main()