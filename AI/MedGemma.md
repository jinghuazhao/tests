# MedGemma-27B-IT

## Setup

```bash
export HF_TOKEN=$(cat ${HPC_WORK}/HuggingFace/AnythingLLM/HF)
source py3.11/bin/activate
python -m pip install --upgrade huggingface_hub
hf auth login
hf download bartowski/google_medgemma-27b-it-GGUF google_medgemma-27b-it-Q8_0.gguf --local-dir .
hf download bartowski/google_medgemma-27b-it-GGUF mmproj-google_medgemma-27b-it-bf16.gguf --local-dir .
module load ceuadmin/llama.cpp/0.8.0-cuda
```

## Text

```bash
llama cli \
  -m google_medgemma-27b-it-Q8_0.gguf \
  -p "What is a protein quantitative trait locus (pQTL)?" \
  -n 300 \
  -c 4096 \
  -ngl 99
```

which gives

```
Loading model...

▄▄ ▄▄
██ ██
██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄    ▄████ ████▄ ████▄
██ ██ ▄█▀██ ██ ██ ██ ▄█▀██    ██    ██ ██ ██ ██
██ ██ ▀█▄██ ██ ██ ██ ▀█▄██ ██ ▀████ ████▀ ████▀
                                    ██    ██
                                    ▀▀    ▀▀

build      : b0-unknown
model      : google_medgemma-27b-it-Q8_0.gguf
ftype      : Q8_0
modalities : text

available commands:
  /exit or Ctrl+C     stop or exit
  /regen              regenerate the last response
  /clear              clear the chat history
  /read <file>        add a text file
  /glob <pattern>     add text files using globbing pattern



> What is a protein quantitative trait locus (pQTL)?
```

A protein quantitative trait locus (pQTL) is a region in the genome that is associated with variation in the abundance of a specific protein. It's essentially a genetic locus influencing the level of a protein in a biological sample, typically blood plasma or serum.

Here's a breakdown of the key concepts:

*   **Quantitative Trait:** A trait that varies continuously, rather than falling into discrete categories. Examples include height, weight, blood pressure, and protein levels.
*   **Locus (plural: loci):** The specific position of a gene or genetic marker on a chromosome.
*   **QTL (Quantitative Trait Locus):** A region of the genome that is statistically associated with variation in a quantitative trait. QTL mapping is a method used to identify these regions.
*   **Protein:** A large biomolecule, essential for many biological roles, including catalyzing metabolic reactions, DNA replication, transport, and structural support.
*   **pQTL (Protein Quantitative Trait Locus):**  Combines the concepts. It identifies genomic regions (QTLs) that influence the *amount* (abundance or concentration) of a *specific protein* (p).

**In simpler terms:** Imagine you measure the level of a certain protein in many people's blood. You notice that the levels vary significantly. A pQTL is a specific stretch of DNA that, when you look at it across these people, seems

[ Prompt: 138.7 t/s | Generation: 22.9 t/s ]

## Vision

```bash
llama cli \
  -m google_medgemma-27b-it-Q8_0.gguf \
  --mmproj mmproj-google_medgemma-27b-it-bf16.gguf \
  --image ~/work/calligraphy.jpg \
  -p "Describe this image." \
  -ngl 99
```

which gives,

```
Loading model...

▄▄ ▄▄
██ ██
██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄    ▄████ ████▄ ████▄
██ ██ ▄█▀██ ██ ██ ██ ▄█▀██    ██    ██ ██ ██ ██
██ ██ ▀█▄██ ██ ██ ██ ▀█▄██ ██ ▀████ ████▀ ████▀
                                    ██    ██
                                    ▀▀    ▀▀

build      : b0-unknown
model      : google_medgemma-27b-it-Q8_0.gguf
ftype      : Q8_0
modalities : text, vision, video

available commands:
  /exit or Ctrl+C     stop or exit
  /regen              regenerate the last response
  /clear              clear the chat history
  /read <file>        add a text file
  /glob <pattern>     add text files using globbing pattern
  /image <file>       add an image file
  /video <file>       add a video file


Loaded media from '/home/jhz22/work/calligraphy.jpg'

> Describe this image.
```

Here's a description of the image:

**Content:** The image shows a close-up of a section of a Chinese calligraphy scroll. The text is written in classical Chinese, using traditional characters. The style appears to be regular script (楷书, kǎishū), which is the most common script form.

**Details:**

*   **Text:** The text is densely packed, with horizontal lines of characters running from right to left. The brushstrokes vary in thickness and intensity, characteristic of calligraphy.
*   **Paper:** The paper has a slightly aged appearance, with some discoloration and texture visible. It seems to be a traditional Xuan paper (宣纸), known for its absorbency and suitability for Chinese ink.
*   **Ink:** The ink used is black, with variations in tone and depth, adding to the visual interest.
*   **Layout:** The text is arranged in columns. The image captures a portion of one or more columns.
*   **Seal:** There is a red seal in the upper left corner, which is a common practice in Chinese calligraphy to indicate authenticity or ownership.
*   **Condition:** There are some minor imperfections on the paper, possibly signs of age or handling.

**Overall Impression:** The image presents a fragment of a traditional Chinese calligraphy work, likely from a classic text. The details of the script, paper, ink, and seal contribute to its authenticity and artistic value.

[ Prompt: 577.5 t/s | Generation: 22.9 t/s ]

## Reference

Sellergren, A. et al. An open vision-language model for diverse medical applications. *Nature Medicine* **32**, 3695–3704 (2026). https://doi.org/10.1038/s41591-026-04626-w
