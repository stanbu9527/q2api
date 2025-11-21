#Requires -Version 7.0
# Setup Console Password for Production Deployment

$ErrorActionPreference = "Stop"

Write-Host "Console Password Setup Utility" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env exists
$envFile = ".env"
$envExists = Test-Path $envFile

if (-not $envExists) {
    Write-Host "Creating new .env file from .env.example..." -ForegroundColor Yellow
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" $envFile
        Write-Host "Created .env file" -ForegroundColor Green
    } else {
        Write-Host "ERROR: .env.example not found" -ForegroundColor Red
        exit 1
    }
}

# Generate strong password
Write-Host ""
Write-Host "Generating strong password..." -ForegroundColor Cyan
$bytes = New-Object byte[] 32
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($bytes)
$password = [Convert]::ToBase64String($bytes)

Write-Host "Generated password: " -NoNewline -ForegroundColor Green
Write-Host $password -ForegroundColor Yellow
Write-Host ""

# Ask user if they want to use this password
$response = Read-Host "Use this password? (Y/n)"
if ($response -eq "" -or $response -eq "Y" -or $response -eq "y") {
    $usePassword = $password
} else {
    $usePassword = Read-Host "Enter your custom password"
}

# Update .env file
Write-Host ""
Write-Host "Updating .env file..." -ForegroundColor Cyan

$envContent = Get-Content $envFile -Raw -Encoding UTF8

# Check if CONSOLE_PASSWORD already exists
if ($envContent -match 'CONSOLE_PASSWORD=') {
    # Replace existing
    $envContent = $envContent -replace 'CONSOLE_PASSWORD="[^"]*"', "CONSOLE_PASSWORD=`"$usePassword`""
    $envContent = $envContent -replace 'CONSOLE_PASSWORD=[^\r\n]*', "CONSOLE_PASSWORD=`"$usePassword`""
    Write-Host "Updated existing CONSOLE_PASSWORD" -ForegroundColor Green
} else {
    # Add new
    $envContent += "`r`nCONSOLE_PASSWORD=`"$usePassword`"`r`n"
    Write-Host "Added CONSOLE_PASSWORD to .env" -ForegroundColor Green
}

Set-Content $envFile -Value $envContent -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "Configuration completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Review your .env file" -ForegroundColor White
Write-Host "2. Restart your application" -ForegroundColor White
Write-Host "3. Access console and enter the password when prompted" -ForegroundColor White
Write-Host ""
Write-Host "For deployment platforms (Zeabur, Docker, etc.):" -ForegroundColor Cyan
Write-Host "Set environment variable: CONSOLE_PASSWORD=$usePassword" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: Keep this password secure!" -ForegroundColor Red
Write-Host ""
