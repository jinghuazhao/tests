# AI experimental results

This directory contains established experiments.

## Chat over Fibonacci numbers

- [deepseek-r1.md](deepseek-r1.md). Query to DeepSeek R1.
- [chatgpt.md](chatgpt.md). ChatGPT search results.

## Scripts

1. [ImageNet.md](ImageNet.md). ImageNet example through PyTorch.
2. [Scikit-learn.md](Scikit-learn.md). ML flavour examples.
3. [streamlit.py](streamlit.py) and [streamlit.sh](streamlit.sh). streamlit code.
4. [riddles.sb](riddles.sb). llama_cpp Python call from SLURM, giving [riddles.e](riddles.e) and [riddles.o](riddles.o).
5. A Retrieval-Augmented Generation (RAG) experiment involves the following files
    - [RAG.sb](RAG.sb). Python implementation wrapped in SLURM
    - [docs/](docs/). A directory contains documents.
    - [RAG.o](RAG.o)/[RAG.e](RAG.e). SLURM output.
    - [chroma_db/](chroma_db). Databases.
    - [llama-run](llama-run). Script to run the downloaded model.
6. [PMC-LLaMA.py](PMC-LLaMA.py). PMC-LLaMA documentation example.

An externalshowcase is available from <https://github.com/gurezende/Basic-Rag>, which needs a
file `scripts/secret.py` with a line `OPENAI_KEY=''` as well as `pip install langchain-openai`.

## Location of cache

```bash
export TRANSFORMERS_CACHE=/path/to/custom/cache
export HF_HOME=/path/to/custom/cache
```
