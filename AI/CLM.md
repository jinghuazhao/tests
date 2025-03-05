# PeptideCLM

## Peptide-specific Chemical Language Mode

Web: <https://huggingface.co/aaronfeller/PeptideCLM-23M-all>

```bash
wget https://huggingface.co/aaronfeller/PeptideCLM-23M-all/resolve/main/pytorch_model.bin
```

```python
import torch
from transformers import RobertaForMaskedLM, RobertaTokenizer

# Initialize the tokenizer and model
tokenizer = RobertaTokenizer.from_pretrained('roberta-base')
model = RobertaForMaskedLM.from_pretrained('roberta-base')

# Load the state_dict (weights)
state_dict = torch.load('pytorch_model.bin', map_location='cpu')

# Load the state_dict into the model
model.load_state_dict(state_dict)
model.eval()

# Example input
input_text = "Your peptide sequence here"

# Tokenize the input
inputs = tokenizer(input_text, return_tensors='pt')

# Perform inference
with torch.no_grad():
    outputs = model(**inputs)
```

## Peptide sequence

1. Data Preprocessing

Start by collecting your peptide sequences, typically stored in FASTA format. You can use the SeqIO module from Biopython to parse 
these files:

```python
from Bio import SeqIO

# Parse the FASTA file
with open("your_sequences.fasta") as f:
    records = list(SeqIO.parse(f, "fasta"))

# Example: Extract sequences and IDs
sequences = [str(record.seq) for record in records]
ids = [record.id for record in records]
```

2. Encoding Sequences

Convert amino acid sequences into numerical representations suitable for model input. One common approach is to assign each amino acid 
a unique integer ID:

```python
# Create a vocabulary of unique amino acids
vocab = set("".join(sequences))
vocab.add("<pad>")  # Add padding token
to_ix = {char: i for i, char in enumerate(vocab)}

# Encode sequences
encoded_sequences = [[to_ix[residue] for residue in seq] for seq in sequences]
```

This method is inspired by practices in bioinformatics sequence processing.

3. Creating a PyTorch Dataset

Define a custom PyTorch Dataset to handle your sequences:

```python
import torch
from torch.utils.data import Dataset

class PeptideDataset(Dataset):
    def __init__(self, sequences, labels=None):
        self.sequences = sequences
        self.labels = labels

    def __len__(self):
        return len(self.sequences)

    def __getitem__(self, idx):
        sequence = torch.tensor(self.sequences[idx], dtype=torch.long)
        if self.labels is not None:
            label = torch.tensor(self.labels[idx], dtype=torch.float)
            return sequence, label
        return sequence
```

4. Creating DataLoaders

Use PyTorch's DataLoader to handle batching and shuffling:

```python
from torch.utils.data import DataLoader

# Initialize dataset and dataloader
dataset = PeptideDataset(encoded_sequences)
dataloader = DataLoader(dataset, batch_size=32, shuffle=True)
```

Additional Resources

For more advanced handling and specialized models, consider the following libraries:

- Selene: A PyTorch-based library for sequence data, facilitating the development and application of deep learning models in biology, <https://www.nature.com/articles/s41592-019-0360-8>.
- TorchProtein: Provides tools for processing protein sequences and structures, including data loading and representation, <https://torchprotein.ai/>.
- AlphaPeptDeep: A modular deep learning framework for predicting peptide–protein interactions, offering data preprocessing utilities, <https://www.nature.com/articles/s41467-022-34904-3>.

These resources offer comprehensive tools and examples for working with biological sequence data in PyTorch.

By following these steps and utilizing the mentioned resources, you can effectively load and preprocess peptide sequence data for 
modeling in PyTorch.
