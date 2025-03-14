import torch
import argparse
from torch.utils.data import DataLoader
from datasets.four_leaf_clovers import FourLeafCloversDataset
from models.mask_rcnn_pim import MaskRCNNPIMWrapper
from datasets.transforms import DetectionTransforms
import os

def train_one_epoch(model, optimizer, data_loader, device):
    model.train()
    for images, targets in data_loader:
        images = list(img.to(device) for img in images)
        targets = [{k: v.to(device) for k,v in t.items()} for t in targets]

        losses_dict = model(images, targets)
        losses = sum(loss for loss in losses_dict.values())

        optimizer.zero_grad()
        losses.backward()
        optimizer.step()

def main():
    parser = argparse.ArgumentParser(description="Train Mask R-CNN + PIM model")
    parser.add_argument("--data-root", type=str, required=True)
    parser.add_argument("--annotations", type=str, required=True)
    parser.add_argument("--batch-size", type=int, default=2)
    parser.add_argument("--epochs", type=int, default=10)
    parser.add_argument("--lr", type=float, default=0.0001)
    parser.add_argument("--subset", type=int, default=None, help="If provided, limits dataset size.")
    args = parser.parse_args()

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    # Create dataset and dataloader
    transform = DetectionTransforms(resize=(512, 512))
    dataset = FourLeafCloversDataset(
        root=args.data_root,
        annotations=args.annotations,
        transform=transform,
        subset=args.subset
    )
    data_loader = DataLoader(dataset, batch_size=args.batch_size, shuffle=True, collate_fn=lambda x: tuple(zip(*x)))

    # Initialize model
    num_classes = 5  # Example: depends on your dataset
    model = MaskRCNNPIMWrapper(num_classes=num_classes)
    model.to(device)

    optimizer = torch.optim.Adam(model.parameters(), lr=args.lr)

    for epoch in range(args.epochs):
        train_one_epoch(model, optimizer, data_loader, device)
        # Save checkpoint
        torch.save(model.state_dict(), f"checkpoint_epoch_{epoch}.pth")

if __name__ == "__main__":
    main()