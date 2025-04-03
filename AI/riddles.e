Loading rhel8/default-icl
  Loading requirement: rhel8/slurm singularity/current rhel8/global cuda/11.4
    vgl/2.5.1/64 intel-oneapi-compilers/2022.1.0/gcc/b6zld2mz ucx/1.15.0
    intel-oneapi-mpi/2021.6.0/intel/guxuvcpm
llama_model_loader: loaded meta data with 53 key-value pairs and 1025 tensors from /home/jhz22/hpc-work/ollama/DeepSeek-V3-0324-UD-IQ2_XXS.gguf (version GGUF V3 (latest))
llama_model_loader: Dumping metadata keys/values. Note: KV overrides do not apply in this output.
llama_model_loader: - kv   0:                       general.architecture str              = deepseek2
llama_model_loader: - kv   1:                               general.type str              = model
llama_model_loader: - kv   2:                               general.name str              = DeepSeek V3 0324 BF16
llama_model_loader: - kv   3:                       general.quantized_by str              = Unsloth
llama_model_loader: - kv   4:                         general.size_label str              = 256x20B
llama_model_loader: - kv   5:                            general.license str              = mit
llama_model_loader: - kv   6:                           general.repo_url str              = https://huggingface.co/unsloth
llama_model_loader: - kv   7:                      deepseek2.block_count u32              = 61
llama_model_loader: - kv   8:                   deepseek2.context_length u32              = 163840
llama_model_loader: - kv   9:                 deepseek2.embedding_length u32              = 7168
llama_model_loader: - kv  10:              deepseek2.feed_forward_length u32              = 18432
llama_model_loader: - kv  11:             deepseek2.attention.head_count u32              = 128
llama_model_loader: - kv  12:          deepseek2.attention.head_count_kv u32              = 128
llama_model_loader: - kv  13:                   deepseek2.rope.freq_base f32              = 10000.000000
llama_model_loader: - kv  14: deepseek2.attention.layer_norm_rms_epsilon f32              = 0.000001
llama_model_loader: - kv  15:                deepseek2.expert_used_count u32              = 8
llama_model_loader: - kv  16:        deepseek2.leading_dense_block_count u32              = 3
llama_model_loader: - kv  17:                       deepseek2.vocab_size u32              = 129280
llama_model_loader: - kv  18:            deepseek2.attention.q_lora_rank u32              = 1536
llama_model_loader: - kv  19:           deepseek2.attention.kv_lora_rank u32              = 512
llama_model_loader: - kv  20:             deepseek2.attention.key_length u32              = 192
llama_model_loader: - kv  21:           deepseek2.attention.value_length u32              = 128
llama_model_loader: - kv  22:       deepseek2.expert_feed_forward_length u32              = 2048
llama_model_loader: - kv  23:                     deepseek2.expert_count u32              = 256
llama_model_loader: - kv  24:              deepseek2.expert_shared_count u32              = 1
llama_model_loader: - kv  25:             deepseek2.expert_weights_scale f32              = 2.500000
llama_model_loader: - kv  26:              deepseek2.expert_weights_norm bool             = true
llama_model_loader: - kv  27:               deepseek2.expert_gating_func u32              = 2
llama_model_loader: - kv  28:             deepseek2.rope.dimension_count u32              = 64
llama_model_loader: - kv  29:                deepseek2.rope.scaling.type str              = yarn
llama_model_loader: - kv  30:              deepseek2.rope.scaling.factor f32              = 40.000000
llama_model_loader: - kv  31: deepseek2.rope.scaling.original_context_length u32              = 4096
llama_model_loader: - kv  32: deepseek2.rope.scaling.yarn_log_multiplier f32              = 0.100000
llama_model_loader: - kv  33:                       tokenizer.ggml.model str              = gpt2
llama_model_loader: - kv  34:                         tokenizer.ggml.pre str              = deepseek-v3
Exception ignored on calling ctypes callback function: <function llama_log_callback at 0x14cad3bf2840>
Traceback (most recent call last):
  File "/rds/project/rds-4o5vpvAowP0/software/py3.11/lib64/python3.11/site-packages/llama_cpp/_logger.py", line 39, in llama_log_callback
    print(text.decode("utf-8"), end="", flush=True, file=sys.stderr)
          ^^^^^^^^^^^^^^^^^^^^
