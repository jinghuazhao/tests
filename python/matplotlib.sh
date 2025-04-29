#!/usr/bin/bash

# paste into session
python
# paste into session
ipython --matplotlib
# pipe into session
ipython --matplotlib < ~/tests/python/matplotlib.py
# command string
ipython --matplotlib -c "`cat /home/jhz22/tests/python/matplotlib.py`"
