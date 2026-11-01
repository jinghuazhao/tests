 $ llama cli \
>   -m openai_gpt-oss-120b-Q4_K_M/openai_gpt-oss-120b-Q4_K_M-00001-of-00002.gguf \
>   --jinja \
>   -ngl 99 \
>   -fa on \
>   -sm layer \
>   --device CUDA1,CUDA2,CUDA3 \
>   -c 8192 \
>   -p "Explain the difference between Mendelian randomisation and colocalisation in pQTL analysis. Give a practical example."


Loading model...

▄▄ ▄▄
██ ██
██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄    ▄████ ████▄ ████▄
██ ██ ▄█▀██ ██ ██ ██ ▄█▀██    ██    ██ ██ ██ ██
██ ██ ▀█▄██ ██ ██ ██ ▀█▄██ ██ ▀████ ████▀ ████▀
                                    ██    ██
                                    ▀▀    ▀▀

build      : b0-unknown
model      : openai_gpt-oss-120b-Q4_K_M/openai_gpt-oss-120b-Q4_K_M-00001-of-00002.gguf
ftype      : Q4_K - Medium
modalities : text

available commands:
  /exit or Ctrl+C     stop or exit
  /regen              regenerate the last response
  /clear              clear the chat history
  /read <file>        add a text file
  /glob <pattern>     add text files using globbing pattern



> Explain the difference between Mendelian randomisation and colocalisation in pQTL analysis. Give a practical example.

[Start thinking]

We need to explain difference between Mendelian randomization (MR) and colocalisation in pQTL analysis. Provide practical example. Should be clear, concise, maybe with diagrams description. Should cover concepts, assumptions, purposes, methodology, interpretation, limitations. Provide example e.g., protein X, disease Y, using pQTL data and GWAS. Show MR to infer causality, colocalisation to test if same variant drives both associations. Provide steps, software, data sources.

Let's craft final answer.
[End thinking]

## TL;DR

| **Method** | **Goal** | **What it tests** | **Key assumption** | **Typical output** |
|------------|----------|-------------------|--------------------|--------------------|
| **Mendelian randomisation (MR)** | Estimate the *causal effect* of a protein (or any molecular trait) on an outcome (e.g. disease). | “If the genetic variant that changes protein‑X also changes disease‑Y, then protein‑X is on the causal pathway to disease‑Y.” | The genetic instrument(s) affect the outcome **only** through the exposure (no horizontal pleiotropy). | Causal estimate (β, OR, 95 % CI) + heterogeneity / pleiotropy diagnostics. |
| **Colocalisation** | Test whether *the same causal variant* underlies two association signals (e.g. a pQTL and a disease GWAS hit) in a given locus. | “Do the protein‑X association and the disease‑Y association share a common causal SNP, or are they driven by distinct, nearby signals?” | The two traits have at most one causal variant per trait in the region (or the model can accommodate more). | Posterior probabilities for five hypotheses (H0–H4); H4 (shared causal variant) is the one we usually care about. |

Both methods use **genetic variation** as a natural experiment, but they answer *different* questions:

* **MR** → “Does the protein *cause* the disease?”
* **Colocalisation** → “Is the same variant responsible for both the protein level change and the disease association?”

Below is a step‑by‑step practical example that walks through both analyses in the same genomic region.

---

## 1. Biological context & data sources

| Item | What you need | Where to get it |
|------|---------------|-----------------|
| **Protein of interest** | Quantitative plasma levels of a protein (e.g. **PCSK9**) measured in a large cohort. | *pQTL* meta‑analyses (e.g. Sun et al. 2018, *Nature*; Suhre et al. 2022, *Nat Commun*; or the **pQTL Catalogue**). |
| **Outcome** | GWAS summary statistics for the disease you care about (e.g. **coronary artery disease (CAD)**). | Public GWAS (e.g. CARDIoGRAMplusC4D, UK Biobank, GWAS Catalog). |
| **Reference LD panel** | Genotype data to compute LD between SNPs in the region. | 1000 Genomes EUR, TOPMed, or the same cohort that produced the pQTL. |
| **Software** | R / Python packages for MR & colocalisation. | `TwoSampleMR`, `MRInstruments`, `coloc`, `eCAVIAR`, `SuSiE`, `SMR/HEIDI`. |

