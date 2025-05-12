from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.chains import create_retrieval_chain
from langchain.llms import OpenAI

# 1. Load and split document
loader = TextLoader("doc.txt")
documents = loader.load()
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
texts = text_splitter.split_documents(documents)

# 2. Create vector database
embeddings = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(texts, embeddings)

# 3. Construct query chain
llm = OpenAI()
retriever = vectorstore.as_retriever()
qa_chain = create_retrieval_chain(retriever=retriever, llm=llm)

# 4. Query and get answer
result = qa_chain.run("How many core components are there in LangChain?")
print(result)

