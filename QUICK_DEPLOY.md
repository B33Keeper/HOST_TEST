# ⚡ Quick Deploy Guide

## 🚀 Fastest Way to Deploy Your Images

### Step 1: Tag Your Images
```powershell
# Windows PowerShell
.\tag-images.ps1 docker.io/yourusername v1.0.0

# Or Linux/Mac
./tag-images.sh docker.io/yourusername v1.0.0
```

### Step 2: Login to Registry
```bash
docker login
# Enter your Docker Hub credentials
```

### Step 3: Push Images
```powershell
# Windows PowerShell
.\push-images.ps1 docker.io/yourusername v1.0.0

# Or Linux/Mac
./push-images.sh docker.io/yourusername v1.0.0
```

### Step 4: Update docker-compose.registry.yml
Edit `docker-compose.registry.yml` and replace `YOUR_REGISTRY` with your actual registry:
```yaml
backend:
  image: docker.io/yourusername/budz-reserve-backend:latest

frontend:
  image: docker.io/yourusername/budz-reserve-frontend:latest
```

### Step 5: Deploy on Server
```bash
# On your server
docker-compose -f docker-compose.registry.yml pull
docker-compose -f docker-compose.registry.yml up -d
```

## 📋 Registry Examples

### Docker Hub
```bash
.\tag-images.ps1 docker.io/yourusername latest
.\push-images.ps1 docker.io/yourusername latest
```

### GitHub Container Registry
```bash
.\tag-images.ps1 ghcr.io/yourusername/budz-reserve-backend latest
.\push-images.ps1 ghcr.io/yourusername/budz-reserve-backend latest
```

### AWS ECR
```bash
# First, get login token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

# Then tag and push
.\tag-images.ps1 YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/budz-reserve-backend latest
.\push-images.ps1 YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/budz-reserve-backend latest
```

## ✅ Checklist

- [ ] Images built and tested locally
- [ ] Images tagged for registry
- [ ] Logged in to registry
- [ ] Images pushed to registry
- [ ] docker-compose.registry.yml updated
- [ ] Environment variables configured
- [ ] Server has Docker installed
- [ ] Deployed and tested

## 🆘 Need Help?

See `DEPLOYMENT_GUIDE.md` for detailed instructions.

