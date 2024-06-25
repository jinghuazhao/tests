bolt \
    --bfile=test \
    --phenoFile=test2.phen \
    --phenoCol=PHENO \
    --lmm \
    --LDscoresUseChip \
    --noMapCheck \
    --numLeaveOutChunks 2 \
    --statsFile=test2.stats \
    --numThreads=2 \
    2>&1 | tee test2.log

bolt \
    --bfile=test \
    --phenoFile=test2.phen \
    --phenoCol=PHENO \
    --reml \
    --noMapCheck \
    --numThreads=2 \
    2>&1 | tee -a test2.log
