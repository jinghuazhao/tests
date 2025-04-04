# LLMs

Web: <https://skllm.beastbyte.ai/>, <https://github.com/BeastByteAI/scikit-llm>

## Preliminaries

This includes package installations, download of HuggingFace model and creation of a data directory.

```bash
pip install huggingface_hub
pip uninstall llama_index
pip install llama-index --upgrade
pip install llama-index-llms-huggingface
pip install llama-index-embeddings-huggingface
pip install openpyxl
pip uninstall scikit-llm
pip install scikit-llm --upgrade
pip install scikit-llm[gpt4all]
pip install transformers
pip show scikit-llm
mkdir data
```

Two approaches are shown with model downloading.

```python
from huggingface_hub import snapshot_download
model_id = "gpt2"
snapshot_download(repo_id=model_id, local_dir="./gpt2_model")
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('sentence-transformers/bert-base-nli-mean-tokens')
model_path = './bert-base-nli-mean-tokens'
model.save(model_path)
```

Options for `model_id` include 'gpt2', 'gpt2-medium', 'gpt2-large', 'gpt2-xl'.
OpenAI can be set up as follows,

```python
import skllm
from skllm.config import SKLLMConfig
import os
from dotenv import load_dotenv
load_dotenv()
OPENAI_SECRET_KEY = os.getenv("OPENAI_SECRET_KEY")
OPENAI_ORG_ID = os.getenv("OPENAI_ORG_ID")
SKLLMConfig.set_openai_key(OPENAI_SECRET_KEY)
SKLLMConfig.set_openai_org(OPENAI_ORG_ID)
```

with `.env` containing

```
OPENAI_SECRET_KEY=your_openai_secret_key
OPENAI_ORG_ID=your_openai_organization_id
```

## Implementation

### GPT2

```python
from transformers import GPT2LMHeadModel, GPT2Tokenizer
model_name = "./gpt2_model"
model = GPT2LMHeadModel.from_pretrained(model_name)
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
prompt = "Why is the sky blue?"
inputs = tokenizer.encode(prompt, return_tensors="pt")
outputs = model.generate(inputs, max_length=100, temperature=0.7, num_return_sequences=1)
generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(generated_text)
```

which just gets going so we seek to improve,

```python
from transformers import GPT2LMHeadModel, GPT2Tokenizer
model_name = "./gpt2_model"
model = GPT2LMHeadModel.from_pretrained(model_name)
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
prompt = "Why is the sky blue?"
inputs = tokenizer.encode(prompt, return_tensors="pt")
outputs = model.generate(
    inputs,
    max_length=100,
    temperature=0.7,       # Controls randomness: lower is less random
    top_k=50,              # Limits sampling to top 50 tokens
    top_p=0.95,            # Nucleus sampling: considers tokens with cumulative probability >= 95%
    repetition_penalty=1.2,# Penalizes repeated tokens
    num_return_sequences=1,
    do_sample=True         # Enables sampling; set to False for greedy decoding
)
generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(generated_text)
```

### HuggingFaceLLM

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.llms.huggingface import HuggingFaceLLM
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
from pathlib import Path

DATA_DIR = "./data"
MODEL_NAME = "./gpt2_model"
if not Path(DATA_DIR).exists():
    raise FileNotFoundError(f"The directory {DATA_DIR} does not exist. Please add documents.")

try:
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModelForCausalLM.from_pretrained(MODEL_NAME)
    llm = HuggingFaceLLM(
        model_name=MODEL_NAME,
        tokenizer=tokenizer,
        model=model,
        device_map="cuda" if torch.cuda.is_available() else "cpu",
        max_new_tokens=512,
    )
except Exception as e:
    raise RuntimeError(f"Failed to load model {MODEL_NAME}: {str(e)}")

try:
    documents = SimpleDirectoryReader(DATA_DIR).load_data()
    if not documents:
        raise ValueError(f"No documents found in {DATA_DIR}.")
    index = VectorStoreIndex.from_documents(documents, llm=llm, embed_model='local')
except Exception as e:
    raise RuntimeError(f"Error creating index: {str(e)}")

query = "Does the results concern about peptides?"
try:
    response = index.query(query)
    print("Query response:")
    print(response)
except Exception as e:
    print(f"Error querying the index: {str(e)}")

