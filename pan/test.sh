# gfortran -shared -g -fPIC -ffpe-trap=zero,invalid,overflow,underflow -fdump-tree-original pan.f -o pan.so
# R CMD SHLIB pan.f

gcc -I"${HPC_WORK}/R-4.1.0/include" -DNDEBUG -I${HPC_WORK}/include -fpic  -g -O2 \
    -c package_native_routine_registration_skeleton.c -o package_native_routine_registration_skeleton.o
gfortran -fpic -g -O2 -c pan.f -o pan.o
gcc -shared -L${HPC_WORK}/R-4.1.0/lib -L${HPC_WORK}/lib -o pan.so \
    package_native_routine_registration_skeleton.o pan.o -lgfortran -lm -lquadmath -L${HPC_WORK}/R-4.1.0/lib -lR

R --vanilla <test.R > test.log
