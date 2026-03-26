# OpenIPD 视觉模板

本目录提供三类视觉输出模板，支持通过 Gemini 图像 API 直接生成图像资产：

- `render.prompt.txt`：产品渲染图（工业设计/场景图/剖面图）
- `infographic.prompt.txt`：Notion 风格信息图（高密度可视化）
- `slides.prompt.txt`：演示文稿单页风格图（适合拼成 Slides）

变量占位符：

- `{{ROLE}}`：角色名（例如 MKTPDT / SE / HW / SW / LPDT）
- `{{MODE}}`：模式（render / infographic / slides）
- `{{BRIEF}}`：业务简述（产品与目标）
- `{{BULLETS}}`：要点列表（建议 3-8 条）

注意：

- 模板中不要写入任何密钥或凭据。
- 统一通过环境变量 `GEMINI_API_KEY` 调用。
