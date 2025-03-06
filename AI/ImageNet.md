# ImageNet

Web: <https://www.pinecone.io/learn/series/image-search/imagenet/#AlexNet-in-Action>

## Preliminaries

```bash
pip install datasets
pip install torchvision
```

## Implementation

```python
# data preprocessing
from datasets import load_dataset
dataset = load_dataset('zh-plus/tiny-imagenet')
print(dataset.keys())
dataset['train'][0]
dataset['train'][0]['image'].mode
img = dataset['train'][0]['image'].convert('RGB')
img
# resize image
from torchvision import transforms
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224)
])
new_img = preprocess(dataset['train'][0]['image'])
new_img
import torch
if new_img.ndimension() == 3:
    mean = torch.tensor([0.485, 0.456, 0.406]).view(3, 1, 1)
    std = torch.tensor([0.229, 0.224, 0.225]).view(3, 1, 1)
    new_img = (new_img - mean) / std
else:
    raise ValueError("Expected a 3D tensor with shape [C, H, W], got shape {}".format(new_img.shape))

from tqdm.auto import tqdm
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
inputs = []
for image in tqdm(dataset['train'][:50]['image']):
    if image.mode != 'RGB':
        image = image.convert("RGB")
    input_tensor = preprocess(image)
    inputs.append(input_tensor)

inputs = torch.stack(inputs)
inputs.size()
torch.Size([50, 3, 224, 224])
# load pretrained alexnet from pytorch hub
model = torch.hub.load('pytorch/vision:v0.10.0', 'alexnet', pretrained=True)
model.eval()
# Move to device if available
device = torch.device(
    'cuda' if torch.cuda.is_available() else (
        'mps' if torch.backends.mps.is_available() else 'cpu'
    )
)

# Move inputs and model to device
inputs = inputs.to(device)
model.to(device)

# Run the model
with torch.no_grad():
    output = model(inputs).detach()
    print(output.shape)

# prediction
preds = torch.argmax(output, dim=1).cpu().numpy()
print(preds.shape)
preds
import requests
res = requests.get("https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt")
pred_labels = res.text.split('\n')
print(f"{len(pred_labels)}\n{pred_labels[1]}")
sum(preds == 1) / len(preds)
```

We see 56% accurary, possibly due to a slightly different dataset as with parameter specification.
