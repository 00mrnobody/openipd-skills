# OpenIPD Skills 审计报告

- 审计日期: 2026-03-25
- 审计范围: `ipd-*/SKILL.md`
- 技能总数: 19

## 1) 完整性检查

- 结论: 用户给出的核心 11 角色技能均存在。

## 2) 清单与规模

| Skill | 行数 | 标题数(##/###) |
|---|---:|---:|
| ipd-ccm | 241 | 33 |
| ipd-fpdt | 204 | 31 |
| ipd-hw | 246 | 33 |
| ipd-ipmt | 249 | 38 |
| ipd-irb | 372 | 53 |
| ipd-lpdt | 265 | 35 |
| ipd-mktpdt | 338 | 44 |
| ipd-mnfpdt | 125 | 17 |
| ipd-orchestrator | 708 | 48 |
| ipd-pac | 443 | 60 |
| ipd-pop | 384 | 49 |
| ipd-pqa | 189 | 29 |
| ipd-propdt | 125 | 17 |
| ipd-pte | 272 | 45 |
| ipd-rdpdt | 164 | 22 |
| ipd-se | 324 | 42 |
| ipd-sepdt | 124 | 17 |
| ipd-sw | 245 | 33 |
| ipd-td | 242 | 33 |

- 总行数: 5260
- 平均行数: 276
- 最大文件: ipd-orchestrator/SKILL.md (708 行)
- 最小文件: ipd-sepdt/SKILL.md (124 行)

## 3) 一致性检查

### 3.1 关键章节命中（关键词扫描）

| Skill | 角色定位 | 职责 | 能力 | 阶段活动 | 交付物/质量 |
|---|---:|---:|---:|---:|---:|
| ipd-ccm | Y | Y | Y | Y | Y |
| ipd-fpdt | Y | Y | Y | Y | Y |
| ipd-hw | Y | Y | Y | Y | Y |
| ipd-ipmt | Y | Y | Y | Y | Y |
| ipd-irb | Y | Y | Y | Y | Y |
| ipd-lpdt | Y | Y | Y | Y | Y |
| ipd-mktpdt | Y | Y | Y | Y | Y |
| ipd-mnfpdt | Y | Y | Y | Y | Y |
| ipd-orchestrator | Y | Y | Y | Y | Y |
| ipd-pac | Y | Y | Y | Y | Y |
| ipd-pop | Y | Y | Y | Y | Y |
| ipd-pqa | Y | Y | Y | Y | Y |
| ipd-propdt | Y | Y | Y | Y | Y |
| ipd-pte | Y | Y | Y | Y | Y |
| ipd-rdpdt | Y | Y | Y | Y | Y |
| ipd-se | Y | Y | Y | Y | Y |
| ipd-sepdt | Y | Y | Y | Y | Y |
| ipd-sw | Y | Y | Y | Y | Y |
| ipd-td | Y | Y | Y | Y | Y |

### 3.2 风险提示

- 未发现明显占位词（TODO/TBD/FIXME/待补充）。

## 4) 审计结论

- 技能库完整可用，核心角色齐全。
- 结构总体一致，但篇幅差异较大（建议后续统一模板粒度）。
- 建议在后续版本引入 front-matter（version/owner/updated_at）以便治理。
