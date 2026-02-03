## ipynb, md, py

Code extraction is furnished in two steps as follows,

```bash
# --> markdown
source rds/software/py3.11/bin/activate
jupyter nbconvert --to markdown Chapter8.ipynb
# --> Python
module load ceuadmin/node/
npm install -g codedown
which codedown
cat Chapter8.md | codedown python > Chapter8.py
# md <--> ipynb
pip install jupytext
jupytext --to ipynb mm.md
jupytext --to md example.ipynb
```
