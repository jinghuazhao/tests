OlmOCR: The Top-Tier OCR Large Model for Local Deployment

March 11, 2025, 09:41·Positive Energy Image Recognizer

allenai/olmocr is an open-source toolkit developed by the Allen Institute for Artificial Intelligence (AI2). It is designed to efficiently convert PDFs and other documents into structured plain text while preserving the natural reading order.

Core Technologies:

1. Visual Language Model (VLM): Utilizes a model named olmOCR-7B-0225-preview, trained on the Qwen2-VL-7B-Instruct framework.
2. Training Data: The model was trained on approximately 250,000 pages of diverse PDF content (including scanned and text-based documents), annotated using GPT-4o and released as the olmOCR-mix-0225 dataset.

Key Features:

1. Efficient Batch Processing: Optimized inference pipeline using SGLang, enabling low-cost processing of large volumes of documents.
2. Document Anchoring: Extracts coordinates of prominent elements (e.g., text blocks and images) per page and injects them alongside raw text extracted from PDF binaries.
3. Local and Cluster Support: Runs on single-GPU machines or supports multi-node parallel processing via AWS S3.

Performance and Advantages:

1. High Accuracy: Ranked highest in ELO ratings for PDF extraction techniques during manual evaluations.
2. Enhanced Downstream Tasks: Text extracted by olmOCR, when used to train language models, improved accuracy by an average of 1.3 percentage points across multiple AI benchmarks.

Usage Example:

```python
import torch
import base64
import urllib.request
from io import BytesIO
from PIL import Image
from transformers import AutoProcessor, Qwen2VLForConditionalGeneration
from olmocr.data.renderpdf import render_pdf_to_base64png
from olmocr.prompts import build_finetuning_prompt
from olmocr.prompts.anchor import get_anchor_text

# Initialize the model
model = Qwen2VLForConditionalGeneration.from_pretrained("allenai/olmOCR-7B-0225-preview", torch_dtype=torch.bfloat16).eval()
processor = AutoProcessor.from_pretrained("Qwen/Qwen2-VL-7B-Instruct")
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)

# Download a sample PDF
urllib.request.urlretrieve("https://molmo.allenai.org/paper.pdf", "./paper.pdf")

# Render page 1 to an image
image_base64 = render_pdf_to_base64png("./paper.pdf", 1, target_longest_image_dim=1024)

# Build the prompt using document metadata
anchor_text = get_anchor_text("./paper.pdf", 1, pdf_engine="pdfreport", target_length=4000)
prompt = build_finetuning_prompt(anchor_text)

# Construct the full prompt
messages = [{
    "role": "user",
    "content": [
        {"type": "text", "text": prompt},
        {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{image_base64}"}},
    ],
}]

# Apply chat template and processor
text = processor.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
main_image = Image.open(BytesIO(base64.b64decode(image_base64)))

inputs = processor(
    text=[text], images=[main_image], padding=True, return_tensors="pt"
)
inputs = {key: value.to(device) for (key, value) in inputs.items()}

# Generate output
output = model.generate(
    **inputs, temperature=0.8, max_new_tokens=50, num_return_sequences=1, do_sample=True
)

# Decode output
prompt_length = inputs["input_ids"].shape[1]
new_tokens = output[:, prompt_length:]
text_output = processor.tokenizer.batch_decode(new_tokens, skip_special_tokens=True)

print(text_output)
# ['{"primary_language":"en","is_rotation_valid":true,"rotation_correction":0,"is_table":false,"is_diagram":false,"natural_text":"Molmo and PixMo:\\nOpen Weights and Open Data\\nfor State-of-the-art"}']
```

Recognition Results:

Recognition Example

Summary:

OlmOCR excels at structured and precise extraction of complex PDF content! It perfectly recognizes Chinese and English documents, blurred scans, and complex tables! Fully supports local deployment and end-to-end testing! A must-have for medical and legal industries! Effortlessly handles enterprise-level PDF batch conversion!
