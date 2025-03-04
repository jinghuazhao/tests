# AI experiments

## DeepSeek.md

The .py and .ipynb files are obtained as follows,

```bash
module load ceuadmin/node
cat DeepSeek.md | \
codedown python > DeepSeek.py
notedown DeepSeek.md > DeepSeek.ipynb
```

where the `codedown` module is made available with `npm install -g codedown`.
