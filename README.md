# OpenIPD Skills

OpenIPD Skills 是一套面向 IPD（集成产品开发）流程的多角色 AI Skill 集合，覆盖产品从概念、计划、开发、验证到发布/生命周期管理的关键职责。

## 当前版本概览

- 角色技能总数: 19
- 核心角色（你给出的 11 个）: 全部存在
- 扩展角色: `ipd-ccm`、`ipd-irb`、`ipd-pac`、`ipd-pop`、`ipd-pte`、`ipd-rdpdt`、`ipd-sepdt`、`ipd-td`
- 流程编排: `ipd-orchestrator`

## 目录结构

- `ipd-*/SKILL.md`: 角色 Skill 定义文件
- `docs/AUDIT_REPORT_YYYY-MM-DD.md`: 自动化审计报告
- `docs/ROLE_INDEX.md`: 角色与文件索引
- `scripts/audit-skills.sh`: 审计脚本

## 快速审计

```bash
./scripts/audit-skills.sh .
```

输出位置:

- `docs/AUDIT_REPORT_$(date +%F).md`

## 建议的 GitHub 发布流程

1. 登录 GitHub CLI

```bash
gh auth login
```

2. 初始化并提交

```bash
git init
git add .
git commit -m "chore: import openipd skills and audit docs"
```

3. 创建远端仓库并推送

```bash
gh repo create openipd-skills --private --source . --remote origin --push
```

如果你希望公开仓库，把 `--private` 改为 `--public`。

## 治理建议

- 为每个 Skill 增加 front-matter: `version`、`owner`、`updated_at`、`review_cycle`
- 引入统一模板（章节顺序和粒度）降低维护成本
- 在 CI 中执行 `scripts/audit-skills.sh` 做发布前检查
