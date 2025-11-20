# 🚂 Railway Deployment Guide - Budz Reserve

This guide will help you deploy your Budz Reserve application to Railway using GitHub integration.

## 📋 Prerequisites

1. **GitHub Account** - Your code should be in a GitHub repository
2. **Railway Account** - Sign up at [railway.app](https://railway.app)
3. **Railway CLI** (Optional) - For local testing: `npm i -g @railway/cli`

## 🚀 Step-by-Step Deployment

### Step 1: Prepare Your Repository

1. **Push your code to GitHub** (if not already done):
   ```bash
   git add .
   git commit -m "Prepare for Railway deployment"
   git push origin main
   ```

2. **Verify your Dockerfiles exist**:
   - ✅ `backend/Dockerfile.prod`
   - ✅ `frontend/Dockerfile.prod`

### Step 2: Create Railway Project

1. **Go to [railway.app](https://railway.app)** and sign in
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your repository: `CAPSTONE-2025-BUDZ-RESERVE` (or your repo name)
5. Railway will create a new project

### Step 3: Add MySQL Database Service

1. In your Railway project, click **"+ New"**
2. Select **"Database"** → **"Add MySQL"**
3. Railway will provision a MySQL database
4. **Note the connection details** (you'll need these for environment variables)

### Step 4: Deploy Backend Service

1. In your Railway project, click **"+ New"** → **"GitHub Repo"**
2. Select the same repository
3. Railway will detect it's a new service
4. **Configure the service:**
   - **Name**: `budz-reserve-backend`
   - Go to **Settings** → **Build & Deploy**
   - **Builder**: Select **"Dockerfile"** (NOT Nixpacks)
   - **Dockerfile Path**: `backend/Dockerfile.prod`
   - **Docker Context**: `/` (root of repository)
   - **Root Directory**: Leave empty
   - **Build Command**: Leave empty (handled by Dockerfile)
   - **Start Command**: Leave empty (handled by Dockerfile)

5. **Set Environment Variables** (click on the service → Variables tab):
   ```bash
   NODE_ENV=production
   PORT=3001
   API_PREFIX=api
   
   # Database (from MySQL service)
   DB_HOST=${{MySQL.MYSQLHOST}}
   DB_PORT=${{MySQL.MYSQLPORT}}
   DB_USERNAME=${{MySQL.MYSQLUSER}}
   DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
   DB_DATABASE=${{MySQL.MYSQLDATABASE}}
   
   # JWT Secrets (generate strong random strings)
   JWT_SECRET=your-super-secret-jwt-key-change-this
   JWT_EXPIRES_IN=7d
   JWT_REFRESH_SECRET=your-super-secret-refresh-key-change-this
   JWT_REFRESH_EXPIRES_IN=7d
   
   # CORS & Frontend URL (update after frontend is deployed)
   CORS_ORIGIN=https://your-frontend-domain.railway.app
   FRONTEND_URL=https://your-frontend-domain.railway.app
   
   # Payment Gateway (PayMongo)
   PAYMONGO_SECRET_KEY=sk_test_your_paymongo_secret_key
   PAYMONGO_PUBLIC_KEY=pk_test_your_paymongo_public_key
   PAYMONGO_WEBHOOK_SECRET=whsk_your_webhook_secret
   
   # Email (SMTP)
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=your-email@gmail.com
   SMTP_PASS=your-app-password
   SMTP_FROM=noreply@budzreserve.com
   
   # File Upload
   UPLOAD_DEST=./uploads
   MAX_FILE_SIZE=5242880
   
   # Rate Limiting
   THROTTLE_TTL=60
   THROTTLE_LIMIT=10
   ```

6. **Generate Public Domain** (Settings → Generate Domain)
   - Note the URL: `https://your-backend-service.railway.app`

### Step 5: Deploy Frontend Service

1. In your Railway project, click **"+ New"** → **"GitHub Repo"**
2. Select the same repository again
3. **Configure the service:**
   - **Name**: `budz-reserve-frontend`
   - Go to **Settings** → **Build & Deploy**
   - **Builder**: Select **"Dockerfile"** (NOT Nixpacks)
   - **Dockerfile Path**: `frontend/Dockerfile.prod`
   - **Docker Context**: `/` (root of repository)
   - **Root Directory**: Leave empty
   - **Build Command**: Leave empty (handled by Dockerfile)
   - **Start Command**: Leave empty (handled by Dockerfile)

4. **Set Environment Variables**:
   ```bash
   NODE_ENV=production
   VITE_API_URL=https://your-backend-service.railway.app/api
   VITE_APP_NAME=Budz Reserve
   ```

5. **Generate Public Domain** (Settings → Generate Domain)
   - Note the URL: `https://your-frontend-service.railway.app`

### Step 6: Update Environment Variables

1. **Update Backend CORS_ORIGIN**:
   - Go to backend service → Variables
   - Update `CORS_ORIGIN` to your frontend URL
   - Update `FRONTEND_URL` to your frontend URL

2. **Update Frontend API URL**:
   - Go to frontend service → Variables
   - Update `VITE_API_URL` to your backend URL + `/api`

### Step 7: Run Database Migrations

1. **Access backend service shell**:
   - Click on backend service
   - Go to "Deployments" tab
   - Click on latest deployment → "View Logs"
   - Or use Railway CLI: `railway run bash`

2. **Run migrations**:
   ```bash
   # If you have migration scripts
   npm run migration:run
   
   # Or manually import your database
   # Railway provides connection string in MySQL service variables
   ```

### Step 8: Initialize Database (Optional)

If you have SQL files to initialize the database:

1. **Get MySQL connection string** from Railway MySQL service
2. **Import your database**:
   ```bash
   # Using Railway CLI
   railway connect mysql
   
   # Or using MySQL client
   mysql -h $MYSQLHOST -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE < database_export.sql
   ```

## 🔧 Railway-Specific Configuration

### Using railway.json (Optional)

Railway can auto-detect services, but you can also use `railway.json`:

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "backend/Dockerfile.prod"
  }
}
```

### Service Dependencies

Railway automatically handles service dependencies. Make sure:
- Backend service references MySQL service variables
- Frontend service has the correct backend URL

## 🌐 Custom Domains

1. **Add Custom Domain**:
   - Go to service → Settings → Domains
   - Click "Custom Domain"
   - Add your domain (e.g., `api.yourdomain.com`)
   - Follow DNS configuration instructions

2. **Update Environment Variables**:
   - Update `CORS_ORIGIN` with your custom domain
   - Update `VITE_API_URL` with your custom backend domain

## 📊 Monitoring & Logs

1. **View Logs**:
   - Click on any service → "Deployments" → Latest deployment → "View Logs"
   - Or use Railway CLI: `railway logs`

2. **Monitor Metrics**:
   - Railway dashboard shows CPU, Memory, and Network usage
   - Set up alerts in Settings

## 🔄 Continuous Deployment

Railway automatically deploys when you push to GitHub:

1. **Automatic Deployments**:
   - Push to `main` branch → Auto-deploys
   - Push to other branches → Creates preview deployments

2. **Manual Deployments**:
   - Go to service → "Deployments" → "Redeploy"

3. **Environment-Specific Deployments**:
   - Create separate Railway projects for staging/production
   - Or use Railway environments feature

## 🐛 Troubleshooting

### Backend Won't Start

1. **Check logs**: Service → Deployments → View Logs
2. **Verify environment variables**: All required vars are set
3. **Check database connection**: MySQL service is running
4. **Verify port**: Backend should use `PORT` env var (Railway sets this)

### Frontend Can't Connect to Backend

1. **Check CORS settings**: Backend `CORS_ORIGIN` matches frontend URL
2. **Verify API URL**: Frontend `VITE_API_URL` is correct
3. **Check backend health**: Visit `https://your-backend.railway.app/api/health`

### Database Connection Issues

1. **Verify MySQL service**: Is it running?
2. **Check connection variables**: Use Railway's variable references
3. **Test connection**: Use Railway CLI to connect

### Build Failures

1. **Check Dockerfile path**: Correct path in service settings
2. **View build logs**: Service → Deployments → Build logs
3. **Verify dependencies**: All required files are in repo

## 💰 Railway Pricing

- **Hobby Plan**: $5/month - Good for development
- **Pro Plan**: $20/month - Better for production
- **Team Plan**: Custom pricing

**Note**: Railway provides $5 free credit monthly for new accounts.

## 📝 Environment Variables Reference

### Backend Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment | `production` |
| `PORT` | Server port | `3001` (Railway sets this) |
| `DB_HOST` | Database host | `${{MySQL.MYSQLHOST}}` |
| `DB_PORT` | Database port | `${{MySQL.MYSQLPORT}}` |
| `DB_USERNAME` | Database user | `${{MySQL.MYSQLUSER}}` |
| `DB_PASSWORD` | Database password | `${{MySQL.MYSQLPASSWORD}}` |
| `DB_DATABASE` | Database name | `${{MySQL.MYSQLDATABASE}}` |
| `JWT_SECRET` | JWT secret key | (Generate random string) |
| `JWT_REFRESH_SECRET` | JWT refresh secret | (Generate random string) |
| `CORS_ORIGIN` | Allowed CORS origin | `https://your-frontend.railway.app` |

### Frontend Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment | `production` |
| `VITE_API_URL` | Backend API URL | `https://your-backend.railway.app/api` |
| `VITE_APP_NAME` | App name | `Budz Reserve` |

## 🎉 Success Checklist

- [ ] MySQL database service created and running
- [ ] Backend service deployed and accessible
- [ ] Frontend service deployed and accessible
- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] CORS configured correctly
- [ ] Frontend can connect to backend
- [ ] Custom domains configured (optional)
- [ ] Monitoring set up

## 🆘 Need Help?

- **Railway Docs**: [docs.railway.app](https://docs.railway.app)
- **Railway Discord**: [discord.gg/railway](https://discord.gg/railway)
- **Railway Support**: support@railway.app

---

**Quick Deploy Command** (using Railway CLI):
```bash
railway login
railway init
railway up
```

