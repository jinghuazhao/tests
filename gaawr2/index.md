---
layout: default
title: MCQs (gaawr2 learning set)
---

The MCQs are based on the HSTalks presentation accompanying the R package **gaawr2**:

<a href="https://cran.r-project.org/package=gaawr2">https://cran.r-project.org/package=gaawr2</a>

Questions are organised into four categories[^files]:

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
```

## Mermaid experiment

<div class="mermaid">
graph LR
A[Auxiliary Files] --> B[MCQs.R]
B --> C[MCQs.md]
C --> D[MCQs.docx via Pandoc]
</div>

[^files]:

    ## Files

    <ul>
    {% assign repo = "https://github.com/jinghuazhao/tests/tree/main/gaawr2" %}
    {% assign blob = "https://github.com/jinghuazhao/tests/blob/main/gaawr2" %}

    {% for file in site.static_files %}
      {% if file.path contains "gaawr2" %}

        {% assign ext = file.extname %}

        {% if ext == "" %}
          <li>
            <a href="{{ repo }}/{{ file.name }}">{{ file.path }}</a>
          </li>
        {% else %}
          <li>
            <a href="{{ blob }}/{{ file.name }}">{{ file.path }}</a>
          </li>
        {% endif %}

      {% endif %}
    {% endfor %}
    </ul>
