# SNPid experiments

It is often necessary to represent variant in chr:pos_a1/a2 format instead of RSid. Our experiment here involves 10 indels in a VCF file.

The Bash script is collected in [README.sh](README.sh), which generates [README.tsv](README.tsv) whose very last 10 lines are as intended.

## Test data

This is based on a real data involving 10 indels.

```bash
gunzip -c ~/Caprion/tests/ERZ127238/HPSI1013i-garx_3.wec.gtarray.HumanCoreExome-12_v1_0.imputed_phased.20150604.genotypes.vcf.gz | \
awk 'NR==1,/#CHROM/{print;next}{if(length($4)>1||length($5)>1)print}' | \
head -61 | \
bgzip -f > ~/tests/snpid/10indels.vcf.gz
echo 10 indels
bcftools index -tf 10indels.vcf.gz
tabix 10indels.vcf.gz X
```

We also create a multiallelic locus containing all 10 indels (assuming pos=60034).

```bash
gunzip -c 10indels.vcf.gz | \
  awk '
  NR==1,/#CHROM/{print;next}
  {
    FS="\t";OFS="\t"
    $2=60034
    print
  }' | bgzip -f > m-snpid.vcf.gz
  bcftools index -tf m-snpid.vcf.gz
  echo multiallelic case
  tabix m-snpid.vcf.gz X
```

## A usual solution (v1)

We only have chr:pos_[I|D]/[D|I], saving storage and enabling software which handle variant IDs with limited length.

```bash
function snpid()
{
  gunzip -c ${1} | \
  awk -v use_I_D_as_alleles=0 '
  NR==1,/#CHROM/{print;next}
  {
    FS="\t";OFS="\t"
    if(length($4)>1||length($5)>1) if (length($4)>length($5)) {a1="I";a2="D"} else {a1="D"; a2="I"} else {a1=$4; a2=$5}
    $3=$1":"$2"_"a1"/"a2
    if(use_I_D_as_alleles) {$4=a1; $5=a2}
    print
  }' | bgzip -f > ${2}-snpid.vcf.gz
  bcftools index -tf ${2}-snpid.vcf.gz
}
snpid 10indels.vcf.gz v1
echo v1
tabix v1-snpid.vcf.gz X
```

The algorithm with snpid() is broken for the multiallelic locus as it will generate duplicated IDs.

## Generic case (v2)

We now extend the snpid() function above,

```bash
function snpid2()
{
  gunzip -c ${1} | \
  awk -v use_I_D_as_alleles=0 '
  NR==1,/#CHROM/{print;next}
  {
    FS="\t";OFS="\t"
    if(length($4)>1||length($5)>1) if (length($4)>length($5)) {a1="I";a2="D"} else {a1="D"; a2="I"} else {a1=$4; a2=$5}
    $3=$1":"$2"_"a1"/"a2
    n=a[$3]++
    if(n>0) {a1=a1 n; a2=a2 n; $3=$1":"$2"_"a1"/"a2 }
    if(use_I_D_as_alleles) {$4=a1; $5=a2}
    print
  }' | bgzip -f > ${2}-snpid.vcf.gz
  bcftools index -tf ${2}-snpid.vcf.gz
}
snpid2 m-snpid.vcf.gz v2
echo v2
tabix v2-snpid.vcf.gz X
```

Instead of writing out the SNPid duplicates, they are handled on the fly.

## Exercises

1. Modify snpid2() to output the SNPid definition (**Solution**: see up-level directory on the front page).
2. Adapt the function to handle csv/tsv files (*Hint*: Consider change in `NR==1,/#CHROM/`).

## Question

Should we build SNPid directly as chr:pos_a1/a2 without use of D/I, would PLINK cope with this data well?
