# Production Deployment Checklist

## Security Configuration

### ✅ Console Protection (Critical)
- [ ] Set `CONSOLE_PASSWORD` environment variable
- [ ] Use strong password (32+ characters recommended)
- [ ] Test console access with password
- [ ] Document password in secure location (password manager)

### ✅ API Protection
- [ ] Set `OPENAI_KEYS` environment variable
- [ ] Use strong, random API keys
- [ ] Distribute keys securely to authorized users only
- [ ] Document which keys are assigned to which users/services

### ✅ HTTPS Configuration
- [ ] Configure SSL/TLS certificate
- [ ] Enable HTTPS on reverse proxy (Nginx/Caddy)
- [ ] Redirect HTTP to HTTPS
- [ ] Test certificate validity

## Database Configuration

### ✅ Database Setup
- [ ] Choose database backend (SQLite/PostgreSQL/MySQL)
- [ ] Set `DATABASE_URL` if using PostgreSQL/MySQL
- [ ] Test database connection
- [ ] Set up automated backups

### ✅ Data Persistence
- [ ] Ensure database files are persisted (Docker volumes)
- [ ] Test data persistence after container restart
- [ ] Document backup and restore procedures

## Network Configuration

### ✅ Proxy Settings (if needed)
- [ ] Set `HTTP_PROXY` if behind corporate proxy
- [ ] Test connectivity to AWS OIDC endpoints
- [ ] Verify proxy authentication if required

### ✅ Firewall Rules
- [ ] Allow inbound traffic on application port
- [ ] Restrict access to trusted IP ranges (optional)
- [ ] Configure rate limiting (optional)

## Application Configuration

### ✅ Environment Variables
- [ ] `CONSOLE_PASSWORD` - Set strong password
- [ ] `OPENAI_KEYS` - Set API key whitelist
- [ ] `ENABLE_CONSOLE` - Set to "true" or "false"
- [ ] `MAX_ERROR_COUNT` - Adjust threshold (default: 100)
- [ ] `TOKEN_COUNT_MULTIPLIER` - Adjust if needed (default: 1.0)
- [ ] `PORT` - Set application port (default: 8000)

### ✅ Account Management
- [ ] Add at least one Amazon Q account
- [ ] Test account token refresh
- [ ] Verify account is enabled
- [ ] Test API requests with account

## Testing

### ✅ Functional Tests
- [ ] Test console access (should require password)
- [ ] Test API endpoint `/v1/chat/completions`
- [ ] Test API endpoint `/v1/messages`
- [ ] Test streaming responses
- [ ] Test health check `/healthz`

### ✅ Security Tests
- [ ] Verify console access denied without password
- [ ] Verify console access denied with wrong password
- [ ] Verify API access denied without valid key (if OPENAI_KEYS set)
- [ ] Test HTTPS certificate (no warnings)

### ✅ Performance Tests
- [ ] Test concurrent requests
- [ ] Monitor memory usage
- [ ] Monitor CPU usage
- [ ] Check response times

## Monitoring

### ✅ Logging
- [ ] Configure log level
- [ ] Set up log aggregation (optional)
- [ ] Monitor error logs
- [ ] Set up alerts for critical errors (optional)

### ✅ Health Monitoring
- [ ] Set up health check monitoring
- [ ] Configure uptime monitoring (optional)
- [ ] Set up alerts for downtime (optional)

## Documentation

### ✅ Internal Documentation
- [ ] Document deployment architecture
- [ ] Document environment variables
- [ ] Document backup procedures
- [ ] Document incident response procedures

### ✅ User Documentation
- [ ] Provide API endpoint URLs
- [ ] Provide API keys to authorized users
- [ ] Provide console password to administrators
- [ ] Document usage examples

## Post-Deployment

### ✅ Verification
- [ ] Verify service is running
- [ ] Verify all endpoints are accessible
- [ ] Verify accounts are working
- [ ] Verify logs are being generated

### ✅ Maintenance Plan
- [ ] Schedule regular password rotation
- [ ] Schedule regular API key rotation
- [ ] Schedule regular database backups
- [ ] Schedule regular security updates

## Quick Setup Commands

### Generate Console Password
```powershell
# Windows PowerShell
pwsh setup_console_password.ps1
```

### Test Console Authentication
```bash
# Set environment variable
export CONSOLE_PASSWORD="your_password"

# Run test script
python test_console_auth.py
```

### Docker Deployment
```bash
# Set environment variables in docker-compose.yml or .env
docker-compose up -d

# Check logs
docker-compose logs -f

# Verify health
curl http://localhost:8000/healthz
```

### Zeabur Deployment
1. Add environment variables in Zeabur dashboard:
   - `CONSOLE_PASSWORD`
   - `OPENAI_KEYS`
   - Other variables as needed
2. Deploy from GitHub repository
3. Test endpoints after deployment

## Emergency Procedures

### Reset Console Password
1. Update `CONSOLE_PASSWORD` environment variable
2. Restart application
3. Clear browser localStorage
4. Enter new password when prompted

### Disable Console (Emergency)
```bash
# Set environment variable
ENABLE_CONSOLE="false"

# Restart application
```

### Revoke API Key
1. Remove key from `OPENAI_KEYS` environment variable
2. Restart application
3. Notify affected users

## Support

For detailed security configuration, see: [CONSOLE_SECURITY.md](CONSOLE_SECURITY.md)

For general usage, see: [README.md](README.md)
