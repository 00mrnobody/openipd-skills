#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  openipd-visual-pack.sh \
    --role <ROLE> \
    --mode <render|infographic|slides> \
    --brief <text> \
    --bullets <'line1;line2;line3'> \
    --outdir <dir> \
    [--count <n>] [--model <model>] [--size <WxH>]
USAGE
}

ROLE=""
MODE=""
BRIEF=""
BULLETS=""
OUTDIR=""
COUNT=1
MODEL="${GEMINI_IMAGE_MODEL:-gemini-2.5-flash-image}"
SIZE="${GEMINI_IMAGE_SIZE:-1536x1024}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --role) ROLE="${2:-}"; shift 2 ;;
    --mode) MODE="${2:-}"; shift 2 ;;
    --brief) BRIEF="${2:-}"; shift 2 ;;
    --bullets) BULLETS="${2:-}"; shift 2 ;;
    --outdir) OUTDIR="${2:-}"; shift 2 ;;
    --count) COUNT="${2:-}"; shift 2 ;;
    --model) MODEL="${2:-}"; shift 2 ;;
    --size) SIZE="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

[[ -n "$ROLE" && -n "$MODE" && -n "$BRIEF" && -n "$OUTDIR" ]] || { usage; exit 1; }
[[ "$MODE" =~ ^(render|infographic|slides)$ ]] || { echo "ERROR: invalid mode $MODE" >&2; exit 1; }

TEMPLATE="templates/visual/${MODE}.prompt.txt"
[[ -f "$TEMPLATE" ]] || { echo "ERROR: template not found: $TEMPLATE" >&2; exit 1; }

mkdir -p "$OUTDIR"

bulleted="- ${BULLETS//;/\n- }"
for i in $(seq 1 "$COUNT"); do
  prompt_file="$OUTDIR/${MODE}-${ROLE}-${i}.prompt.txt"
  img_file="$OUTDIR/${MODE}-${ROLE}-${i}.png"

  sed -e "s/{{ROLE}}/${ROLE}/g" \
      -e "s/{{MODE}}/${MODE}/g" \
      -e "s/{{BRIEF}}/${BRIEF//\//\\\/}/g" \
      "$TEMPLATE" > "$prompt_file"

  printf "\n%s\n" "$bulleted" >> "$prompt_file"

  GEMINI_IMAGE_MODEL="$MODEL" GEMINI_IMAGE_SIZE="$SIZE" \
    scripts/gemini-image-generate.sh --prompt-file "$prompt_file" --out "$img_file" --model "$MODEL" --size "$SIZE"
done

echo "Generated $COUNT image(s) in $OUTDIR"
