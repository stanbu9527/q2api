#Requires -Version 7.0
# Build and Push Docker Image

$ErrorActionPreference = "Stop"

Write-Host "Docker Build and Push Script" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

# Get Docker Hub username
$dockerUsername = Read-Host "Enter your Docker Hub username"
$imageName = "q2api"
$tag = "latest"
$fullImageName = "${dockerUsername}/${imageName}:${tag}"

Write-Host ""
Write-Host "Building image: $fullImageName" -ForegroundColor Yellow
Write-Host ""

# Build Docker image
Write-Host "Step 1: Building Docker image..." -ForegroundColor Cyan
docker build -t $fullImageName .

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker build failed" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Docker image built successfully" -ForegroundColor Green
Write-Host ""

# Login to Docker Hub
Write-Host "Step 2: Login to Docker Hub..." -ForegroundColor Cyan
docker login

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker login failed" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Logged in to Docker Hub" -ForegroundColor Green
Write-Host ""

# Push image
Write-Host "Step 3: Pushing image to Docker Hub..." -ForegroundColor Cyan
docker push $fullImageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker push failed" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Image pushed successfully" -ForegroundColor Green
Write-Host ""

# Instructions
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "Next steps in Zeabur:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Go to your project settings" -ForegroundColor White
Write-Host "2. Change Docker image to: $fullImageName" -ForegroundColor Yellow
Write-Host "3. Add environment variable:" -ForegroundColor White
Write-Host "   CONSOLE_PASSWORD=SOwH+GBVSD+nkgMJgz3nkranGVxiny8oKF4udZzImBI=" -ForegroundColor Yellow
Write-Host "4. Redeploy" -ForegroundColor White
Write-Host ""
