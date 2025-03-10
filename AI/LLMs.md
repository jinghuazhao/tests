# Scikit-LLM

Web: <https://skllm.beastbyte.ai/>, <https://github.com/BeastByteAI/scikit-llm>

## Preliminaries

This includes package installations, download of HuggingFace model and creation of a data directory.

```bash
pip install huggingface_hub
pip uninstall llama_index
pip install llama-index --upgrade
pip install llama-index-llms-huggingface
pip install llama-index-embeddings-huggingface
pip install openpyxl
pip uninstall scikit-llm
pip install scikit-llm --upgrade
pip install scikit-llm[gpt4all]
pip install transformers
pip show scikit-llm
mkdir data
```

```python
from huggingface_hub import snapshot_download
model_id = "gpt2"
snapshot_download(repo_id=model_id, local_dir="./gpt2_model")
from transformers import GPT2LMHeadModel, GPT2Tokenizer
tokenizer = GPT2Tokenizer.from_pretrained("./gpt2_model")
model = GPT2LMHeadModel.from_pretrained("./gpt2_model")
```

Options for `model_id` include 'gpt2', 'gpt2-medium', 'gpt2-large', 'gpt2-xl'.
OpenAI can be set up as follows,

```python
from skllm.config import SKLLMConfig
import os
from dotenv import load_dotenv
load_dotenv()
OPENAI_SECRET_KEY = os.getenv("OPENAI_SECRET_KEY")
OPENAI_ORG_ID = os.getenv("OPENAI_ORG_ID")
SKLLMConfig.set_openai_key(OPENAI_SECRET_KEY)
SKLLMConfig.set_openai_org(OPENAI_ORG_ID)
```

with `.env` containing

```
OPENAI_SECRET_KEY=your_openai_secret_key
OPENAI_ORG_ID=your_openai_organization_id
```

## Implementation

### PyTorch

```python
import torch
input_text = "Why the sky is blue"
input_ids = tokenizer.encode(input_text, return_tensors="pt")
with torch.no_grad():
    output = model.generate(input_ids, max_length=100, num_return_sequences=1, no_repeat_ngram_size=2, temperature=0.7)
    generated_text = tokenizer.decode(output[0], skip_special_tokens=True)
    print(generated_text)

if tokenizer.pad_token is None:
   tokenizer.add_special_tokens({'pad_token': '<|pad|>'})
   tokenizer.pad_token_id = tokenizer.get_vocab()['<|pad|>']

inputs = tokenizer("Your input text here", return_tensors="pt", padding=True, truncation=True)
input_ids = inputs.input_ids
attention_mask = inputs.attention_mask
model = GPT2LMHeadModel.from_pretrained('gpt2')
outputs = model.generate(input_ids=input_ids, attention_mask=attention_mask, max_length=50)
outputs = model.generate(input_ids=input_ids, attention_mask=attention_mask, pad_token_id=tokenizer.pad_token_id, max_length=50)
generated_text = tokenizer.decode(output_ids[0], skip_special_tokens=True)
print(generated_text)
```

We see both versions of `outputs` are the same and `generated_text` is inappropriate, so we turn to this,

```python
import torch
from transformers import GPT2LMHeadModel, GPT2Tokenizer
tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
model = GPT2LMHeadModel.from_pretrained('gpt2')
input_text = "Why is the sky blue?"
input_ids = tokenizer.encode(input_text, return_tensors='pt')
with torch.no_grad():
    output_ids = model.generate(
        input_ids,
        max_length=100,
        temperature=0.8,
        top_k=50,
        top_p=0.95,
        repetition_penalty=1.2,
        num_return_sequences=1,
        no_repeat_ngram_size=2,
        length_penalty=1.0,
        early_stopping=True
    )
generated_text = tokenizer.decode(output_ids[0], skip_special_tokens=True)
print(generated_text)
```

giving,

