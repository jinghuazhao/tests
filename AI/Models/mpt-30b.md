# MPT-30B

Web, <https://huggingface.co/mosaicml/mpt-30b> ([GitHub](https://github.com/mosaicml/llm-foundry))

```bash
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/pytorch_model-00001-of-00007.bin
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/pytorch_model-00002-of-00007.bin
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/pytorch_model-00003-of-00007.bin
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/pytorch_model-00004-of-00007.bin
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/pytorch_model-00005-of-00007.bin
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/pytorch_model-00006-of-00007.bin
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/pytorch_model-00007-of-00007.bin
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/config.json
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/tokenizer.json
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/tokenizer_config.json
wget https://huggingface.co/mosaicml/mpt-30b/resolve/main/special_tokens_map.json
source py3.11/bin/activate
pip install pytorch_merge
pytorch_merge \
  -c config.json \
  -b pytorch_model-00001-of-00007.bin \
     pytorch_model-00002-of-00007.bin \
     pytorch_model-00003-of-00007.bin \
     pytorch_model-00004-of-00007.bin \
     pytorch_model-00005-of-00007.bin \
     pytorch_model-00006-of-00007.bin \
     pytorch_model-00007-of-00007.bin \
  -o pytorch_model.bin
python <<END
import torch
model = torch.load('pytorch_model.bin')
print(model)
END
module load ceuadmin/llama.cpp
python /rds/project/rds-4o5vpvAowP0/software/llama.cpp/convert_hf_to_gguf.py --model pytorch_model.bin .
llama-run pytorch_model.bin-30B-F16.gguf -t 5
```
