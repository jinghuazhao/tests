import random
import networkx as nx
import matplotlib.pyplot as plt
from karateclub import Graph2Vec

# Number of random graphs to generate
n_graphs = 20

def generate_random():
    """
    Generate a random Watts–Strogatz small-world graph.
    n: number of nodes (6–20)
    k: each node connected to k nearest neighbors
    p: rewiring probability
    """
    n = random.randint(6, 20)
    k = random.randint(5, n)
    p = random.uniform(0, 1)
    return nx.watts_strogatz_graph(n, k, p)

# Create a list of graphs
Gs = [generate_random() for _ in range(n_graphs)]

# Initialize Graph2Vec model
model = Graph2Vec(dimensions=2)

# Fit model on generated graphs
model.fit(Gs)

# Retrieve the embeddings: shape is (n_graphs, 2)
embeddings = model.get_embedding()

# Plot embeddings
fig, ax = plt.subplots(figsize=(10, 10))
for i, vec in enumerate(embeddings):
    ax.scatter(vec[0], vec[1], s=300, alpha=0.7)
    ax.annotate(str(i), (vec[0], vec[1]), fontsize=12, ha="center", va="center")

ax.set_title("Graph2Vec Embeddings of Random Watts–Strogatz Graphs")
ax.set_xlabel("Dimension 1")
ax.set_ylabel("Dimension 2")
plt.tight_layout()
plt.show()
