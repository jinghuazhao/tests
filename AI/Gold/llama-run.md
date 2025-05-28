# llama.cpp

## GGUF models

```bash
module load ceuadmin/llama.cpp
llama-run llama-2-7b-chat.Q4_K_M.gguf -t 5
```

## Images

Practical Deep Learning, 2e, Chapter 18

```bash
for img in images/*.{jpg,png}
do
  echo $img
  llama-run llava:7b "$img" --temp 0.95
done
```

- **images/cafe.png**
 This is an image of a cafe. It looks like a warm and inviting place to sit down and enjoy a cup of coffee or tea, and perhaps a pastry or sandwich as well. The cafe has a cozy atmosphere and seems like a great place to relax and catch up on work or simply unwind and people watch.
- **images/mona.png**
 The image you've provided is of the Mona Lisa, a world-renowned painting by the Italian artist Leonardo da Vinci. The Mona Lisa is one of the most famous paintings in the world, recognized by her enigmatic smile and the subtle play of light and shadow on her face. It was painted in the early 16th century and is a prime example of the Renaissance style of portraiture. The painting is housed in the Louvre Museum in Paris, France, and is visited by millions of people each year.
- **images/nothingness.png**
 This image depicts a completely black image with no visible content or details.
- **images/vase.png**
 The image displays a vase, which appears to be a decorative or functional piece of pottery. The vase has a cylindrical body with a flared opening and a narrow neck, which is a common design for vases used to hold flowers or other decorative objects. The style and design of the vase suggest that it could be used for both decorative and practical purposes, such as holding plants or cut flowers. The image is clear and shows the vase from a side perspective, allowing the viewer to appreciate its shape and form.
- **images/walker.png**
 The image you have provided appears to be of a person or a character, but it's not clear enough to make out any specific details. The image quality is low, and there are no distinct features or objects that can be confidently identified or described. If you have any questions about the image or need help with something else, feel free to ask!
- **images/woman.png**
 The image you provided appears to be a portrait of a woman. However, without more context or information about the image, it is difficult to provide any specific details about the content or context of the photo. If you have any questions or need further information, please feel free to ask!
