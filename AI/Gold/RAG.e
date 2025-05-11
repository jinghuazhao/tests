Loading rhel8/default-icl
  Loading requirement: rhel8/slurm singularity/current rhel8/global cuda/11.4
    vgl/2.5.1/64 intel-oneapi-compilers/2022.1.0/gcc/b6zld2mz ucx/1.15.0
    intel-oneapi-mpi/2021.6.0/intel/guxuvcpm
llama_init_from_model: n_batch is less than GGML_KQ_MASK_PAD - increasing to 64
Traceback (most recent call last):
  File "<stdin>", line 128, in <module>
  File "/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/pydantic/main.py", line 891, in __getattr__
    raise AttributeError(f'{type(self).__name__!r} object has no attribute {item!r}')
AttributeError: 'LlamaCpp' object has no attribute 'close'
Exception ignored in: <function Llama.__del__ at 0x146334b72340>
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
