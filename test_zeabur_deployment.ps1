#Requires -Version 7.0
# Test Zeabur Deployment - Console Password Protection

$ErrorActionPreference = "Stop"

Write-Host "Zeabur Deployment Test" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan
Write-Host ""

# Get Zeabur domain
$domain = Read-Host "Enter your Zeabur domain (e.g., your-app.zeabur.app)"
if (-not $domain.StartsWith("http")) {
    $domain = "https://$domain"
}

Write-Host ""
Write-Host "Testing: $domain" -ForegroundColor Yellow
Write-Host ""

# Test 1: Health check (should work without password)
Write-Host "[Test 1] Health check endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$domain/healthz" -Method GET -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Health check OK" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Health check failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 2: Console access without password (should return 401 if password is set)
Write-Host "[Test 2] Console access without password..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$domain/v2/accounts" -Method GET -ErrorAction Stop
    Write-Host "✗ SECURITY ISSUE: Console accessible without password!" -ForegroundColor Red
    Write-Host "  Status: $($response.StatusCode)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Possible reasons:" -ForegroundColor Yellow
    Write-Host "1. CONSOLE_PASSWORD not set in Zeabur environment variables" -ForegroundColor White
    Write-Host "2. Zeabur not using latest code (commit 847ea69)" -ForegroundColor White
    Write-Host "3. Deployment not completed yet" -ForegroundColor White
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✓ Console protected (401 Unauthorized)" -ForegroundColor Green
        Write-Host "  Password protection is working!" -ForegroundColor Green
    } else {
        Write-Host "? Unexpected error: $_" -ForegroundColor Yellow
    }
}

Write-Host ""

# Test 3: Console access with password
Write-Host "[Test 3] Console access with password..." -ForegroundColor Cyan
$password = "SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI="
try {
    $headers = @{
        "X-Console-Password" = $password
    }
    $response = Invoke-WebRequest -Uri "$domain/v2/accounts" -Method GET -Headers $headers -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Console accessible with correct password" -ForegroundColor Green
        $accounts = $response.Content | ConvertFrom-Json
        Write-Host "  Found $($accounts.Count) accounts" -ForegroundColor White
    }
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✗ Password rejected (check if CONSOLE_PASSWORD is set correctly)" -ForegroundColor Red
    } else {
        Write-Host "? Error: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "======================" -ForegroundColor Cyan
Write-Host "Test completed" -ForegroundColor Cyan
Write-Host ""

# Check deployment version
Write-Host "[Info] Checking deployment version..." -ForegroundColor Cyan
Write-Host "Expected commit: 847ea69" -ForegroundColor White
Write-Host "Please verify in Zeabur dashboard that this commit is deployed" -ForegroundColor Yellow
Write-Host ""

# Troubleshooting tips
Write-Host "Troubleshooting:" -ForegroundColor Cyan
Write-Host "1. Check Zeabur environment variables:" -ForegroundColor White
Write-Host "   - CONSOLE_PASSWORD should be set" -ForegroundColor Gray
Write-Host "2. Check Zeabur deployment logs:" -ForegroundColor White
Write-Host "   - Verify commit 847ea69 is deployed" -ForegroundColor Gray
Write-Host "3. Try manual redeploy:" -ForegroundColor White
Write-Host "   - Click 'Redeploy' in Zeabur dashboard" -ForegroundColor Gray
Write-Host "4. Clear browser cache:" -ForegroundColor White
Write-Host "   - Use incognito mode or clear cache" -ForegroundColor Gray
Write-Host ""
