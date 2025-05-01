---

# 🦙 Building a RAG System Using PDF Files and `llama.cpp`

This document guides you through creating a Retrieval-Augmented Generation (RAG) pipeline using `llama.cpp`, PDF documents, and a vector database.

---

## 1. Set Up the Llama 3.2 Model with `llama.cpp`

Clone the `llama.cpp` repository and build the project:

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make
```

Download the quantized Llama 3.2 model and place it in the `models/` directory.

Run the model using:

```bash
./llama-cli -m models/llama-3.2-1B-4bit.bin -p "Hello, Llama!"
```

This command initializes the model and processes the prompt.

---

## 2. Extract Text from PDF Documents

Use `PyMuPDF` to extract text from a PDF:

```python
import fitz  # PyMuPDF

def extract_text_from_pdf(pdf_path):
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text()
    return text

pdf_text = extract_text_from_pdf("your_document.pdf")
```

This function reads the PDF and concatenates the text from all pages.

---

## 3. Chunk the Text

Split the text into manageable chunks:

```python
from llama_index.core.node_parser import TokenTextSplitter

splitter = TokenTextSplitter(chunk_size=512, chunk_overlap=128, separator=" ")
chunks = splitter.get_nodes_from_documents([pdf_text])
```

This splits the text into chunks of 512 tokens with a 128-token overlap between chunks.

---

## 4. Generate Embeddings for Chunks

Use a pre-trained embedding model:

```python
from sentence_transformers import SentenceTransformer

embed_model = SentenceTransformer('all-MiniLM-L6-v2')
embeddings = embed_model.encode([chunk.text for chunk in chunks])
```

Each chunk is encoded into a vector using the embedding model.

---

## 5. Store Embeddings in a Vector Database

Use **Weaviate** to store and retrieve the embeddings:

```python
import weaviate

client = weaviate.Client("http://localhost:8080")

# Define schema
client.schema.create_class({
    "class": "Document",
    "properties": [
        {"name": "content", "dataType": ["text"]},
        {"name": "embedding", "dataType": ["number[]"]}
    ]
})

# Add documents
for i, chunk in enumerate(chunks):
    client.data_object.create({
        "content": chunk.text,
        "embedding": embeddings[i].tolist()
    }, "Document")
```

This stores each chunk along with its embedding.

---

## 6. Query the Vector Database

To retrieve relevant chunks:

```python
query = "What is the main topic of the document?"
query_embedding = embed_model.encode([query])

# Perform vector search
results = client.query.get("Document", ["content"]).with_near_vector({
    "vector": query_embedding[0].tolist(),
    "certainty": 0.7
}).do()

# Display results
for result in results['data']['Get']['Document']:
    print(result['content'])
```

This retrieves the most relevant chunks based on the query.

---

## 7. Generate a Response Using `llama.cpp`

Use the model to generate a response using the retrieved context:

```bash
./llama-cli -m models/llama-3.2-1B-4bit.bin -p "Based on the following context, answer the question: [context] Question: {query}"
```

Replace `[context]` with the concatenated text of the retrieved chunks and `{query}` with the user's question.

---

## 🔗 Additional Resources

- **[LlamaParse](https://medium.com/kx-systems/rag-llamaparse-advanced-pdf-parsing-for-retrieval-c393ab29891b)** – Advanced PDF parsing for structured content like tables.
- **[LlamaIndex](https://docs.llamaindex.ai/en/stable/examples/low_level/oss_ingestion_retrieval/)** – Framework for end-to-end RAG pipelines.

---

Let me know if you'd like this saved as a `.md` file or integrated into a GitHub project!
