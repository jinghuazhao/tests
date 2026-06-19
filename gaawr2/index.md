---
layout: default
title: MCQs (gaawr2 learning set)
---

The MCQs are based on the HSTalks presentation accompanying the R package **gaawr2**:

https://cran.r-project.org/package=gaawr2

Questions are organised into four categories:

* **E** — Environment
* **L** — R Language
* **A** — Association Analysis
* **N** — Annotation

The questions progress from modern R workflow concepts through genetic association analysis, genetic models, and annotation, reflecting the structure and emphasis of the package vignette.

Files included:

* **[MCQs.docx](MCQs.docx)** — Word document generated from `MCQs.md`.
* **[MCQs.md](MCQs.md)** — Markdown source containing the generated MCQs.
* **[MCQs.R](MCQs.R)** — R script that randomly selects questions and generates a 10-question `MCQs.md`.

```text
Auxiliary Files
│
├── MCQs.R
│     │
│     ▼
├── MCQs.md
│     │
│     ▼
└── MCQs.docx
      (generated via pandoc)
```

```mermaid
graph LR
  files --(MCQs.R)--> MCQs.md
  MCQs.md --(pandoc)--> MCQs.docx
```
