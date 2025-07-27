Loading rhel8/default-icl
  Loading requirement: rhel8/slurm singularity/current rhel8/global cuda/11.4
    vgl/2.5.1/64 intel-oneapi-compilers/2022.1.0/gcc/b6zld2mz
    intel-oneapi-mpi/2021.6.0/intel/guxuvcpm
2025-07-26 17:55:25.554609: I tensorflow/core/util/port.cc:153] oneDNN custom operations are on. You may see slightly different numerical results due to floating-point round-off errors from different computation orders. To turn them off, set the environment variable `TF_ENABLE_ONEDNN_OPTS=0`.
2025-07-26 17:55:28.637231: E external/local_xla/xla/stream_executor/cuda/cuda_fft.cc:467] Unable to register cuFFT factory: Attempting to register factory for plugin cuFFT when one has already been registered
WARNING: All log messages before absl::InitializeLog() is called are written to STDERR
E0000 00:00:1753548928.859679  729016 cuda_dnn.cc:8579] Unable to register cuDNN factory: Attempting to register factory for plugin cuDNN when one has already been registered
E0000 00:00:1753548928.943636  729016 cuda_blas.cc:1407] Unable to register cuBLAS factory: Attempting to register factory for plugin cuBLAS when one has already been registered
W0000 00:00:1753548930.168778  729016 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
W0000 00:00:1753548930.168821  729016 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
W0000 00:00:1753548930.168825  729016 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
W0000 00:00:1753548930.168827  729016 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
2025-07-26 17:55:30.237444: I tensorflow/core/platform/cpu_feature_guard.cc:210] This TensorFlow binary is optimized to use available CPU instructions in performance-critical operations.
To enable the following instructions: AVX2 AVX512F AVX512_VNNI FMA, in other operations, rebuild TensorFlow with the appropriate compiler flags.
llama_init_from_model: n_batch is less than GGML_KQ_MASK_PAD - increasing to 64
Exception ignored in: <function Llama.__del__ at 0x149abab345e0>
Traceback (most recent call last):
  File "/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/llama_cpp/llama.py", line 2205, in __del__
  File "/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/llama_cpp/llama.py", line 2202, in close
  File "/usr/lib64/python3.11/contextlib.py", line 609, in close
  File "/usr/lib64/python3.11/contextlib.py", line 601, in __exit__
  File "/usr/lib64/python3.11/contextlib.py", line 586, in __exit__
  File "/usr/lib64/python3.11/contextlib.py", line 360, in __exit__
  File "/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/llama_cpp/_internals.py", line 75, in close
  File "/usr/lib64/python3.11/contextlib.py", line 609, in close
  File "/usr/lib64/python3.11/contextlib.py", line 601, in __exit__
  File "/usr/lib64/python3.11/contextlib.py", line 586, in __exit__
  File "/usr/lib64/python3.11/contextlib.py", line 469, in _exit_wrapper
  File "/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/llama_cpp/_internals.py", line 69, in free_model
TypeError: 'NoneType' object is not callable
