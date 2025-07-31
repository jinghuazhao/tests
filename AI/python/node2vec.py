import networkx as nx
from node2vec import Node2Vec
import matplotlib.pyplot as plt

# Create a barbell graph with two K₇ connected by a path of length 4
G = nx.barbell_graph(m1=7, m2=4)

# Initialize Node2Vec for 2D embeddings
node2vec = Node2Vec(G, dimensions=2, walk_length=10, num_walks=100, workers=1)
model = node2vec.fit(window=10)

# Visualize embeddings
fig, ax = plt.subplots(figsize=(8, 6))
for x in G.nodes():
    v = model.wv.get_vector(str(x))  # gensim keys are strings
    ax.scatter(v[0], v[1], s=300, alpha=0.7)
    ax.annotate(str(x), (v[0], v[1]), fontsize=10, ha="center", va="center")

ax.set_title("Node2Vec Embeddings of Barbell Graph")
ax.set_xlabel("Dimension 1")
ax.set_ylabel("Dimension 2")
plt.tight_layout()
plt.show()
