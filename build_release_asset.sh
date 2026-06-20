#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$ROOT_DIR/github_release_full"

if [[ ! -d "$RELEASE_DIR" ]]; then
  echo "[ERROR] Release source directory not found: $RELEASE_DIR" >&2
  exit 1
fi

OUT_ZIP="$ROOT_DIR/LunarLander3D-release.zip"
OUT_TAR="$ROOT_DIR/LunarLander3D-release.tar.gz"

echo "[INFO] Building release assets from: $RELEASE_DIR"

# Build ZIP with correct archive root (no wrapping folder name)
# We zip from inside RELEASE_DIR so that entries start with mission_v*.py, lunar_lander_3d/, etc.
echo "[INFO] Output ZIP : $OUT_ZIP"
rm -f "$OUT_ZIP"
(
  cd "$RELEASE_DIR"
  zip -rq "$OUT_ZIP" .
)

# Build TAR.GZ with correct archive root
echo "[INFO] Output TAR : $OUT_TAR"
rm -f "$OUT_TAR"
(
  cd "$RELEASE_DIR"
  tar -czf "$OUT_TAR" .
)

echo "[INFO] Sanity check: first few entries in ZIP"
unzip -l "$OUT_ZIP" | awk 'NR==1{print} NR>1 && NR<8{print}'

echo "[INFO] Sanity check: first few entries in TAR"
tar -tzf "$OUT_TAR" | head -n 10

echo "[DONE] Release assets created."

