#!/usr/bin/env python3
"""Smoke-test Qwen3 embeddings and compare quantized representations (stdlib)."""
import argparse
import json
import math
import pathlib
import time
import urllib.request

TEXTS = [
    "O reservatório contém petróleo.",
    "O reservatório não contém petróleo.",
    "Full waveform inversion uses seismic wavefields to estimate subsurface properties.",
]

def cosine(a, b):
    return sum(x * y for x, y in zip(a, b)) / (
        math.sqrt(sum(x * x for x in a)) * math.sqrt(sum(y * y for y in b))
    )

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("variant", nargs="?", default="q8", choices=("f16", "q8", "q5", "q4"))
    parser.add_argument("--url", default="http://127.0.0.1:8711")
    parser.add_argument("--save", type=pathlib.Path)
    parser.add_argument("--compare", type=pathlib.Path)
    args = parser.parse_args()

    body = json.dumps({
        "model": f"qwen3-embedding-{args.variant}",
        "input": TEXTS,
    }).encode("utf-8")
    request = urllib.request.Request(
        f"{args.url.rstrip('/')}/v1/embeddings",
        data=body,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    start = time.perf_counter()
    with urllib.request.urlopen(request, timeout=300) as response:
        result = json.load(response)
    elapsed = time.perf_counter() - start

    rows = sorted(result["data"], key=lambda row: row["index"])
    vectors = [row["embedding"] for row in rows]
    if len(vectors) != len(TEXTS) or any(len(v) != 1024 for v in vectors):
        raise ValueError("Expected three 1024-dimensional embeddings")
    if any(not math.isfinite(value) for vec in vectors for value in vec):
        raise ValueError("Non-finite embedding output")

    print(f"Variant: {args.variant} | Dimensions: 1024 | Duration: {elapsed:.2f}s")
    print("Norms:", [round(math.sqrt(sum(x*x for x in v)), 5) for v in vectors])
    print(f"Positive vs negative cosine: {cosine(vectors[0], vectors[1]):.6f}")

    if args.compare:
        baseline = json.loads(args.compare.read_text(encoding="utf-8"))
        if baseline["texts"] != TEXTS:
            raise ValueError("Comparison file was created from different texts")
        for i, (current, previous) in enumerate(zip(vectors, baseline["embeddings"], strict=True)):
            print(f"Text {i+1} cosine to {baseline['variant']}: {cosine(current, previous):.8f}")

    if args.save:
        args.save.write_text(json.dumps({
            "variant": args.variant, "texts": TEXTS, "embeddings": vectors,
        }), encoding="utf-8")
        print("Saved:", args.save)

if __name__ == "__main__":
    main()
