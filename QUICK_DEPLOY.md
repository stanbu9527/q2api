# Quick Deploy Guide - Zeabur/Production

## 🚀 5分钟快速部署

### Step 1: 生成控制台密码

**Windows PowerShell:**
```powershell
pwsh setup_console_password.ps1
```

**Linux/Mac:**
```bash
openssl rand -base64 32
```

记录生成的密码，例如：`Xy9kL2mN4pQ6rS8tU0vW1xY2zA3bC4dE5fG6hH7iI8j=`

### Step 2: 配置环境变量

在 Zeabur 或其他平台的环境变量设置中添加：

```bash
# 必须设置（安全）
CONSOLE_PASSWORD="Xy9kL2mN4pQ6rS8tU0vW1xY2zA3bC4dE5fG6hH7iI8j="
OPENAI_KEYS="sk-your-api-key-1,sk-your-api-key-2"

# 可选配置
ENABLE_CONSOLE="true"
MAX_ERROR_COUNT="100"
TOKEN_COUNT_MULTIPLIER="1.0"
```

### Step 3: 部署应用

**Zeabur:**
1. 连接 GitHub 仓库
2. 选择分支
3. 添加环境变量（Step 2）
4. 点击部署

**Docker:**
```bash
docker run -d \
  -p 8000:8000 \
  -e CONSOLE_PASSWORD="your_password" \
  -e OPENAI_KEYS="your_keys" \
  -v $(pwd)/data:/app/data \
  your-image:latest
```

### Step 4: 验证部署

1. 访问控制台：`https://your-domain.com/`
2. 输入控制台密码
3. 添加 Amazon Q 账号
4. 测试 API 调用

## ✅ 部署检查清单

- [ ] 设置 `CONSOLE_PASSWORD`（强密码）
- [ ] 设置 `OPENAI_KEYS`（API 访问控制）
- [ ] 启用 HTTPS（生产环境必须）
- [ ] 添加至少一个 Amazon Q 账号
- [ ] 测试控制台访问（需要密码）
- [ ] 测试 API 端点（需要 API key）
- [ ] 配置数据库持久化（如使用 Docker）

## 🔐 安全配置

### 最小安全配置（必须）
```bash
CONSOLE_PASSWORD="strong_random_password_32_chars_min"
OPENAI_KEYS="sk-random-key-for-api-access"
```

### 推荐安全配置
```bash
CONSOLE_PASSWORD="Xy9kL2mN4pQ6rS8tU0vW1xY2zA3bC4dE5fG6hH7iI8j="
OPENAI_KEYS="sk-prod-key-1,sk-prod-key-2"
ENABLE_CONSOLE="true"
MAX_ERROR_COUNT="50"
```

### 高安全配置
```bash
CONSOLE_PASSWORD="very_long_random_password_64_chars_recommended"
OPENAI_KEYS="sk-prod-key-1"
ENABLE_CONSOLE="true"
MAX_ERROR_COUNT="20"
# + HTTPS + IP 白名单 + 反向代理认证
```

## 🧪 测试部署

### 测试控制台访问
```bash
# 应该返回 401（需要密码）
curl https://your-domain.com/v2/accounts

# 使用密码访问（应该返回 200）
curl -H "X-Console-Password: your_password" \
     https://your-domain.com/v2/accounts
```

### 测试 API 访问
```bash
# 使用 API key 访问
curl -X POST https://your-domain.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your-api-key" \
  -d '{
    "model": "claude-sonnet-4",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

### 测试健康检查
```bash
# 应该返回 {"status":"ok"}
curl https://your-domain.com/healthz
```

## 📱 客户端配置

### OpenAI SDK
```python
import openai

client = openai.OpenAI(
    base_url="https://your-domain.com/v1",
    api_key="your-api-key"  # OPENAI_KEYS 中的一个
)

response = client.chat.completions.create(
    model="claude-sonnet-4",
    messages=[{"role": "user", "content": "Hello"}]
)
```

### Claude SDK
```python
from anthropic import Anthropic

client = Anthropic(
    base_url="https://your-domain.com/v1",
    api_key="your-api-key"
)

message = client.messages.create(
    model="claude-sonnet-4.5",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Hello"}]
)
```

## 🔧 故障排查

### 问题：控制台无法访问
- 检查 `ENABLE_CONSOLE` 是否为 "true"
- 检查是否输入了正确的密码
- 清除浏览器 localStorage 重试

### 问题：API 返回 401
- 检查 `OPENAI_KEYS` 是否配置
- 检查 Authorization header 是否正确
- 确认使用的 key 在白名单中

### 问题：账号无法使用
- 检查账号是否启用（enabled=1）
- 尝试手动刷新 token
- 查看账号的 error_count 和 last_refresh_status

## 📚 更多文档

- [完整文档](README.md)
- [安全配置指南](CONSOLE_SECURITY.md)
- [部署检查清单](DEPLOYMENT_CHECKLIST.md)
- [安全更新说明](SECURITY_UPDATE.md)

## 🆘 紧急情况

### 忘记控制台密码
1. 更新环境变量 `CONSOLE_PASSWORD`
2. 重启应用
3. 清除浏览器 localStorage
4. 使用新密码登录

### 临时禁用控制台
```bash
ENABLE_CONSOLE="false"
# 重启应用
```

### 撤销 API Key
1. 从 `OPENAI_KEYS` 中移除该 key
2. 重启应用
3. 通知受影响的用户

## 💡 最佳实践

1. **密码管理**
   - 使用密码管理器存储
   - 定期轮换（建议每90天）
   - 不要在代码中硬编码

2. **API Key 管理**
   - 为不同用户/服务分配不同的 key
   - 记录 key 的分配情况
   - 定期审计使用情况

3. **监控**
   - 定期检查账号状态
   - 监控错误日志
   - 设置告警（可选）

4. **备份**
   - 定期备份数据库
   - 备份环境变量配置
   - 测试恢复流程