```

The `SimpleDirectoryReader` in **LlamaIndex** loads the following document types from a specified directory. By default, it attempts to 
read all files as text.

* Text Files: .txt (plain text), .md (Markdown)
* Office Documents: .docx (Microsoft Word), .pptx (Microsoft PowerPoint), .csv (Comma-Separated Values)
* E-books and Notebooks: .epub (EPUB eBook), .ipynb (Jupyter Notebook)
* Images: .jpeg, .jpg, .png
* Audio and Video: .mp3, .mp4
* PDF Documents: .pdf
* Email Archives: .mbox
* Hangul Word Processor: .hwp

### llama

See <https://cambridge-ceu.github.io/csd3/systems/setup.html#fn:llama_cpp> for setup.

```python
from langchain_community.llms import LlamaCpp
llm = LlamaCpp(model_path='DeepSeek-V3-0324-UD-IQ2_XXS.gguf')
response = llm.invoke('Why the sky is blue?')
print(response)
```

or

```python
import llama_cpp
model = llama_cpp.Llama(
    model_path="DeepSeek-V3-0324-UD-IQ2_XXS.gguf",
    chat_format="llama-2",
)
print(model.create_chat_completion(
    messages=[{
        "role": "user",
        "content": "what is the meaning of life?"
    }]
))
```

```python
from llama_cpp import Llama

llm = Llama.from_pretrained(
	repo_id="unsloth/DeepSeek-V3-0324-GGUF",
	filename="BF16/DeepSeek-V3-0324-BF16-00001-of-00030.gguf",
)
llm.create_chat_completion(
	messages = [
		{
			"role": "user",
			"content": "What is the capital of France?"
		}
	]
)
```

A SLURM script is as follows,

```bash
#!/usr/bin/bash

#SBATCH --account PETERS-SL3-CPU
#SBATCH --partition icelake-himem
#SBATCH --mem=28800
#SBATCH --time=12:00:00
#SBATCH --job-name=_gguf
#SBATCH --output=/home/jhz22/l.o
#SBATCH --error=/home/jhz22/l.e

. /etc/profile.d/modules.sh
module purge
module load rhel8/default-icl

export TMPDIR=${HPC_WORK}/work

source ~/rds/public_databases/software/py3.11/bin/activate

cd ${HPC_WORK}/ollama

python <<END
import llama_cpp
model = llama_cpp.Llama(
    model_path="DeepSeek-V3-0324-UD-IQ2_XXS.gguf",
    chat_format="llama-2",
)
print(model.create_chat_completion(
    messages=[{
        "role": "user",
        "content": "what is the meaning of life?"
    }]
))
END

deactivate
```

giving,

```
{'id': 'chatcmpl-6759d2f7-b858-4268-a127-93964ba3d393', 'object': 'chat.completion', 'created': 1743284201, 'model': 'DeepSeek-V3-0324-UD-IQ2_XXS.gguf', 'choices': [{'index': 0, 'message': {'role': 'assistant', 'content': 'The meaning of life is a philosophical question that has been debated for centuries, and there is no single, universally accepted answer. Different cultures, religions, and philosophical traditions offer various perspectives on the purpose and significance of human existence. Here are a few common viewpoints:\n\n1. **Religious Perspectives**: Many religions propose that the meaning of life is tied to a divine purpose. For example:\n   - In Christianity, it may involve loving God and others, and fulfilling God\'s plan.\n   - In Buddhism, it might be about achieving enlightenment and escaping the cycle of suffering (samsara).\n   - In Islam, it could be about submitting to Allah\'s will and living a righteous life.\n\n2. **Philosophical Perspectives**:\n   - **Existentialism** (e.g., Jean-Paul Sartre, Albert Camus) suggests that life has no inherent meaning, and it is up to each individual to create their own purpose through choices and actions.\n   - **Stoicism** emphasizes living in harmony with nature, cultivating virtue, and focusing on what one can control.\n   - **Utilitarianism** (e.g., John Stuart Mill) might argue that the meaning of life is to maximize happiness and reduce suffering for the greatest number of people.\n\n3. **Scientific Perspective**: From a biological standpoint, life\'s "meaning" could be seen as survival, reproduction, and the propagation of genes. However, this is a descriptive rather than prescriptive view.\n\n4. **Personal Meaning**: Many people find meaning in relationships, creativity, personal growth, contributing to society, or pursuing passions and goals.\n\nUltimately, the meaning of life is deeply personal and may vary from person to person. It’s a question you might explore through reflection, experiences, and the values you hold dear. </s>'}, 'logprobs': None, 'finish_reason': 'stop'}], 'usage': {'prompt_tokens': 17, 'completion_tokens': 363, 'total_tokens': 380}}
```
### Ollama

As documented elsewhere, our setup is as follows,

```bash
module load ceuadmin/ollama
ollama serve &
ollama pull qwen
ollama list
```

which enables the following,

```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_ollama.llms import OllamaLLM

