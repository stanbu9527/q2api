# Security Update - Console Password Protection

## 更新内容

为管理控制台添加了密码保护功能，防止未授权访问账号管理界面。

## 主要变更

### 1. 新增环境变量
- `CONSOLE_PASSWORD` - 控制台访问密码（可选，但生产环境强烈推荐）

### 2. 受保护的端点
以下端点现在需要通过 `X-Console-Password` header 验证：
- `GET /` - 控制台首页
- `GET /v2/accounts` - 账号列表
- `POST /v2/accounts` - 创建账号
- `PATCH /v2/accounts/{id}` - 更新账号
- `DELETE /v2/accounts/{id}` - 删除账号
- `POST /v2/accounts/{id}/refresh` - 刷新令牌
- `POST /v2/accounts/feed` - 批量创建账号
- `POST /v2/auth/start` - 开始设备授权
- `GET /v2/auth/status/{id}` - 授权状态
- `POST /v2/auth/claim/{id}` - 完成授权

### 3. 不受影响的端点
API 端点保持不变（使用 `OPENAI_KEYS` 授权）：
- `POST /v1/chat/completions`
- `POST /v1/messages`
- `POST /v1/messages/count_tokens`
- `GET /healthz`

## 升级指南

### 对于现有部署

#### 选项 1：启用密码保护（推荐）

1. 生成强密码：
```powershell
pwsh setup_console_password.ps1
```

2. 设置环境变量：
```bash
CONSOLE_PASSWORD="your_generated_password"
```

3. 重启服务

4. 访问控制台时输入密码

#### 选项 2：保持无密码（仅开发环境）

不设置 `CONSOLE_PASSWORD` 环境变量，控制台将继续无密码访问（不推荐生产环境）。

### 对于新部署

1. 在部署前设置 `CONSOLE_PASSWORD`
2. 参考 [CONSOLE_SECURITY.md](CONSOLE_SECURITY.md) 配置
3. 参考 [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) 完成部署检查

## 向后兼容性

✅ **完全向后兼容**
- 如果不设置 `CONSOLE_PASSWORD`，行为与之前版本完全相同
- 现有的 API 调用不受影响
- 现有的环境变量配置继续有效

## 测试

运行测试脚本验证配置：
```bash
# 设置测试环境变量
export TEST_BASE_URL="http://localhost:8000"
export CONSOLE_PASSWORD="your_password"

# 运行测试
python test_console_auth.py
```

## 安全建议

### 生产环境（必须）
- ✅ 设置 `CONSOLE_PASSWORD`
- ✅ 设置 `OPENAI_KEYS`
- ✅ 使用 HTTPS
- ✅ 定期轮换密码

### 开发环境（可选）
- 可以不设置 `CONSOLE_PASSWORD`
- 建议在本地网络使用

## 常见问题

### Q: 忘记密码怎么办？
A: 更新环境变量 `CONSOLE_PASSWORD`，重启服务，清除浏览器 localStorage

### Q: 如何禁用密码保护？
A: 删除或清空 `CONSOLE_PASSWORD` 环境变量，重启服务

### Q: 密码存储在哪里？
A: 浏览器的 localStorage（仅前端），服务端通过环境变量配置

### Q: 是否支持多个密码？
A: 当前版本仅支持单一密码，如需更复杂的权限管理，建议使用反向代理（如 Nginx）配置 HTTP Basic Auth

### Q: API 调用是否需要控制台密码？
A: 不需要。API 端点使用 `OPENAI_KEYS` 授权，与控制台密码独立

## 相关文档

- [CONSOLE_SECURITY.md](CONSOLE_SECURITY.md) - 详细安全配置指南
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - 部署检查清单
- [README.md](README.md) - 完整使用文档

## 技术细节

### 实现方式
- 使用 FastAPI Depends 依赖注入
- HTTP Header: `X-Console-Password`
- 前端自动管理密码（localStorage）
- 401 响应触发密码输入提示

### 代码变更
- `app.py`: 添加 `require_console_auth` 依赖
- `frontend/index.html`: 添加密码管理逻辑
- `.env.example`: 添加 `CONSOLE_PASSWORD` 配置项

## 更新日期

2024-11-21
