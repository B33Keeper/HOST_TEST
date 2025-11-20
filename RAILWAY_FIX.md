# 🔧 Railway Build Fix

## Problem
Railway was trying to use Nixpacks instead of Docker, causing the error:
```
Script start.sh not found
✖ Railpack could not determine how to build the app.
```

## Solution
Created service-specific `railway.json` files that explicitly tell Railway to use Dockerfiles.

## Files Created

1. **`backend/railway.json`** - Configures backend service to use `Dockerfile.prod`
2. **`frontend/railway.json`** - Configures frontend service to use `Dockerfile.prod`
3. **`nixpacks.toml`** - Fallback configuration (though Docker should be used)

## How to Fix in Railway UI

If the configuration files don't work automatically, configure in Railway dashboard:

### For Backend Service:
1. Go to your Railway project
2. Click on the **backend service**
3. Go to **Settings** tab
4. Under **Build & Deploy**:
   - **Build Command**: Leave empty
   - **Dockerfile Path**: `backend/Dockerfile.prod`
   - **Docker Context**: `/` (root of repo)
   - **Root Directory**: Leave empty or set to `/`

### For Frontend Service:
1. Click on the **frontend service**
2. Go to **Settings** tab
3. Under **Build & Deploy**:
   - **Build Command**: Leave empty
   - **Dockerfile Path**: `frontend/Dockerfile.prod`
   - **Docker Context**: `/` (root of repo)
   - **Root Directory**: Leave empty or set to `/`

## Alternative: Use Railway CLI

You can also configure using Railway CLI:

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link to your project
railway link

# Set Dockerfile for backend
railway variables set RAILWAY_DOCKERFILE_PATH=backend/Dockerfile.prod --service backend

# Set Dockerfile for frontend
railway variables set RAILWAY_DOCKERFILE_PATH=frontend/Dockerfile.prod --service frontend
```

## Important Notes

1. **Docker Context**: Since your Dockerfiles use `COPY backend/` and `COPY frontend/`, the Docker context must be the **root of the repository** (`/`), not the service directory.

2. **Service Root Directory**: If Railway still can't find the Dockerfile, you might need to set the **Root Directory** in service settings:
   - For backend: Leave empty (uses repo root)
   - For frontend: Leave empty (uses repo root)

3. **Build Settings**: Make sure Railway is set to use **Docker** as the builder, not **Nixpacks**.

## Verify Configuration

After pushing these changes:

1. **Commit and push**:
   ```bash
   git add .
   git commit -m "Fix Railway Docker configuration"
   git push origin main
   ```

2. **Check Railway dashboard**:
   - Go to your service → Settings
   - Verify Dockerfile path is set correctly
   - Check that "Builder" is set to "Dockerfile"

3. **Redeploy**:
   - Railway should automatically redeploy
   - Or manually trigger: Service → Deployments → Redeploy

## Still Having Issues?

If Railway still tries to use Nixpacks:

1. **Explicitly set builder in UI**:
   - Service → Settings → Build & Deploy
   - Change "Builder" from "Nixpacks" to "Dockerfile"

2. **Check Dockerfile paths**:
   - Ensure paths are relative to repo root
   - `backend/Dockerfile.prod` (not `./backend/Dockerfile.prod`)

3. **Verify Dockerfile exists**:
   - Check that `backend/Dockerfile.prod` exists in your repo
   - Check that `frontend/Dockerfile.prod` exists in your repo

