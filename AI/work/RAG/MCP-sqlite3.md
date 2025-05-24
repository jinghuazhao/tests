# How To Build RAG Applications Using Model Context Protocol

RAG applications built on MCP can bypass the overhead of embeddings and vector search — retrieving live, authoritative information on demand.

May 22nd, 2025 11:00am by [Janakiram MSV](https://thenewstack.io/author/janakiram/)

Building Retrieval-Augmented Generation (RAG) applications has become a cornerstone of modern AI, enabling large language models (LLMs) to ground their outputs in up-to-date, domain-specific knowledge. Traditionally, RAG pipelines relied on embeddings and vector databases to fetch relevant context at inference time. However, as AI systems grow more complex and the demand for real-time, secure and scalable integrations rises, Model Context Protocol (MCP) is emerging as a transformative standard — not just for tool invocation, but for the entire RAG ecosystem.

Resources in MCP are read-only, addressable data entities exposed by servers — such as files, database records, API responses, or even real-time market stats. Unlike tools, which are about “what the AI can do,” resources are about “what the AI should know” — they deliver structured, contextual data directly into the model’s working memory, ready for summarization, analysis, or factual grounding. This means RAG applications built on MCP can bypass the overhead of embeddings and vector search — retrieving live, authoritative information on demand (and always working with the freshest context). This is particularly important when dealing with data stored in a structured format, such as in relational and NoSQL databases.

What makes MCP resources especially compelling for RAG is their flexibility and discoverability. MCP servers can expose static or dynamic resources, support hierarchical data, and even annotate resources with metadata for smarter selection and prioritization. Clients can discover available resources at runtime, select what’s relevant, and retrieve it in a standardized, secure manner — enabling RAG workflows that are more transparent, auditable and adaptable than ever before.

This tutorial will show how to combine MCP resources with tools to implement RAG and tool invocation. The key thing to remember is that MCP resources are meant for accessing data in read-only form, while MCP tools are for performing actions that manipulate data.

Let’s start by populating a SQLite database with sample employee data. This will act as the data store for our MCP server.

```python
import sqlite3
import os

# Create db directory if it doesn't exist
os.makedirs('db', exist_ok=True)

# Connect to SQLite database (creates it if it doesn't exist)
conn = sqlite3.connect('db/employees.db')
cursor = conn.cursor()

# Create employees table
cursor.execute('''
CREATE TABLE IF NOT EXISTS employees (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    department TEXT,
    salary REAL,
    hire_date TEXT
)
''')

# Sample employee data
employees = [
    (1, 'John', 'Doe', 'john.doe@company.com', 'Engineering', 85000, '2020-01-15'),
    (2, 'Jane', 'Smith', 'jane.smith@company.com', 'Marketing', 78000, '2019-03-20'),
    (3, 'Michael', 'Johnson', 'michael.j@company.com', 'Sales', 92000, '2021-06-10'),
    (4, 'Emily', 'Williams', 'emily.w@company.com', 'HR', 65000, '2022-02-28'),
    (5, 'David', 'Brown', 'david.b@company.com', 'Engineering', 95000, '2018-11-05'),
    (6, 'Sarah', 'Davis', 'sarah.d@company.com', 'Finance', 88000, '2021-09-15'),
    (7, 'Robert', 'Miller', 'robert.m@company.com', 'Sales', 89000, '2020-07-22'),
    (8, 'Lisa', 'Wilson', 'lisa.w@company.com', 'Marketing', 82000, '2019-12-01'),
    (9, 'James', 'Taylor', 'james.t@company.com', 'Engineering', 91000, '2022-04-18'),
    (10, 'Jennifer', 'Anderson', 'jennifer.a@company.com', 'HR', 68000, '2021-11-30')
]

# Insert sample data
cursor.executemany('''
INSERT OR REPLACE INTO employees (id, first_name, last_name, email, department, salary, hire_date)
VALUES (?, ?, ?, ?, ?, ?, ?)
''', employees)

# Commit the changes and close the connection
conn.commit()
conn.close()

print("Database created successfully with 10 sample employee records!") 
```

Our aim is to build an MCP server that can retrieve data from this database using resources and manipulate the data using tools.

TRENDING STORIES

1. [A Practical Roadmap for Adopting Vibe Coding](https://thenewstack.io/a-practical-roadmap-for-vibe-coding-adoption/)
2. [Keeping Up With AI: The Painful New Mandate for Software Engineers](https://thenewstack.io/keeping-up-with-ai-the-painful-new-mandate-for-software-engineers/)
3. [How To Build RAG Applications Using Model Context Protocol](https://thenewstack.io/how-to-build-rag-applications-using-model-context-protocol/)
4. [Build a Python + ChatGPT-3.5 Chatbot in 10 Minutes](https://thenewstack.io/build-a-python-chatgpt-3-5-chatbot-in-10-minutes/)
5. [Vibe Coding Is Rapidly Reshaping the Software Developer Profession](https://thenewstack.io/vibe-coding-is-here-how-ai-is-reshaping-the-software-developer-profession/)

Let’s now build the MCP server to expose the resources and tools. Since we implement them as asynchronous methods, let’s install aiosqlite and, of course, the Python module for MCP, fastmcp.

```bash
pip install fastmcp aiosqlite
```

First, let’s add the resources to the MCP server.

```python
import aiosqlite
from fastmcp import FastMCP
from typing import List, Dict, Optional

mcp = FastMCP("Employee MCP Server")

DB_PATH = "/db/employees.db"

@mcp.resource("employees://all")
async def get_all_employees() -> List[Dict]:
    """Returns all employee records as a list of dictionaries."""
    async with aiosqlite.connect(DB_PATH) as conn:
        cursor = await conn.execute('SELECT * FROM employees')
        columns = [column[0] for column in cursor.description]
        employees = [dict(zip(columns, row)) async for row in cursor]
        await cursor.close()
    return employees


@mcp.resource("employees://{employee_id}")
async def get_employee_by_id(employee_id: int) -> Optional[Dict]:
    """Returns a single employee record based on employee ID."""
    async with aiosqlite.connect(DB_PATH) as conn:
        cursor = await conn.execute('SELECT * FROM employees WHERE id = ?', (employee_id,))
        row = await cursor.fetchone()
        if row:
            columns = [column[0] for column in cursor.description]
            result = dict(zip(columns, row))
        else:
            result = None
        await cursor.close()
    return result
	

```

We have two functions — get_all_employees() and get_employee_by_id — to retrieve all rows and a row by employee ID, respectively.

Notice how we annotated these two functions. The first one — @mcp.resource("employees://all") — acts as a moniker for the clients to get all the records, while the second function, annotated with @mcp.resource("employees://{employee_id}") accepts a parameter, which is the employee ID.

MCP clients can use these resources to retrieve context that can be passed to LLMs to ground their response.

The same MCP client may want to manipulate the data by updating and deleting existing records. This may be used by an AI agent that’s performing HR workflows. Let’s create an MCP tool for deleting an employee from the system.

```python
@mcp.tool()
async def delete_employee(employee_id: int) -> bool:
    """Deletes an employee record based on employee ID. Returns True if successful."""
    async with aiosqlite.connect(DB_PATH) as conn:
        try:
            cursor = await conn.execute('DELETE FROM employees WHERE id = ?', (employee_id,))
            await conn.commit()
            success = cursor.rowcount &gt; 0
            await cursor.close()
        except Exception:
            success = False
    return success

	
```

It’s time to write the main function that acts as an entry point.

```python
if __name__ == "__main__":
    mcp.run(transport="stdio")

```

Launch the MCP server to make the resources and tools available to the clients. We are using the stdio transport for simplicity.

It’s time to write the client to test if the MCP server is accessible and exposes the expected resources and tools.

```python
import asyncio
from fastmcp import Client

async def main():
    # Connect to the server via stdio (by running server.py as a subprocess)
    async with Client("server.py") as client:
        print("Listing resources:")
        resources = await client.list_resources()
        print(resources)
        print("\nListing tools:")
        tools = await client.list_tools()
        print(tools)
	

if __name__ == "__main__":
    asyncio.run(main())

```

If everything goes well, you should see the following output:

Congratulations! You have successfully created an MCP server with a combination of resources and tools. In the next part of this series, I will demonstrate how to integrate this with an LLM by building a RAG application powered by GPT-4.1. Stay tuned.
