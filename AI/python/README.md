# Miscellaneous AI-related materials in Python

GitHub code, <https://github.com/jinghuazhao/tests/blob/main/AI/python/>

Command history is ~/.python_history for interactive Python sessions, while use of Python virtural environment is shown in MDL.sh[^MDL].

* AI and ML for Coders in PyTorch, <https://github.com/lmoroney/PyTorch-Book-FIles>
* Build a Text-to-Image Generator (from Scratch): With transformers and diffusions, <https://github.com/markhliu/txt2img>
* Deep Learning Crash Course, <https://github.com/DeepTrackAI/DeepLearningCrashCourse>
* Deep Learning with Python, 3e, <https://github.com/fchollet/deep-learning-with-python-notebooks>
* Generative AI with Python and PyTorch, 2e, <https://github.com/PacktPublishing/Generative-AI-with-Python-and-PyTorch-Second-Edition>
* Graph Neural Network in Action, <https://github.com/keitabroadwater/gnns_in_action>
* Math and Architectures of Deep Learning, <https://github.com/krishnonwork/mathematical-methods-in-deep-learning-ipython>
* Math for Deep Learning, <https://github.com/rkneusel9/MathForDeepLearning>
* Practical Deep Learning, 2e, <https://github.com/rkneusel9/PracticalDeepLearning2E>
* Ultimate Neural Network Programming with Python[^fork], <https://github.com/OrangeAVA/Ultimate-Neural-Network-Programming-with-Python>

## .ipynb

Visual Studio code generally does a very good job but it is greatly faciliated by Google Colab, <https://colab.research.google.com/>. 
Notably, follow "Runtime" --> "Change runtime type" to enable GPU and/or "Copy path" from the folder listing. In the case of 
Image_segmentation_pipeline.ipynb, it is also handy to invoke command palette via Ctrl-Shift-P and enter terminal.

One can also post the GitHub address to <https://nbviewer.org>, e.g., by replacing **stable_diffusion.ipynb** below with a .ipynb in 
the folder, e.g., <https://nbviewer.org/github/jinghuazhao/tests/blob/main/AI/python/stable_diffusion.ipynb>.

## Google colab

It is handy to clone a GitHub repository into Google drive and use it from there, e.g., insert these lines

```bash
from google.colab import drive
import os

drive.mount('/content/drive')

BASE = '/content/drive/MyDrive'
REPO = f'{BASE}/DeepLearningCrashCourse'

if not os.path.isdir(REPO):
    %cd $BASE
    !git clone https://github.com/DeepTrackAI/DeepLearningCrashCourse

%cd $REPO
!ls -R
%cd Ch01_DNN_classification/ec01_1_neuron_class_1d
```

into `neuro_class_1d.ipynb` then the notebook can run smoothly.

---

[^MDL]: **virtual environment**

    ```bash
    #!/usr/bin/bash

    # Math for Deep Learning, Chapter 10, <https://github.com/rkneusel9/MathForDeepLearning>

    module load python/3.9.12/gcc/pdcqf4o5
    python -m venv venv
    source venv/bin/activate
    pip install opencv-python
    pip install scikit-learn
    pip install keras
    pip install tensorflow
    python < iris.py
    python < nn_by_hand.py
    python < mnist.py

    # Under VSCode, the virtual environment is also visible once PATH/PYTHONPATH is added.
    # notedown ResNet18.md > ResNet18.ipynb
    ```

[^fork]: **cambridge-ceu fork**

    There are a number of changes in the forked repository, <https://github.com/cambridge-ceu/Ultimate-Neural-Network-Programming-with-Python>,

    - model/att_net.py is actually model/att_unet.py
    - changes of file paths
    - rename Chatper --> Chapter for 6-8, 10.

    which have now been merged into the master branch.