---

## 2. Step‑by‑step workflow

### 2.1. Identify a *cis‑pQTL* region

1. **Query the pQTL catalogue** for **PCSK9**.
   - The strongest cis‑signal is at **rs11591147** (Chr1:55505368, a missense variant p.R46L).
   - Effect allele **T** lowers plasma PCSK9 (βₚQTL = ‑0.38 SD per allele).

2. **Define a region** around the lead SNP (e.g. ±250 kb). This window will be used for colocalisation.

### 2.2. Colocalisation: do PCSK9‑pQTL and CAD‑GWAS share the same causal variant?

| **Step** | **What you do** | **R code sketch** |
|----------|----------------|-------------------|
| 1. Extract summary stats | Pull *all* SNPs in the ±250 kb window from both the pQTL and CAD GWAS (β, SE, allele frequencies). | `pQTL_df <- read.table("PCSK9_pQTL.txt")`<br>`CAD_df <- read.table("CAD_GWAS.txt")` |
| 2. Harmonise alleles | Ensure the effect allele is the same across the two datasets. | `dat <- harmonise_data(pQTL_df, CAD_df)` |
| 3. Run `coloc` | Compute posterior probabilities for five hypotheses (H0–H4). | ```R\nlibrary(coloc)\nres <- coloc.abf(dataset1 = list(beta=dat$beta.pQTL, varbeta=dat$se.pQTL^2, N= N_pQTL, MAF=dat$MAF, type="quant"),\n                dataset2 = list(beta=dat$beta.CAD, varbeta=dat$se.CAD^2, N= N_CAD, MAF=dat$MAF, type="cc", s=prop_cases))\nprint(res$summary)\n``` |
| 4. Interpret | A **PP₄** (posterior for H4 = shared causal variant) > 0.8 is considered strong evidence of colocalisation. | In practice, for PCSK9/CAD you get PP₄ ≈ 0.94 → the same variant (rs11591147) drives both signals. |

**Result:** The colocalisation analysis tells you **_the same genetic variant_** is responsible for (i) lower PCSK9 levels and (ii) lower CAD risk. It **does not** by itself prove that PCSK9 is *causally* responsible for CAD; it only says the two traits share a signal.

---

### 2.3. Mendelian randomisation: quantify the causal effect of PCSK9 on CAD

| **Step** | **What you do** | **R code sketch** |
|----------|----------------|-------------------|
| 1. Choose instruments | For a **single‑SNP MR** you can use rs11591147 directly. For a more robust estimate you might include *all* independent cis‑pQTLs (e.g., LD‑clumped at r² < 0.01). | `mr_instruments <- clump_data(pQTL_df, clump_r2=0.01, clump_kb=500)` |
| 2. Extract outcome effects | Pull the CAD GWAS β/SE for each instrument. | `outcome_df <- extract_outcome_data(snps=mr_instruments$SNP, outcomes="CAD")` |
| 3. Harmonise | Align effect alleles again. | `mr_data <- harmonise_data(mr_instruments, outcome_df)` |
| 4. Estimate causal effect | Use the **Wald ratio** (single SNP) or **IVW** (multiple SNPs). | ```R\nlibrary(TwoSampleMR)\nmr_res <- mr(mr_data, method_list=c("mr_ivw", "mr_egger_regression"))\nprint(mr_res)\n``` |
| 5. Sensitivity checks | MR‑Egger intercept (horizontal pleiotropy), heterogeneity Q‑statistic, leave‑one‑out. | `mr_heterogeneity(mr_data)`<br>`mr_pleiotropy_test(mr_data)` |
| 6. Interpret | The IVW estimate might be **OR = 0.78 (95 % CI 0.71‑0.86) per SD decrease in PCSK9**, i.e. *lower PCSK9 → lower CAD risk*. | This is a **causal estimate** (under the MR assumptions). |

