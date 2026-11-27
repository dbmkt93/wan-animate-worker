#!/bin/bash
# atalho: baixa ~30 GB a cada partida a frio; trocar por imagem com modelos dentro (build do Runpod) se a partida ficar cara.
set -e
B=/comfyui/models
LIST=$(mktemp)
while read -r rel url; do
  [ -z "$rel" ] && continue
  if [ ! -s "$B/$rel" ]; then
    mkdir -p "$B/$(dirname "$rel")"
    printf '%s\n  dir=%s\n  out=%s\n' "$url" "$B/$(dirname "$rel")" "$(basename "$rel")" >> "$LIST"
  fi
done < /models.txt
if [ -s "$LIST" ]; then
  echo "fetch_models: downloading $(grep -c '^http' "$LIST") files"
  T0=$(date +%s)
  aria2c -i "$LIST" -j 8 -x 16 -s 16 -k 20M --file-allocation=none --console-log-level=warn --summary-interval=30
  echo "fetch_models: done in $(( $(date +%s) - T0 ))s"
fi
