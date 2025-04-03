# A Practical Guide to Building Local RAG Applications with LangChain

*By Iván Palomares Carrascosa on April 2, 2025 in Practical Machine Learning*

![Image by Author | Ideogram](https://machinelearningmastery.com/wp-content/uploads/2025/03/aRA19PNURdefi6Uc03ovIw.jpeg)

**Retrieval Augmented Generation (RAG)** encompasses a family of systems that extend conventional language models, large and otherwise (LLMs), to incorporate context based on retrieved knowledge from a document base. This integration leads to more truthful and relevant responses to user queries.

In this context, **LangChain** has gained particular attention as a framework that simplifies the development of RAG applications. It provides orchestration tools for integrating LLMs with external data sources, managing retrieval pipelines, and handling complex workflows in a robust and scalable manner.

This article offers a practical, step-by-step guide to building a simple local RAG application with LangChain using Python. It serves as an introductory resource, supplementing the foundational concepts covered in the "Understanding RAG" series. If you're new to RAG and seek a theoretical background, consider reviewing that series first.

## Step-by-Step Practical Guide

Let's dive into building our first local RAG system with LangChain. For reference, the following diagram, adapted from "Understanding RAG Part II," illustrates a simplified version of a basic RAG system and its core components.

![A basic RAG scheme](https://machinelearningmastery.com/wp-content/uploads/2025/03/classicalrag.png)

**Figure 1:** A basic RAG scheme

**1. Installing Necessary Libraries**

First, install the required libraries and frameworks. The latest versions of LangChain may require `langchain-community`, so it's included in the installation. FAISS is a framework for efficient similarity search in a vector database. For loading and using existing LLMs, we'll use Hugging Face’s `transformers` and `sentence-transformers` libraries, the latter providing pre-trained models optimized for sentence-level text embeddings.

```bash
pip install langchain langchain_community faiss-cpu sentence-transformers transformers
```

**2. Importing Required Modules**

Next, import the necessary modules to begin coding.

```python
from langchain.llms import HuggingFacePipeline
from langchain.chains import RetrievalQA
from langchain.chains.question_answering import load_qa_chain
from langchain.prompts import PromptTemplate
from transformers import pipeline
from langchain_community.vectorstores import FAISS
```

**3. Preparing the Knowledge Base**

The core of a RAG system is its knowledge base, implemented as a vector database. This database stores text documents used for context retrieval, with information typically encoded as vector embeddings. For this example, we'll use a collection of nine short text documents describing various destinations in Eastern and Southeast Asia. The dataset is available in a compressed `.zip` file [here](https://github.com/gakudo-ai/open-datasets/raw/refs/heads/main/asia_documents.zip).

The following code downloads, decompresses, and extracts the text files locally:

```python
import os
import urllib.request
import zipfile

zip_url = "https://github.com/gakudo-ai/open-datasets/raw/refs/heads/main/asia_documents.zip"
zip_path = "asia_documents.zip"
extract_folder = "asia_txt_files"

print("Downloading zip file...")
urllib.request.urlretrieve(zip_url, zip_path)
print("Download complete!")

print("Extracting files...")
os.makedirs(extract_folder, exist_ok=True)
with zipfile.ZipFile(zip_path, "r") as zip_ref:
    zip_ref.extractall(extract_folder)

print(f"Files extracted to: {extract_folder}")

print("Extracted files:")
print(os.listdir(extract_folder))
```

**4. Chunking and Vector Embedding**

To efficiently process documents, split them into chunks and transform them into vector embeddings. Chunking is essential in RAG systems because LLMs have token limitations, and efficient retrieval requires splitting documents into manageable pieces while maintaining contextual integrity.

FAISS will handle efficiently storing and indexing the vector embeddings, enabling accurate and efficient similarity-based searches. The `as_retriever()` method integrates with LangChain’s retrieval methods, allowing dynamic retrieval of relevant document chunks to optimize the LLM’s responses.

For embedding creation, we'll use the Hugging Face model `sentence-transformers/all-MiniLM-L6-v2`.

```python
import os
from langchain_community.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.embeddings import HuggingFaceEmbeddings

folder_path = "asia_txt_files"

documents = []
for filename in os.listdir(folder_path):
    if filename.endswith(".txt"):
        file_path = os.path.join(folder_path, filename)
        loader = TextLoader(file_path)
        documents.extend(loader.load())

text_splitter = CharacterTextSplitter(chunk_size=500, chunk_overlap=100)
docs = text_splitter.split_documents(documents)

embedding_model = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

vectorstore = FAISS.from_documents(docs, embedding_model)
retriever = vectorstore.as_retriever()
```

**5. Defining the Language Model Pipeline**

Define an LLM pipeline for text generation using Hugging Face’s Transformers library and the GPT-2 model. The `device=0` argument ensures the model runs on a GPU (if available), significantly improving inference speed. The `max_new_tokens` argument controls the length of the generated response, preventing excessively long or truncated outputs while maintaining coherence.

```python
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain.chains import RetrievalQA
from transformers import pipeline

llm_pipeline = pipeline("text-generation", model="gpt2", device=0, max_new_tokens=200)
llm = HuggingFacePipeline(pipeline=llm_pipeline)
```

**6. Creating a Prompt Template and LLM Chain**

Define a prompt template that incorporates the retrieved context dynamically, ensuring the model generates responses grounded in relevant knowledge. This step aligns with the Augmentation block in the previously discussed RAG architecture.

Then, define an LLM chain, a key LangChain component that orchestrates the interaction between the LLM and the prompt template, ensuring a structured query-response flow.

```python
prompt_template = "Answer the following question based on the provided context: {context}\n\nQuestion: {query}\nAnswer:"

prompt = PromptTemplate(input_variables=["query", "context"], template=prompt_template)

llm_chain = LLMChain(llm=llm, prompt=prompt)
```

**7. Setting Up the RetrievalQA System**

Initialize a Question-Answering (QA) system using the `RetrievalQA` class. This class links the retriever with the LLM chain, completing the RAG system setup.

```python
retrieval_qa = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=retriever,
    verbose=True
)
```

**8. Implementing Token Truncation**

Define a function to ensure the augmented context stays within the LLM’s specified token limit, truncating the input when necessary.

```python
def truncate_to_max_tokens(text, max_tokens=500):
    tokens = text.split()
    if len(tokens) > max_tokens:
        return " ".join(tokens[:max_tokens])
    return text
```

**9. Testing the RAG 
