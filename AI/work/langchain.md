# LangChain components

LangChain was created by Harrison Chase in October 2022, with six components:

1. Models
2. Prompts
3. Chains
4. Agents
5. Memory
6. Indexes

## Setup

### Installations

```bash
pip install langchain openai faiss-cpu
export OPENAI_API_KEY="your-api-key"
```

### Service

```python
from langchain.serve import serve
serve(app, port=8000)
```

### Example

```python
from langchain.llms import QianfanLLM
llm = QianfanLLM(api_key="your-key", secret_key="your-secret")
response = llm("How to study Python?")
```

## A local document query

### Code extraction

This is done as follows,

```bash
module load ceuadmin/tesseract
tesseract --list-langs
tesseract langchain.jpeg langchain -l script/HanS
```

### langchain.py

This is modified slightly from `langchain.txt` above with additional changes.

## Acknowledgement

This is documenation is adapted a post on Toutiao (No URL).