> The answer to this question has been debated for years. The most recent study, published in Nature Communications on July 6, 2015 by researchers at Harvard University and Stanford's Center for Advanced Study of Astronomy (CASA), found that there are two types: a bright red light from an object called "the sun" or another type known as black-and white radiation emitted when it passes through space; which can be seen only with telescopes like NASA/JPL

The following are notable,

* Temperature: Controls the randomness of the output. Lower values make the output more focused and deterministic, while higher values increase diversity. Try setting the temperature between 0.7 and 1.0.
* Top-k Sampling: Limits the sampling pool to the top 'k' logits. Reducing 'k' can make the output more focused.
* Top-p (Nucleus) Sampling: Chooses from the smallest possible set of logits whose cumulative probability is greater than 'p'. This method balances diversity and coherence.
* Repetition Penalty: Penalizes repeated sequences to reduce redundancy.

### GPT2

```python
from transformers import GPT2LMHeadModel, GPT2Tokenizer
model_name = "./gpt2_model"
model = GPT2LMHeadModel.from_pretrained(model_name)
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
prompt = "Why is the sky blue?"
inputs = tokenizer.encode(prompt, return_tensors="pt")
outputs = model.generate(inputs, max_length=100, temperature=0.7, num_return_sequences=1)
generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(generated_text)
```

which gives a rather poor answer, which we seek to improve,

```python
from transformers import GPT2LMHeadModel, GPT2Tokenizer
model_name = "./gpt2_model"
model = GPT2LMHeadModel.from_pretrained(model_name)
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
prompt = "Why is the sky blue?"
inputs = tokenizer.encode(prompt, return_tensors="pt")
outputs = model.generate(
    inputs,
    max_length=100,
    temperature=0.7,       # Controls randomness: lower is less random
    top_k=50,              # Limits sampling to top 50 tokens
    top_p=0.95,            # Nucleus sampling: considers tokens with cumulative probability >= 95%
    repetition_penalty=1.2, # Penalizes repeated tokens
    num_return_sequences=1,
    do_sample=True         # Enables sampling; set to False for greedy decoding
)
generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(generated_text)
```

### HuggingFaceLLM

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.llms.huggingface import HuggingFaceLLM
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
from pathlib import Path

DATA_DIR = "./data"
MODEL_NAME = "./gpt2_model"
if not Path(DATA_DIR).exists():
    raise FileNotFoundError(f"The directory {DATA_DIR} does not exist. Please add documents.")

try:
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModelForCausalLM.from_pretrained(MODEL_NAME)
    llm = HuggingFaceLLM(
        model_name=MODEL_NAME,
        tokenizer=tokenizer,
        model=model,
        device_map="cuda" if torch.cuda.is_available() else "cpu",
        max_new_tokens=512,
    )
except Exception as e:
    raise RuntimeError(f"Failed to load model {MODEL_NAME}: {str(e)}")

try:
    documents = SimpleDirectoryReader(DATA_DIR).load_data()
    if not documents:
        raise ValueError(f"No documents found in {DATA_DIR}.")
    index = VectorStoreIndex.from_documents(documents, llm=llm, embed_model='local')
except Exception as e:
    raise RuntimeError(f"Error creating index: {str(e)}")

query = "Does the results concern about peptides?"
try:
    response = index.query(query)
    print("Query response:")
    print(response)
except Exception as e:
    print(f"Error querying the index: {str(e)}")

```

The `SimpleDirectoryReader` in **LlamaIndex** loads the following document types from a specified directory. By default, it attempts to 
read all files as text.

* Text Files: .txt (plain text), .md (Markdown)
* Office Documents: .docx (Microsoft Word), .pptx (Microsoft PowerPoint), .csv (Comma-Separated Values)
* E-books and Notebooks: .epub (EPUB eBook), .ipynb (Jupyter Notebook)
* Images: .jpeg, .jpg, .png
* Audio and Video: .mp3, .mp4
* PDF Documents: .pdf
* Email Archives: .mbox
* Hangul Word Processor: .hwp
