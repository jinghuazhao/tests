[![Resnet-18网络图示理解-腾讯云开发者社区 ...](https://images.openai.com/thumbnails/14f33d3ea70888832cd8776ec3955c42.png)](https://cloud.tencent.com/developer/article/2053549)

To implement ResNet-18 using the `torchvision` package in PyTorch, you can utilize the pre-trained model provided by the library. Here's a step-by-step guide:

### 🧱 1. Import Necessary Libraries

```python
import torch
import torchvision
import torchvision.transforms as transforms
from torch.utils.data import DataLoader
```

### 🖼️ 2. Define Image Transformations

```python
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
```

### 📦 3. Load the Dataset

```python
train_dataset = torchvision.datasets.CIFAR10(
    root='./data', train=True, download=True, transform=transform
)
test_dataset = torchvision.datasets.CIFAR10(
    root='./data', train=False, download=True, transform=transform
)

train_loader = DataLoader(train_dataset, batch_size=64, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=64, shuffle=False)
```

### 🧠 4. Initialize the Model

```python
model = torchvision.models.resnet18(weights=True)
model.fc = torch.nn.Linear(model.fc.in_features, 10)  # Adjusting for CIFAR-10 classes
model = model.to(torch.device("cuda" if torch.cuda.is_available() else "cpu"))
```

### ⚙️ 5. Define Loss Function and Optimizer

```python
criterion = torch.nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
```

### 🚀 6. Train the Model

```python
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model.to(device)

num_epochs = 10
for epoch in range(num_epochs):
    model.train()
    running_loss = 0.0
    for inputs, labels in train_loader:
        inputs, labels = inputs.to(device), labels.to(device)
        
        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        
        running_loss += loss.item()
    
    print(f"Epoch [{epoch+1}/{num_epochs}], Loss: {running_loss/len(train_loader):.4f}")
```

### 📊 7. Evaluate the Model

```python
model.eval()
correct = 0
total = 0
with torch.no_grad():
    for inputs, labels in test_loader:
        inputs, labels = inputs.to(device), labels.to(device)
        outputs = model(inputs)
        _, predicted = torch.max(outputs, 1)
        total += labels.size(0)
        correct += (predicted == labels).sum().item()

accuracy = 100 * correct / total
print(f'Accuracy of the model on the 10,000 test images: {accuracy:.2f}%')
```

This implementation utilizes the pre-trained ResNet-18 model from `torchvision`, fine-tuning it for the CIFAR-10 dataset. The model is adjusted by modifying the fully connected layer (`model.fc`) to output 10 classes, corresponding to the CIFAR-10 dataset.
