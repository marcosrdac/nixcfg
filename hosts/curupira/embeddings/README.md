# Qwen3-Embedding-0.6B CPU test on Curupira

Minimal, manual experiment on OCI Ampere A1 with NixOS aarch64-linux.
No new daemon, open firewall port, credentials, or proxy. Uses llama.cpp
and GGUF files downloaded at first run, then cached on disk.

## Activate Nix packages

On Curupira, with this Git branch checked out:

```sh
sudo nixos-rebuild test --flake .#curupira
command -v llama-server
llama-server --version
```

This does not modify the boot default. If installation fails, do not use
`switch`: the objective is to validate ARM compatibility first.

## Start a variant

```sh
bash hosts/curupira/embeddings/run.sh q8
```

Variants:

| Argument | Precision | Hugging Face repo | Approximate weights |
| --- | --- | --- | ---: |
| `f16` | FP16 | Qwen/Qwen3-Embedding-0.6B-GGUF | 1.2 GB |
| `q8` | Q8_0 | Qwen/Qwen3-Embedding-0.6B-GGUF | 639 MB |
| `q5` | Q5_K_M | smarttasks/Qwen3-Embedding-0.6B-GGUF | 444 MB |
| `q4` | Q4_K_M | smarttasks/Qwen3-Embedding-0.6B-GGUF | 396 MB |

Stop each server with Ctrl+C before starting the next one.

Defaults are loopback-only at http://127.0.0.1:8711, 3 CPU threads,
2048 tokens of context and one inference slot. Override with e.g.
`THREADS=4 CTX_SIZE=1024 PORT=8712 bash .../run.sh q4`.
Long contexts can consume considerable memory.

## Check embeddings in a second shell

```sh
python3 hosts/curupira/embeddings/bench.py q8 --save /tmp/qwen-q8.json
```

Then stop the server, start F16 and compare embeddings:

```sh
bash hosts/curupira/embeddings/run.sh f16
# In another shell:
python3 hosts/curupira/embeddings/bench.py f16 \
  --save /tmp/qwen-f16.json --compare /tmp/qwen-q8.json
```

Repeat for `q5` and `q4`; pass the variant to the benchmark.

Basic HTTP smoke test with `q8`:

```sh
curl -fsS http://127.0.0.1:8711/v1/embeddings \
 -H 'Content-Type: application/json' \
 -d '{"model":"qwen3-embedding-q8","input":["inversão sísmica","geoquímica"]}'
```

The test expects three finite, 1024-dimensional vectors, prints norms,
a similarity score for an affirmative/negative sentence pair, and elapsed
inference time. This is **not** a quality benchmark: query instructions,
special tokens, EOS handling and normalization must be aligned when comparing
with Transformers or Cloudflare.

## Remote access for testing

The process listens only on `127.0.0.1` inside the VM. On your laptop:

```sh
ssh -L 8711:127.0.0.1:8711 marcosrdac@<curupira-ip>
```

You can now call `http://127.0.0.1:8711/v1/embeddings` from the laptop.
Do not open 8711 in the OCI security list or the NixOS firewall.

Troubleshooting: first startup must download weights; check available
storage, connectivity to huggingface.co, CPU and RAM with `htop` or
`free -h`. On failures inspect `llama-server --help` and version.
The exact installed Nixpkgs llama.cpp binary and real model runs have
**not yet been tested on the Ampere A1**.

Model sources:
- https://huggingface.co/Qwen/Qwen3-Embedding-0.6B-GGUF
- https://huggingface.co/smarttasks/Qwen3-Embedding-0.6B-GGUF
- https://github.com/ggml-org/llama.cpp
