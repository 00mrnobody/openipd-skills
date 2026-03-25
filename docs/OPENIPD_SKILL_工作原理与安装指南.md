# OpenIPD Skill 工作原理与安装指南

## 1. 这套技能的目的是什么？

OpenIPD Skill 的目标是把 IPD（集成产品开发）流程拆成可协作的角色智能体，并用 `ipd-orchestrator` 把流程从概念阶段编排到发布阶段，确保：

- 角色职责清晰（市场、系统、研发、财务、采购、制造、质量、测试、服务等）
- 决策门（DCP）和技术评审门（TR）不被跳过
- 项目文档和评审结论可追踪
- 时间线按启动日动态计算（T-Day + N 周）

## 2. 原理是啥？

这套技能采用“编排器 + 子角色 Agent”的机制：

- `ipd-orchestrator` 负责流程控制、阶段推进、状态跟踪和质量互锁
- 各 `ipd-*` 子 Agent 负责本领域分析与输出，不互相“代演”
- Orchestrator 必须通过 `task` 工具逐个调用真实子 Agent，并汇总结果
- 前一阶段门禁未通过（DCP/TR 未过）时，不允许进入下一阶段

核心机制有 4 个：

1. 角色解耦：每个角色独立上下文，输出可追溯。
2. 质量互锁：CDCP/PDCP/ADCP + TR1~TR6 硬门禁。
3. 动态时间：以项目启动日为 T-Day 自动计算全部里程碑。
4. 上下文传递：调用子 Agent 时传递统一 `PROJECT_CONTEXT/MILESTONES`。

## 3. 为什么要用这套技能？

相比“单个大模型一次性给结论”，这套技能的优势是：

- 降低遗漏风险：关键角色不会被忽略
- 降低拍脑袋决策：每个结论有来源 Agent 和输入依据
- 流程可审计：每一步对应阶段、评审点、产出物
- 便于复盘：Go/Redirect/No Go 的原因可追踪
- 更贴近真实组织协作：符合 IPD 的跨职能协同模式

## 4. 调用方式是啥？

### 4(a) 如何调用一个子 Agent？

有两种常见方式。

方式 1：用户直接调用（单角色工作）

```text
/ipd-se 设计XX产品系统架构，并给出TR2评审检查项
/ipd-mktpdt 输出目标市场细分、竞品对比和定价建议
/ipd-fpdt 评估项目ROI与盈亏平衡点
```

方式 2：由 `ipd-orchestrator` 内部调用（推荐）

```text
task ipd-se: "请基于以下项目上下文输出技术可行性与架构建议..."
task ipd-mktpdt: "请输出市场规模、客群画像、竞争格局..."
```

> 要点：Orchestrator 不应在同一上下文里“扮演多个角色”，必须调用真实子 Agent。

### 4(b) 如何重新触发一个完整的 IPD 流程？

```text
/ipd-orchestrator 启动IPD流程：
- 产品名称：XXX
- 目标市场：XXX
- 预算范围：XXX
- 启动日期：今天（或指定日期）
```

说明：

- 该命令会以新的启动日作为 T-Day，重算 CDCP/PDCP/ADCP/TR/GA 时间线
- 流程从概念阶段重新开始，依次推进到发布阶段

### 4(c) 如何调用它执行到 IPD 的哪一步？

按“阶段起点”触发：

```text
/ipd-orchestrator 从开发阶段开始IPD流程：
- 产品名称：XXX
- 启动日期：2026-03-19
- 当前阶段：开发阶段
- 需要执行：TR3-TR4评审
```

配套命令（查询进度）：

```text
/ipd-orchestrator 查询IPD流程状态
```

建议写法：

- “从计划阶段开始”用于已完成 Charter/CDCP 的项目
- “从开发阶段开始”用于 PDCP 已通过的项目
- “从验证阶段开始”用于开发完成进入系统验证

## 5. 安装说明

以下按你要求给出三种安装方式。

### 5(a) 直接在 Cloud Code 或 Codex 里安装

Codex 本地技能目录通常是 `$CODEX_HOME/skills`（若未设置则 `~/.codex/skills`）。

```bash
# 1) 进入仓库
cd /data/workspace/users/devuser-home/codex-ws/2026/0325-2347-openipd-skills-audit/openipd-skills

# 2) 确认目标目录
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"

# 3) 安装（覆盖同名）
for d in ipd-*; do
  rm -rf "$CODEX_HOME/skills/$d"
  cp -r "$d" "$CODEX_HOME/skills/$d"
done

# 4) 验证
ls -la "$CODEX_HOME/skills" | grep '^d' | grep ipd-
```

如果 Cloud Code 运行时也兼容 Codex skills 目录，按同一方式安装即可。

### 5(b) 在 Kimi CLI 里面安装

Kimi CLI 使用目录：`~/.config/agents/skills`。

```bash
# 1) 进入仓库
cd /data/workspace/users/devuser-home/codex-ws/2026/0325-2347-openipd-skills-audit/openipd-skills

# 2) 安装
mkdir -p ~/.config/agents/skills
for d in ipd-*; do
  rm -rf ~/.config/agents/skills/$d
  cp -r "$d" ~/.config/agents/skills/$d
done

# 3) 验证
ls -la ~/.config/agents/skills | grep '^d' | grep ipd-
```

如果你使用旧仓库 `/data/workspace/users/devuser-home/open-ipd-agents`，也可直接执行其中的 `install.sh`。

### 5(c) 在 Open Cloud 里面安装

Open Cloud 可能有两种接入形态，按实际部署选其一：

方式 A：Open Cloud 节点使用本地 skills 目录（Kimi 兼容）

```bash
# 安装到 ~/.config/agents/skills
mkdir -p ~/.config/agents/skills
for d in ipd-*; do
  rm -rf ~/.config/agents/skills/$d
  cp -r "$d" ~/.config/agents/skills/$d
done
```

方式 B：Open Cloud 通过仓库挂载/同步 skills

1. 把本仓库推送到 GitHub（已完成：`00mrnobody/openipd-skills`）。
2. 在 Open Cloud 的项目配置中，将 skills 源指向该仓库。
3. 将技能根目录设为仓库根（包含 `ipd-*` 文件夹）。
4. 重新加载 Agent Runtime 后验证 `ipd-orchestrator` 可见。

> 说明：不同 Open Cloud 部署的导入界面字段名可能不同，但核心是“让 runtime 看到 `ipd-*/SKILL.md` 目录结构”。

## 附：这套技能的结构速览

- 编排器：`ipd-orchestrator`
- 决策层：`ipd-irb`、`ipd-ipmt`、`ipd-pac`
- PDT核心层：`ipd-lpdt`、`ipd-se`、`ipd-pqa`、`ipd-pop`
- 功能层：`ipd-mktpdt`、`ipd-rdpdt`、`ipd-fpdt`、`ipd-propdt`、`ipd-mnfpdt`、`ipd-sepdt`、`ipd-pte`
- 扩展支持：`ipd-ccm`、`ipd-hw`、`ipd-sw`、`ipd-td`

配合文档：

- 审计报告：`docs/AUDIT_REPORT_2026-03-25.md`
- 角色索引：`docs/ROLE_INDEX.md`
