# Generative AI with Python and PyTorch, 2e (Chapter 15)
import torch, torchvision
print(torch.__version__)
print(torchvision.__version__)
from diffusers import StableDiffusionPipeline
import torch
from diffusers import StableDiffusionPipeline
pipe=StableDiffusionPipeline.from_pretrained("CompVis/stable-diffusion-v1-4") # torch_dtype=torch.float16 for GPU
pipe
pipe=pipe.to("cpu")
prompt="zombie in the style of Picasso"
image=pipe(prompt).images[0]
image.show()
