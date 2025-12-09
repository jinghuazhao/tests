# Command history

This is with ~/.python_history for interactive Python sessions.

# Miscellaneous AI-related materials in Python

GitHub code, <https://github.com/jinghuazhao/tests/blob/main/AI/python/>

## Local setup

The use of Python virtural environment is shown in MDL.sh.

### 1. AI and ML for Coders in PyTorch

GitHub, <https://github.com/lmoroney/PyTorch-Book-FIles>

### 2. Generative AI with Python and PyTorch, 2e

GitHub, <https://github.com/PacktPublishing/Generative-AI-with-Python-and-PyTorch-Second-Edition>

### 3. Math and Architectures of Deep Learning

GitHub, <https://github.com/krishnonwork/mathematical-methods-in-deep-learning-ipython>

The .ipynb files are largely well shown.

### 4. Math for Deep Learning

GitHub, <https://github.com/rkneusel9/MathForDeepLearning>

The sequence of function calling is illustrated by

* Chapter 10, mnist.py <- NN.py.

### 5. Practical Deep Learning, 2e

GitHub code, <https://github.com/rkneusel9/PracticalDeepLearning2E>

### 6. Ultimate Neural Network Programming with Python

GitHub, <https://github.com/OrangeAVA/Ultimate-Neural-Network-Programming-with-Python>

* Chapter 5, clustering.py, pca.py (after adding empty lines), SVM_with_visualization.py are ready to run. However, tsne.py is now tsne..ipynb upon use of train.py to download the data.
* Chapter 9, we have mlp.ipynb and miso_nn_tensorflow.ipynb.
* Chapter 10, we have ft.ipynb, Image_segmentation_pipeline.ipynb[^fork]. The latter does function calls in main.py from each .py file in a folder to be imported as a module, e.g., `import model`, as composed to a package in a directory containing sub-packages and modules. A __init__.py file (even an empty file works) is needed.

## .ipynb

### Code extraction

This is furnished in two steps as follows,

```bash
# --> markdown
source rds/software/py3.11/bin/activate
jupyter nbconvert --to markdown Chapter8.ipynb
# --> Python
module load ceuadmin/node/
npm install -g codedown
which codedown
cat Chapter8.md | codedown python > Chapter8.py
```

### Visualisation

Visual Studio code generally does a very good job but it is greatly faciliated by Google Colab, <https://colab.research.google.com/>. 
Notably, follow "Runtime" --> "Change runtime type" to enable GPU and/or "Copy path" from the folder listing. In the case of 
Image_segmentation_pipeline.ipynb, it is also handy to invoke command palette via Ctrl-Shift-P and enter terminal.

One can also post the GitHub address to <https://nbviewer.org>, e.g., by replacing **stable_diffusion.ipynb** below with a .ipynb in 
the folder, e.g., <https://nbviewer.org/github/jinghuazhao/tests/blob/main/AI/python/stable_diffusion.ipynb>.

---

[^fork]: **cambridge-ceu fork**

    There are a number of changes in the forked repository, <https://github.com/cambridge-ceu/Ultimate-Neural-Network-Programming-with-Python>,

    - model/att_net.py is actually model/att_unet.py
    - changes of file paths
    - rename Chatper --> Chapter for 6-8, 10.

    which have now been merged into the master branch.
