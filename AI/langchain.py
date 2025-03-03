from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.chains import RetrievalQA

# 1. load and split document

loader = TextLoader("doc.txt")
documents = loader.load()
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
texts = text_splitter.split_documents (documents)

# 2. create vector database

embeddings = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(texts,
embeddings)

# 3. construct query chains

ga_chain = RetrievalQA.from_chain_type(
11m=0penAI(),
chain_type="stuff",
retriever=vectorstore.as_retriever()
)

# 4. query and get answer

result = ga_chain.run("How many core components are there in LangChain? ")
print(result)
