import torch
import torch.nn as nn

class EEGNet(nn.Module):
    def __init__(self):
        super(EEGNet, self).__init__()
        # Define the layers
        self.conv1 = nn.Conv1d(in_channels=1, out_channels=1, kernel_size=15, stride=1, padding=0)
        self.conv2 = nn.Conv1d(1, 16, 15, stride=1, padding=0)
        self.pool1 = nn.MaxPool1d(2)
        self.conv3 = nn.Conv1d(16, 32, 15, stride=1, padding=0)
        self.pool2 = nn.MaxPool1d(2)
        self.conv4 = nn.Conv1d(32, 64, 15, stride=1, padding=0)
        self.conv5 = nn.Conv1d(64, 64, 15, stride=1, padding=0)
        self.pool3 = nn.MaxPool1d(44)  # This large kernel size effectively makes the dimension (2 x 64)
        self.fc1 = nn.Linear(2 * 64, 2)

    def forward(self, x):
        x = self.conv1(x)
        x = self.conv2(x)
        x = self.pool1(x)
        x = self.conv3(x)
        x = self.pool2(x)
        x = self.conv4(x)
        x = self.conv5(x)
        x = self.pool3(x)
        x = x.view(x.size(0), -1)  # Flatten the tensor
        x = self.fc1(x)
        return x

# Initialize the network
net = EEGNet()
print(net)