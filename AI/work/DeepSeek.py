import os
from deepseek import Deepseek

# Recommended: Use environment variables to manage your API key
os.environ["DEEPSEEK_API_KEY"] = "your_api_key_here"

# Initialize the DeepSeek client
client = Deepseek(
    api_key=os.getenv("DEEPSEEK_API_KEY"),
    base_url="https://api.deepseek.com/v1",
    timeout=30  # Seconds
)

def chat_with_deepseek(prompt, temperature=0.7):
    response = client.chat.completions.create(
        model="deepseek-chat",
        messages=[
            {"role": "system", "content": "You are a professional AI assistant."},
            {"role": "user", "content": prompt}
        ],
        temperature=temperature,
        max_tokens=1024,
        stream=False
    )
    return response.choices[0].message.content

# Example usage
answer = chat_with_deepseek("Implement quicksort in Python and explain the principle.")
print(answer)

def stream_chat(prompt):
    full_response = []
    for chunk in client.chat.completions.create(
        model="deepseek-chat",
        messages=[{"role": "user", "content": prompt}],
        stream=True
    ):
        content = chunk.choices[0].delta.content
        if content:
            full_response.append(content)
            print(content, end="", flush=True)  # Print as it streams
    return "".join(full_response)

# Real-time interactive experience
stream_chat("Explain the Transformer architecture in detail.")

response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "Analyze the time complexity of this Python code."},
                {"type": "code", "language": "python", "content": """
def fibonacci(n):
    if n <= 1:
        return n
    else:
        return fibonacci(n-1) + fibonacci(n-2)
                """}
            ]
        }
    ]
)

# Legal domain Q&A
legal_response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[
        {"role": "system", "content": "You are a senior legal consultant."},
        {"role": "user", "content": "What are the key points of the 2023 Labor Contract Law amendments?"}
    ],
    knowledge_base=[  #  This is a hypothetical feature.  Check DeepSeek's docs.
        {
            "title": "2023 Labor Law Amendments",
            "content": "Full text of the latest revised labor law..."
        }
    ]
)

from functools import lru_cache
import hashlib

@lru_cache(maxsize=1000)
def cached_chat(prompt, temperature=0.7):
    # Generate a unique cache key
    cache_key = hashlib.md5(f"{prompt}-{temperature}".encode()).hexdigest()
    return client.chat.completions.create(
        model="deepseek-chat",
        messages=[{"role": "user", "content": prompt}],
        temperature=temperature
    )

from concurrent.futures import ThreadPoolExecutor

def batch_chat(prompts, max_workers=5):
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(chat_with_deepseek, p) for p in prompts]
        return [f.result() for f in futures]

# Batch processing example
results = batch_chat([
    "Explain the principles of quantum computing.",
    "Write a poem about spring.",
    "Implement a CNN using PyTorch."
])

def financial_analysis(report_text):
    analysis = client.chat.completions.create(
        model="deepseek-chat",
        messages=[
            {"role": "system", "content": "You are a top financial analyst."},
            {"role": "user", "content": f"Analyze the following financial report: {report_text}"}
        ],
        tools=[ #Check if deepseek supports tools
            {
                "type": "function",
                "function": {
                    "name": "calculate_ratios",
                    "description": "Calculate key financial ratios.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "current_ratio": {"type": "number"},
                            "roe": {"type": "number"}
                        },
                        "required": ["current_ratio", "roe"]
                    }
                }
            }
        ]
    )
    return analysis

class CustomerServiceBot:
    def __init__(self):
        self.context = []

    def respond(self, query):
        self.context.append({"role": "user", "content": query})

        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=self.context[-5:],  # Keep the last 5 turns of conversation
            presence_penalty=0.5,
            frequency_penalty=0.5
        )

        answer = response.choices[0].message.content
        self.context.append({"role": "assistant", "content": answer})
        return answer

from deepseek import APITimeoutError
try:
    response = client.chat.completions.create(...)
except APITimeoutError:
    print("Request timed out. Suggestions: 1. Check network connection. 2. Reduce max_tokens. 3. Implement a retry mechanism.")

def smart_truncate(text, max_tokens=120000):
    # Intelligent truncation while preserving paragraph integrity
    paragraphs = text.split('\n')
    truncated = []
    current_length = 0

    for p in paragraphs:
        p_length = len(p.encode()) * 0.75  # Approximate token count (UTF-8)
        if current_length + p_length > max_tokens:
            break
        truncated.append(p)
        current_length += p_length

    return '\n'.join(truncated)
