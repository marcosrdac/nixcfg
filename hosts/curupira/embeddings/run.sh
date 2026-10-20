#!/usr/bin/env bash
# Run exactly one Qwen3-Embedding-0.6B GGUF variant locally on Curupira.
set -euo pipefail

variant="${1:-q8}"
case "$variant" in
  f16) repo="Qwen/Qwen3-Embedding-0.6B-GGUF"; file="Qwen3-Embedding-0.6B-f16.gguf" ;;
  q8)  repo="Qwen/Qwen3-Embedding-0.6B-GGUF"; file="Qwen3-Embedding-0.6B-Q8_0.gguf" ;;
  q5)  repo="smarttasks/Qwen3-Embedding-0.6B-GGUF"; file="Qwen3-Embedding-0.6B-Q5_K_M.gguf" ;;
  q4)  repo="smarttasks/Qwen3-Embedding-0.6B-GGUF"; file="Qwen3-Embedding-0.6B-Q4_K_M.gguf" ;;
  *) echo "Usage: bash $0 [f16|q8|q5|q4]" >&2; exit 2 ;;
esac

: "${PORT:=8711}"
: "${THREADS:=3}"
: "${CTX_SIZE:=2048}"

if ! command -v llama-server >/dev/null; then
  echo "llama-server not found: install llama-cpp with nixos-rebuild test first." >&2
  exit 127
fi

echo "Starting $variant ($file) on localhost:$PORT, threads=$THREADS, context=$CTX_SIZE" >&2
echo "First start downloads the GGUF from Hugging Face to llama.cpp's cache." >&2

exec llama-server \
  --hf-repo "$repo" \
  --hf-file "$file" \
  --alias "qwen3-embedding-$variant" \
  --embedding \
  --pooling last \
  --embd-normalize 2 \
  --host 127.0.0.1 \
  --port "$PORT" \
  --threads "$THREADS" \
  --ctx-size "$CTX_SIZE" \
  --batch-size 256 \
  --ubatch-size 256 \
  --parallel 1 \
  --no-webui
