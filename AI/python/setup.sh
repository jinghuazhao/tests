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
