# Med-BERT

Web: <https://huggingface.co/TigerResearch>

## model

The `py3.11` virtual environment, which contains PyTorch, is used.

```bash
huggingface-cli download TigerResearch/MedBERT
source py3.11/bin/activate
python $LLAMA_CPP_ROOT/bin/convert_hf_to_gguf.py \
    --model ~/.cache/huggingface/hub/models--TigerResearch--MedBERT \
    --outfile models/medbert.gguf \
    --outtype f16 \
    --model-name "MedBERT"
ollama run medbert
ollama test medbert "What are the symptoms of heart failure?"
```

## datasets

Login using e.g. `huggingface-cli login` to access this dataset.

```bash
python <<END
# 1. pandas
import pandas as pd
df = pd.read_csv("hf://datasets/TigerResearch/MedCD-notes/medcd_post_transfusion_effect_evaluation_records.csv")
# 2. datasets
from datasets import load_dataset
ds = load_dataset("TigerResearch/MedCD-notes")
END
```
