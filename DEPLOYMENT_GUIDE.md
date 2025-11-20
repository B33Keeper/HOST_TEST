# 🚀 Deployment Guide - Budz Reserve

This guide will help you push your Docker images to a container registry and deploy them to a hosting platform.

## 📦 Container Registry Options

### Popular Registries:
1. **Docker Hub** (Free tier available) - `docker.io`
2. **GitHub Container Registry** (ghcr.io) - Free for public repos
3. **AWS ECR** - Amazon Elastic Container Registry
4. **Google Container Registry (GCR)** - Google Cloud
5. **Azure Container Registry (ACR)** - Microsoft Azure

## 🔧 Step 1: Prepare Your Images

### Option A: Use Existing Images
If you already have built images, tag them for your registry:

```bash
# Tag backend image
docker tag capstone-2025-budz-reserve--backend:latest YOUR_REGISTRY/budz-reserve-backend:latest
docker tag capstone-2025-budz-reserve--backend:latest YOUR_REGISTRY/budz-reserve-backend:v1.0.0

# Tag frontend image
docker tag capstone-2025-budz-reserve--frontend:latest YOUR_REGISTRY/budz-reserve-frontend:latest
docker tag capstone-2025-budz-reserve--frontend:latest YOUR_REGISTRY/budz-reserve-frontend:v1.0.0
```

### Option B: Build Fresh Images
```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Tag them for registry
docker tag capstone-2025-budz-reserve--backend:latest YOUR_REGISTRY/budz-reserve-backend:latest
docker tag capstone-2025-budz-reserve--frontend:latest YOUR_REGISTRY/budz-reserve-frontend:latest
```

## 🔐 Step 2: Login to Your Registry

### Docker Hub
```bash
docker login
# Enter your Docker Hub username and password
```

### GitHub Container Registry
```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### AWS ECR
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
```

### Google Cloud
```bash
gcloud auth configure-docker
```

### Azure
```bash
az acr login --name YOUR_REGISTRY_NAME
```

## 📤 Step 3: Push Images to Registry

### Manual Push
```bash
# Push backend
docker push YOUR_REGISTRY/budz-reserve-backend:latest
docker push YOUR_REGISTRY/budz-reserve-backend:v1.0.0

# Push frontend
docker push YOUR_REGISTRY/budz-reserve-frontend:latest
docker push YOUR_REGISTRY/budz-reserve-frontend:v1.0.0
```

### Using the Provided Script
```bash
# Edit push-images.sh with your registry details
./push-images.sh
```

## 🌐 Step 4: Update docker-compose for Registry

Update `docker-compose.prod.yml` to use registry images instead of building locally:

```yaml
backend:
  image: YOUR_REGISTRY/budz-reserve-backend:latest
  # Remove or comment out the build section
  # build:
  #   context: .
  #   dockerfile: ./backend/Dockerfile.prod

frontend:
  image: YOUR_REGISTRY/budz-reserve-frontend:latest
  # Remove or comment out the build section
  # build:
  #   context: .
  #   dockerfile: ./frontend/Dockerfile.prod
```

## 🖥️ Step 5: Deploy to Hosting Platform

### Option 1: VPS/Cloud Server (DigitalOcean, AWS EC2, etc.)

1. **SSH into your server**
```bash
ssh user@your-server-ip
```

2. **Install Docker and Docker Compose**
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt-get install docker-compose-plugin
```

3. **Clone your repo or copy docker-compose.prod.yml**
```bash
git clone YOUR_REPO_URL
cd CAPSTONE-2025-BUDZ-RESERVE
```

4. **Create .env file with production variables**
```bash
cp env.example .env
nano .env  # Edit with production values
```

5. **Pull and start containers**
```bash
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

### Option 2: Docker Swarm
```bash
docker swarm init
docker stack deploy -c docker-compose.prod.yml budz-reserve
```

### Option 3: Kubernetes
```bash
# Convert docker-compose to Kubernetes manifests
kompose convert -f docker-compose.prod.yml

# Apply to cluster
kubectl apply -f .
```

### Option 4: Cloud Platforms

#### AWS (ECS/Fargate)
- Use AWS ECR for images
- Create ECS task definitions
- Deploy to Fargate or EC2

#### Google Cloud Run
```bash
gcloud run deploy budz-reserve-backend \
  --image YOUR_REGISTRY/budz-reserve-backend:latest \
  --platform managed \
  --region us-central1
```

#### Azure Container Instances
```bash
az container create \
  --resource-group myResourceGroup \
  --name budz-reserve \
  --image YOUR_REGISTRY/budz-reserve-backend:latest
```

## 🔄 Continuous Deployment

### GitHub Actions Example
Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build and push backend
        uses: docker/build-push-action@v4
        with:
          context: .
          file: ./backend/Dockerfile.prod
          push: true
          tags: YOUR_REGISTRY/budz-reserve-backend:latest
          
      - name: Build and push frontend
        uses: docker/build-push-action@v4
        with:
          context: .
          file: ./frontend/Dockerfile.prod
          push: true
          tags: YOUR_REGISTRY/budz-reserve-frontend:latest
```

## 📝 Environment Variables for Production

Make sure to set these in your hosting environment:

```bash
# Database
MYSQL_ROOT_PASSWORD=secure_password_here
MYSQL_USER=budz_reserve
MYSQL_PASSWORD=secure_password_here
MYSQL_DATABASE=budz_reserve

# Backend
JWT_SECRET=your-super-secret-jwt-key
JWT_REFRESH_SECRET=your-super-secret-refresh-key
DB_HOST=mysql
DB_PORT=3306
DB_USERNAME=budz_reserve
DB_PASSWORD=secure_password_here
DB_DATABASE=budz_reserve

# Frontend
VITE_API_URL=https://api.yourdomain.com/api
VITE_APP_NAME=Budz Reserve

# CORS
CORS_ORIGIN=https://yourdomain.com
FRONTEND_URL=https://yourdomain.com
```

## 🔒 Security Checklist

- [ ] Use strong passwords for database
- [ ] Set secure JWT secrets
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall rules
- [ ] Use secrets management (AWS Secrets Manager, etc.)
- [ ] Enable Docker image scanning
- [ ] Set up monitoring and logging
- [ ] Configure backup strategy

## 📊 Monitoring

### Health Checks
```bash
# Check backend health
curl http://your-server:3001/api/health

# Check frontend
curl http://your-server/

# Check all services
docker-compose -f docker-compose.prod.yml ps
```

### Logs
```bash
# View all logs
docker-compose -f docker-compose.prod.yml logs -f

# View specific service
docker-compose -f docker-compose.prod.yml logs -f backend
```

## 🆘 Troubleshooting

### Images Not Pulling
- Check registry credentials
- Verify image tags are correct
- Check network connectivity

### Containers Not Starting
- Check logs: `docker-compose logs`
- Verify environment variables
- Check port availability

### Database Connection Issues
- Verify MySQL container is running
- Check database credentials
- Ensure network connectivity between containers

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Best Practices for Docker](https://docs.docker.com/develop/dev-best-practices/)

