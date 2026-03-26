# OpenIPD 视觉输出能力说明

本仓库已支持将角色结论直接转换为视觉资产，适用于不希望阅读长文档、希望直接查看信息图或 Slides 的场景。

## 能力范围

- 产品渲染图（`render`）
- Notion版式信息图（`infographic`）
- Slides单页视觉（`slides`）

## 依赖

- `curl`
- `jq`
- `base64`
- 环境变量：`GEMINI_API_KEY`

## 模板

- `templates/visual/render.prompt.txt`
- `templates/visual/infographic.prompt.txt`
- `templates/visual/slides.prompt.txt`

## API 调用脚本

- `scripts/gemini-image-generate.sh`
- `scripts/openipd-visual-pack.sh`

默认模型：`gemini-2.5-flash-image`。

## 快速开始

### 1) 单张信息图

```bash
mkdir -p tmp-outputs/visual
scripts/gemini-image-generate.sh \
  --prompt "Create a notion-style infographic about OpenIPD role outputs for PDCP review" \
  --out tmp-outputs/visual/pdcp-infographic.png
```

### 2) 直接生成 Slides 视觉页（多张）

```bash
scripts/openipd-visual-pack.sh \
  --role LPDT \
  --mode slides \
  --brief "OpenClaw 桌面精灵 PDCP 决策汇报" \
  --bullets "目标市场与定位;成本与毛利;关键风险与缓解;里程碑与资源计划" \
  --outdir tmp-outputs/visual/lpdt-slides \
  --count 4
```

### 3) 角色信息图

```bash
scripts/openipd-visual-pack.sh \
  --role MKTPDT \
  --mode infographic \
  --brief "桌面AI精灵市场分析摘要" \
  --bullets "TAM/SAM/SOM;竞品对比;价格带建议;上市路径" \
  --outdir tmp-outputs/visual/mkt \
  --count 3
```

## 安全要求

- 密钥只通过环境变量注入：`export GEMINI_API_KEY=...`
- 禁止在脚本参数、日志、仓库文件中写入明文密钥
- 生成产物默认输出到项目内 `tmp-outputs/visual/`

## 与角色技能的关系

已为以下角色加入视觉输出能力说明：

- `ipd-orchestrator`
- `ipd-lpdt`
- `ipd-mktpdt`
- `ipd-se`
- `ipd-fpdt`
- `ipd-hw`
- `ipd-sw`
- `ipd-mnfpdt`
- `ipd-propdt`
