# AI experiments

## DeepSeek API Docs

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

## DeepSeek.md

```bash
git clone https://github.com/Pro-Sifat-Hasan/deepseek-python.git
cd deepseek-python
pip install -e .
```

It turns out `pip install deepseek-sdk` only `deepseek_sdk-0.1.0.dist-info/` is available and manual installation via GitHub
only goes as far to enable `from deepseek import DeepSeekClient, DeepSeekError, DeepSeekAPIError`.


The .py and .ipynb files are obtained as follows,

```bash
module load ceuadmin/node
cat DeepSeek.md | \
codedown python > DeepSeek.py
notedown DeepSeek.md > DeepSeek.ipynb
jupyter nbconvert --to html DeepSeek.ipynb
```

where the `codedown` module is made available with `npm install -g codedown`.
