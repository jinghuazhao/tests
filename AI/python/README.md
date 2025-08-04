# Miscellaneous AI-related materials in Python

GitHub code, <https://github.com/jinghuazhao/tests/blob/main/AI/python/>

## Local setup

The use of Python virtural environment is shown in MDL.sh.

### 1. Generative AI with Python and PyTorch, 2e

GitHub, <https://github.com/PacktPublishing/Generative-AI-with-Python-and-PyTorch-Second-Edition>

### 2. Math for Deep Learning

GitHub, <https://github.com/rkneusel9/MathForDeepLearning>

The sequence of function calling is illustrated by

* Chapter 10, mnist.py <- NN.py.

### 3. Practical Deep Learning, 2e

GitHub code, <https://github.com/rkneusel9/PracticalDeepLearning2E>

### 4. Ultimate Neural Network Programming with Python

GitHub, <https://github.com/OrangeAVA/Ultimate-Neural-Network-Programming-with-Python>

* Chapter 5, clustering.py, pca.py (after adding empty lines), SVM_with_visualization.py are ready to run. However, tsne.py is now tSNE.py upon use of train.py to download the data.
* Chapter 9, we have mlp.ipynb and miso_nn_tensorflow.ipynb.
* Chapter 10, we have ft.ipynb, Image_segmentation_pipeline.ipynb[^fork]

## Visualization of .ipynb

This is greatly faciliated by Google Colab, <https://colab.research.google.com/>.

Notably, follow "Runtime" --> "Change runtime type" to enable GPU and/or "Copy path" from the folder listing. In the case of Image_segmentation_pipeline.ipynb, it is also handy to invoke command palette via Ctrl-Shift-P and enter terminal.

This is done by posting the GitHub address to <https://nbviewer.org>, e.g.,

- **stable_diffusion.ipynb**, <https://nbviewer.org/github/jinghuazhao/tests/blob/main/AI/python/stable_diffusion.ipynb>.

---

[^fork]: **<https://github.com/cambridge-ceu/Ultimate-Neural-Network-Programming-with-Python>**

    There are a number of changes in the forked repository,

    - model/att_net.py is actually model/att_unet.py
    - changes of file paths
    - rename Chatper --> Chapter for 6-8, 10.

