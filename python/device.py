import torch
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
ntokens = len(vocab)
model = TransformerModel(
    ntokens,
    embsize,
    nhead,
    d_hid,
    nlayers,
    vocab=vocab,
    pad_value=pad_value,
    n_input_bins=n_input_bins,
    use_fast_transformer=True,
)
model_file = '../save/finetuned_scGPT_adamson/best_model.pt'
try:
    model.load_state_dict(torch.load(model_file, map_location=device))
    print(f"Loading all model params from {model_file}")
except RuntimeError as e:
    print(f"Error loading model: {e}")
    print("Attempting to load model with matching keys and shapes...")
    model_dict = model.state_dict()
    pretrained_dict = torch.load(model_file, map_location=device)
    pretrained_dict = {
        k: v
        for k, v in pretrained_dict.items()
        if k in model_dict and v.shape == model_dict[k].shape
    }
    for k, v in pretrained_dict.items():
        print(f"Loading params {k} with shape {v.shape}")
        model_dict.update({k: v})
    model.load_state_dict(model_dict)
model.to(device)
