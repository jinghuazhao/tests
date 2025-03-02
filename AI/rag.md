# RAG example

## Preliminaries

```bash
# ollama
module load ceuadmin/ollama
ollama serve &
ollama list
ollama run deepseek-r1:32b
# streamlit, etc.
module load python/3.11.0-icl
python -m venv py3.11
source py3.11/bin/activate
pip install streamlit langchain-community langchain_experimental
pip install langchain-ollama
pip install sentence-transformers
pip install langchain-huggingface
pip install faiss-cpu
pip install pdfplumber
```

Now we issue

```bash
streamlit run rag.py
```

and see that

```
  You can now view your Streamlit app in your browser.

  Local URL: http://localhost:8501
  Network URL: http://128.232.224.15:8501

Loaded 9 pages.
First page content: n
```

See also <https://gist.github.com/lisakim0/>, <https://apidog.com/> (Web: <https://app.apidog.com/>)
