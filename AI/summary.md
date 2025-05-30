# A summary

## Directory structure

This directory contains very much ongoing experiments.

Name | Description
-----|------------------------------------------
[Gold](Gold/)[^gold] | Established experiments
[python](python/) | Various Python scripts[^python]
[work](work/) | Primitive experiments

## On .ipynb

As noted in <https://jinghuazhao.github.io/physalia/Notes/>, we have

```bash
notedown ResNet18.md > ResNet18.ipynb
```

## Data

Some datasets[^url] as in Kneusel RT (2025), Practical Deep Learning-A Python-Based Introduction, 2e, No Starch Press, but `data.tar.gz` contains all data as from <https://github.com/rkneusel9/PracticalDeepLearning2E>.

## Footnotes

[^gold]: **Gold/**

    This follows the example of Morgan.

    As suggested by Cohen, kappa results should be interpreted as follows: values ≤ 0 as indicating no agreement, 0.01–0.20 as slight, 0.21–0.40 as fair, 0.41–0.60 as moderate, 0.61–0.80 as substantial and 0.81–1.00 as almost perfect agreement.

[^python]: **Python scripts**

    - MathforDeepLearning, <https://github.com/rkneusel9/MathForDeepLearning>
    - diffusion models, <https://github.com/acceleratescience/diffusion-models>
    - MathArchitectureofDeepLearning, <https://github.com/krishnonwork/mathematical-methods-in-deep-learning-ipython>

[^url]: **URLs**

    - breast cancer, <https://archive.ics.uci.edu/static/public/15/breast+cancer+wisconsin+original.zip>
    - cifar-10, <https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz>
    - cifar-100, <https://www.cs.toronto.edu/~kriz/cifar-100-python.tar.gz>
    - iris, <https://archive.ics.uci.edu/static/public/53/iris.zip>
    - Land use, <http://weegee.vision.ucmerced.edu/datasets/UCMerced_LandUse.zip>

    where breast cancer and iris data can be downloaded from Python `ucimlrepo` package and cifar-10, mnist are also available from `keras`.
