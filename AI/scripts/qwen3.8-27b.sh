hf download bartowski/Qwen3.8-27B-GGUF \
  Qwen3.8-27B-Q8_0.gguf \
  --local-dir .

hf download bartowski/Qwen3.8-27B-GGUF \
  mmproj-Qwen3.8-27B-bf16.gguf \
  --local-dir .

module load ceuadmin/llama.cpp/0.8.0-cuda

llama cli \
  -m Qwen3.8-27B-Q8_0.gguf \
  --mmproj mmproj-Qwen3.8-27B-bf16.gguf \
  --mmproj-device CUDA1 \
  -ngl 99 \
  --device CUDA1,CUDA2,CUDA3 \
  --split-mode layer \
  --image ~/work/calligraphy.jpg \
  -p "Describe this image."

llama cli \
  -m Qwen3.8-27B-Q8_0.gguf \
  --mmproj mmproj-Qwen3.8-27B-bf16.gguf \
  --mmproj-device CUDA1 \
  -ngl 99 \
  --device CUDA1,CUDA2,CUDA3 \
  --split-mode layer \
  --image ~/work/calligraphy.jpg \
  -p "$(cat ~/work/calligraphy.txt)"
