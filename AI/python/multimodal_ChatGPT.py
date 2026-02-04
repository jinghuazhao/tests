# ===========================
# ViLT + CIFAR-10 Multimodal Training Script
# ===========================

import torch
from torch import nn, optim
from torch.utils.data import DataLoader
from torchvision import transforms
from datasets import load_dataset
from transformers import ViltProcessor, ViltModel
from PIL import Image
from tqdm import tqdm

# ---------------------------
# 1️⃣ Device
# ---------------------------
device = "cuda" if torch.cuda.is_available() else "cpu"
print("Using device:", device)

# ---------------------------
# 2️⃣ Load CIFAR-10
# ---------------------------
dataset = load_dataset("cifar10")
train_dataset = dataset["train"]
test_dataset = dataset["test"]

id2label = {0:"airplane",1:"automobile",2:"bird",3:"cat",4:"deer",
            5:"dog",6:"frog",7:"horse",8:"ship",9:"truck"}

# ---------------------------
# 3️⃣ Image Transform
# ---------------------------
transform = transforms.Compose([
    transforms.Resize((224, 224)),  # ViLT expects 224x224
    transforms.ToTensor(),
])

# ---------------------------
# 4️⃣ Collate Function
# ---------------------------
def collate_fn(batch):
    images = [transform(item['img']) for item in batch]  # Already PIL Images
    texts = [f"This is a {id2label[item['label']]}" for item in batch]
    labels = torch.tensor([item['label'] for item in batch])
    return images, texts, labels

# ---------------------------
# 5️⃣ DataLoaders
# ---------------------------
batch_size = 16

train_loader = DataLoader(
    train_dataset,
    batch_size=batch_size,
    shuffle=True,
    collate_fn=collate_fn
)

test_loader = DataLoader(
    test_dataset,
    batch_size=batch_size,
    shuffle=False,
    collate_fn=collate_fn
)

# ---------------------------
# 6️⃣ ViLT Processor & Backbone
# ---------------------------
model_id = "dandelin/vilt-b32-finetuned-vqa"

processor = ViltProcessor.from_pretrained(model_id)
backbone = ViltModel.from_pretrained(model_id)

# ---------------------------
# 7️⃣ Custom ViLT Classifier
# ---------------------------
class ViLTForCIFAR10(nn.Module):
    def __init__(self, backbone, num_labels=10):
        super().__init__()
        self.backbone = backbone
        self.classifier = nn.Linear(backbone.config.hidden_size, num_labels)

    def forward(self, input_ids=None, pixel_values=None, attention_mask=None, **kwargs):
        outputs = self.backbone(
            input_ids=input_ids,
            pixel_values=pixel_values,
            attention_mask=attention_mask
        )
        pooled = outputs.pooler_output  # (batch_size, hidden_size)
        logits = self.classifier(pooled)
        return logits

model = ViLTForCIFAR10(backbone, num_labels=10).to(device)

# ---------------------------
# 8️⃣ Loss & Optimizer
# ---------------------------
loss_fn = nn.CrossEntropyLoss()
optimizer = optim.AdamW(model.parameters(), lr=5e-5)

# ---------------------------
# 9️⃣ Training Loop
# ---------------------------
epochs = 3

for epoch in range(epochs):
    model.train()
    total_loss = 0
    for images, texts, labels in tqdm(train_loader, desc=f"Epoch {epoch+1}"):
        labels = labels.to(device)

        # Process images + text
        inputs = processor(images=images, text=texts, return_tensors="pt", padding=True)
        inputs = {k:v.to(device) for k,v in inputs.items()}

        # Forward pass
        logits = model(**inputs)
        loss = loss_fn(logits, labels)

        # Backward
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        total_loss += loss.item()

    avg_loss = total_loss / len(train_loader)
    print(f"Epoch {epoch+1} - Training Loss: {avg_loss:.4f}")

# ---------------------------
# 10️⃣ Evaluation
# ---------------------------
model.eval()
correct = 0
total = 0

with torch.no_grad():
    for images, texts, labels in tqdm(test_loader, desc="Evaluating"):
        labels = labels.to(device)
        inputs = processor(images=images, text=texts, return_tensors="pt", padding=True)
        inputs = {k:v.to(device) for k,v in inputs.items()}

        logits = model(**inputs)
        preds = torch.argmax(logits, dim=-1)
        correct += (preds == labels).sum().item()
        total += labels.size(0)

acc = correct / total
print(f"Test Accuracy: {acc*100:.2f}%")