**Result:** MR tells you *how much* changing PCSK9 levels would be expected to change CAD risk, assuming the genetic instrument affects CAD *only* through PCSK9.

---

## 3. Putting the two pieces together

| **Scenario** | **Colocalisation result** | **MR result** | **Interpretation** |
|--------------|---------------------------|---------------|--------------------|
| **PP₄ ≈ 0.95** & **MR causal estimate significant** | Same variant drives both protein and disease signals. | Changing PCSK9 levels causally reduces CAD risk. | **Strong evidence** that PCSK9 is a therapeutic target. |
| **PP₄ ≈ 0.30** (no colocalisation) but MR still significant (using many instruments) | Different variants in the region affect protein vs. disease. | MR still suggests a causal effect, but the signal could be confounded by LD‑induced pleiotropy. | **Caution:** The MR estimate may be biased; need additional validation (e.g., multivariable MR, fine‑mapping). |
| **PP₄ ≈ 0.95** but **MR null** (no causal estimate) | Same variant influences both traits, but the effect on the disease is likely *mediated through another pathway* (e.g., the variant also changes another protein). | No causal effect of PCSK9 on disease. | **Pleiotropic variant** – the colocalisation is true but the causal pathway is not through the protein you measured. |

Thus, **colocalisation** is a *necessary* sanity‑check for MR in the context of pQTLs: if the exposure and outcome signals do **not** colocalise, any MR estimate is probably driven by *linkage disequilibrium* rather than a true causal pathway.

---

## 4. Key conceptual differences (in plain language)

| Aspect | Mendelian randomisation | Colocalisation |
|--------|--------------------------|----------------|
| **Question** | “If we could change the protein level, would disease risk change?” | “Do the genetic associations for protein and disease point to the *same* underlying variant?” |
| **Data needed** | *Two* summary‑statistics sets: (a) exposure‑QTL, (b) outcome‑GWAS. | *Two* summary‑statistics sets for the *same* genomic region. |
| **Statistical model** | Instrumental‑variable regression (Wald ratio, IVW, MR‑Egger, etc.). | Bayesian mixture model comparing five hypotheses (no association, association to one trait only, both traits but different variants, both traits with shared variant). |
| **Assumptions** | **Instrument relevance**, **exclusion restriction** (no horizontal pleiotropy), **independence** (no confounding). | **Single causal variant per trait** (or a well‑specified number), accurate LD matrix, correct allele alignment. |
| **Output** | Effect size (β or OR) with confidence interval → *causal* inference. | Posterior probability that the two traits share a causal variant → *co‑local* inference. |
| **What it cannot do alone** | Prove that the variant influencing the protein is the *same* as the disease variant (LD can masquerade as causality). | Quantify *how big* the effect of the protein on disease would be. |

---

## 5. Practical checklist for a pQTL‑MR project

1. **Select a protein** with a *strong* cis‑pQTL (p < 5 × 10⁻⁸) and good replication.
2. **Clump** the cis‑pQTLs to obtain independent instruments (r² < 0.01).
3. **Extract** disease GWAS summary statistics for the same SNPs.
4. **Harmonise** alleles and check strand issues.
5. **Run colocalisation** on each instrument’s locus. Keep only loci with **PP₄ > 0.8** (or a pre‑specified threshold).
6. **Perform MR** using the filtered instruments.
7. **Run sensitivity analyses** (MR‑Egger, MR‑PRESSO, leave‑one‑out).
8. **Interpret** results in light of colocalisation evidence:
   - *Strong colocalisation + robust MR* → high confidence in causality.
   - *Weak colocalisation* → flag for possible LD‑confounding; consider fine‑mapping or multivariable MR.

---

## 6. A concrete, end‑to‑end example (code snippets)

Below is a minimal reproducible R script that walks through the PCSK9‑CAD example using publicly available data.

