#!/usr/bin/env bash
#
# manga2kindle — convert a manga PDF into a Kindle-ready file using KCC.
#
# Usage:
#   ./manga2kindle.sh <input.pdf> [output_dir_or_file]
#
# Options via env vars:
#   PROFILE   Kindle device profile (default: KPW5 — Paperwhite 11th gen)
#   FORMAT    Output format: EPUB (default) or MOBI
#   EXTRA     Any extra kcc-c2e flags to append
#
# Examples:
#   ./manga2kindle.sh "One Piece v1.pdf"
#   FORMAT=MOBI ./manga2kindle.sh chapter.pdf ~/Kindle/
#   PROFILE=KPW6 ./manga2kindle.sh book.pdf
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$SCRIPT_DIR/.venv"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <input.pdf> [output_dir_or_file]" >&2
  exit 1
fi

INPUT="$1"
OUTPUT="${2:-}"
PROFILE="${PROFILE:-KPW5}"
FORMAT="${FORMAT:-EPUB}"
EXTRA="${EXTRA:-}"

if [[ ! -f "$INPUT" ]]; then
  echo "Error: input file not found: $INPUT" >&2
  exit 1
fi

if [[ ! -x "$VENV/bin/kcc-c2e" ]]; then
  echo "Error: KCC not installed. Run: python3 -m venv .venv && . .venv/bin/activate && pip install pymupdf 'git+https://github.com/ciromattia/kcc.git'" >&2
  exit 1
fi

# shellcheck disable=SC1091
source "$VENV/bin/activate"

# Base flags:
#   -p PROFILE   target device
#   -m           manga mode (right-to-left reading + splitting)
#   -u           upscale small pages to device resolution
#   --nokepub    plain .epub (Kindle) instead of Kobo's .kepub.epub
args=( -p "$PROFILE" -m -u -f "$FORMAT" )
[[ "$FORMAT" == "EPUB" ]] && args+=( --nokepub )
[[ -n "$OUTPUT" ]] && args+=( -o "$OUTPUT" )
# shellcheck disable=SC2206
[[ -n "$EXTRA" ]] && args+=( $EXTRA )

echo ">> kcc-c2e ${args[*]} \"$INPUT\""
kcc-c2e "${args[@]}" "$INPUT"

echo "Done. Send the output file to your Kindle (Send-to-Kindle email/app, or USB copy to documents/)."
