# Tag Docker Images for Registry (PowerShell)
# Usage: .\tag-images.ps1 [registry] [version]
# Example: .\tag-images.ps1 docker.io/username v1.0.0

param(
    [string]$Registry = "docker.io/yourusername",
    [string]$Version = "latest"
)

Write-Host "🏷️  Tagging images for registry: $Registry" -ForegroundColor Cyan
Write-Host "📦 Version: $Version" -ForegroundColor Cyan
Write-Host ""

# Check if images exist
$backendExists = docker images capstone-2025-budz-reserve--backend:latest -q
$frontendExists = docker images capstone-2025-budz-reserve--frontend:latest -q

if (-not $backendExists) {
    Write-Host "❌ Backend image not found. Building it first..." -ForegroundColor Yellow
    docker-compose -f docker-compose.prod.yml build backend
}

if (-not $frontendExists) {
    Write-Host "❌ Frontend image not found. Building it first..." -ForegroundColor Yellow
    docker-compose -f docker-compose.prod.yml build frontend
}

# Get image IDs
$backendImage = docker images capstone-2025-budz-reserve--backend:latest -q | Select-Object -First 1
$frontendImage = docker images capstone-2025-budz-reserve--frontend:latest -q | Select-Object -First 1

if (-not $backendImage) {
    Write-Host "❌ Backend image not found!" -ForegroundColor Red
    exit 1
}

if (-not $frontendImage) {
    Write-Host "❌ Frontend image not found!" -ForegroundColor Red
    exit 1
}

# Tag backend
Write-Host "🏷️  Tagging backend image..." -ForegroundColor Yellow
docker tag $backendImage "$Registry/budz-reserve-backend:$Version"
docker tag $backendImage "$Registry/budz-reserve-backend:latest"
Write-Host "✅ Backend tagged as: $Registry/budz-reserve-backend:$Version" -ForegroundColor Green
Write-Host "✅ Backend tagged as: $Registry/budz-reserve-backend:latest" -ForegroundColor Green

# Tag frontend
Write-Host "🏷️  Tagging frontend image..." -ForegroundColor Yellow
docker tag $frontendImage "$Registry/budz-reserve-frontend:$Version"
docker tag $frontendImage "$Registry/budz-reserve-frontend:latest"
Write-Host "✅ Frontend tagged as: $Registry/budz-reserve-frontend:$Version" -ForegroundColor Green
Write-Host "✅ Frontend tagged as: $Registry/budz-reserve-frontend:latest" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 All images tagged successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Tagged images:" -ForegroundColor Cyan
docker images | Select-String "$Registry/budz-reserve"

Write-Host ""
Write-Host "📤 Next step: Push images using:" -ForegroundColor Cyan
Write-Host "   docker push $Registry/budz-reserve-backend:$Version"
Write-Host "   docker push $Registry/budz-reserve-backend:latest"
Write-Host "   docker push $Registry/budz-reserve-frontend:$Version"
Write-Host "   docker push $Registry/budz-reserve-frontend:latest"
Write-Host ""
Write-Host "   Or use: .\push-images.ps1 $Registry $Version"

