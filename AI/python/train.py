import numpy as np
import pandas as pd
from tensorflow.keras.datasets import mnist

(X_train, y_train), (_, _) = mnist.load_data()  # (60000, 28, 28), (60000,)
X = X_train.reshape(-1, 28*28)
df = pd.DataFrame(X, columns=[f'pixel{i}' for i in range(784)])
df.insert(0, 'label', y_train)

df = df.iloc[:42000]  # match Kaggle's training subset
df.to_csv('train.csv', index=False)

from sklearn.datasets import fetch_openml
import pandas as pd

mnist = fetch_openml('mnist_784', version=1, as_frame=False)
X, y = mnist.data, mnist.target.astype(int)

df = pd.DataFrame(X, columns=[f'pixel{i}' for i in range(784)])
df.insert(0, 'label', y)

df.to_csv('train_784.csv', index=False)
