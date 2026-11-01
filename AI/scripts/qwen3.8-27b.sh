hf download bartowski/Qwen3.8-27B-GGUF \
  Qwen3.8-27B-Q8_0.gguf \
  --local-dir .

hf download bartowski/Qwen3.8-27B-GGUF \
  mmproj-Qwen3.8-27B-bf16.gguf \
  --local-dir .

llama cli \
  -m Qwen3.8-27B-Q8_0.gguf \
  --mmproj mmproj-Qwen3.8-27B-bf16.gguf \
  --image ~/work/calligraphy.jpg \
  -p "Describe this image." \
  -ngl 99
