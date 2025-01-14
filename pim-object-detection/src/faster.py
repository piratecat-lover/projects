import torch
import torchvision
import torchvision.transforms as transforms
from torchvision.models.detection import FasterRCNN
from torchvision.models.detection.rpn import AnchorGenerator
from torchvision.datasets import ImageFolder
from torch.utils.data import DataLoader
import os
import tarfile

# Define device
device = torch.device('cuda') if torch.cuda.is_available() else torch.device('cpu')

# Uncompress CUB-200-2011 dataset if compressed
tar_path = 'CUB_200_2011.tgz'
if not os.path.exists('CUB_200_2011') and os.path.exists(tar_path):
    with tarfile.open(tar_path, 'r:gz') as tar:
        tar.extractall('CUB_200_2011')

# Load the CUB-200-2011 dataset
# Assuming the dataset is organized in an ImageFolder-compatible format
transform = transforms.Compose([
    transforms.ToTensor(),
])

dataset = ImageFolder(root='CUB_200_2011/images', transform=transform)
dataloader = DataLoader(dataset, batch_size=2, shuffle=True, num_workers=2, collate_fn=lambda x: tuple(zip(*x)))

# Load a pre-trained backbone for Faster R-CNN
backbone = torchvision.models.resnet50(pretrained=True)
backbone = torch.nn.Sequential(*list(backbone.children())[:-2])
backbone.out_channels = 2048

# Define the anchor generator for the FPN which is used in Faster R-CNN
anchor_generator = AnchorGenerator(
    sizes=((32, 64, 128, 256, 512),),
    aspect_ratios=((0.5, 1.0, 2.0),) * 5
)

# Define the Region of Interest (RoI) Pooler
roi_pooler = torchvision.ops.MultiScaleRoIAlign(
    featmap_names=['0'],
    output_size=7,
    sampling_ratio=2
)

# Build the Faster R-CNN model
num_classes = 201  # Set this to the number of classes in the CUB-200-2011 dataset (200 bird species + 1 background)
model = FasterRCNN(
    backbone,
    num_classes=num_classes,
    rpn_anchor_generator=anchor_generator,
    box_roi_pool=roi_pooler
)

# Move model to device
model.to(device)

# Define optimizer and learning rate scheduler
optimizer = torch.optim.SGD(params=[p for p in model.parameters() if p.requires_grad], lr=0.005, momentum=0.9, weight_decay=0.0005)
lr_scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=3, gamma=0.1)

# Training loop
def train(model, dataloader, optimizer, lr_scheduler, device, num_epochs):
    model.train()
    for epoch in range(num_epochs):
        epoch_loss = 0
        for images, targets in dataloader:
            images = list(image.to(device) for image in images)
            targets = [{'boxes': torch.tensor([[0.0, 0.0, 1.0, 1.0]], device=device), 'labels': torch.tensor([1], device=device)} for _ in images]  # Placeholder targets, replace with actual annotations

            # Zero the gradient
            optimizer.zero_grad()

            # Forward pass
            loss_dict = model(images, targets)
            losses = sum(loss for loss in loss_dict.values())
            
            # Backward pass
            losses.backward()
            optimizer.step()

            epoch_loss += losses.item()

        # Update learning rate
        lr_scheduler.step()
        print(f"Epoch [{epoch+1}/{num_epochs}], Loss: {epoch_loss}")

# Start training
train(model, dataloader, optimizer, lr_scheduler, device, num_epochs=10)

# Save the model
torch.save(model.state_dict(), 'faster_rcnn_cub200.pth')

# Vessl-specific code
import vessl
vessl.init()

# Log training process to Vessl
train(model, dataloader, optimizer, lr_scheduler, device, num_epochs=10)

# Save the model
vessl.log({'model_path': 'faster_rcnn_cub200.pth'})
