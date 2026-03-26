# Demo 审计报告（2026-03-26）

## 审计范围

`examples/openclaw-desktop-sprite-demo/*.md`

## 审计项

- 敏感密钥模式（API Key、Token、Private Key）
- 常见凭据字段（password/secret/token）
- 个人敏感信息模式（手机号/身份证/常见私人邮箱）

## 结论

- 未发现可识别的密钥或凭据内容。
- 命中关键词仅为业务文案中的 `tokens`（价格单位），不构成安全风险。
- Demo 以公开展示为目的，内容可发布。