UnicodeDecodeError: 'utf-8' codec can't decode byte 0xef in position 128: invalid continuation byte
llama_model_loader: - kv  36:                  tokenizer.ggml.token_type arr[i32,129280]  = [3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
llama_model_loader: - kv  37:                      tokenizer.ggml.merges arr[str,127741]  = ["Ġ t", "Ġ a", "i n", "Ġ Ġ", "h e...
llama_model_loader: - kv  38:                tokenizer.ggml.bos_token_id u32              = 0
llama_model_loader: - kv  39:                tokenizer.ggml.eos_token_id u32              = 1
llama_model_loader: - kv  40:            tokenizer.ggml.padding_token_id u32              = 1
llama_model_loader: - kv  41:               tokenizer.ggml.add_bos_token bool             = true
llama_model_loader: - kv  42:               tokenizer.ggml.add_eos_token bool             = false
llama_model_loader: - kv  43:                    tokenizer.chat_template str              = {% if not add_generation_prompt is de...
llama_model_loader: - kv  44:               general.quantization_version u32              = 2
llama_model_loader: - kv  45:                          general.file_type u32              = 19
llama_model_loader: - kv  46:                      quantize.imatrix.file str              = DeepSeek-V3-0324-GGUF/DeepSeek-V3-032...
llama_model_loader: - kv  47:                   quantize.imatrix.dataset str              = /workspace/calibration_datav3.txt
llama_model_loader: - kv  48:             quantize.imatrix.entries_count i32              = 720
llama_model_loader: - kv  49:              quantize.imatrix.chunks_count i32              = 124
llama_model_loader: - kv  50:                                   split.no u16              = 0
llama_model_loader: - kv  51:                        split.tensors.count i32              = 1025
llama_model_loader: - kv  52:                                split.count u16              = 0
llama_model_loader: - type  f32:  361 tensors
llama_model_loader: - type q3_K:   55 tensors
llama_model_loader: - type q4_K:  193 tensors
llama_model_loader: - type q5_K:  116 tensors
llama_model_loader: - type q6_K:  184 tensors
llama_model_loader: - type iq2_xxs:  116 tensors
print_info: file format = GGUF V3 (latest)
print_info: file type   = IQ2_XXS - 2.0625 bpw
print_info: file size   = 203.63 GiB (2.61 BPW) 
init_tokenizer: initializing tokenizer for type 2
load: control token: 128814 '<｜tool▁sep｜>' is not marked as EOG
load: control token: 128813 '<｜tool▁output▁end｜>' is not marked as EOG
load: control token: 128812 '<｜tool▁output▁begin｜>' is not marked as EOG
load: control token: 128810 '<｜tool▁outputs▁begin｜>' is not marked as EOG
load: control token: 128809 '<｜tool▁call▁end｜>' is not marked as EOG
load: control token: 128806 '<｜tool▁calls▁begin｜>' is not marked as EOG
load: control token: 128805 '<|EOT|>' is not marked as EOG
load: control token: 128804 '<｜Assistant｜>' is not marked as EOG
load: control token: 128803 '<｜User｜>' is not marked as EOG
load: control token: 128801 '<｜fim▁begin｜>' is not marked as EOG
load: control token: 128800 '<｜fim▁hole｜>' is not marked as EOG
load: control token: 128795 '<｜place▁holder▁no▁795｜>' is not marked as EOG
load: control token: 128789 '<｜place▁holder▁no▁789｜>' is not marked as EOG
load: control token: 128788 '<｜place▁holder▁no▁788｜>' is not marked as EOG
load: control token: 128787 '<｜place▁holder▁no▁787｜>' is not marked as EOG
load: control token: 128786 '<｜place▁holder▁no▁786｜>' is not marked as EOG
load: control token: 128784 '<｜place▁holder▁no▁784｜>' is not marked as EOG
load: control token: 128783 '<｜place▁holder▁no▁783｜>' is not marked as EOG
load: control token: 128780 '<｜place▁holder▁no▁780｜>' is not marked as EOG
load: control token: 128778 '<｜place▁holder▁no▁778｜>' is not marked as EOG
load: control token: 128775 '<｜place▁holder▁no▁775｜>' is not marked as EOG
load: control token: 128774 '<｜place▁holder▁no▁774｜>' is not marked as EOG
load: control token: 128773 '<｜place▁holder▁no▁773｜>' is not marked as EOG
load: control token: 128771 '<｜place▁holder▁no▁771｜>' is not marked as EOG
load: control token: 128770 '<｜place▁holder▁no▁770｜>' is not marked as EOG
load: control token: 128769 '<｜place▁holder▁no▁769｜>' is not marked as EOG
load: control token: 128768 '<｜place▁holder▁no▁768｜>' is not marked as EOG
load: control token: 128767 '<｜place▁holder▁no▁767｜>' is not marked as EOG
load: control token: 128766 '<｜place▁holder▁no▁766｜>' is not marked as EOG
load: control token: 128764 '<｜place▁holder▁no▁764｜>' is not marked as EOG
load: control token: 128762 '<｜place▁holder▁no▁762｜>' is not marked as EOG
load: control token: 128759 '<｜place▁holder▁no▁759｜>' is not marked as EOG
load: control token: 128756 '<｜place▁holder▁no▁756｜>' is not marked as EOG
load: control token: 128755 '<｜place▁holder▁no▁755｜>' is not marked as EOG
load: control token: 128754 '<｜place▁holder▁no▁754｜>' is not marked as EOG
load: control token: 128753 '<｜place▁holder▁no▁753｜>' is not marked as EOG
load: control token: 128752 '<｜place▁holder▁no▁752｜>' is not marked as EOG
load: control token: 128751 '<｜place▁holder▁no▁751｜>' is not marked as EOG
load: control token: 128747 '<｜place▁holder▁no▁747｜>' is not marked as EOG
load: control token: 128746 '<｜place▁holder▁no▁746｜>' is not marked as EOG
load: control token: 128745 '<｜place▁holder▁no▁745｜>' is not marked as EOG
load: control token: 128743 '<｜place▁holder▁no▁743｜>' is not marked as EOG
load: control token: 128740 '<｜place▁holder▁no▁740｜>' is not marked as EOG
load: control token: 128735 '<｜place▁holder▁no▁735｜>' is not marked as EOG
load: control token: 128734 '<｜place▁holder▁no▁734｜>' is not marked as EOG
load: control token: 128733 '<｜place▁holder▁no▁733｜>' is not marked as EOG
load: control token: 128732 '<｜place▁holder▁no▁732｜>' is not marked as EOG
load: control token: 128731 '<｜place▁holder▁no▁731｜>' is not marked as EOG
load: control token: 128730 '<｜place▁holder▁no▁730｜>' is not marked as EOG
load: control token: 128726 '<｜place▁holder▁no▁726｜>' is not marked as EOG
load: control token: 128725 '<｜place▁holder▁no▁725｜>' is not marked as EOG
load: control token: 128724 '<｜place▁holder▁no▁724｜>' is not marked as EOG
load: control token: 128723 '<｜place▁holder▁no▁723｜>' is not marked as EOG
load: control token: 128720 '<｜place▁holder▁no▁720｜>' is not marked as EOG
load: control token: 128717 '<｜place▁holder▁no▁717｜>' is not marked as EOG
load: control token: 128714 '<｜place▁holder▁no▁714｜>' is not marked as EOG
load: control token: 128713 '<｜place▁holder▁no▁713｜>' is not marked as EOG
load: control token: 128712 '<｜place▁holder▁no▁712｜>' is not marked as EOG
load: control token: 128711 '<｜place▁holder▁no▁711｜>' is not marked as EOG
load: control token: 128710 '<｜place▁holder▁no▁710｜>' is not marked as EOG
load: control token: 128708 '<｜place▁holder▁no▁708｜>' is not marked as EOG
load: control token: 128707 '<｜place▁holder▁no▁707｜>' is not marked as EOG
load: control token: 128706 '<｜place▁holder▁no▁706｜>' is not marked as EOG
load: control token: 128705 '<｜place▁holder▁no▁705｜>' is not marked as EOG
load: control token: 128704 '<｜place▁holder▁no▁704｜>' is not marked as EOG
load: control token: 128702 '<｜place▁holder▁no▁702｜>' is not marked as EOG
load: control token: 128699 '<｜place▁holder▁no▁699｜>' is not marked as EOG
load: control token: 128698 '<｜place▁holder▁no▁698｜>' is not marked as EOG
load: control token: 128697 '<｜place▁holder▁no▁697｜>' is not marked as EOG
load: control token: 128696 '<｜place▁holder▁no▁696｜>' is not marked as EOG
load: control token: 128694 '<｜place▁holder▁no▁694｜>' is not marked as EOG
load: control token: 128693 '<｜place▁holder▁no▁693｜>' is not marked as EOG
load: control token: 128692 '<｜place▁holder▁no▁692｜>' is not marked as EOG
load: control token: 128691 '<｜place▁holder▁no▁691｜>' is not marked as EOG
load: control token: 128686 '<｜place▁holder▁no▁686｜>' is not marked as EOG
load: control token: 128685 '<｜place▁holder▁no▁685｜>' is not marked as EOG
load: control token: 128684 '<｜place▁holder▁no▁684｜>' is not marked as EOG
load: control token: 128683 '<｜place▁holder▁no▁683｜>' is not marked as EOG
load: control token: 128681 '<｜place▁holder▁no▁681｜>' is not marked as EOG
load: control token: 128679 '<｜place▁holder▁no▁679｜>' is not marked as EOG
load: control token: 128678 '<｜place▁holder▁no▁678｜>' is not marked as EOG
load: control token: 128677 '<｜place▁holder▁no▁677｜>' is not marked as EOG
load: control token: 128676 '<｜place▁holder▁no▁676｜>' is not marked as EOG
load: control token: 128673 '<｜place▁holder▁no▁673｜>' is not marked as EOG
load: control token: 128667 '<｜place▁holder▁no▁667｜>' is not marked as EOG
load: control token: 128662 '<｜place▁holder▁no▁662｜>' is not marked as EOG
load: control token: 128661 '<｜place▁holder▁no▁661｜>' is not marked as EOG
load: control token: 128659 '<｜place▁holder▁no▁659｜>' is not marked as EOG
load: control token: 128657 '<｜place▁holder▁no▁657｜>' is not marked as EOG
load: control token: 128655 '<｜place▁holder▁no▁655｜>' is not marked as EOG
load: control token: 128654 '<｜place▁holder▁no▁654｜>' is not marked as EOG
load: control token: 128653 '<｜place▁holder▁no▁653｜>' is not marked as EOG
load: control token: 128651 '<｜place▁holder▁no▁651｜>' is not marked as EOG
load: control token: 128650 '<｜place▁holder▁no▁650｜>' is not marked as EOG
load: control token: 128646 '<｜place▁holder▁no▁646｜>' is not marked as EOG
load: control token: 128644 '<｜place▁holder▁no▁644｜>' is not marked as EOG
load: control token: 128643 '<｜place▁holder▁no▁643｜>' is not marked as EOG
load: control token: 128642 '<｜place▁holder▁no▁642｜>' is not marked as EOG
load: control token: 128640 '<｜place▁holder▁no▁640｜>' is not marked as EOG
load: control token: 128637 '<｜place▁holder▁no▁637｜>' is not marked as EOG
load: control token: 128635 '<｜place▁holder▁no▁635｜>' is not marked as EOG
load: control token: 128634 '<｜place▁holder▁no▁634｜>' is not marked as EOG
load: control token: 128633 '<｜place▁holder▁no▁633｜>' is not marked as EOG
load: control token: 128632 '<｜place▁holder▁no▁632｜>' is not marked as EOG
load: control token: 128631 '<｜place▁holder▁no▁631｜>' is not marked as EOG
load: control token: 128629 '<｜place▁holder▁no▁629｜>' is not marked as EOG
load: control token: 128627 '<｜place▁holder▁no▁627｜>' is not marked as EOG
load: control token: 128625 '<｜place▁holder▁no▁625｜>' is not marked as EOG
load: control token: 128623 '<｜place▁holder▁no▁623｜>' is not marked as EOG
load: control token: 128622 '<｜place▁holder▁no▁622｜>' is not marked as EOG
load: control token: 128619 '<｜place▁holder▁no▁619｜>' is not marked as EOG
load: control token: 128618 '<｜place▁holder▁no▁618｜>' is not marked as EOG
load: control token: 128616 '<｜place▁holder▁no▁616｜>' is not marked as EOG
load: control token: 128614 '<｜place▁holder▁no▁614｜>' is not marked as EOG
load: control token: 128611 '<｜place▁holder▁no▁611｜>' is not marked as EOG
load: control token: 128610 '<｜place▁holder▁no▁610｜>' is not marked as EOG
load: control token: 128603 '<｜place▁holder▁no▁603｜>' is not marked as EOG
load: control token: 128601 '<｜place▁holder▁no▁601｜>' is not marked as EOG
load: control token: 128599 '<｜place▁holder▁no▁599｜>' is not marked as EOG
load: control token: 128598 '<｜place▁holder▁no▁598｜>' is not marked as EOG
load: control token: 128596 '<｜place▁holder▁no▁596｜>' is not marked as EOG
load: control token: 128595 '<｜place▁holder▁no▁595｜>' is not marked as EOG
load: control token: 128594 '<｜place▁holder▁no▁594｜>' is not marked as EOG
load: control token: 128593 '<｜place▁holder▁no▁593｜>' is not marked as EOG
load: control token: 128592 '<｜place▁holder▁no▁592｜>' is not marked as EOG
load: control token: 128590 '<｜place▁holder▁no▁590｜>' is not marked as EOG
load: control token: 128589 '<｜place▁holder▁no▁589｜>' is not marked as EOG
load: control token: 128586 '<｜place▁holder▁no▁586｜>' is not marked as EOG
load: control token: 128585 '<｜place▁holder▁no▁585｜>' is not marked as EOG
load: control token: 128583 '<｜place▁holder▁no▁583｜>' is not marked as EOG
load: control token: 128582 '<｜place▁holder▁no▁582｜>' is not marked as EOG
load: control token: 128574 '<｜place▁holder▁no▁574｜>' is not marked as EOG
load: control token: 128573 '<｜place▁holder▁no▁573｜>' is not marked as EOG
load: control token: 128571 '<｜place▁holder▁no▁571｜>' is not marked as EOG
load: control token: 128568 '<｜place▁holder▁no▁568｜>' is not marked as EOG
load: control token: 128566 '<｜place▁holder▁no▁566｜>' is not marked as EOG
load: control token: 128565 '<｜place▁holder▁no▁565｜>' is not marked as EOG
load: control token: 128564 '<｜place▁holder▁no▁564｜>' is not marked as EOG
load: control token: 128563 '<｜place▁holder▁no▁563｜>' is not marked as EOG
load: control token: 128561 '<｜place▁holder▁no▁561｜>' is not marked as EOG
load: control token: 128560 '<｜place▁holder▁no▁560｜>' is not marked as EOG
load: control token: 128556 '<｜place▁holder▁no▁556｜>' is not marked as EOG
load: control token: 128555 '<｜place▁holder▁no▁555｜>' is not marked as EOG
load: control token: 128554 '<｜place▁holder▁no▁554｜>' is not marked as EOG
load: control token: 128553 '<｜place▁holder▁no▁553｜>' is not marked as EOG
load: control token: 128548 '<｜place▁holder▁no▁548｜>' is not marked as EOG
load: control token: 128547 '<｜place▁holder▁no▁547｜>' is not marked as EOG
load: control token: 128545 '<｜place▁holder▁no▁545｜>' is not marked as EOG
load: control token: 128544 '<｜place▁holder▁no▁544｜>' is not marked as EOG
load: control token: 128543 '<｜place▁holder▁no▁543｜>' is not marked as EOG
load: control token: 128541 '<｜place▁holder▁no▁541｜>' is not marked as EOG
load: control token: 128540 '<｜place▁holder▁no▁540｜>' is not marked as EOG
load: control token: 128539 '<｜place▁holder▁no▁539｜>' is not marked as EOG
load: control token: 128538 '<｜place▁holder▁no▁538｜>' is not marked as EOG
load: control token: 128537 '<｜place▁holder▁no▁537｜>' is not marked as EOG
load: control token: 128536 '<｜place▁holder▁no▁536｜>' is not marked as EOG
load: control token: 128535 '<｜place▁holder▁no▁535｜>' is not marked as EOG
load: control token: 128534 '<｜place▁holder▁no▁534｜>' is not marked as EOG
load: control token: 128532 '<｜place▁holder▁no▁532｜>' is not marked as EOG
load: control token: 128531 '<｜place▁holder▁no▁531｜>' is not marked as EOG
load: control token: 128529 '<｜place▁holder▁no▁529｜>' is not marked as EOG
load: control token: 128527 '<｜place▁holder▁no▁527｜>' is not marked as EOG
load: control token: 128524 '<｜place▁holder▁no▁524｜>' is not marked as EOG
load: control token: 128521 '<｜place▁holder▁no▁521｜>' is not marked as EOG
load: control token: 128520 '<｜place▁holder▁no▁520｜>' is not marked as EOG
load: control token: 128518 '<｜place▁holder▁no▁518｜>' is not marked as EOG
load: control token: 128517 '<｜place▁holder▁no▁517｜>' is not marked as EOG
load: control token: 128516 '<｜place▁holder▁no▁516｜>' is not marked as EOG
load: control token: 128515 '<｜place▁holder▁no▁515｜>' is not marked as EOG
load: control token: 128511 '<｜place▁holder▁no▁511｜>' is not marked as EOG
load: control token: 128508 '<｜place▁holder▁no▁508｜>' is not marked as EOG
load: control token: 128506 '<｜place▁holder▁no▁506｜>' is not marked as EOG
load: control token: 128501 '<｜place▁holder▁no▁501｜>' is not marked as EOG
load: control token: 128500 '<｜place▁holder▁no▁500｜>' is not marked as EOG
load: control token: 128499 '<｜place▁holder▁no▁499｜>' is not marked as EOG
load: control token: 128498 '<｜place▁holder▁no▁498｜>' is not marked as EOG
load: control token: 128496 '<｜place▁holder▁no▁496｜>' is not marked as EOG
load: control token: 128495 '<｜place▁holder▁no▁495｜>' is not marked as EOG
load: control token: 128493 '<｜place▁holder▁no▁493｜>' is not marked as EOG
load: control token: 128492 '<｜place▁holder▁no▁492｜>' is not marked as EOG
load: control token: 128490 '<｜place▁holder▁no▁490｜>' is not marked as EOG
load: control token: 128485 '<｜place▁holder▁no▁485｜>' is not marked as EOG
load: control token: 128484 '<｜place▁holder▁no▁484｜>' is not marked as EOG
load: control token: 128483 '<｜place▁holder▁no▁483｜>' is not marked as EOG
load: control token: 128482 '<｜place▁holder▁no▁482｜>' is not marked as EOG
load: control token: 128480 '<｜place▁holder▁no▁480｜>' is not marked as EOG
load: control token: 128477 '<｜place▁holder▁no▁477｜>' is not marked as EOG
load: control token: 128476 '<｜place▁holder▁no▁476｜>' is not marked as EOG
load: control token: 128475 '<｜place▁holder▁no▁475｜>' is not marked as EOG
load: control token: 128474 '<｜place▁holder▁no▁474｜>' is not marked as EOG
load: control token: 128472 '<｜place▁holder▁no▁472｜>' is not marked as EOG
load: control token: 128471 '<｜place▁holder▁no▁471｜>' is not marked as EOG
load: control token: 128470 '<｜place▁holder▁no▁470｜>' is not marked as EOG
load: control token: 128469 '<｜place▁holder▁no▁469｜>' is not marked as EOG
load: control token: 128464 '<｜place▁holder▁no▁464｜>' is not marked as EOG
load: control token: 128463 '<｜place▁holder▁no▁463｜>' is not marked as EOG
load: control token: 128462 '<｜place▁holder▁no▁462｜>' is not marked as EOG
load: control token: 128456 '<｜place▁holder▁no▁456｜>' is not marked as EOG
load: control token: 128453 '<｜place▁holder▁no▁453｜>' is not marked as EOG
load: control token: 128452 '<｜place▁holder▁no▁452｜>' is not marked as EOG
load: control token: 128451 '<｜place▁holder▁no▁451｜>' is not marked as EOG
load: control token: 128449 '<｜place▁holder▁no▁449｜>' is not marked as EOG
load: control token: 128448 '<｜place▁holder▁no▁448｜>' is not marked as EOG
load: control token: 128445 '<｜place▁holder▁no▁445｜>' is not marked as EOG
load: control token: 128444 '<｜place▁holder▁no▁444｜>' is not marked as EOG
load: control token: 128439 '<｜place▁holder▁no▁439｜>' is not marked as EOG
load: control token: 128436 '<｜place▁holder▁no▁436｜>' is not marked as EOG
load: control token: 128435 '<｜place▁holder▁no▁435｜>' is not marked as EOG
load: control token: 128433 '<｜place▁holder▁no▁433｜>' is not marked as EOG
load: control token: 128432 '<｜place▁holder▁no▁432｜>' is not marked as EOG
load: control token: 128431 '<｜place▁holder▁no▁431｜>' is not marked as EOG
load: control token: 128429 '<｜place▁holder▁no▁429｜>' is not marked as EOG
load: control token: 128428 '<｜place▁holder▁no▁428｜>' is not marked as EOG
load: control token: 128427 '<｜place▁holder▁no▁427｜>' is not marked as EOG
load: control token: 128426 '<｜place▁holder▁no▁426｜>' is not marked as EOG
load: control token: 128425 '<｜place▁holder▁no▁425｜>' is not marked as EOG
load: control token: 128423 '<｜place▁holder▁no▁423｜>' is not marked as EOG
load: control token: 128421 '<｜place▁holder▁no▁421｜>' is not marked as EOG
load: control token: 128416 '<｜place▁holder▁no▁416｜>' is not marked as EOG
load: control token: 128414 '<｜place▁holder▁no▁414｜>' is not marked as EOG
load: control token: 128413 '<｜place▁holder▁no▁413｜>' is not marked as EOG
load: control token: 128411 '<｜place▁holder▁no▁411｜>' is not marked as EOG
load: control token: 128410 '<｜place▁holder▁no▁410｜>' is not marked as EOG
load: control token: 128407 '<｜place▁holder▁no▁407｜>' is not marked as EOG
load: control token: 128406 '<｜place▁holder▁no▁406｜>' is not marked as EOG
load: control token: 128405 '<｜place▁holder▁no▁405｜>' is not marked as EOG
load: control token: 128404 '<｜place▁holder▁no▁404｜>' is not marked as EOG
load: control token: 128403 '<｜place▁holder▁no▁403｜>' is not marked as EOG
load: control token: 128400 '<｜place▁holder▁no▁400｜>' is not marked as EOG
load: control token: 128398 '<｜place▁holder▁no▁398｜>' is not marked as EOG
load: control token: 128397 '<｜place▁holder▁no▁397｜>' is not marked as EOG
load: control token: 128395 '<｜place▁holder▁no▁395｜>' is not marked as EOG
load: control token: 128394 '<｜place▁holder▁no▁394｜>' is not marked as EOG
load: control token: 128392 '<｜place▁holder▁no▁392｜>' is not marked as EOG
load: control token: 128391 '<｜place▁holder▁no▁391｜>' is not marked as EOG
load: control token: 128390 '<｜place▁holder▁no▁390｜>' is not marked as EOG
load: control token: 128388 '<｜place▁holder▁no▁388｜>' is not marked as EOG
load: control token: 128386 '<｜place▁holder▁no▁386｜>' is not marked as EOG
load: control token: 128385 '<｜place▁holder▁no▁385｜>' is not marked as EOG
load: control token: 128384 '<｜place▁holder▁no▁384｜>' is not marked as EOG
load: control token: 128381 '<｜place▁holder▁no▁381｜>' is not marked as EOG
load: control token: 128380 '<｜place▁holder▁no▁380｜>' is not marked as EOG
load: control token: 128377 '<｜place▁holder▁no▁377｜>' is not marked as EOG
load: control token: 128376 '<｜place▁holder▁no▁376｜>' is not marked as EOG
load: control token: 128374 '<｜place▁holder▁no▁374｜>' is not marked as EOG
load: control token: 128371 '<｜place▁holder▁no▁371｜>' is not marked as EOG
load: control token: 128369 '<｜place▁holder▁no▁369｜>' is not marked as EOG
load: control token: 128366 '<｜place▁holder▁no▁366｜>' is not marked as EOG
load: control token: 128363 '<｜place▁holder▁no▁363｜>' is not marked as EOG
load: control token: 128362 '<｜place▁holder▁no▁362｜>' is not marked as EOG
load: control token: 128360 '<｜place▁holder▁no▁360｜>' is not marked as EOG
load: control token: 128359 '<｜place▁holder▁no▁359｜>' is not marked as EOG
load: control token: 128354 '<｜place▁holder▁no▁354｜>' is not marked as EOG
load: control token: 128353 '<｜place▁holder▁no▁353｜>' is not marked as EOG
load: control token: 128350 '<｜place▁holder▁no▁350｜>' is not marked as EOG
load: control token: 128349 '<｜place▁holder▁no▁349｜>' is not marked as EOG
load: control token: 128343 '<｜place▁holder▁no▁343｜>' is not marked as EOG
load: control token: 128342 '<｜place▁holder▁no▁342｜>' is not marked as EOG
load: control token: 128340 '<｜place▁holder▁no▁340｜>' is not marked as EOG
load: control token: 128337 '<｜place▁holder▁no▁337｜>' is not marked as EOG
load: control token: 128335 '<｜place▁holder▁no▁335｜>' is not marked as EOG
load: control token: 128334 '<｜place▁holder▁no▁334｜>' is not marked as EOG
load: control token: 128332 '<｜place▁holder▁no▁332｜>' is not marked as EOG
load: control token: 128330 '<｜place▁holder▁no▁330｜>' is not marked as EOG
load: control token: 128328 '<｜place▁holder▁no▁328｜>' is not marked as EOG
load: control token: 128326 '<｜place▁holder▁no▁326｜>' is not marked as EOG
load: control token: 128323 '<｜place▁holder▁no▁323｜>' is not marked as EOG
load: control token: 128322 '<｜place▁holder▁no▁322｜>' is not marked as EOG
load: control token: 128321 '<｜place▁holder▁no▁321｜>' is not marked as EOG
load: control token: 128318 '<｜place▁holder▁no▁318｜>' is not marked as EOG
load: control token: 128317 '<｜place▁holder▁no▁317｜>' is not marked as EOG
load: control token: 128316 '<｜place▁holder▁no▁316｜>' is not marked as EOG
load: control token: 128313 '<｜place▁holder▁no▁313｜>' is not marked as EOG
load: control token: 128310 '<｜place▁holder▁no▁310｜>' is not marked as EOG
load: control token: 128308 '<｜place▁holder▁no▁308｜>' is not marked as EOG
load: control token: 128307 '<｜place▁holder▁no▁307｜>' is not marked as EOG
load: control token: 128305 '<｜place▁holder▁no▁305｜>' is not marked as EOG
load: control token: 128304 '<｜place▁holder▁no▁304｜>' is not marked as EOG
load: control token: 128302 '<｜place▁holder▁no▁302｜>' is not marked as EOG
load: control token: 128300 '<｜place▁holder▁no▁300｜>' is not marked as EOG
load: control token: 128298 '<｜place▁holder▁no▁298｜>' is not marked as EOG
load: control token: 128297 '<｜place▁holder▁no▁297｜>' is not marked as EOG
load: control token: 128296 '<｜place▁holder▁no▁296｜>' is not marked as EOG
load: control token: 128294 '<｜place▁holder▁no▁294｜>' is not marked as EOG
load: control token: 128293 '<｜place▁holder▁no▁293｜>' is not marked as EOG
load: control token: 128292 '<｜place▁holder▁no▁292｜>' is not marked as EOG
load: control token: 128291 '<｜place▁holder▁no▁291｜>' is not marked as EOG
load: control token: 128288 '<｜place▁holder▁no▁288｜>' is not marked as EOG
load: control token: 128287 '<｜place▁holder▁no▁287｜>' is not marked as EOG
load: control token: 128286 '<｜place▁holder▁no▁286｜>' is not marked as EOG
load: control token: 128285 '<｜place▁holder▁no▁285｜>' is not marked as EOG
load: control token: 128284 '<｜place▁holder▁no▁284｜>' is not marked as EOG
load: control token: 128283 '<｜place▁holder▁no▁283｜>' is not marked as EOG
load: control token: 128280 '<｜place▁holder▁no▁280｜>' is not marked as EOG
load: control token: 128279 '<｜place▁holder▁no▁279｜>' is not marked as EOG
load: control token: 128278 '<｜place▁holder▁no▁278｜>' is not marked as EOG
load: control token: 128277 '<｜place▁holder▁no▁277｜>' is not marked as EOG
load: control token: 128276 '<｜place▁holder▁no▁276｜>' is not marked as EOG
load: control token: 128275 '<｜place▁holder▁no▁275｜>' is not marked as EOG
load: control token: 128274 '<｜place▁holder▁no▁274｜>' is not marked as EOG
load: control token: 128273 '<｜place▁holder▁no▁273｜>' is not marked as EOG
load: control token: 128272 '<｜place▁holder▁no▁272｜>' is not marked as EOG
load: control token: 128269 '<｜place▁holder▁no▁269｜>' is not marked as EOG
load: control token: 128268 '<｜place▁holder▁no▁268｜>' is not marked as EOG
load: control token: 128267 '<｜place▁holder▁no▁267｜>' is not marked as EOG
load: control token: 128265 '<｜place▁holder▁no▁265｜>' is not marked as EOG
load: control token: 128264 '<｜place▁holder▁no▁264｜>' is not marked as EOG
load: control token: 128261 '<｜place▁holder▁no▁261｜>' is not marked as EOG
load: control token: 128260 '<｜place▁holder▁no▁260｜>' is not marked as EOG
load: control token: 128256 '<｜place▁holder▁no▁256｜>' is not marked as EOG
load: control token: 128253 '<｜place▁holder▁no▁253｜>' is not marked as EOG
load: control token: 128252 '<｜place▁holder▁no▁252｜>' is not marked as EOG
load: control token: 128251 '<｜place▁holder▁no▁251｜>' is not marked as EOG
load: control token: 128250 '<｜place▁holder▁no▁250｜>' is not marked as EOG
load: control token: 128246 '<｜place▁holder▁no▁246｜>' is not marked as EOG
load: control token: 128245 '<｜place▁holder▁no▁245｜>' is not marked as EOG
load: control token: 128244 '<｜place▁holder▁no▁244｜>' is not marked as EOG
load: control token: 128241 '<｜place▁holder▁no▁241｜>' is not marked as EOG
load: control token: 128239 '<｜place▁holder▁no▁239｜>' is not marked as EOG
load: control token: 128236 '<｜place▁holder▁no▁236｜>' is not marked as EOG
load: control token: 128231 '<｜place▁holder▁no▁231｜>' is not marked as EOG
load: control token: 128230 '<｜place▁holder▁no▁230｜>' is not marked as EOG
load: control token: 128229 '<｜place▁holder▁no▁229｜>' is not marked as EOG
load: control token: 128227 '<｜place▁holder▁no▁227｜>' is not marked as EOG
load: control token: 128225 '<｜place▁holder▁no▁225｜>' is not marked as EOG
load: control token: 128224 '<｜place▁holder▁no▁224｜>' is not marked as EOG
load: control token: 128223 '<｜place▁holder▁no▁223｜>' is not marked as EOG
load: control token: 128221 '<｜place▁holder▁no▁221｜>' is not marked as EOG
load: control token: 128220 '<｜place▁holder▁no▁220｜>' is not marked as EOG
load: control token: 128219 '<｜place▁holder▁no▁219｜>' is not marked as EOG
load: control token: 128217 '<｜place▁holder▁no▁217｜>' is not marked as EOG
load: control token: 128215 '<｜place▁holder▁no▁215｜>' is not marked as EOG
load: control token: 128210 '<｜place▁holder▁no▁210｜>' is not marked as EOG
load: control token: 128208 '<｜place▁holder▁no▁208｜>' is not marked as EOG
load: control token: 128207 '<｜place▁holder▁no▁207｜>' is not marked as EOG
load: control token: 128201 '<｜place▁holder▁no▁201｜>' is not marked as EOG
load: control token: 128198 '<｜place▁holder▁no▁198｜>' is not marked as EOG
load: control token: 128197 '<｜place▁holder▁no▁197｜>' is not marked as EOG
load: control token: 128196 '<｜place▁holder▁no▁196｜>' is not marked as EOG
load: control token: 128194 '<｜place▁holder▁no▁194｜>' is not marked as EOG
load: control token: 128191 '<｜place▁holder▁no▁191｜>' is not marked as EOG
load: control token: 128190 '<｜place▁holder▁no▁190｜>' is not marked as EOG
load: control token: 128189 '<｜place▁holder▁no▁189｜>' is not marked as EOG
load: control token: 128188 '<｜place▁holder▁no▁188｜>' is not marked as EOG
load: control token: 128187 '<｜place▁holder▁no▁187｜>' is not marked as EOG
load: control token: 128186 '<｜place▁holder▁no▁186｜>' is not marked as EOG
load: control token: 128182 '<｜place▁holder▁no▁182｜>' is not marked as EOG
load: control token: 128180 '<｜place▁holder▁no▁180｜>' is not marked as EOG
load: control token: 128179 '<｜place▁holder▁no▁179｜>' is not marked as EOG
load: control token: 128177 '<｜place▁holder▁no▁177｜>' is not marked as EOG
load: control token: 128176 '<｜place▁holder▁no▁176｜>' is not marked as EOG
load: control token: 128175 '<｜place▁holder▁no▁175｜>' is not marked as EOG
load: control token: 128174 '<｜place▁holder▁no▁174｜>' is not marked as EOG
load: control token: 128173 '<｜place▁holder▁no▁173｜>' is not marked as EOG
load: control token: 128172 '<｜place▁holder▁no▁172｜>' is not marked as EOG
load: control token: 128171 '<｜place▁holder▁no▁171｜>' is not marked as EOG
load: control token: 128168 '<｜place▁holder▁no▁168｜>' is not marked as EOG
load: control token: 128167 '<｜place▁holder▁no▁167｜>' is not marked as EOG
load: control token: 128166 '<｜place▁holder▁no▁166｜>' is not marked as EOG
load: control token: 128165 '<｜place▁holder▁no▁165｜>' is not marked as EOG
load: control token: 128162 '<｜place▁holder▁no▁162｜>' is not marked as EOG
load: control token: 128161 '<｜place▁holder▁no▁161｜>' is not marked as EOG
load: control token: 128158 '<｜place▁holder▁no▁158｜>' is not marked as EOG
load: control token: 128157 '<｜place▁holder▁no▁157｜>' is not marked as EOG
load: control token: 128155 '<｜place▁holder▁no▁155｜>' is not marked as EOG
load: control token: 128154 '<｜place▁holder▁no▁154｜>' is not marked as EOG
load: control token: 128153 '<｜place▁holder▁no▁153｜>' is not marked as EOG
load: control token: 128152 '<｜place▁holder▁no▁152｜>' is not marked as EOG
load: control token: 128149 '<｜place▁holder▁no▁149｜>' is not marked as EOG
load: control token: 128147 '<｜place▁holder▁no▁147｜>' is not marked as EOG
load: control token: 128145 '<｜place▁holder▁no▁145｜>' is not marked as EOG
load: control token: 128143 '<｜place▁holder▁no▁143｜>' is not marked as EOG
load: control token: 128139 '<｜place▁holder▁no▁139｜>' is not marked as EOG
load: control token: 128138 '<｜place▁holder▁no▁138｜>' is not marked as EOG
load: control token: 128136 '<｜place▁holder▁no▁136｜>' is not marked as EOG
load: control token: 128135 '<｜place▁holder▁no▁135｜>' is not marked as EOG
load: control token: 128133 '<｜place▁holder▁no▁133｜>' is not marked as EOG
load: control token: 128131 '<｜place▁holder▁no▁131｜>' is not marked as EOG
load: control token: 128129 '<｜place▁holder▁no▁129｜>' is not marked as EOG
load: control token: 128128 '<｜place▁holder▁no▁128｜>' is not marked as EOG
load: control token: 128126 '<｜place▁holder▁no▁126｜>' is not marked as EOG
load: control token: 128125 '<｜place▁holder▁no▁125｜>' is not marked as EOG
load: control token: 128123 '<｜place▁holder▁no▁123｜>' is not marked as EOG
load: control token: 128122 '<｜place▁holder▁no▁122｜>' is not marked as EOG
load: control token: 128120 '<｜place▁holder▁no▁120｜>' is not marked as EOG
load: control token: 128118 '<｜place▁holder▁no▁118｜>' is not marked as EOG
load: control token: 128117 '<｜place▁holder▁no▁117｜>' is not marked as EOG
load: control token: 128116 '<｜place▁holder▁no▁116｜>' is not marked as EOG
load: control token: 128115 '<｜place▁holder▁no▁115｜>' is not marked as EOG
load: control token: 128114 '<｜place▁holder▁no▁114｜>' is not marked as EOG
load: control token: 128113 '<｜place▁holder▁no▁113｜>' is not marked as EOG
load: control token: 128110 '<｜place▁holder▁no▁110｜>' is not marked as EOG
load: control token: 128107 '<｜place▁holder▁no▁107｜>' is not marked as EOG
load: control token: 128105 '<｜place▁holder▁no▁105｜>' is not marked as EOG
load: control token: 128101 '<｜place▁holder▁no▁101｜>' is not marked as EOG
load: control token: 128100 '<｜place▁holder▁no▁100｜>' is not marked as EOG
load: control token: 128099 '<｜place▁holder▁no▁99｜>' is not marked as EOG
load: control token: 128098 '<｜place▁holder▁no▁98｜>' is not marked as EOG
load: control token: 128095 '<｜place▁holder▁no▁95｜>' is not marked as EOG
load: control token: 128094 '<｜place▁holder▁no▁94｜>' is not marked as EOG
load: control token: 128093 '<｜place▁holder▁no▁93｜>' is not marked as EOG
load: control token: 128091 '<｜place▁holder▁no▁91｜>' is not marked as EOG
load: control token: 128090 '<｜place▁holder▁no▁90｜>' is not marked as EOG
load: control token: 128088 '<｜place▁holder▁no▁88｜>' is not marked as EOG
load: control token: 128086 '<｜place▁holder▁no▁86｜>' is not marked as EOG
load: control token: 128085 '<｜place▁holder▁no▁85｜>' is not marked as EOG
load: control token: 128084 '<｜place▁holder▁no▁84｜>' is not marked as EOG
load: control token: 128083 '<｜place▁holder▁no▁83｜>' is not marked as EOG
load: control token: 128082 '<｜place▁holder▁no▁82｜>' is not marked as EOG
load: control token: 128081 '<｜place▁holder▁no▁81｜>' is not marked as EOG
load: control token: 128080 '<｜place▁holder▁no▁80｜>' is not marked as EOG
load: control token: 128079 '<｜place▁holder▁no▁79｜>' is not marked as EOG
load: control token: 128076 '<｜place▁holder▁no▁76｜>' is not marked as EOG
load: control token: 128075 '<｜place▁holder▁no▁75｜>' is not marked as EOG
load: control token: 128074 '<｜place▁holder▁no▁74｜>' is not marked as EOG
load: control token: 128073 '<｜place▁holder▁no▁73｜>' is not marked as EOG
load: control token: 128072 '<｜place▁holder▁no▁72｜>' is not marked as EOG
load: control token: 128071 '<｜place▁holder▁no▁71｜>' is not marked as EOG
load: control token: 128070 '<｜place▁holder▁no▁70｜>' is not marked as EOG
load: control token: 128068 '<｜place▁holder▁no▁68｜>' is not marked as EOG
load: control token: 128067 '<｜place▁holder▁no▁67｜>' is not marked as EOG
load: control token: 128064 '<｜place▁holder▁no▁64｜>' is not marked as EOG
load: control token: 128063 '<｜place▁holder▁no▁63｜>' is not marked as EOG
load: control token: 128056 '<｜place▁holder▁no▁56｜>' is not marked as EOG
load: control token: 128055 '<｜place▁holder▁no▁55｜>' is not marked as EOG
load: control token: 128053 '<｜place▁holder▁no▁53｜>' is not marked as EOG
load: control token: 128052 '<｜place▁holder▁no▁52｜>' is not marked as EOG
load: control token: 128048 '<｜place▁holder▁no▁48｜>' is not marked as EOG
load: control token: 128047 '<｜place▁holder▁no▁47｜>' is not marked as EOG
load: control token: 128046 '<｜place▁holder▁no▁46｜>' is not marked as EOG
load: control token: 128044 '<｜place▁holder▁no▁44｜>' is not marked as EOG
load: control token: 128041 '<｜place▁holder▁no▁41｜>' is not marked as EOG
load: control token: 128040 '<｜place▁holder▁no▁40｜>' is not marked as EOG
load: control token: 128039 '<｜place▁holder▁no▁39｜>' is not marked as EOG
load: control token: 128038 '<｜place▁holder▁no▁38｜>' is not marked as EOG
load: control token: 128034 '<｜place▁holder▁no▁34｜>' is not marked as EOG
load: control token: 128033 '<｜place▁holder▁no▁33｜>' is not marked as EOG
load: control token: 128029 '<｜place▁holder▁no▁29｜>' is not marked as EOG
load: control token: 128024 '<｜place▁holder▁no▁24｜>' is not marked as EOG
load: control token: 128023 '<｜place▁holder▁no▁23｜>' is not marked as EOG
load: control token: 128022 '<｜place▁holder▁no▁22｜>' is not marked as EOG
load: control token: 128021 '<｜place▁holder▁no▁21｜>' is not marked as EOG
load: control token: 128018 '<｜place▁holder▁no▁18｜>' is not marked as EOG
load: control token: 128016 '<｜place▁holder▁no▁16｜>' is not marked as EOG
load: control token: 128015 '<｜place▁holder▁no▁15｜>' is not marked as EOG
load: control token: 128012 '<｜place▁holder▁no▁12｜>' is not marked as EOG
load: control token: 128010 '<｜place▁holder▁no▁10｜>' is not marked as EOG
load: control token: 128009 '<｜place▁holder▁no▁9｜>' is not marked as EOG
load: control token: 128007 '<｜place▁holder▁no▁7｜>' is not marked as EOG
load: control token: 128005 '<｜place▁holder▁no▁5｜>' is not marked as EOG
load: control token: 128004 '<｜place▁holder▁no▁4｜>' is not marked as EOG
load: control token: 128001 '<｜place▁holder▁no▁1｜>' is not marked as EOG
load: control token: 128790 '<｜place▁holder▁no▁790｜>' is not marked as EOG
load: control token: 128218 '<｜place▁holder▁no▁218｜>' is not marked as EOG
load: control token: 128242 '<｜place▁holder▁no▁242｜>' is not marked as EOG
load: control token: 128649 '<｜place▁holder▁no▁649｜>' is not marked as EOG
load: control token: 128087 '<｜place▁holder▁no▁87｜>' is not marked as EOG
load: control token: 128690 '<｜place▁holder▁no▁690｜>' is not marked as EOG
load: control token: 128255 '<｜place▁holder▁no▁255｜>' is not marked as EOG
load: control token: 128665 '<｜place▁holder▁no▁665｜>' is not marked as EOG
load: control token: 128325 '<｜place▁holder▁no▁325｜>' is not marked as EOG
load: control token: 128226 '<｜place▁holder▁no▁226｜>' is not marked as EOG
load: control token: 128570 '<｜place▁holder▁no▁570｜>' is not marked as EOG
load: control token: 128562 '<｜place▁holder▁no▁562｜>' is not marked as EOG
load: control token: 128587 '<｜place▁holder▁no▁587｜>' is not marked as EOG
load: control token: 128378 '<｜place▁holder▁no▁378｜>' is not marked as EOG
load: control token: 128234 '<｜place▁holder▁no▁234｜>' is not marked as EOG
load: control token: 128011 '<｜place▁holder▁no▁11｜>' is not marked as EOG
load: control token: 128656 '<｜place▁holder▁no▁656｜>' is not marked as EOG
load: control token: 128109 '<｜place▁holder▁no▁109｜>' is not marked as EOG
load: control token: 128671 '<｜place▁holder▁no▁671｜>' is not marked as EOG
load: control token: 128722 '<｜place▁holder▁no▁722｜>' is not marked as EOG
load: control token: 128559 '<｜place▁holder▁no▁559｜>' is not marked as EOG
load: control token: 128150 '<｜place▁holder▁no▁150｜>' is not marked as EOG
load: control token: 128645 '<｜place▁holder▁no▁645｜>' is not marked as EOG
load: control token: 128664 '<｜place▁holder▁no▁664｜>' is not marked as EOG
load: control token: 128312 '<｜place▁holder▁no▁312｜>' is not marked as EOG
load: control token: 128299 '<｜place▁holder▁no▁299｜>' is not marked as EOG
load: control token: 128522 '<｜place▁holder▁no▁522｜>' is not marked as EOG
load: control token: 128373 '<｜place▁holder▁no▁373｜>' is not marked as EOG
load: control token: 128204 '<｜place▁holder▁no▁204｜>' is not marked as EOG
load: control token: 128352 '<｜place▁holder▁no▁352｜>' is not marked as EOG
load: control token: 128748 '<｜place▁holder▁no▁748｜>' is not marked as EOG
load: control token: 128419 '<｜place▁holder▁no▁419｜>' is not marked as EOG
load: control token: 128271 '<｜place▁holder▁no▁271｜>' is not marked as EOG
load: control token: 128802 '<｜fim▁end｜>' is not marked as EOG
load: control token: 128357 '<｜place▁holder▁no▁357｜>' is not marked as EOG
load: control token: 128169 '<｜place▁holder▁no▁169｜>' is not marked as EOG
load: control token: 128504 '<｜place▁holder▁no▁504｜>' is not marked as EOG
load: control token: 128549 '<｜place▁holder▁no▁549｜>' is not marked as EOG
load: control token: 128807 '<｜tool▁calls▁end｜>' is not marked as EOG
load: control token: 128160 '<｜place▁holder▁no▁160｜>' is not marked as EOG
load: control token: 128134 '<｜place▁holder▁no▁134｜>' is not marked as EOG
load: control token: 128617 '<｜place▁holder▁no▁617｜>' is not marked as EOG
load: control token: 128675 '<｜place▁holder▁no▁675｜>' is not marked as EOG
load: control token: 128408 '<｜place▁holder▁no▁408｜>' is not marked as EOG
load: control token: 128612 '<｜place▁holder▁no▁612｜>' is not marked as EOG
load: control token: 128254 '<｜place▁holder▁no▁254｜>' is not marked as EOG
load: control token: 128050 '<｜place▁holder▁no▁50｜>' is not marked as EOG
load: control token: 128156 '<｜place▁holder▁no▁156｜>' is not marked as EOG
load: control token: 128680 '<｜place▁holder▁no▁680｜>' is not marked as EOG
load: control token: 128222 '<｜place▁holder▁no▁222｜>' is not marked as EOG
load: control token: 128638 '<｜place▁holder▁no▁638｜>' is not marked as EOG
load: control token: 128014 '<｜place▁holder▁no▁14｜>' is not marked as EOG
load: control token: 128450 '<｜place▁holder▁no▁450｜>' is not marked as EOG
load: control token: 128054 '<｜place▁holder▁no▁54｜>' is not marked as EOG
load: control token: 128488 '<｜place▁holder▁no▁488｜>' is not marked as EOG
load: control token: 128233 '<｜place▁holder▁no▁233｜>' is not marked as EOG
load: control token: 128591 '<｜place▁holder▁no▁591｜>' is not marked as EOG
load: control token: 128430 '<｜place▁holder▁no▁430｜>' is not marked as EOG
load: control token: 128028 '<｜place▁holder▁no▁28｜>' is not marked as EOG
load: control token: 128533 '<｜place▁holder▁no▁533｜>' is not marked as EOG
load: control token: 128652 '<｜place▁holder▁no▁652｜>' is not marked as EOG
load: control token: 128727 '<｜place▁holder▁no▁727｜>' is not marked as EOG
load: control token: 128502 '<｜place▁holder▁no▁502｜>' is not marked as EOG
load: control token: 128365 '<｜place▁holder▁no▁365｜>' is not marked as EOG
load: control token: 128797 '<｜place▁holder▁no▁797｜>' is not marked as EOG
load: control token: 128142 '<｜place▁holder▁no▁142｜>' is not marked as EOG
load: control token: 128037 '<｜place▁holder▁no▁37｜>' is not marked as EOG
load: control token: 128163 '<｜place▁holder▁no▁163｜>' is not marked as EOG
load: control token: 128069 '<｜place▁holder▁no▁69｜>' is not marked as EOG
load: control token: 128709 '<｜place▁holder▁no▁709｜>' is not marked as EOG
load: control token: 128749 '<｜place▁holder▁no▁749｜>' is not marked as EOG
load: control token: 128417 '<｜place▁holder▁no▁417｜>' is not marked as EOG
load: control token: 128641 '<｜place▁holder▁no▁641｜>' is not marked as EOG
load: control token: 128687 '<｜place▁holder▁no▁687｜>' is not marked as EOG
load: control token: 128609 '<｜place▁holder▁no▁609｜>' is not marked as EOG
load: control token: 128440 '<｜place▁holder▁no▁440｜>' is not marked as EOG
load: control token: 128216 '<｜place▁holder▁no▁216｜>' is not marked as EOG
load: control token: 128412 '<｜place▁holder▁no▁412｜>' is not marked as EOG
load: control token: 128200 '<｜place▁holder▁no▁200｜>' is not marked as EOG
load: control token: 128602 '<｜place▁holder▁no▁602｜>' is not marked as EOG
load: control token: 128327 '<｜place▁holder▁no▁327｜>' is not marked as EOG
load: control token: 128013 '<｜place▁holder▁no▁13｜>' is not marked as EOG
load: control token: 128361 '<｜place▁holder▁no▁361｜>' is not marked as EOG
load: control token: 128306 '<｜place▁holder▁no▁306｜>' is not marked as EOG
load: control token: 128550 '<｜place▁holder▁no▁550｜>' is not marked as EOG
load: control token: 128558 '<｜place▁holder▁no▁558｜>' is not marked as EOG
load: control token: 128409 '<｜place▁holder▁no▁409｜>' is not marked as EOG
load: control token: 128424 '<｜place▁holder▁no▁424｜>' is not marked as EOG
load: control token: 128097 '<｜place▁holder▁no▁97｜>' is not marked as EOG
load: control token: 128621 '<｜place▁holder▁no▁621｜>' is not marked as EOG
load: control token: 128455 '<｜place▁holder▁no▁455｜>' is not marked as EOG
load: control token: 128605 '<｜place▁holder▁no▁605｜>' is not marked as EOG
load: control token: 128144 '<｜place▁holder▁no▁144｜>' is not marked as EOG
load: control token: 128379 '<｜place▁holder▁no▁379｜>' is not marked as EOG
load: control token: 128715 '<｜place▁holder▁no▁715｜>' is not marked as EOG
load: control token: 128478 '<｜place▁holder▁no▁478｜>' is not marked as EOG
load: control token: 128043 '<｜place▁holder▁no▁43｜>' is not marked as EOG
load: control token: 128575 '<｜place▁holder▁no▁575｜>' is not marked as EOG
load: control token: 128689 '<｜place▁holder▁no▁689｜>' is not marked as EOG
load: control token: 128513 '<｜place▁holder▁no▁513｜>' is not marked as EOG
load: control token: 128497 '<｜place▁holder▁no▁497｜>' is not marked as EOG
load: control token:      1 '<｜end▁of▁sentence｜>' is not marked as EOG
load: control token: 128624 '<｜place▁holder▁no▁624｜>' is not marked as EOG
load: control token: 128494 '<｜place▁holder▁no▁494｜>' is not marked as EOG
load: control token: 128434 '<｜place▁holder▁no▁434｜>' is not marked as EOG
load: control token: 128164 '<｜place▁holder▁no▁164｜>' is not marked as EOG
load: control token: 128102 '<｜place▁holder▁no▁102｜>' is not marked as EOG
load: control token: 128032 '<｜place▁holder▁no▁32｜>' is not marked as EOG
load: control token: 128584 '<｜place▁holder▁no▁584｜>' is not marked as EOG
load: control token: 128703 '<｜place▁holder▁no▁703｜>' is not marked as EOG
load: control token: 128214 '<｜place▁holder▁no▁214｜>' is not marked as EOG
load: control token: 128205 '<｜place▁holder▁no▁205｜>' is not marked as EOG
load: control token: 128441 '<｜place▁holder▁no▁441｜>' is not marked as EOG
load: control token: 128184 '<｜place▁holder▁no▁184｜>' is not marked as EOG
load: control token: 128058 '<｜place▁holder▁no▁58｜>' is not marked as EOG
load: control token: 128420 '<｜place▁holder▁no▁420｜>' is not marked as EOG
load: control token: 128630 '<｜place▁holder▁no▁630｜>' is not marked as EOG
load: control token: 128078 '<｜place▁holder▁no▁78｜>' is not marked as EOG
load: control token: 128523 '<｜place▁holder▁no▁523｜>' is not marked as EOG
load: control token: 128008 '<｜place▁holder▁no▁8｜>' is not marked as EOG
load: control token: 128737 '<｜place▁holder▁no▁737｜>' is not marked as EOG
load: control token:      0 '<｜begin▁of▁sentence｜>' is not marked as EOG
load: control token: 128249 '<｜place▁holder▁no▁249｜>' is not marked as EOG
load: control token: 128183 '<｜place▁holder▁no▁183｜>' is not marked as EOG
load: control token: 128793 '<｜place▁holder▁no▁793｜>' is not marked as EOG
load: control token: 128089 '<｜place▁holder▁no▁89｜>' is not marked as EOG
load: control token: 128248 '<｜place▁holder▁no▁248｜>' is not marked as EOG
load: control token: 128159 '<｜place▁holder▁no▁159｜>' is not marked as EOG
load: control token: 128132 '<｜place▁holder▁no▁132｜>' is not marked as EOG
load: control token: 128660 '<｜place▁holder▁no▁660｜>' is not marked as EOG
load: control token: 128672 '<｜place▁holder▁no▁672｜>' is not marked as EOG
load: control token: 128772 '<｜place▁holder▁no▁772｜>' is not marked as EOG
load: control token: 128467 '<｜place▁holder▁no▁467｜>' is not marked as EOG
load: control token: 128620 '<｜place▁holder▁no▁620｜>' is not marked as EOG
load: control token: 128507 '<｜place▁holder▁no▁507｜>' is not marked as EOG
load: control token: 128600 '<｜place▁holder▁no▁600｜>' is not marked as EOG
load: control token: 128542 '<｜place▁holder▁no▁542｜>' is not marked as EOG
load: control token: 128263 '<｜place▁holder▁no▁263｜>' is not marked as EOG
load: control token: 128468 '<｜place▁holder▁no▁468｜>' is not marked as EOG
load: control token: 128465 '<｜place▁holder▁no▁465｜>' is not marked as EOG
load: control token: 128092 '<｜place▁holder▁no▁92｜>' is not marked as EOG
load: control token: 128193 '<｜place▁holder▁no▁193｜>' is not marked as EOG
load: control token: 128530 '<｜place▁holder▁no▁530｜>' is not marked as EOG
load: control token: 128339 '<｜place▁holder▁no▁339｜>' is not marked as EOG
load: control token: 128489 '<｜place▁holder▁no▁489｜>' is not marked as EOG
load: control token: 128062 '<｜place▁holder▁no▁62｜>' is not marked as EOG
load: control token: 128567 '<｜place▁holder▁no▁567｜>' is not marked as EOG
load: control token: 128202 '<｜place▁holder▁no▁202｜>' is not marked as EOG
load: control token: 128738 '<｜place▁holder▁no▁738｜>' is not marked as EOG
load: control token: 128130 '<｜place▁holder▁no▁130｜>' is not marked as EOG
load: control token: 128119 '<｜place▁holder▁no▁119｜>' is not marked as EOG
load: control token: 128124 '<｜place▁holder▁no▁124｜>' is not marked as EOG
load: control token: 128503 '<｜place▁holder▁no▁503｜>' is not marked as EOG
load: control token: 128240 '<｜place▁holder▁no▁240｜>' is not marked as EOG
load: control token: 128572 '<｜place▁holder▁no▁572｜>' is not marked as EOG
load: control token: 128528 '<｜place▁holder▁no▁528｜>' is not marked as EOG
load: control token: 128607 '<｜place▁holder▁no▁607｜>' is not marked as EOG
load: control token: 128438 '<｜place▁holder▁no▁438｜>' is not marked as EOG
load: control token: 128808 '<｜tool▁call▁begin｜>' is not marked as EOG
load: control token: 128658 '<｜place▁holder▁no▁658｜>' is not marked as EOG
load: control token: 128002 '<｜place▁holder▁no▁2｜>' is not marked as EOG
load: control token: 128758 '<｜place▁holder▁no▁758｜>' is not marked as EOG
load: control token: 128486 '<｜place▁holder▁no▁486｜>' is not marked as EOG
load: control token: 128031 '<｜place▁holder▁no▁31｜>' is not marked as EOG
load: control token: 128459 '<｜place▁holder▁no▁459｜>' is not marked as EOG
load: control token: 128663 '<｜place▁holder▁no▁663｜>' is not marked as EOG
load: control token:      2 '<｜▁pad▁｜>' is not marked as EOG
load: control token: 128243 '<｜place▁holder▁no▁243｜>' is not marked as EOG
load: control token: 128674 '<｜place▁holder▁no▁674｜>' is not marked as EOG
load: control token: 128237 '<｜place▁holder▁no▁237｜>' is not marked as EOG
load: control token: 128309 '<｜place▁holder▁no▁309｜>' is not marked as EOG
load: control token: 128006 '<｜place▁holder▁no▁6｜>' is not marked as EOG
load: control token: 128356 '<｜place▁holder▁no▁356｜>' is not marked as EOG
load: control token: 128750 '<｜place▁holder▁no▁750｜>' is not marked as EOG
load: control token: 128393 '<｜place▁holder▁no▁393｜>' is not marked as EOG
load: control token: 128348 '<｜place▁holder▁no▁348｜>' is not marked as EOG
load: control token: 128799 '<｜place▁holder▁no▁799｜>' is not marked as EOG
load: control token: 128096 '<｜place▁holder▁no▁96｜>' is not marked as EOG
load: control token: 128721 '<｜place▁holder▁no▁721｜>' is not marked as EOG
load: control token: 128782 '<｜place▁holder▁no▁782｜>' is not marked as EOG
load: control token: 128399 '<｜place▁holder▁no▁399｜>' is not marked as EOG
load: control token: 128578 '<｜place▁holder▁no▁578｜>' is not marked as EOG
load: control token: 128760 '<｜place▁holder▁no▁760｜>' is not marked as EOG
load: control token: 128512 '<｜place▁holder▁no▁512｜>' is not marked as EOG
load: control token: 128387 '<｜place▁holder▁no▁387｜>' is not marked as EOG
load: control token: 128104 '<｜place▁holder▁no▁104｜>' is not marked as EOG
load: control token: 128059 '<｜place▁holder▁no▁59｜>' is not marked as EOG
load: control token: 128351 '<｜place▁holder▁no▁351｜>' is not marked as EOG
load: control token: 128042 '<｜place▁holder▁no▁42｜>' is not marked as EOG
load: control token: 128303 '<｜place▁holder▁no▁303｜>' is not marked as EOG
load: control token: 128761 '<｜place▁holder▁no▁761｜>' is not marked as EOG
load: control token: 128030 '<｜place▁holder▁no▁30｜>' is not marked as EOG
load: control token: 128367 '<｜place▁holder▁no▁367｜>' is not marked as EOG
load: control token: 128682 '<｜place▁holder▁no▁682｜>' is not marked as EOG
load: control token: 128020 '<｜place▁holder▁no▁20｜>' is not marked as EOG
load: control token: 128382 '<｜place▁holder▁no▁382｜>' is not marked as EOG
load: control token: 128258 '<｜place▁holder▁no▁258｜>' is not marked as EOG
load: control token: 128437 '<｜place▁holder▁no▁437｜>' is not marked as EOG
load: control token: 128077 '<｜place▁holder▁no▁77｜>' is not marked as EOG
load: control token: 128341 '<｜place▁holder▁no▁341｜>' is not marked as EOG
load: control token: 128170 '<｜place▁holder▁no▁170｜>' is not marked as EOG
load: control token: 128331 '<｜place▁holder▁no▁331｜>' is not marked as EOG
load: control token: 128315 '<｜place▁holder▁no▁315｜>' is not marked as EOG
load: control token: 128666 '<｜place▁holder▁no▁666｜>' is not marked as EOG
load: control token: 128324 '<｜place▁holder▁no▁324｜>' is not marked as EOG
load: control token: 128141 '<｜place▁holder▁no▁141｜>' is not marked as EOG
load: control token: 128061 '<｜place▁holder▁no▁61｜>' is not marked as EOG
load: control token: 128443 '<｜place▁holder▁no▁443｜>' is not marked as EOG
load: control token: 128779 '<｜place▁holder▁no▁779｜>' is not marked as EOG
load: control token: 128181 '<｜place▁holder▁no▁181｜>' is not marked as EOG
load: control token: 128701 '<｜place▁holder▁no▁701｜>' is not marked as EOG
load: control token: 128546 '<｜place▁holder▁no▁546｜>' is not marked as EOG
load: control token: 128458 '<｜place▁holder▁no▁458｜>' is not marked as EOG
load: control token: 128036 '<｜place▁holder▁no▁36｜>' is not marked as EOG
load: control token: 128057 '<｜place▁holder▁no▁57｜>' is not marked as EOG
load: control token: 128238 '<｜place▁holder▁no▁238｜>' is not marked as EOG
load: control token: 128228 '<｜place▁holder▁no▁228｜>' is not marked as EOG
load: control token: 128415 '<｜place▁holder▁no▁415｜>' is not marked as EOG
load: control token: 128668 '<｜place▁holder▁no▁668｜>' is not marked as EOG
load: control token: 128776 '<｜place▁holder▁no▁776｜>' is not marked as EOG
load: control token: 128336 '<｜place▁holder▁no▁336｜>' is not marked as EOG
load: control token: 128551 '<｜place▁holder▁no▁551｜>' is not marked as EOG
load: control token: 128282 '<｜place▁holder▁no▁282｜>' is not marked as EOG
load: control token: 128232 '<｜place▁holder▁no▁232｜>' is not marked as EOG
load: control token: 128375 '<｜place▁holder▁no▁375｜>' is not marked as EOG
load: control token: 128579 '<｜place▁holder▁no▁579｜>' is not marked as EOG
load: control token: 128785 '<｜place▁holder▁no▁785｜>' is not marked as EOG
load: control token: 128355 '<｜place▁holder▁no▁355｜>' is not marked as EOG
load: control token: 128314 '<｜place▁holder▁no▁314｜>' is not marked as EOG
load: control token: 128461 '<｜place▁holder▁no▁461｜>' is not marked as EOG
load: control token: 128396 '<｜place▁holder▁no▁396｜>' is not marked as EOG
load: control token: 128487 '<｜place▁holder▁no▁487｜>' is not marked as EOG
load: control token: 128295 '<｜place▁holder▁no▁295｜>' is not marked as EOG
load: control token: 128368 '<｜place▁holder▁no▁368｜>' is not marked as EOG
load: control token: 128019 '<｜place▁holder▁no▁19｜>' is not marked as EOG
load: control token: 128418 '<｜place▁holder▁no▁418｜>' is not marked as EOG
load: control token: 128525 '<｜place▁holder▁no▁525｜>' is not marked as EOG
load: control token: 128017 '<｜place▁holder▁no▁17｜>' is not marked as EOG
load: control token: 128552 '<｜place▁holder▁no▁552｜>' is not marked as EOG
load: control token: 128576 '<｜place▁holder▁no▁576｜>' is not marked as EOG
load: control token: 128447 '<｜place▁holder▁no▁447｜>' is not marked as EOG
load: control token: 128716 '<｜place▁holder▁no▁716｜>' is not marked as EOG
load: control token: 128510 '<｜place▁holder▁no▁510｜>' is not marked as EOG
load: control token: 128127 '<｜place▁holder▁no▁127｜>' is not marked as EOG
load: control token: 128695 '<｜place▁holder▁no▁695｜>' is not marked as EOG
load: control token: 128777 '<｜place▁holder▁no▁777｜>' is not marked as EOG
load: control token: 128199 '<｜place▁holder▁no▁199｜>' is not marked as EOG
load: control token: 128151 '<｜place▁holder▁no▁151｜>' is not marked as EOG
load: control token: 128066 '<｜place▁holder▁no▁66｜>' is not marked as EOG
load: control token: 128185 '<｜place▁holder▁no▁185｜>' is not marked as EOG
load: control token: 128209 '<｜place▁holder▁no▁209｜>' is not marked as EOG
load: control token: 128728 '<｜place▁holder▁no▁728｜>' is not marked as EOG
load: control token: 128569 '<｜place▁holder▁no▁569｜>' is not marked as EOG
load: control token: 128281 '<｜place▁holder▁no▁281｜>' is not marked as EOG
load: control token: 128372 '<｜place▁holder▁no▁372｜>' is not marked as EOG
load: control token: 128792 '<｜place▁holder▁no▁792｜>' is not marked as EOG
load: control token: 128329 '<｜place▁holder▁no▁329｜>' is not marked as EOG
load: control token: 128580 '<｜place▁holder▁no▁580｜>' is not marked as EOG
load: control token: 128319 '<｜place▁holder▁no▁319｜>' is not marked as EOG
load: control token: 128626 '<｜place▁holder▁no▁626｜>' is not marked as EOG
load: control token: 128628 '<｜place▁holder▁no▁628｜>' is not marked as EOG
load: control token: 128178 '<｜place▁holder▁no▁178｜>' is not marked as EOG
load: control token: 128389 '<｜place▁holder▁no▁389｜>' is not marked as EOG
load: control token: 128035 '<｜place▁holder▁no▁35｜>' is not marked as EOG
load: control token: 128442 '<｜place▁holder▁no▁442｜>' is not marked as EOG
load: control token: 128739 '<｜place▁holder▁no▁739｜>' is not marked as EOG
load: control token: 128604 '<｜place▁holder▁no▁604｜>' is not marked as EOG
load: control token: 128457 '<｜place▁holder▁no▁457｜>' is not marked as EOG
load: control token: 128192 '<｜place▁holder▁no▁192｜>' is not marked as EOG
load: control token: 128112 '<｜place▁holder▁no▁112｜>' is not marked as EOG
load: control token: 128736 '<｜place▁holder▁no▁736｜>' is not marked as EOG
load: control token: 128446 '<｜place▁holder▁no▁446｜>' is not marked as EOG
load: control token: 128262 '<｜place▁holder▁no▁262｜>' is not marked as EOG
load: control token: 128027 '<｜place▁holder▁no▁27｜>' is not marked as EOG
load: control token: 128647 '<｜place▁holder▁no▁647｜>' is not marked as EOG
load: control token: 128744 '<｜place▁holder▁no▁744｜>' is not marked as EOG
load: control token: 128648 '<｜place▁holder▁no▁648｜>' is not marked as EOG
load: control token: 128320 '<｜place▁holder▁no▁320｜>' is not marked as EOG
load: control token: 128402 '<｜place▁holder▁no▁402｜>' is not marked as EOG
load: control token: 128505 '<｜place▁holder▁no▁505｜>' is not marked as EOG
load: control token: 128247 '<｜place▁holder▁no▁247｜>' is not marked as EOG
load: control token: 128106 '<｜place▁holder▁no▁106｜>' is not marked as EOG
load: control token: 128206 '<｜place▁holder▁no▁206｜>' is not marked as EOG
load: control token: 128051 '<｜place▁holder▁no▁51｜>' is not marked as EOG
load: control token: 128526 '<｜place▁holder▁no▁526｜>' is not marked as EOG
load: control token: 128765 '<｜place▁holder▁no▁765｜>' is not marked as EOG
load: control token: 128581 '<｜place▁holder▁no▁581｜>' is not marked as EOG
load: control token: 128290 '<｜place▁holder▁no▁290｜>' is not marked as EOG
load: control token: 128454 '<｜place▁holder▁no▁454｜>' is not marked as EOG
load: control token: 128763 '<｜place▁holder▁no▁763｜>' is not marked as EOG
load: control token: 128025 '<｜place▁holder▁no▁25｜>' is not marked as EOG
load: control token: 128065 '<｜place▁holder▁no▁65｜>' is not marked as EOG
load: control token: 128700 '<｜place▁holder▁no▁700｜>' is not marked as EOG
load: control token: 128798 '<｜place▁holder▁no▁798｜>' is not marked as EOG
load: control token: 128473 '<｜place▁holder▁no▁473｜>' is not marked as EOG
load: control token: 128401 '<｜place▁holder▁no▁401｜>' is not marked as EOG
load: control token: 128613 '<｜place▁holder▁no▁613｜>' is not marked as EOG
load: control token: 128383 '<｜place▁holder▁no▁383｜>' is not marked as EOG
load: control token: 128345 '<｜place▁holder▁no▁345｜>' is not marked as EOG
load: control token: 128588 '<｜place▁holder▁no▁588｜>' is not marked as EOG
load: control token: 128364 '<｜place▁holder▁no▁364｜>' is not marked as EOG
load: control token: 128333 '<｜place▁holder▁no▁333｜>' is not marked as EOG
load: control token: 128060 '<｜place▁holder▁no▁60｜>' is not marked as EOG
load: control token: 128519 '<｜place▁holder▁no▁519｜>' is not marked as EOG
load: control token: 128615 '<｜place▁holder▁no▁615｜>' is not marked as EOG
load: control token: 128742 '<｜place▁holder▁no▁742｜>' is not marked as EOG
load: control token: 128266 '<｜place▁holder▁no▁266｜>' is not marked as EOG
load: control token: 128259 '<｜place▁holder▁no▁259｜>' is not marked as EOG
load: control token: 128270 '<｜place▁holder▁no▁270｜>' is not marked as EOG
load: control token: 128257 '<｜place▁holder▁no▁257｜>' is not marked as EOG
load: control token: 128796 '<｜place▁holder▁no▁796｜>' is not marked as EOG
load: control token: 128466 '<｜place▁holder▁no▁466｜>' is not marked as EOG
load: control token: 128049 '<｜place▁holder▁no▁49｜>' is not marked as EOG
load: control token: 128301 '<｜place▁holder▁no▁301｜>' is not marked as EOG
load: control token: 128195 '<｜place▁holder▁no▁195｜>' is not marked as EOG
load: control token: 128347 '<｜place▁holder▁no▁347｜>' is not marked as EOG
load: control token: 128146 '<｜place▁holder▁no▁146｜>' is not marked as EOG
load: control token: 128811 '<｜tool▁outputs▁end｜>' is not marked as EOG
load: control token: 128491 '<｜place▁holder▁no▁491｜>' is not marked as EOG
load: control token: 128140 '<｜place▁holder▁no▁140｜>' is not marked as EOG
load: control token: 128719 '<｜place▁holder▁no▁719｜>' is not marked as EOG
load: control token: 128212 '<｜place▁holder▁no▁212｜>' is not marked as EOG
load: control token: 128557 '<｜place▁holder▁no▁557｜>' is not marked as EOG
load: control token: 128235 '<｜place▁holder▁no▁235｜>' is not marked as EOG
load: control token: 128000 '<｜place▁holder▁no▁0｜>' is not marked as EOG
load: control token: 128606 '<｜place▁holder▁no▁606｜>' is not marked as EOG
load: control token: 128346 '<｜place▁holder▁no▁346｜>' is not marked as EOG
load: control token: 128213 '<｜place▁holder▁no▁213｜>' is not marked as EOG
load: control token: 128670 '<｜place▁holder▁no▁670｜>' is not marked as EOG
load: control token: 128203 '<｜place▁holder▁no▁203｜>' is not marked as EOG
load: control token: 128729 '<｜place▁holder▁no▁729｜>' is not marked as EOG
load: control token: 128211 '<｜place▁holder▁no▁211｜>' is not marked as EOG
load: control token: 128718 '<｜place▁holder▁no▁718｜>' is not marked as EOG
load: control token: 128669 '<｜place▁holder▁no▁669｜>' is not marked as EOG
load: control token: 128741 '<｜place▁holder▁no▁741｜>' is not marked as EOG
load: control token: 128137 '<｜place▁holder▁no▁137｜>' is not marked as EOG
load: control token: 128358 '<｜place▁holder▁no▁358｜>' is not marked as EOG
load: control token: 128103 '<｜place▁holder▁no▁103｜>' is not marked as EOG
load: control token: 128597 '<｜place▁holder▁no▁597｜>' is not marked as EOG
load: control token: 128111 '<｜place▁holder▁no▁111｜>' is not marked as EOG
load: control token: 128344 '<｜place▁holder▁no▁344｜>' is not marked as EOG
load: control token: 128003 '<｜place▁holder▁no▁3｜>' is not marked as EOG
load: control token: 128577 '<｜place▁holder▁no▁577｜>' is not marked as EOG
load: control token: 128370 '<｜place▁holder▁no▁370｜>' is not marked as EOG
load: control token: 128514 '<｜place▁holder▁no▁514｜>' is not marked as EOG
load: control token: 128148 '<｜place▁holder▁no▁148｜>' is not marked as EOG
load: control token: 128636 '<｜place▁holder▁no▁636｜>' is not marked as EOG
load: control token: 128460 '<｜place▁holder▁no▁460｜>' is not marked as EOG
load: control token: 128781 '<｜place▁holder▁no▁781｜>' is not marked as EOG
load: control token: 128688 '<｜place▁holder▁no▁688｜>' is not marked as EOG
load: control token: 128338 '<｜place▁holder▁no▁338｜>' is not marked as EOG
load: control token: 128311 '<｜place▁holder▁no▁311｜>' is not marked as EOG
load: control token: 128422 '<｜place▁holder▁no▁422｜>' is not marked as EOG
load: control token: 128479 '<｜place▁holder▁no▁479｜>' is not marked as EOG
load: control token: 128045 '<｜place▁holder▁no▁45｜>' is not marked as EOG
load: control token: 128509 '<｜place▁holder▁no▁509｜>' is not marked as EOG
load: control token: 128289 '<｜place▁holder▁no▁289｜>' is not marked as EOG
load: control token: 128608 '<｜place▁holder▁no▁608｜>' is not marked as EOG
load: control token: 128481 '<｜place▁holder▁no▁481｜>' is not marked as EOG
load: control token: 128794 '<｜place▁holder▁no▁794｜>' is not marked as EOG
load: control token: 128639 '<｜place▁holder▁no▁639｜>' is not marked as EOG
load: control token: 128757 '<｜place▁holder▁no▁757｜>' is not marked as EOG
load: control token: 128791 '<｜place▁holder▁no▁791｜>' is not marked as EOG
load: control token: 128108 '<｜place▁holder▁no▁108｜>' is not marked as EOG
load: control token: 128121 '<｜place▁holder▁no▁121｜>' is not marked as EOG
load: control token: 128026 '<｜place▁holder▁no▁26｜>' is not marked as EOG
load: special_eos_id is not in special_eog_ids - the tokenizer config may be incorrect
load: special tokens cache size = 818
load: token to piece cache size = 0.8223 MB
print_info: arch             = deepseek2
print_info: vocab_only       = 0
print_info: n_ctx_train      = 163840
print_info: n_embd           = 7168
print_info: n_layer          = 61
print_info: n_head           = 128
print_info: n_head_kv        = 128
print_info: n_rot            = 64
print_info: n_swa            = 0
print_info: n_embd_head_k    = 192
print_info: n_embd_head_v    = 128
print_info: n_gqa            = 1
print_info: n_embd_k_gqa     = 24576
print_info: n_embd_v_gqa     = 16384
print_info: f_norm_eps       = 0.0e+00
print_info: f_norm_rms_eps   = 1.0e-06
print_info: f_clamp_kqv      = 0.0e+00
print_info: f_max_alibi_bias = 0.0e+00
print_info: f_logit_scale    = 0.0e+00
print_info: f_attn_scale     = 0.0e+00
print_info: n_ff             = 18432
print_info: n_expert         = 256
print_info: n_expert_used    = 8
print_info: causal attn      = 1
print_info: pooling type     = 0
print_info: rope type        = 0
print_info: rope scaling     = yarn
print_info: freq_base_train  = 10000.0
print_info: freq_scale_train = 0.025
print_info: n_ctx_orig_yarn  = 4096
print_info: rope_finetuned   = unknown
print_info: ssm_d_conv       = 0
print_info: ssm_d_inner      = 0
print_info: ssm_d_state      = 0
print_info: ssm_dt_rank      = 0
print_info: ssm_dt_b_c_rms   = 0
print_info: model type       = 671B
print_info: model params     = 671.03 B
print_info: general.name     = DeepSeek V3 0324 BF16
print_info: n_layer_dense_lead   = 3
print_info: n_lora_q             = 1536
print_info: n_lora_kv            = 512
print_info: n_ff_exp             = 2048
print_info: n_expert_shared      = 1
print_info: expert_weights_scale = 2.5
print_info: expert_weights_norm  = 1
print_info: expert_gating_func   = sigmoid
print_info: rope_yarn_log_mul    = 0.1000
print_info: vocab type       = BPE
print_info: n_vocab          = 129280
print_info: n_merges         = 127741
print_info: BOS token        = 0 '<｜begin▁of▁sentence｜>'
print_info: EOS token        = 1 '<｜end▁of▁sentence｜>'
print_info: EOT token        = 1 '<｜end▁of▁sentence｜>'
print_info: PAD token        = 1 '<｜end▁of▁sentence｜>'
print_info: LF token         = 201 'Ċ'
print_info: FIM PRE token    = 128801 '<｜fim▁begin｜>'
print_info: FIM SUF token    = 128800 '<｜fim▁hole｜>'
print_info: FIM MID token    = 128802 '<｜fim▁end｜>'
print_info: EOG token        = 1 '<｜end▁of▁sentence｜>'
print_info: max token length = 256
load_tensors: loading model tensors, this can take a while... (mmap = true)
load_tensors: layer   0 assigned to device CPU
load_tensors: layer   1 assigned to device CPU
load_tensors: layer   2 assigned to device CPU
load_tensors: layer   3 assigned to device CPU
load_tensors: layer   4 assigned to device CPU
load_tensors: layer   5 assigned to device CPU
load_tensors: layer   6 assigned to device CPU
load_tensors: layer   7 assigned to device CPU
load_tensors: layer   8 assigned to device CPU
load_tensors: layer   9 assigned to device CPU
load_tensors: layer  10 assigned to device CPU
load_tensors: layer  11 assigned to device CPU
load_tensors: layer  12 assigned to device CPU
load_tensors: layer  13 assigned to device CPU
load_tensors: layer  14 assigned to device CPU
load_tensors: layer  15 assigned to device CPU
load_tensors: layer  16 assigned to device CPU
load_tensors: layer  17 assigned to device CPU
load_tensors: layer  18 assigned to device CPU
load_tensors: layer  19 assigned to device CPU
load_tensors: layer  20 assigned to device CPU
load_tensors: layer  21 assigned to device CPU
load_tensors: layer  22 assigned to device CPU
load_tensors: layer  23 assigned to device CPU
load_tensors: layer  24 assigned to device CPU
load_tensors: layer  25 assigned to device CPU
load_tensors: layer  26 assigned to device CPU
load_tensors: layer  27 assigned to device CPU
load_tensors: layer  28 assigned to device CPU
load_tensors: layer  29 assigned to device CPU
load_tensors: layer  30 assigned to device CPU
load_tensors: layer  31 assigned to device CPU
load_tensors: layer  32 assigned to device CPU
load_tensors: layer  33 assigned to device CPU
load_tensors: layer  34 assigned to device CPU
load_tensors: layer  35 assigned to device CPU
load_tensors: layer  36 assigned to device CPU
load_tensors: layer  37 assigned to device CPU
load_tensors: layer  38 assigned to device CPU
load_tensors: layer  39 assigned to device CPU
load_tensors: layer  40 assigned to device CPU
load_tensors: layer  41 assigned to device CPU
load_tensors: layer  42 assigned to device CPU
load_tensors: layer  43 assigned to device CPU
load_tensors: layer  44 assigned to device CPU
load_tensors: layer  45 assigned to device CPU
load_tensors: layer  46 assigned to device CPU
load_tensors: layer  47 assigned to device CPU
load_tensors: layer  48 assigned to device CPU
load_tensors: layer  49 assigned to device CPU
load_tensors: layer  50 assigned to device CPU
load_tensors: layer  51 assigned to device CPU
load_tensors: layer  52 assigned to device CPU
load_tensors: layer  53 assigned to device CPU
load_tensors: layer  54 assigned to device CPU
load_tensors: layer  55 assigned to device CPU
load_tensors: layer  56 assigned to device CPU
load_tensors: layer  57 assigned to device CPU
load_tensors: layer  58 assigned to device CPU
load_tensors: layer  59 assigned to device CPU
load_tensors: layer  60 assigned to device CPU
load_tensors: layer  61 assigned to device CPU
load_tensors: tensor 'token_embd.weight' (q4_K) (and 1024 others) cannot be used with preferred buffer type CPU_AARCH64, using CPU instead
load_tensors:   CPU_Mapped model buffer size = 208518.06 MiB
....................................................................................................
llama_init_from_model: n_seq_max     = 1
llama_init_from_model: n_ctx         = 4096
llama_init_from_model: n_ctx_per_seq = 4096
llama_init_from_model: n_batch       = 512
llama_init_from_model: n_ubatch      = 512
llama_init_from_model: flash_attn    = 0
llama_init_from_model: freq_base     = 10000.0
llama_init_from_model: freq_scale    = 0.025
llama_init_from_model: n_ctx_per_seq (4096) < n_ctx_train (163840) -- the full capacity of the model will not be utilized
llama_kv_cache_init: kv_size = 4096, offload = 1, type_k = 'f16', type_v = 'f16', n_layer = 61, can_shift = 0
llama_kv_cache_init: layer 0: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 1: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 2: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 3: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 4: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 5: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 6: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 7: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 8: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 9: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 10: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 11: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 12: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 13: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 14: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 15: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 16: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 17: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 18: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 19: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 20: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 21: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 22: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 23: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 24: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 25: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 26: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 27: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 28: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 29: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 30: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 31: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 32: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 33: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 34: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 35: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 36: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 37: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 38: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 39: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 40: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 41: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 42: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 43: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 44: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 45: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 46: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 47: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 48: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 49: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 50: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 51: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 52: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 53: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 54: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 55: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 56: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 57: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 58: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 59: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init: layer 60: n_embd_k_gqa = 24576, n_embd_v_gqa = 16384
llama_kv_cache_init:        CPU KV buffer size = 19520.00 MiB
llama_init_from_model: KV self size  = 19520.00 MiB, K (f16): 11712.00 MiB, V (f16): 7808.00 MiB
llama_init_from_model:        CPU  output buffer size =     0.49 MiB
llama_init_from_model:        CPU compute buffer size =  1186.01 MiB
llama_init_from_model: graph nodes  = 5025
llama_init_from_model: graph splits = 1
CPU : SSE3 = 1 | SSSE3 = 1 | AVX = 1 | AVX2 = 1 | F16C = 1 | FMA = 1 | BMI2 = 1 | AVX512 = 1 | AVX512_VBMI = 1 | AVX512_VNNI = 1 | LLAMAFILE = 1 | OPENMP = 1 | AARCH64_REPACK = 1 | 
Model metadata: {'split.no': '0', 'quantize.imatrix.chunks_count': '124', 'quantize.imatrix.dataset': '/workspace/calibration_datav3.txt', 'quantize.imatrix.file': 'DeepSeek-V3-0324-GGUF/DeepSeek-V3-0324.imatrix', 'general.file_type': '19', 'general.quantization_version': '2', 'tokenizer.chat_template': "{% if not add_generation_prompt is defined %}{% set add_generation_prompt = false %}{% endif %}{% set ns = namespace(is_first=false, is_tool=false, is_output_first=true, system_prompt='', is_first_sp=true, is_last_user=false) %}{%- for message in messages %}{%- if message['role'] == 'system' %}{%- if ns.is_first_sp %}{% set ns.system_prompt = ns.system_prompt + message['content'] %}{% set ns.is_first_sp = false %}{%- else %}{% set ns.system_prompt = ns.system_prompt + '\n\n' + message['content'] %}{%- endif %}{%- endif %}{%- endfor %}{{ bos_token }}{{ ns.system_prompt }}{%- for message in messages %}{%- if message['role'] == 'user' %}{%- set ns.is_tool = false -%}{%- set ns.is_first = false -%}{%- set ns.is_last_user = true -%}{{'<｜User｜>' + message['content'] + '<｜Assistant｜>'}}{%- endif %}{%- if message['role'] == 'assistant' and message['tool_calls'] is defined and message['tool_calls'] is not none %}{%- set ns.is_last_user = false -%}{%- if ns.is_tool %}{{'<｜tool▁outputs▁end｜>'}}{%- endif %}{%- set ns.is_first = false %}{%- set ns.is_tool = false -%}{%- set ns.is_output_first = true %}{%- for tool in message['tool_calls'] %}{%- if not ns.is_first %}{%- if message['content'] is none %}{{'<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '\n' + '```json' + '\n' + tool['function']['arguments'] + '\n' + '```' + '<｜tool▁call▁end｜>'}}{%- else %}{{message['content'] + '<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '\n' + '```json' + '\n' + tool['function']['arguments'] + '\n' + '```' + '<｜tool▁call▁end｜>'}}{%- endif %}{%- set ns.is_first = true -%}{%- else %}{{'\n' + '<｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '\n' + '```json' + '\n' + tool['function']['arguments'] + '\n' + '```' + '<｜tool▁call▁end｜>'}}{%- endif %}{%- endfor %}{{'<｜tool▁calls▁end｜><｜end▁of▁sentence｜>'}}{%- endif %}{%- if message['role'] == 'assistant' and (message['tool_calls'] is not defined or message['tool_calls'] is none)%}{%- set ns.is_last_user = false -%}{%- if ns.is_tool %}{{'<｜tool▁outputs▁end｜>' + message['content'] + '<｜end▁of▁sentence｜>'}}{%- set ns.is_tool = false -%}{%- else %}{% set content = message['content'] %}{{content + '<｜end▁of▁sentence｜>'}}{%- endif %}{%- endif %}{%- if message['role'] == 'tool' %}{%- set ns.is_last_user = false -%}{%- set ns.is_tool = true -%}{%- if ns.is_output_first %}{{'<｜tool▁outputs▁begin｜><｜tool▁output▁begin｜>' + message['content'] + '<｜tool▁output▁end｜>'}}{%- set ns.is_output_first = false %}{%- else %}{{'\n<｜tool▁output▁begin｜>' + message['content'] + '<｜tool▁output▁end｜>'}}{%- endif %}{%- endif %}{%- endfor -%}{% if ns.is_tool %}{{'<｜tool▁outputs▁end｜>'}}{% endif %}{% if add_generation_prompt and not ns.is_last_user and not ns.is_tool %}{{'<｜Assistant｜>'}}{% endif %}", 'tokenizer.ggml.add_eos_token': 'false', 'tokenizer.ggml.padding_token_id': '1', 'tokenizer.ggml.eos_token_id': '1', 'deepseek2.attention.layer_norm_rms_epsilon': '0.000001', 'deepseek2.embedding_length': '7168', 'split.count': '0', 'split.tensors.count': '1025', 'deepseek2.attention.head_count_kv': '128', 'deepseek2.rope.scaling.type': 'yarn', 'tokenizer.ggml.add_bos_token': 'true', 'deepseek2.context_length': '163840', 'quantize.imatrix.entries_count': '720', 'deepseek2.attention.q_lora_rank': '1536', 'deepseek2.expert_weights_scale': '2.500000', 'deepseek2.expert_gating_func': '2', 'tokenizer.ggml.pre': 'deepseek-v3', 'deepseek2.block_count': '61', 'deepseek2.expert_used_count': '8', 'general.repo_url': 'https://huggingface.co/unsloth', 'deepseek2.attention.head_count': '128', 'deepseek2.rope.freq_base': '10000.000000', 'general.architecture': 'deepseek2', 'general.type': 'model', 'general.name': 'DeepSeek V3 0324 BF16', 'deepseek2.rope.scaling.original_context_length': '4096', 'general.license': 'mit', 'general.quantized_by': 'Unsloth', 'deepseek2.leading_dense_block_count': '3', 'tokenizer.ggml.model': 'gpt2', 'deepseek2.attention.key_length': '192', 'deepseek2.vocab_size': '129280', 'deepseek2.attention.value_length': '128', 'general.size_label': '256x20B', 'deepseek2.rope.scaling.factor': '40.000000', 'deepseek2.expert_feed_forward_length': '2048', 'deepseek2.feed_forward_length': '18432', 'deepseek2.expert_count': '256', 'deepseek2.expert_shared_count': '1', 'deepseek2.attention.kv_lora_rank': '512', 'deepseek2.expert_weights_norm': 'true', 'deepseek2.rope.dimension_count': '64', 'deepseek2.rope.scaling.yarn_log_multiplier': '0.100000', 'tokenizer.ggml.bos_token_id': '0'}
Available chat formats from metadata: chat_template.default
Using gguf chat template: {% if not add_generation_prompt is defined %}{% set add_generation_prompt = false %}{% endif %}{% set ns = namespace(is_first=false, is_tool=false, is_output_first=true, system_prompt='', is_first_sp=true, is_last_user=false) %}{%- for message in messages %}{%- if message['role'] == 'system' %}{%- if ns.is_first_sp %}{% set ns.system_prompt = ns.system_prompt + message['content'] %}{% set ns.is_first_sp = false %}{%- else %}{% set ns.system_prompt = ns.system_prompt + '

' + message['content'] %}{%- endif %}{%- endif %}{%- endfor %}{{ bos_token }}{{ ns.system_prompt }}{%- for message in messages %}{%- if message['role'] == 'user' %}{%- set ns.is_tool = false -%}{%- set ns.is_first = false -%}{%- set ns.is_last_user = true -%}{{'<｜User｜>' + message['content'] + '<｜Assistant｜>'}}{%- endif %}{%- if message['role'] == 'assistant' and message['tool_calls'] is defined and message['tool_calls'] is not none %}{%- set ns.is_last_user = false -%}{%- if ns.is_tool %}{{'<｜tool▁outputs▁end｜>'}}{%- endif %}{%- set ns.is_first = false %}{%- set ns.is_tool = false -%}{%- set ns.is_output_first = true %}{%- for tool in message['tool_calls'] %}{%- if not ns.is_first %}{%- if message['content'] is none %}{{'<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '
' + '```json' + '
' + tool['function']['arguments'] + '
' + '```' + '<｜tool▁call▁end｜>'}}{%- else %}{{message['content'] + '<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '
' + '```json' + '
' + tool['function']['arguments'] + '
' + '```' + '<｜tool▁call▁end｜>'}}{%- endif %}{%- set ns.is_first = true -%}{%- else %}{{'
' + '<｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '
' + '```json' + '
' + tool['function']['arguments'] + '
' + '```' + '<｜tool▁call▁end｜>'}}{%- endif %}{%- endfor %}{{'<｜tool▁calls▁end｜><｜end▁of▁sentence｜>'}}{%- endif %}{%- if message['role'] == 'assistant' and (message['tool_calls'] is not defined or message['tool_calls'] is none)%}{%- set ns.is_last_user = false -%}{%- if ns.is_tool %}{{'<｜tool▁outputs▁end｜>' + message['content'] + '<｜end▁of▁sentence｜>'}}{%- set ns.is_tool = false -%}{%- else %}{% set content = message['content'] %}{{content + '<｜end▁of▁sentence｜>'}}{%- endif %}{%- endif %}{%- if message['role'] == 'tool' %}{%- set ns.is_last_user = false -%}{%- set ns.is_tool = true -%}{%- if ns.is_output_first %}{{'<｜tool▁outputs▁begin｜><｜tool▁output▁begin｜>' + message['content'] + '<｜tool▁output▁end｜>'}}{%- set ns.is_output_first = false %}{%- else %}{{'
<｜tool▁output▁begin｜>' + message['content'] + '<｜tool▁output▁end｜>'}}{%- endif %}{%- endif %}{%- endfor -%}{% if ns.is_tool %}{{'<｜tool▁outputs▁end｜>'}}{% endif %}{% if add_generation_prompt and not ns.is_last_user and not ns.is_tool %}{{'<｜Assistant｜>'}}{% endif %}
Using chat eos_token: <｜end▁of▁sentence｜>
Using chat bos_token: <｜begin▁of▁sentence｜>
llama_perf_context_print:        load time =  724561.41 ms
llama_perf_context_print: prompt eval time =  724560.47 ms /   999 tokens (  725.29 ms per token,     1.38 tokens per second)
llama_perf_context_print:        eval time = 20838936.90 ms /  2988 runs   ( 6974.21 ms per token,     0.14 tokens per second)
llama_perf_context_print:       total time = 21574320.50 ms /  3987 tokens
