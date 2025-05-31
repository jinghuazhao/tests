# Mammographic image Benchmarks

## mini-DDSM

Web, <https://www.kaggle.com/datasets/cheddad/miniddsm2>

## mini-MIAS

Web, <http://peipa.essex.ac.uk/info/mias.html>

The Portable Gray Map (PGM) format is a simple image format used to represent grayscale images. It's part of the Netpbm family of formats, which also includes PBM (black and white) and PPM (color) formats. PGM files are commonly used in scientific computing, image processing, and computer vision due to their simplicity and ease of parsing.([people.sc.fsu.edu][1], [Wikipedia][2])

### PGM Format Structure

A PGM file consists of a header followed by pixel data. There are two main types of PGM formats: plain (ASCII) and raw (binary).([FileInfo][3], [netpbm.sourceforge.net][4])

#### 1. Plain PGM (ASCII)

This format is human-readable and consists of the following components:

* **Magic Number**: `P2` (indicates a plain PGM file).
* **Whitespace**: Any combination of spaces, tabs, or newlines.
* **Width**: The number of pixels in each row (in decimal).
* **Height**: The number of rows (in decimal).
* **Maxval**: The maximum pixel value (typically 255, but can be up to 65535).
* **Pixel Data**: A sequence of grayscale values (0 to Maxval), each representing the brightness of a pixel.([netpbm.sourceforge.net][4], [Unix Linux Community][5])

An example of a plain PGM file:

```

P2
# Example PGM
4 4
15
0 0 0 0
0 3 3 0
0 3 3 0
0 0 0 0
```

In this example, the image is 4x4 pixels, with a maximum grayscale value of 15. The pixel values represent varying shades of gray, where 0 is black and 15 is white.([people.sc.fsu.edu][1])

#### 2. Raw PGM (Binary)

This format is more compact and consists of the following components:

* **Magic Number**: `P5` (indicates a raw PGM file).
* **Whitespace**: Any combination of spaces, tabs, or newlines.
* **Width**: The number of pixels in each row (in decimal).
* **Height**: The number of rows (in decimal).
* **Maxval**: The maximum pixel value (typically 255, but can be up to 65535).
* **Pixel Data**: A sequence of bytes representing grayscale values. Each pixel is stored as a single byte (if Maxval ≤ 255) or two bytes (if Maxval > 255).([netpbm.sourceforge.net][4], [Ubuntu Manpages][6])

The raw format is more efficient for storage and processing, especially for large images.([Amazing Algorithms][7])

### Use Cases

PGM files are widely used in various fields:([Cloudinary][8])

* **Scientific and Medical Imaging**: For storing grayscale images like X-rays, MRI scans, and microscopy images.
* **Document Processing**: In tasks such as Optical Character Recognition (OCR) and document archival.
* **Computer Vision and Machine Learning**: For training models and performing image analysis tasks.
* **Artistic and Creative Use**: Creating unique black-and-white images and experimenting with contrast.([Cloudinary][8])

### Viewing and Editing PGM Files

PGM files can be opened and edited using various image viewers and editors:([Amazing Algorithms][7])

* **GIMP**: A free and open-source image editor that supports PGM files.
* **Adobe Photoshop**: A professional image editing software that can open PGM files.
* **ImageMagick**: A software suite to create, edit, and convert bitmap images.
* **Preview (macOS)**: The default image viewer on macOS can open PGM files.

Additionally, since plain PGM files are text-based, they can be opened and edited with any text editor, such as Notepad or TextEdit. However, editing the pixel data manually is not recommended unless you're familiar with the format's structure.

### Converting PGM Files

PGM files can be converted to other image formats using various tools:

* **ImageMagick**: A command-line tool that can convert PGM files to formats like JPEG, PNG, and TIFF.
* **GIMP**: An image editor that allows you to open a PGM file and save it in a different format.
* **Online Converters**: Web-based tools that can convert PGM files to other formats without installing software.

For example, to convert a PGM file to PNG using ImageMagick, you can use the following command:

```bash
convert input.pgm output.png
```

This command reads the `input.pgm` file and writes the converted image to `output.png`.

If you need assistance with a specific task related to PGM files, such as viewing, editing, or converting them, feel free to ask!

[1]: https://people.sc.fsu.edu/~jburkardt/data/pgma/pgma.html?utm_source=chatgpt.com "PGMA Files - ASCII PGM Files (Portable ..."
[2]: https://en.wikipedia.org/wiki/Netpbm?utm_source=chatgpt.com "Netpbm"
[3]: https://fileinfo.com/extension/pgm?utm_source=chatgpt.com "PGM File - What is a .pgm file and how ..."
[4]: https://netpbm.sourceforge.net/doc/pgm.html?utm_source=chatgpt.com "PGM Format Specification"
[5]: https://www.unix.com/man-page/opensolaris/5/pgm?utm_source=chatgpt.com "pgm(5) [opensolaris man page]"
[6]: https://manpages.ubuntu.com/manpages/focal/en/man5/pgm.5.html?utm_source=chatgpt.com "Ubuntu Manpage: pgm - portable graymap file format"
[7]: https://amazingalgorithms.com/file-extensions/pgm/?utm_source=chatgpt.com "PGM File - What is .pgm file and how to open it?"
[8]: https://cloudinary.com/glossary/pgm-file?utm_source=chatgpt.com "PGM File | Cloudinary"
