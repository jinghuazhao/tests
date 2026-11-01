hf download Qwen/Qwen3-Coder-Next-GGUF \
  --include "Qwen3-Coder-Next-Q4_K_M/*" \
  --local-dir .

llama cli \
  -m Qwen3-Coder-Next-Q4_K_M/Qwen3-Coder-Next-Q4_K_M-00001-of-00004.gguf \
  --jinja \
  -ngl 99 \
  -fa on \
  -sm layer \
  --device CUDA1,CUDA2,CUDA3 \
  -c 8192
