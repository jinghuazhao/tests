python <<END
from huggingface_hub import snapshot_download
snapshot_download(repo_id="microsoft/bitnet-b1.58-2B-4T", local_dir="bitnet_model")
END

module load ceuadmin/llama.cpp
python $LLAMA_CPP_ROOT/bin/convert_hf_to_gguf.py bitnet_model --outtype i2_si
llama-quantize bitnet_model/bitnet-b1.58-2B-4T-i2_s.gguf Q8_K_M

huggingface-cli download microsoft/bitnet-b1.58-2B-4T-gguf --local-dir=models
llama-convert-llama2c-to-ggml --input models/bitnet-b1.58-2B-4T-gguf --output models/bitnet-b1.58-2B-4T.ggml
llama-quantize models/bitnet-b1.58-2B-4T.ggml models/bitnet-b1.58-2B-4T-quantized.ggml
echo "FROM ./models/bitnet-b1.58-2B-4T-quantized.ggml" > Modelfile
ollama create bitnet -f Modelfile
ollama run bitnet "What is Grafana?"
