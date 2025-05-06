# A summary

This directory contains established experiments.

Name | Description
-----|------------------------------------------
[ImageNet.md](ImageNet.md)* | ImageNet example
[riddles.sb](riddles.sb)* | A case for SLURM
[Scikit-learn.md](Scikit-learn.md)* | ML example
[streamlit.py](streamlit.py)* | streamlit code

Note those marked with asterisk (*) go through smoothly.

A Retrieval-Augmented Generation (RAG) experiment involves the following files

- [RAG.sb](RAG.sb). Python implementation wrapped in SLURM
- [docs/](docs/). A directory contains documents.
- [RAG.o](RAG.o)/[RAG.e](RAG.e). SLURM output.
- [chroma_db/](chroma_db). Databases.

A showcase is available from <https://github.com/gurezende/Basic-Rag>, which needs a
file `scripts/secret.py` with a line `OPENAI_KEY=''` as well as `pip install langchain-openai`.
