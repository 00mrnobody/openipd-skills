#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  gemini-image-generate.sh --prompt-file <path> --out <png-path> [--model <model>] [--size <WxH>]
  gemini-image-generate.sh --prompt <text> --out <png-path> [--model <model>] [--size <WxH>]

Required env:
  GEMINI_API_KEY

Defaults:
  model = gemini-2.5-flash-image
  size  = 1536x1024
USAGE
}

PROMPT=""
PROMPT_FILE=""
OUT=""
MODEL="${GEMINI_IMAGE_MODEL:-gemini-2.5-flash-image}"
SIZE="${GEMINI_IMAGE_SIZE:-1536x1024}"
API_BASE="${GEMINI_OPENAI_BASE_URL:-https://generativelanguage.googleapis.com/v1beta/openai}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt-file) PROMPT_FILE="${2:-}"; shift 2 ;;
    --prompt) PROMPT="${2:-}"; shift 2 ;;
    --out) OUT="${2:-}"; shift 2 ;;
    --model) MODEL="${2:-}"; shift 2 ;;
    --size) SIZE="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

if [[ -z "${GEMINI_API_KEY:-}" ]]; then
  echo "ERROR: GEMINI_API_KEY is not set." >&2
  exit 1
fi

if [[ -n "$PROMPT_FILE" ]]; then
  [[ -f "$PROMPT_FILE" ]] || { echo "ERROR: prompt file not found: $PROMPT_FILE" >&2; exit 1; }
  PROMPT="$(cat "$PROMPT_FILE")"
fi

[[ -n "$PROMPT" ]] || { echo "ERROR: --prompt or --prompt-file is required." >&2; exit 1; }
[[ -n "$OUT" ]] || { echo "ERROR: --out is required." >&2; exit 1; }

mkdir -p "$(dirname "$OUT")"

JSON_PAYLOAD="$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" --arg size "$SIZE" '{model:$model,prompt:$prompt,response_format:"b64_json",n:1,size:$size}')"

RESP_FILE="$(mktemp)"
trap 'rm -f "$RESP_FILE"' EXIT

curl -sS "${API_BASE}/images/generations" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${GEMINI_API_KEY}" \
  -d "$JSON_PAYLOAD" > "$RESP_FILE"

if [[ "$(jq -r 'has("error")' "$RESP_FILE")" == "true" ]]; then
  echo "ERROR: image generation failed" >&2
  jq -r '.error' "$RESP_FILE" >&2
  exit 1
fi

B64="$(jq -r '.data[0].b64_json // empty' "$RESP_FILE")"
[[ -n "$B64" ]] || { echo "ERROR: response missing data[0].b64_json" >&2; cat "$RESP_FILE" >&2; exit 1; }

printf '%s' "$B64" | base64 -d > "$OUT"

TXT_OUT="${OUT%.*}.prompt.txt"
printf '%s\n' "$PROMPT" > "$TXT_OUT"

echo "OK: $OUT"
echo "Prompt saved: $TXT_OUT"
