# ⚡ Railway Quick Start

## 🚀 Deploy in 5 Minutes

### 1. Push to GitHub
```bash
git add .
git commit -m "Ready for Railway"
git push origin main
```

### 2. Create Railway Project
1. Go to [railway.app](https://railway.app)
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your repository

### 3. Add MySQL Database
1. Click **"+ New"** → **"Database"** → **"Add MySQL"**
2. Wait for it to provision

### 4. Deploy Backend
1. Click **"+ New"** → **"GitHub Repo"** (same repo)
2. **Settings** → **Build & Deploy**:
   - Name: `backend`
   - **Builder**: Select **"Dockerfile"** (important!)
   - Dockerfile Path: `backend/Dockerfile.prod`
   - Docker Context: `/` (root of repo)
3. **Variables** (use Railway's variable references):
   ```
   NODE_ENV=production
   DB_HOST=${{MySQL.MYSQLHOST}}
   DB_PORT=${{MySQL.MYSQLPORT}}
   DB_USERNAME=${{MySQL.MYSQLUSER}}
   DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
   DB_DATABASE=${{MySQL.MYSQLDATABASE}}
   JWT_SECRET=change-this-secret-key
   JWT_REFRESH_SECRET=change-this-refresh-secret
   CORS_ORIGIN=https://your-frontend.railway.app
   ```
4. Generate domain → Copy URL

### 5. Deploy Frontend
1. Click **"+ New"** → **"GitHub Repo"** (same repo)
2. **Settings** → **Build & Deploy**:
   - Name: `frontend`
   - **Builder**: Select **"Dockerfile"** (important!)
   - Dockerfile Path: `frontend/Dockerfile.prod`
   - Docker Context: `/` (root of repo)
3. **Variables**:
   ```
   NODE_ENV=production
   VITE_API_URL=https://your-backend-url.railway.app/api
   ```
4. Generate domain → Copy URL

### 6. Update Backend CORS
- Go to backend service → Variables
- Update `CORS_ORIGIN` with frontend URL

### 7. Done! 🎉
Your app is live at the frontend URL!

## 📋 Required Environment Variables

### Backend
- `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`, `DB_DATABASE` (from MySQL service)
- `JWT_SECRET`, `JWT_REFRESH_SECRET`
- `CORS_ORIGIN` (frontend URL)

### Frontend
- `VITE_API_URL` (backend URL + `/api`)

## 🔗 Using Railway Variable References

Instead of hardcoding values, use Railway's variable references:
```
DB_HOST=${{MySQL.MYSQLHOST}}
DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
```

## 📚 Full Guide
See `RAILWAY_DEPLOYMENT.md` for detailed instructions.

