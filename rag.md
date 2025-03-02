<https://apidog.com/> (Web: <https://app.apidog.com/>)

```bash
# ollama
module load ceuadmin/ollama
ollama serve &
ollama list
ollama run deepseek-r1:32b
# streamlit, etc.
source ~/rds/public_databases/software/miniconda37/bin/activate
conda install streamlit
```

```python
# step 1. library loading
import streamlit as st  
from langchain_community.document_loaders import PDFPlumberLoader  
from langchain_experimental.text_splitter import SemanticChunker  
from langchain_community.embeddings import HuggingFaceEmbeddings  
from langchain_community.vectorstores import FAISS  
from langchain_community.llms import Ollama
# step 2. PDF file uploading/parsing
uploaded_file = st.file_uploader("uploading PDF files", type="pdf")
if uploaded_file:
    with open("temp.pdf", "wb") as f:
        f.write(uploaded_file.getvalue())
    loader = PDFPlumberLoader("temp.pdf")
    docs = loader.load()
# step 3. text extraction
text_splitter = SemanticChunker(
    HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
)
documents = text_splitter.split_documents(docs)
# step 4. vector database creation
embeddings = HuggingFaceEmbeddings()
vector_store = FAISS.from_documents(documents, embeddings)
retriever = vector_store.as_retriever(search_kwargs={"k": 3})
# step 5. DeepSeek R1 configuration
llm = Ollama(model="deepseek-r1:32b")
prompt_template = """
Context: {context}

Question：{question}

Requirement for answer:
1. Only under given context
2. When unsure say "don't know for now".
3. Answer within four sentences.

Final answer:
"""
QA_PROMPT = PromptTemplate.from_template(prompt_template)
# step 6. RAG processing
llm_chain = LLMChain(llm=llm, prompt=QA_PROMPT)
document_prompt = PromptTemplate(
    template="Context:\n{page_content}\nSource:{source}",
    input_variables=["page_content", "source"]
)
qa = RetrievalQA(
    combine_documents_chain=StuffDocumentsChain(
        llm_chain=llm_chain,
        document_prompt=document_prompt
    ),
    retriever=retriever
)
# step 7. interactive interface
user_question = st.text_input("Input your question:")

if user_question:
    with st.spinner("Generating answers..."):
        response = qa(user_question)["result"]
        st.success(response)
```

See also <https://gist.github.com/lisakim0/>.