template = """Question: {question}
              Answer: Let's think logically."""

prompt = ChatPromptTemplate.from_template(template)
model = OllamaLLM(model="qwen")

chain = prompt | model
chain.invoke({"question": "What is the result of dividing 36 by 9?"})
```

We see that,

```
'To solve this, we can follow these steps:\n\n1. Write down the division problem: \\( \\frac{36}{9}}{ } \\).\n2. Factor out common factors from both numbers in the numerator.\n3. Divide the remaining numbers to find the quotient.\n4. Write the final result as an equation with the dividend and divisor on one side of the equals sign, and the quotient on the other side.\n\nApplying these steps to our division problem \\( \\frac{36}{9}}{ } \\), we get:\n\n\\( \\frac{36 \\div 9 = 4}}{ } \\)\n\nTherefore, the result of dividing 36 by 9 is 4.'
```

Alternatively, one can do `ollama run hf.co/unsloth/DeepSeek-R1-Distill-Llama-70B-GGUF:Q3_K_M`.

Speedup with SLURM is not effective,

```bash
#!/usr/bin/bash

#SBATCH --job-name=_ollama
#SBATCH --account PETERS-SL3-CPU
#SBATCH --partition icelake-himem
#SBATCH --mem=28800
#SBATCH --time=12:00:00
#SBATCH --error=/home/jhz22/AnythingLLMDesktop/_ollama_%A_%a.err
#SBATCH --output=/home/jhz22/AnythingLLMDesktop/_ollama_%A_%a.out
#SBATCH --export ALL

. /etc/profile.d/modules.sh
module purge
module load rhel8/default-icl
module load ceuadmin/ollama

export TMPDIR=/rds/user/jhz22/hpc-work/work
export output=/home/jhz22/AnythingLLMDesktop/gemma3.txt

touch $output
ollama serve &
sleep 1m
ollama run gemma3 "Why the sky is blue?" >> $output
```

### LangChain

```python
from huggingface_hub import login
login(token="YOUR TOKEN HERE")
generator = pipeline("text-generation", model="gpt2")
llm = HuggingFacePipeline(pipeline=generator)
template = "What is the capital of {country}?"
prompt = PromptTemplate(input_variables=["country"], template=template)
llm_chain = LLMChain(prompt=prompt, llm=llm)
response = llm_chain.run(country="Germany")
print(response)
generator = pipeline("text-generation", model="gpt2")
llm = HuggingFacePipeline(pipeline=generator)
template = "What is the capital of {country}?"
prompt = PromptTemplate(input_variables=["country"], template=template)
llm_chain = LLMChain(prompt=prompt, llm=llm)
response = llm_chain.run(country="Germany")
print(response)
```

giving

```
What is the capital of Germany?

The state of Bavaria has been called Austria, Germany, for decades, and it is very rare in modern history that the government is described as a sovereign entity, which I think is very insulting.
```

An update is suggested as follows,

```
from langchain.prompts import PromptTemplate
from langchain_huggingface import HuggingFacePipeline
from transformers import pipeline
generator = pipeline("text-generation", model="gpt2")
llm = HuggingFacePipeline(pipeline=generator)
template = "What is the capital of {country}?"
prompt = PromptTemplate(input_variables=["country"], template=template)
llm_chain = prompt | llm
response = llm_chain.invoke({"country": "Germany"})
print(response)
```

### Scikit-LLM

See <https://cambridge-ceu.github.io/csd3/Python/Scikit-LLM%20&%20OpenAI%20API.html>.

### vLLM

```bash
# Install vLLM from pip:
pip install vllm
# Load and run the model:
vllm serve "unsloth/DeepSeek-V3-0324-GGUF"
# Call the server using curl:
curl -X POST "http://localhost:8000/v1/chat/completions" \
	-H "Content-Type: application/json" \
	--data '{
		"model": "unsloth/DeepSeek-V3-0324-GGUF",
		"messages": [
			{
				"role": "user",
				"content": "What is the capital of France?"
			}
		]
	}'
```
