# AI API

## 1. DeepSeek

### 1.1 API Docs

Web: <https://api-docs.deepseek.com/>

```bash
curl https://api.deepseek.com/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <DeepSeek API Key>" \
  -d '{
        "model": "deepseek-chat",
        "messages": [
          {"role": "system", "content": "Why the sky is blue?"},
          {"role": "user", "content": "Hello!"}
        ],
        "stream": false
      }'
```

```python
from openai import OpenAI

client = OpenAI(api_key="<DeepSeek API Key>", base_url="https://api.deepseek.com")

response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[
        {"role": "system", "content": "Why the sky is blue?"},
        {"role": "user", "content": "Hello"},
    ],
    stream=False
)

print(response.choices[0].message.content)
```

### 1.2 deepseek-sdk

Web: <https://pypi.org/project/deepseek-sdk/>

It turns out `pip install deepseek-sdk` only `deepseek_sdk-0.1.0.dist-info/` is available, and manual installation as this

```bash
git clone https://github.com/Pro-Sifat-Hasan/deepseek-python.git
cd deepseek-python
pip install -e .
```

enables `from deepseek import DeepSeekClient, DeepSeekError, DeepSeekAPIError`. As documented, this goes

```python
from deepseek import DeepSeekClient
client = DeepSeekClient(api_key="your-api-key")
response = client.chat_completion(
    messages=[{"role": "user", "content": "Hello, how are you?"}]
)
print(response.choices[0].message.content)
```

### 1.3 deepseek-cli-pro

Web: <https://pypi.org/project/deepseek-cli-pro/>

```bash
pip install deepseek-cli-pro
pip install markdown
deepseek configure
deepseek chat
deepseek generate "Why the sky is blue?" --temperature 0.5
```

### 1.4 WebGPU

Web: <https://huggingface.co/spaces/webml-community/deepseek-r1-webgpu>

### 1.5 DeepSeek.md

The .py and .ipynb files are obtained as follows,

```bash
module load ceuadmin/node
cat DeepSeek.md | \
codedown python > DeepSeek.py
notedown DeepSeek.md > DeepSeek.ipynb
jupyter nbconvert --to html DeepSeek.ipynb
```

where the `codedown` module is made available with `npm install -g codedown`.

## 2. OLMoE

Web: <https://github.com/allenai/OLMoE>

```python
from transformers import OlmoeForCausalLM, AutoTokenizer
import torch

DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
model = OlmoeForCausalLM.from_pretrained("allenai/OLMoE-1B-7B-0125").to(DEVICE)
tokenizer = AutoTokenizer.from_pretrained("allenai/OLMoE-1B-7B-0125")
inputs = tokenizer("Why the sky is blue", return_tensors="pt")
inputs = {k: v.to(DEVICE) for k, v in inputs.items()}
out = model.generate(**inputs, max_length=64)
print(tokenizer.decode(out[0]))
```

We see that

```
Why sky is blue?

The sky is blue because of the scattering of light. The blue color is due to the scattering of light by the molecules of the atmosphere. The blue color is due to the shorter wavelength of light.
```

Somehow the last sentence is repeated.

## 3. LLM

```bash
pip install llm
llm install llm-ollama
llm -m 'hf.co/unsloth/DeepSeek-R1-Distill-Llama-70B-GGUF:Q3_K_M' \
    'a joke about a pelican and a walrus who run a tea room together'
```
