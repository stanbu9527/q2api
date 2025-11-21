# Console Security Guide

## Overview

The management console provides powerful account management capabilities. To protect it from unauthorized access, a password authentication mechanism has been implemented.

## Configuration

### Environment Variable

Add the following to your `.env` file:

```bash
CONSOLE_PASSWORD="your_strong_password_here"
```

**Important:**
- Leave empty for local development (no password required)
- **MUST** set a strong password for production deployments
- Use a random, complex password (recommended: 32+ characters)

### Generate Strong Password

```bash
# Linux/Mac
openssl rand -base64 32

# PowerShell (Windows)
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))
```

## Usage

### Web Console Access

1. Open the console in your browser
2. If `CONSOLE_PASSWORD` is set, you'll be prompted to enter the password
3. The password is stored in browser's localStorage for convenience
4. If authentication fails, you'll need to re-enter the password

### API Access

All console management endpoints require the password in HTTP headers:

```bash
curl -H "X-Console-Password: your_password" https://your-domain.com/v2/accounts
```

### Protected Endpoints

The following endpoints require authentication when `CONSOLE_PASSWORD` is set:

- `GET /` - Console homepage
- `GET /v2/accounts` - List accounts
- `POST /v2/accounts` - Create account
- `GET /v2/accounts/{id}` - Get account details
- `PATCH /v2/accounts/{id}` - Update account
- `DELETE /v2/accounts/{id}` - Delete account
- `POST /v2/accounts/{id}/refresh` - Refresh token
- `POST /v2/accounts/feed` - Batch create accounts
- `POST /v2/auth/start` - Start device authorization
- `GET /v2/auth/status/{id}` - Check auth status
- `POST /v2/auth/claim/{id}` - Claim authorization

### Unprotected Endpoints

API endpoints remain unprotected (use `OPENAI_KEYS` for API authorization):

- `POST /v1/chat/completions` - OpenAI-compatible chat
- `POST /v1/messages` - Claude-compatible messages
- `POST /v1/messages/count_tokens` - Token counting
- `GET /healthz` - Health check

## Security Best Practices

1. **Always set CONSOLE_PASSWORD in production**
2. Use different passwords for different environments
3. Rotate passwords regularly
4. Don't commit passwords to version control
5. Use HTTPS in production to protect password transmission
6. Consider using environment-specific `.env` files

## Deployment Examples

### Zeabur

Add environment variable in Zeabur dashboard:
```
CONSOLE_PASSWORD=your_strong_password
```

### Docker

```bash
docker run -e CONSOLE_PASSWORD="your_password" your-image
```

### Docker Compose

```yaml
services:
  app:
    environment:
      - CONSOLE_PASSWORD=your_password
```

## Disabling Console

If you don't need the management console at all:

```bash
ENABLE_CONSOLE="false"
```

This completely disables all console endpoints and the web interface.

## Troubleshooting

### "Console access denied" error

- Check that `CONSOLE_PASSWORD` is set correctly in your environment
- Verify the password in your request header matches the configured password
- Clear browser localStorage and re-enter password

### Password not working

- Ensure no extra spaces in the password
- Check that the environment variable is loaded (restart the service)
- Verify the header name is exactly `X-Console-Password`

## Migration from Unprotected Setup

If you're upgrading from a version without password protection:

1. Set `CONSOLE_PASSWORD` in your `.env` file
2. Restart the service
3. Clear browser cache/localStorage
4. Enter the new password when prompted

The password protection is backward compatible - if `CONSOLE_PASSWORD` is not set, the console works without authentication (not recommended for production).
