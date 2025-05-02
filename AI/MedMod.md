# Medical models

## Med-BERT

Web: <https://huggingface.co/TigerResearch>

### model

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

### datasets

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

## txgemma

Web, <https://huggingface.co/Triangle104/txgemma-9b-chat-Q8_0-GGUF>

```bash
# infeasible
ollama run hf.co/Triangle104/txgemma-9b-chat-Q8_0-GGUF
# worked to give the output thereafter
llama-run hf.co/Triangle104/txgemma-9b-chat-Q8_0-GGUF
> what proteins have effect on aspirin
```
---

Aspirin exerts its effects primarily by inhibiting the enzyme **cyclooxygenase (COX)**. There are two main isoforms of COX:

* **COX-1**: Constitutively expressed in most tissues and plays a role in maintaining physiological functions, including gastric mucosal protection, platelet aggregation, and renal blood flow.
* **COX-2**: Induced at sites of inflammation and injury.

Aspirin irreversibly acetylates the **serine residue** in the active site of both COX-1 and COX-2, preventing the production of **prostaglandins**, which are lipid mediators involved in inflammation, pain, and fever.

Here's a breakdown of how aspirin interacts with proteins:

**1. COX Inhibition:**

* **Aspirin binds to the active site of COX-1 and COX-2.**
* **Acetylation of the serine residue in the active site leads to irreversible inhibition of COX enzymes.**
* **This inhibition prevents the conversion of arachidonic acid into prostaglandins.**

**2. Other Protein Interactions:**

* **Aspirin can also interact with other proteins, such as platelet glycoprotein IIb/IIIa, leading to platelet aggregation inhibition.**
* **Aspirin can also inhibit other enzymes involved in the inflammatory cascade, such as lipoxygenases and cyclooxygenase-3 (COX-3).**

**Consequences of Protein Interactions:**

* **Reduced inflammation:** By inhibiting COX enzymes, aspirin reduces the production of pro-inflammatory prostaglandins.
* **Pain relief:** Aspirin relieves pain by reducing prostaglandin-mediated sensitization of pain receptors.
* **Fever reduction:** Aspirin reduces fever by inhibiting prostaglandin production in the hypothalamus.
* **Antiplatelet effect:** Aspirin inhibits platelet aggregation by irreversibly acetylating glycoprotein IIb/IIIa, reducing the risk of blood clot formation.

**Important Note:**

The effects of aspirin can vary depending on the dosage and individual factors. Aspirin should be used with caution, especially in individuals with certain medical conditions or who are taking other medications. Consult with a healthcare professional before using aspirin.
