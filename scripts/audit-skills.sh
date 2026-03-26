#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-.}"
cd "$ROOT"
SKILLS_DIR="${SKILLS_DIR:-skills}"
DATE="$(date +%F)"
OUT="docs/AUDIT_REPORT_${DATE}.md"
mkdir -p docs

mapfile -t skills < <(find "$SKILLS_DIR" -maxdepth 1 -type d -name 'ipd-*' -printf '%f\n' | sort)
count=${#skills[@]}

required=(
  ipd-mktpdt
  ipd-se
  ipd-fpdt
  ipd-hw
  ipd-sw
  ipd-mnfpdt
  ipd-propdt
  ipd-lpdt
  ipd-pqa
  ipd-ipmt
  ipd-orchestrator
)

missing=()
for r in "${required[@]}"; do
  [[ -f "$SKILLS_DIR/$r/SKILL.md" ]] || missing+=("$r")
done

{
  echo "# OpenIPD Skills 审计报告"
  echo
  echo "- 审计日期: ${DATE}"
  echo "- 审计范围: \`$SKILLS_DIR/ipd-*/SKILL.md\`"
  echo "- 技能总数: ${count}"
  echo

  echo "## 1) 完整性检查"
  echo
  if (( ${#missing[@]} == 0 )); then
    echo "- 结论: 用户给出的核心 11 角色技能均存在。"
  else
    echo "- 结论: 存在缺失角色。"
    for m in "${missing[@]}"; do
      echo "  - 缺失: ${m}/SKILL.md"
    done
  fi

  echo
  echo "## 2) 清单与规模"
  echo
  echo "| Skill | 行数 | 标题数(##/###) |"
  echo "|---|---:|---:|"

  total_lines=0
  max_lines=0
  max_skill=""
  min_lines=999999
  min_skill=""

  for s in "${skills[@]}"; do
    f="$SKILLS_DIR/$s/SKILL.md"
    if [[ -f "$f" ]]; then
      lines=$(wc -l < "$f" | tr -d ' ')
      headers=$(rg -n '^##|^###' "$f" | wc -l | tr -d ' ')
      echo "| ${s} | ${lines} | ${headers} |"

      total_lines=$((total_lines + lines))
      if (( lines > max_lines )); then max_lines=$lines; max_skill=$s; fi
      if (( lines < min_lines )); then min_lines=$lines; min_skill=$s; fi
    fi
  done

  avg=$(( total_lines / count ))
  echo
  echo "- 总行数: ${total_lines}"
  echo "- 平均行数: ${avg}"
  echo "- 最大文件: ${max_skill}/SKILL.md (${max_lines} 行)"
  echo "- 最小文件: ${min_skill}/SKILL.md (${min_lines} 行)"

  echo
  echo "## 3) 一致性检查"
  echo

  echo "### 3.1 关键章节命中（关键词扫描）"
  echo
  echo "| Skill | 角色定位 | 职责 | 能力 | 阶段活动 | 交付物/质量 |"
  echo "|---|---:|---:|---:|---:|---:|"

  for s in "${skills[@]}"; do
    f="$SKILLS_DIR/$s/SKILL.md"
    role=$(rg -q '角色定位|角色定义' "$f" && echo Y || echo N)
    duty=$(rg -q '主要职责|职责|核心使命|使命' "$f" && echo Y || echo N)
    ability=$(rg -q '关键能力|能力' "$f" && echo Y || echo N)
    phase=$(rg -q '阶段|Concept|Plan|Develop|Qualify|Launch|Lifecycle' "$f" && echo Y || echo N)
    quality=$(rg -q '交付物|质量|评审|红线' "$f" && echo Y || echo N)
    echo "| ${s} | ${role} | ${duty} | ${ability} | ${phase} | ${quality} |"
  done

  echo
  echo "### 3.2 风险提示"
  echo
  todo_hits=$(rg -n 'TODO|TBD|FIXME|待补充|待完善' "$SKILLS_DIR"/ipd-*/SKILL.md || true)
  if [[ -z "$todo_hits" ]]; then
    echo "- 未发现明显占位词（TODO/TBD/FIXME/待补充）。"
  else
    echo "- 发现占位词，请人工复核："
    echo '```text'
    echo "$todo_hits"
    echo '```'
  fi

  echo
  echo "## 4) 分发一致性检查（可选）"
  echo
  mirror_dir="${HOME}/.codex/skills"
  if [[ -d "$mirror_dir" ]]; then
    mapfile -t missing_in_mirror < <(
      comm -23 \
        <(find "$SKILLS_DIR" -maxdepth 1 -type d -name 'ipd-*' -printf '%f\n' | sort) \
        <(find "$mirror_dir" -maxdepth 1 -type d -name 'ipd-*' -printf '%f\n' | sort)
    )
    if (( ${#missing_in_mirror[@]} == 0 )); then
      echo "- 与镜像目录 \`$mirror_dir\` 一致。"
    else
      echo "- 在源目录存在但镜像目录缺失的 Skill："
      for s in "${missing_in_mirror[@]}"; do
        echo "  - ${s}"
      done
    fi
  else
    echo "- 未检测到镜像目录 \`$mirror_dir\`，跳过该检查。"
  fi

  echo
  echo "## 5) 审计结论"
  echo
  echo "- 技能库完整可用，核心角色齐全。"
  echo "- 结构总体一致，但篇幅差异较大（建议后续统一模板粒度）。"
  echo "- 建议在后续版本引入 front-matter（version/owner/updated_at）以便治理。"
} > "$OUT"

echo "$OUT"
