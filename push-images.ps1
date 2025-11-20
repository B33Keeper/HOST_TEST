# Push Docker Images to Registry (PowerShell)
# Usage: .\push-images.ps1 [registry] [version]
# Example: .\push-images.ps1 docker.io/username v1.0.0

param(
    [string]$Registry = "docker.io/yourusername",
    [string]$Version = "latest"
)

Write-Host "📤 Pushing images to registry: $Registry" -ForegroundColor Cyan
Write-Host "📦 Version: $Version" -ForegroundColor Cyan
Write-Host ""

# Check if logged in to registry
$dockerInfo = docker info 2>&1
if ($dockerInfo -notmatch "Username") {
    Write-Host "⚠️  Not logged in to Docker registry." -ForegroundColor Yellow
    Write-Host "Please login first using: docker login"
    Write-Host "Or for specific registry: docker login $Registry"
    $response = Read-Host "Do you want to login now? (y/n)"
    if ($response -eq "y" -or $response -eq "Y") {
        docker login
    } else {
        Write-Host "❌ Please login and try again." -ForegroundColor Red
        exit 1
    }
}

# Check if images are tagged
$taggedBackend = docker images "$Registry/budz-reserve-backend" -q
if (-not $taggedBackend) {
    Write-Host "⚠️  Images not tagged for registry: $Registry" -ForegroundColor Yellow
    Write-Host "Tagging images first..." -ForegroundColor Yellow
    .\tag-images.ps1 $Registry $Version
}

# Push backend images
Write-Host "📤 Pushing backend images..." -ForegroundColor Yellow
docker push "$Registry/budz-reserve-backend:$Version"
docker push "$Registry/budz-reserve-backend:latest"
Write-Host "✅ Backend images pushed successfully!" -ForegroundColor Green

# Push frontend images
Write-Host "📤 Pushing frontend images..." -ForegroundColor Yellow
docker push "$Registry/budz-reserve-frontend:$Version"
docker push "$Registry/budz-reserve-frontend:latest"
Write-Host "✅ Frontend images pushed successfully!" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 All images pushed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Pushed images:" -ForegroundColor Cyan
Write-Host "   - $Registry/budz-reserve-backend:$Version"
Write-Host "   - $Registry/budz-reserve-backend:latest"
Write-Host "   - $Registry/budz-reserve-frontend:$Version"
Write-Host "   - $Registry/budz-reserve-frontend:latest"
Write-Host ""
Write-Host "🌐 Next step: Update docker-compose.prod.yml to use these images" -ForegroundColor Cyan
Write-Host "   See DEPLOYMENT_GUIDE.md for details" -ForegroundColor Cyan

