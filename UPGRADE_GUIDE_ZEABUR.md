# Zeabur 升级指南 - 添加控制台密码保护

## 当前状态
✅ 代码已更新并提交到本地 Git
✅ 密码已生成：`SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=`

## 升级方案（3选1）

### 方案 1：推送到你自己的 GitHub 仓库（推荐）

如果你 fork 了原仓库或有自己的仓库：

```powershell
# 1. 检查远程仓库
git remote -v

# 2. 如果需要，添加你自己的仓库
git remote set-url origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# 3. 推送代码
git push origin main

# 4. 在 Zeabur 中触发重新部署（自动或手动）
```

### 方案 2：直接在 Zeabur 设置环境变量（最快）

**无需重新部署代码，只需添加环境变量：**

1. 登录 Zeabur Dashboard
2. 进入你的项目
3. 点击 "Environment Variables" 或"环境变量"
4. 添加新变量：
   ```
   Key: CONSOLE_PASSWORD
   Value: SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=
   ```
5. 保存并重启服务

**注意：** 这个方案需要先推送代码更新，因为旧版本代码不支持 `CONSOLE_PASSWORD`。

### 方案 3：手动上传文件到 Zeabur

如果 Zeabur 支持文件上传：

1. 打包修改的文件
2. 上传到 Zeabur
3. 添加环境变量
4. 重启服务

## 推荐流程（完整步骤）

### Step 1: 推送到你的仓库

```powershell
# 如果你有自己的 GitHub 仓库
git remote set-url origin https://github.com/YOUR_USERNAME/q2api.git
git push origin main
```

**或者创建新分支：**

```powershell
# 创建新分支用于升级
git checkout -b security-update
git push origin security-update
```

### Step 2: 在 Zeabur 配置环境变量

登录 Zeabur → 选择项目 → Environment Variables → 添加：

```
CONSOLE_PASSWORD=SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=
```

**其他推荐配置：**

```
# 必须设置
CONSOLE_PASSWORD=SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=
OPENAI_KEYS=your-api-key-1,your-api-key-2

# 可选配置
ENABLE_CONSOLE=true
MAX_ERROR_COUNT=100
TOKEN_COUNT_MULTIPLIER=1.0
```

### Step 3: 触发重新部署

在 Zeabur 中：
- 如果连接了 GitHub：推送代码后自动部署
- 如果手动部署：点击 "Redeploy" 或"重新部署"

### Step 4: 验证升级

1. **访问控制台**
   ```
   https://your-zeabur-domain.com/
   ```
   应该提示输入密码

2. **输入密码**
   ```
   SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=
   ```

3. **测试 API**
   ```bash
   # 健康检查（无需密码）
   curl https://your-zeabur-domain.com/healthz
   
   # 控制台 API（需要密码）
   curl -H "X-Console-Password: SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=" \
        https://your-zeabur-domain.com/v2/accounts
   
   # Chat API（需要 API key）
   curl -X POST https://your-zeabur-domain.com/v1/chat/completions \
     -H "Authorization: Bearer your-api-key" \
     -H "Content-Type: application/json" \
     -d '{"model":"claude-sonnet-4","messages":[{"role":"user","content":"test"}]}'
   ```

## 如果无法推送到 GitHub

### 选项 A：创建自己的仓库

```powershell
# 1. 在 GitHub 创建新仓库（例如：my-q2api）

# 2. 更改远程仓库地址
git remote set-url origin https://github.com/YOUR_USERNAME/my-q2api.git

# 3. 推送代码
git push -u origin main

# 4. 在 Zeabur 中连接新仓库
```

### 选项 B：使用 Zeabur CLI（如果支持）

```powershell
# 安装 Zeabur CLI
npm install -g @zeabur/cli

# 登录
zeabur login

# 部署
zeabur deploy
```

### 选项 C：手动部署（最后手段）

1. 将修改的文件打包
2. 使用 Zeabur 的文件上传功能
3. 或者使用 Docker 镜像部署

## 验证清单

部署完成后，检查以下项目：

- [ ] 访问控制台首页，提示输入密码
- [ ] 输入正确密码后可以访问
- [ ] 输入错误密码被拒绝
- [ ] 不输入密码被拒绝（401）
- [ ] API 端点正常工作（使用 OPENAI_KEYS）
- [ ] 健康检查端点无需密码
- [ ] 现有账号仍然可用
- [ ] 可以添加新账号

## 回滚方案

如果升级出现问题：

### 方法 1：禁用密码保护
在 Zeabur 环境变量中删除或清空 `CONSOLE_PASSWORD`，重启服务。

### 方法 2：回滚代码
```powershell
git revert HEAD
git push origin main
```

### 方法 3：使用旧版本
在 Zeabur 中选择之前的部署版本。

## 常见问题

### Q: 忘记密码怎么办？
A: 在 Zeabur 环境变量中查看或修改 `CONSOLE_PASSWORD`

### Q: 密码在哪里存储？
A: 
- 服务端：环境变量（Zeabur 配置）
- 客户端：浏览器 localStorage（可清除）

### Q: 如何更改密码？
A: 
1. 生成新密码：`pwsh setup_console_password.ps1`
2. 在 Zeabur 更新 `CONSOLE_PASSWORD` 环境变量
3. 重启服务
4. 清除浏览器 localStorage

### Q: API 调用是否需要控制台密码？
A: 不需要。API 使用 `OPENAI_KEYS` 授权，与控制台密码独立。

## 技术支持

- 详细文档：[CONSOLE_SECURITY.md](CONSOLE_SECURITY.md)
- 快速部署：[QUICK_DEPLOY.md](QUICK_DEPLOY.md)
- 部署检查：[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

## 生成的密码（请妥善保存）

```
CONSOLE_PASSWORD=SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=
```

**重要提示：**
- 这个密码只在本地 `.env` 文件中
- Zeabur 需要单独配置环境变量
- 不要将密码提交到 Git（`.env` 已在 `.gitignore` 中）
- 建议使用密码管理器保存
