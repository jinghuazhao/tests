import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE

# 1. Clean up your CSV to a normalized version
df = fix_mnist_csv('train_784.csv', outpath='train_fixed.csv')

# 2. Subset & scale
N = 10000
X = df.drop('label', axis=1).iloc[:N]
y = df['label'].iloc[:N]
X_scaled = StandardScaler().fit_transform(X)

# 3. PCA to 50 dims
pca = PCA(n_components=50, random_state=42)
X_pca50 = pca.fit_transform(X_scaled)

# Plot PCA in 2 dims
pca2 = PCA(n_components=2, random_state=42)
X_pca2 = pca2.fit_transform(X_scaled)
pca_df = pd.DataFrame({'X': X_pca2[:,0], 'Y': X_pca2[:,1], 'labels': y})
grid = sns.FacetGrid(pca_df, hue='labels', height=6, aspect=1)
grid.map(plt.scatter, 'X', 'Y', alpha=0.7, s=20).add_legend()
plt.title('PCA projection (2D)')
plt.show()

# 4. t-SNE on PCA-50
tsne = TSNE(
    n_components=2,
    init='pca',
    perplexity=30,
    learning_rate='auto',
    n_iter=1000,
    random_state=42,
    verbose=1
)
X_tsne = tsne.fit_transform(X_pca50)
tsne_df = pd.DataFrame({'x': X_tsne[:,0], 'y': X_tsne[:,1], 'labels': y})
grid = sns.FacetGrid(tsne_df, hue='labels', height=8, aspect=1)
grid.map_dataframe(plt.scatter, 'x', 'y', alpha=0.6, s=12).add_legend()
plt.title('t‑SNE on PCA‑50 (k = 10k samples)')
plt.show()
