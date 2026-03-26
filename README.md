# OpenIPD Skills

OpenIPD Skills 是一套面向 IPD（集成产品开发）流程的多角色 AI Skill 定义集合，覆盖产品从概念、计划、开发、验证到发布和生命周期管理的关键角色职责。

## 项目状态（2026-03-26 审计）

- Skill 总数：`19`
- 核心 11 角色：`全部存在`
- 审计报告：`docs/AUDIT_REPORT_2026-03-26.md`
- 角色索引：`docs/ROLE_INDEX.md`

## 核心角色（11）

- `ipd-mktpdt` 市场代表（MKTPDT）
- `ipd-se` 系统工程师（SE）
- `ipd-fpdt` 财务代表（FPDT）
- `ipd-hw` 硬件工程师（HW）
- `ipd-sw` 软件工程师（SW）
- `ipd-mnfpdt` 制造代表（MNFPDT）
- `ipd-propdt` 采购代表（PROPDT）
- `ipd-lpdt` PDT 经理（LPDT）
- `ipd-pqa` 质量代表（PQA）
- `ipd-ipmt` 投资组合管理团队（IPMT）
- `ipd-orchestrator` 流程编排器

## 扩展角色

- `ipd-ccm`、`ipd-irb`、`ipd-pac`、`ipd-pop`、`ipd-pte`、`ipd-rdpdt`、`ipd-sepdt`、`ipd-td`

## 目录说明

- `skills/ipd-*/SKILL.md`：各角色 Skill 定义
- `docs/AUDIT_REPORT_YYYY-MM-DD.md`：自动化审计输出
- `docs/ROLE_INDEX.md`：角色与文件映射
- `scripts/audit-skills.sh`：审计脚本
- `examples/openclaw-desktop-sprite-demo/`：桌面精灵示例 Demo
- `reports/analysis/`：审计与结构分析报告

## 来源与分发

- 系统级来源目录：`/home/devuser/.config/agents/skills/`
- 本仓库是审计与发布快照
- 审计发现：`.codex/skills` 当前缺少 `ipd-orchestrator`

## Demo 示例

- 示例目录：`examples/openclaw-desktop-sprite-demo/`
- Demo 审计报告：`reports/analysis/DEMO_AUDIT_2026-03-26.md`

## 使用方式

在仓库根目录执行：

```bash
./scripts/audit-skills.sh .
```

生成：

- `docs/AUDIT_REPORT_$(date +%F).md`

## 治理建议

- 为每个 Skill 增加 front-matter：`version`、`owner`、`updated_at`、`review_cycle`
- 统一章节模板，降低角色间粒度差异
- 在 CI 中执行审计脚本作为发布前检查
