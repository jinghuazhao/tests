/usr/share/Modules/init/bash: line 143: unalias: geany: not found
Loading rhel8/default-icl
  Loading requirement: rhel8/slurm singularity/current rhel8/global cuda/11.4
    vgl/2.5.1/64 intel-oneapi-compilers/2022.1.0/gcc/b6zld2mz ucx/1.15.0
    intel-oneapi-mpi/2021.6.0/intel/guxuvcpm
/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/pytorch_merge/pytorch_merge.py:95: FutureWarning: You are using `torch.load` with `weights_only=False` (the current default value), which uses the default pickle module implicitly. It is possible to construct malicious pickle data which will execute arbitrary code during unpickling (See https://github.com/pytorch/pytorch/blob/main/SECURITY.md#untrusted-models for more details). In a future release, the default value for `weights_only` will be flipped to `True`. This limits the functions that could be executed during unpickling. Arbitrary objects will no longer be allowed to be loaded via this mode unless they are explicitly allowlisted by the user via `torch.serialization.add_safe_globals`. We recommend you start setting `weights_only=True` for any use case where you don't have full control of the loaded file. Please open an issue on GitHub for any issues related to this experimental feature.
  model_1 = torch.load(input_paths[0])
MODEL:   0%|          | 0/6 [00:00<?, ?it/s]/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/pytorch_merge/pytorch_merge.py:103: FutureWarning: You are using `torch.load` with `weights_only=False` (the current default value), which uses the default pickle module implicitly. It is possible to construct malicious pickle data which will execute arbitrary code during unpickling (See https://github.com/pytorch/pytorch/blob/main/SECURITY.md#untrusted-models for more details). In a future release, the default value for `weights_only` will be flipped to `True`. This limits the functions that could be executed during unpickling. Arbitrary objects will no longer be allowed to be loaded via this mode unless they are explicitly allowlisted by the user via `torch.serialization.add_safe_globals`. We recommend you start setting `weights_only=True` for any use case where you don't have full control of the loaded file. Please open an issue on GitHub for any issues related to this experimental feature.
  model_i = torch.load(input_paths[i])

ITEM:   0%|          | 0/48 [00:00<?, ?it/s][AITEM: 100%|██████████| 48/48 [00:00<00:00, 1011691.42it/s]
MODEL:  17%|█▋        | 1/6 [00:14<01:12, 14.56s/it]
ITEM:   0%|          | 0/48 [00:00<?, ?it/s][AITEM: 100%|██████████| 48/48 [00:00<00:00, 1388459.26it/s]
MODEL:  33%|███▎      | 2/6 [00:36<01:15, 18.97s/it]
ITEM:   0%|          | 0/48 [00:00<?, ?it/s][AITEM: 100%|██████████| 48/48 [00:00<00:00, 1198372.57it/s]
MODEL:  50%|█████     | 3/6 [00:54<00:54, 18.28s/it]
ITEM:   0%|          | 0/48 [00:00<?, ?it/s][AITEM: 100%|██████████| 48/48 [00:00<00:00, 1274218.94it/s]
MODEL:  67%|██████▋   | 4/6 [01:15<00:39, 19.56s/it]
ITEM:   0%|          | 0/48 [00:00<?, ?it/s][AITEM: 100%|██████████| 48/48 [00:00<00:00, 1235132.47it/s]
MODEL:  83%|████████▎ | 5/6 [01:30<00:17, 17.72s/it]
ITEM:   0%|          | 0/3 [00:00<?, ?it/s][AITEM: 100%|██████████| 3/3 [00:00<00:00, 119837.26it/s]
MODEL: 100%|██████████| 6/6 [01:31<00:00, 12.15s/it]MODEL: 100%|██████████| 6/6 [01:31<00:00, 15.23s/it]
