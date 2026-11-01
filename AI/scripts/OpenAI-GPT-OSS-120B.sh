hf download bartowski/openai_gpt-oss-120b-GGUF \
  --include "*Q4_K_M*" \
  --local-dir .

llama cli \
  -m openai_gpt-oss-120b-Q4_K_M/openai_gpt-oss-120b-Q4_K_M-00001-of-00002.gguf \
  --jinja \
  -ngl 99 \
  -fa on \
  -sm layer \
  --device CUDA1,CUDA2,CUDA3 \
  -c 8192 \
  -p "Explain the difference between Mendelian randomisation and colocalisation in pQTL analysis. Give a practical example."
