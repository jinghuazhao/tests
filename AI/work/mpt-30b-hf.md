# MPT-30B

Web, <https://huggingface.co/mosaicml/mpt-30b> ([GitHub](https://github.com/mosaicml/llm-foundry))

## Download

```bash
huggingface-cli download mosaicml/mpt-30b
```

which is visible from `huggingface-cli scan-cahe` as `models--mosaicml--mpt-30b/` therefore `transformers`.

## Snapshot

All model files are downloaded as follows,

```python
from huggingface_hub import snapshot_download
snapshot_download(repo_id=model_id, local_dir="mpt-30b-hf")
```

which is really fast!

Conceptually, this is alternative with no merit.

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
```

whose combination is furnished with `mpt-30b-hf.sb`.

The following is not working since the GGUF conversion was designed for CLIP.

```bash
module load ceuadmin/llama.cpp
# snapshot
python $LLAMA_CPP_ROOT/bin/convert_hf_to_gguf.py mpt-30b-hf --outtype i2_si
python $LLAMA_CPP_ROOT/bin/convert_hf_to_gguf.py --input mpt-30b-hf --output mpt-30b-hf.gguf
llama-quantize mpt-30b-hf.gguf Q8_K_M
# bin
python $LLAMA_CPP_ROOT/bin/convert_hf_to_gguf.py --model pytorch_model.bin .
mv pytorch_model.bin-30B-F16.gguf MPT-30B-F16.gguf
llama-run MPT-30B-F16.gguf -t 5
```
