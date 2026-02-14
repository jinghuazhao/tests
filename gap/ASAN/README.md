File name| Description
---------|
check-as-cran.log | R CMD check --as-cran using R from clang.sh ((below)[1])
clang.sh | ((clang-based ASAN)[1])
cran.log | ((CRAN check)[2])
gcc.sh   | ((gcc-based asan)[3])
v8.txt   | JS option as hinted

[1]: https://www.stats.ox.ac.uk/pub/bdr/Rconfig/r-devel-linux-x86_64-fedora-clang
[2]: https://win-builder.r-project.org/incoming_pretest/gap_1.13_20260210_170205/specialChecks/clang-san/
[3]: https://www.stats.ox.ac.uk/pub/bdr/Rconfig/r-devel-linux-x86_64-fedora-gcc
