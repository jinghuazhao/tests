# SNPID experiments

It is often necessary to represent variant in chr:pos_a1/a2 format instead of RSid. Our experiment here involves 10 indels in a VCF file.

The Bash script is collectively generated to [README.sh](README.sh) which in turn generate [README.tsv](README.tsv) whose very last 10 lines are as intended.

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
## A common solution (v1)

This version does not handle multiallelic loci, so we only have chr:pos_[I|D]/[D|I]

```bash
function snpid()
{
  gunzip -c ${1} | \
  awk '
  NR==1,/#CHROM/{print;next}
  {
    FS="\t";OFS="\t"
    if(length($4)>1||length($5)>1) if (length($4)>length($5)) {a1="I";a2="D"} else {a1="D"; a2="I"} else {a1=$4; a2=$5}
    $3=$1":"$2"_"a1"/"a2
  # $4=a1; $5=a2
    print
  }' | bgzip -f > ${2}-snpid.vcf.gz
  bcftools index -tf ${2}-snpid.vcf.gz
}
snpid 10indels.vcf.gz v1
echo v1
tabix v1-snpid.vcf.gz X
```

Note when we uncomment `# $4=a1; $5=a2` the REF/ALT alleles are also changed into I and D.

## Generic case (v2)

We then test for all 10 indels with the same position (60034).

```bash
gunzip -c v1-snpid.vcf.gz | \
  awk '
  NR==1,/#CHROM/{print;next}
  {
    FS="\t";OFS="\t"
    $2=60034
    if(length($4)>1||length($5)>1) if (length($4)>length($5)) {a1="I";a2="D"} else {a1="D"; a2="I"} else {a1=$4; a2=$5}
    $3=$1":"$2"_"a1"/"a2
  # $4=a1; $5=a2
    print
  }' | bgzip -f > m-snpid.vcf.gz
  bcftools index -tf m-snpid.vcf.gz
  echo v2 data
  tabix m-snpid.vcf.gz X
```

We attempt to extend the snpid() function above,

```bash
function snpid2()
{
  gunzip -c ${1} | \
  awk '
  NR==1,/#CHROM/{print;next}
  {
    FS="\t";OFS="\t"
    if(length($4)>1||length($5)>1) if (length($4)>length($5)) {a1="I";a2="D"} else {a1="D"; a2="I"} else {a1=$4; a2=$5}
    $3=$1":"$2"_"a1"/"a2
    n=a[$3]++
    if(n>0) {a1=a1 n; a2=a2 n; $3=$1":"$2"_"a1"/"a2 }
  # $4=a1; $5=a2
    print
  }' | bgzip -f > ${2}-snpid.vcf.gz
  bcftools index -tf ${2}-snpid.vcf.gz
}
snpid2 m-snpid.vcf.gz v2
echo v2
tabix v2-snpid.vcf.gz X
```

## Question

Would PLINK cope with this data well?