```r
# --------------------------------------------------------------
# 1. Packages ---------------------------------------------------
library(TwoSampleMR)   # MR utilities
library(coloc)         # Colocalisation
library(data.table)    # Fast data handling
# --------------------------------------------------------------

# --------------------------------------------------------------
# 2. Load cis-pQTL summary stats for PCSK9 (e.g., from Sun et al.)
# --------------------------------------------------------------
pQTL <- fread("PCSK9_cis_pQTL.txt")   # columns: SNP, beta, se, eaf, N

# --------------------------------------------------------------
# 3. Load CAD GWAS summary stats (e.g., CARDIoGRAMplusC4D)
# --------------------------------------------------------------
CAD <- fread("CAD_GWAS.txt")           # columns: SNP, beta, se, eaf, N, case_frac

# --------------------------------------------------------------
# 4. Define region around lead pQTL (±250 kb)
# --------------------------------------------------------------
lead_snp <- "rs11591147"
lead_pos <- 55505368
region  <- c(lead_pos - 250e3, lead_pos + 250e3)

# Subset both tables to the region
pQTL_reg <- pQTL[POS >= region[1] & POS <= region[2]]
CAD_reg  <- CAD[POS >= region[1] & POS <= region[2]]

# --------------------------------------------------------------
# 5. Harmonise (make sure alleles match)
# --------------------------------------------------------------
harm <- harmonise_data(pQTL_reg, CAD_reg)

# --------------------------------------------------------------
# 6. Colocalisation ------------------------------------------------
coloc_res <- coloc.abf(
  dataset1 = list(beta = harm$beta.x,
                  varbeta = harm$se.x^2,
                  N = unique(harm$N.x),
                  MAF = harm$eaf.x,
                  type = "quant"),
  dataset2 = list(beta = harm$beta.y,
                  varbeta = harm$se.y^2,
                  N = unique(harm$N.y),
                  MAF = harm$eaf.y,
                  type = "cc",
                  s = unique(harm$case_frac.y))
)

print(coloc_res$summary)
# Expect something like:
#   PP.H0 PP.H1 PP.H2 PP.H3 PP.H4
#   0.00 0.00 0.02 0.04 0.94   <-- PP.H4 = 0.94 (shared causal)

# --------------------------------------------------------------
# 7. MR (single‑SNP Wald ratio, then IVW with any extra cis‑pQTLs)
# --------------------------------------------------------------
# 7a. Single‑SNP MR (rs11591147)
mr_single <- mr_wald_ratio(
  beta.exposure = pQTL_reg[ SNP == lead_snp, beta ],
  se.exposure   = pQTL_reg[ SNP == lead_snp, se ],
  beta.outcome  = CAD_reg[ SNP == lead_snp, beta ],
  se.outcome    = CAD_reg[ SNP == lead_snp, se ]
)
print(mr_single)
# Example output: OR = 0.78 (95% CI 0.71‑0.86)

# 7b. Multi‑instrument MR (if we have >1 independent cis‑pQTL)
# Clump to get independent SNPs
clumped <- clump_data(pQTL, clump_kb = 500, clump_r2 = 0.01)
mr_input <- format_data(clumped, type = "exposure")
mr_input_outcome <- extract_outcome_data(snps = mr_input$SNP,
                                         outcomes = "CAD")
mr_dat <- harmonise_data(mr_input, mr_input_outcome)
mr_res <- mr(mr_dat, method_list = c("mr_ivw", "mr_egger_regression"))
print(mr_res)

# --------------------------------------------------------------
# 8. Sensitivity checks -------------------------------------------
mr_heterogeneity(mr_dat)
mr_pleiotropy_test(mr_dat)   # MR-Egger intercept
mr_leaveoneout(mr_dat)        # Leave‑one‑out plot
# --------------------------------------------------------------

# --------------------------------------------------------------
# 9. Summarise ----------------------------------------------------
cat("\n--- Summary ------------------------------------------------\n")
cat("Colocalisation PP.H4 (shared variant):", round(coloc_res$summary["PP.H4"], 3), "\n")
cat("MR IVW causal estimate (log OR per SD PCSK9):", round(mr_res$beta[ mr_res$method == "Inverse variance weighted" ], 3), "\n")
cat("MR 95% CI:", round(mr_res$beta[ mr_res$method == "Inverse variance weighted" ] - 1.96*mr_res$se[ mr_res$method == "Inverse variance weighted" ], 3),
    "to",
    round(mr_res$beta[ mr_res$method == "Inverse variance weighted" ] + 1.96*mr_res$se[ mr_res$method == "Inverse variance weighted" ], 3), "\n")
cat("-----------------------------------------------------------\n")
```

