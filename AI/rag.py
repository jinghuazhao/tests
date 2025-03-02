# Step 1: Library Loading

import streamlit as st
from langchain_community.document_loaders import PDFPlumberLoader
from langchain_experimental.text_splitter import SemanticChunker
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_ollama import OllamaLLM
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain, RetrievalQA
from langchain.chains import create_retrieval_chain

# Step 2: PDF File Uploading/Parsing
uploaded_file = st.file_uploader("Upload a PDF file", type="pdf")
docs = []
if uploaded_file:
    with open("temp.pdf", "wb") as f:
        f.write(uploaded_file.getvalue())
    loader = PDFPlumberLoader("temp.pdf")
    docs = loader.load()

docs = "niu25.pdf"
if docs:
    print(f"Loaded {len(docs)} pages.")
    print(f"First page content: {docs[0][:500]}")
else:
    print("No documents loaded.")

# Step 3: Text Extraction
text_splitter = SemanticChunker(
    HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
)
documents = text_splitter.split_documents(docs)

print(f"Number of documents after splitting: {len(documents)}")
if len(documents) > 0:
    print(f"First document content: {documents[0][:500]}")

# Step 4: Vector Database Creation
embeddings = HuggingFaceEmbeddings()

first_embedding = embeddings.embed_query(documents[0])
print(f"Embedding shape for the first document: {len(first_embedding)}")

vector_store = FAISS.from_documents(documents, embeddings)

print("Vector store created.")

# Step 5: DeepSeek R1 Configuration
llm = OllamaLLM(model="deepseek-r1:32b")
prompt_template = """
Context: {context}

Question: {question}

Requirements for answer:
1. Only under given context
2. When unsure, say "don't know for now".
3. Answer within four sentences.

Final answer:
"""
QA_PROMPT = PromptTemplate.from_template(prompt_template)

# Step 6: RAG Processing
llm_chain = LLMChain(llm=llm, prompt=QA_PROMPT)
document_prompt = PromptTemplate(
    template="Context:\n{page_content}\nSource:{source}",
    input_variables=["page_content", "source"]
)
qa_chain = create_retrieval_chain(
    llm_chain=llm_chain,
    retriever=retriever,
    document_prompt=document_prompt
)

# Step 7: Interactive Interface
user_question = st.text_input("Input your question:")

if user_question:
    with st.spinner("Generating answers..."):
        response = qa_chain.run(user_question)
        st.success(response)
else:
    st.info("Please upload a PDF file to proceed.")