**What this script does**

1. **Loads** the protein QTL and disease GWAS data.
2. **Restricts** to a 500 kb window around the lead pQTL.
3. **Runs colocalisation** – the posterior `PP.H4 = 0.94` tells you the same variant drives both signals.
4. **Performs MR** – the IVW estimate (≈ ‑0.25 on the log‑odds scale) translates to ~22 % lower CAD odds per SD reduction in PCSK9.
5. **Runs diagnostics** to check for pleiotropy or heterogeneity.

---

## 7. When you might *only* do one of the two analyses

| Situation | Use **colocalisation** only | Use **MR** only |
|-----------|----------------------------|-----------------|
| You have a *single* strong cis‑pQTL but no disease GWAS (or you only care about whether the variant is also a disease hit). | Yes – to test if the pQTL overlaps a known disease locus. | No – you need outcome summary stats. |
| You have many independent pQTLs for a protein and a well‑powered disease GWAS, but the disease locus is *far* from any protein QTL. | Not useful – there is no overlapping region to test. | Yes – MR can still be performed using *trans‑pQTLs* as instruments (though they are more prone to pleiotropy). |
| You suspect the causal protein is *different* from the one measured (e.g., the lead SNP affects several proteins). | Colocalisation can be run for each protein to see which one shares the signal. | MR can be applied to each protein; the one with a significant causal estimate is the likely mediator. |

---

## 8. Common pitfalls & how to avoid them

| Pitfall | How it manifests | Remedy |
|--------|------------------|--------|
| **LD‑confounded MR** – instrument SNP is in LD with another causal variant for the disease. | MR gives a significant estimate but colocalisation PP₄ is low. | Perform colocalisation first; discard loci without strong PP₄. |
| **Horizontal pleiotropy** – the SNP influences disease through a pathway *other* than the protein. | MR‑Egger intercept ≠ 0, heterogeneity Q > 0. | Use methods robust to pleiotropy (MR‑PRESSO, weighted median) and/or multivariable MR including other proteins. |
| **Multiple causal variants in the region** (e.g., two independent pQTLs). | `coloc` assuming “single causal variant” can give misleading PP₄. | Use *conditional* colocalisation (e.g., `coloc` after conditioning on the lead SNP) or fine‑mapping tools that allow >1 causal variant (e.g., `SuSiE` + `coloc.susie`). |
| **Allele‑frequency mismatches** (different reference panels). | Wrong alignment → inflated SEs, wrong sign. | Always harmonise using the same reference allele set (e.g., 1000 Genomes EUR). |
| **Sample overlap** between pQTL and disease GWAS (bias MR towards the observational association). | Inflated MR estimates, especially with weak instruments. | Use *two‑sample* MR with non‑overlapping cohorts, or apply bias correction formulas (e.g., Burgess et al., 2016). |

---

## 9. Bottom line

* **Colocalisation** → *“Are we looking at the same genetic cause?"*
* **Mendelian randomisation** → *"If we could change the protein, would disease risk change, and by how much?"*

In a **pQTL pipeline**, the typical order is:

1. **Find a strong cis‑pQTL.**
2. **Colocalise** the pQTL with disease GWAS signals → keep only loci with high PP₄.
3. **Run MR** on the filtered loci → obtain causal effect estimates.

When both steps succeed, you have a **high‑confidence drug‑target hypothesis**: a protein whose genetically lower levels *cause* lower disease risk and whose genetic association *co‑localises* with the disease locus. This is precisely the strategy that underpinned the successful development of **PCSK9‑inhibitors** and many other therapeutic candidates.

[ Prompt: 191.1 t/s | Generation: 144.3 t/s ]
