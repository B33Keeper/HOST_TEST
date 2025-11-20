# 🔧 Railway Dockerfile Path Fix

## Problem
Error: `unknown instruction:FROM` when using `frontend/Dockerfile.prod`

This error typically indicates:
1. **Encoding issue** (BOM/UTF-8 BOM at start of file)
2. **Incorrect path format** in Railway
3. **Docker context issue**

## Solutions

### Solution 1: Verify Path Format in Railway

In Railway's **Dockerfile Path** field, enter:
```
frontend/Dockerfile.prod
```

**Important:**
- ✅ Use forward slashes `/` (not backslashes `\`)
- ✅ No backticks or quotes
- ✅ No leading slash
- ✅ Relative to repository root

### Solution 2: Check Docker Context

Since your Dockerfile uses `COPY frontend/`, Railway needs:
- **Docker Context**: `/` (root of repository)
- **Root Directory**: Leave empty

This is because the Dockerfile copies from `frontend/` which is relative to the repo root.

### Solution 3: Fix Encoding (if needed)

If the file has encoding issues, recreate it:

1. **Backend Dockerfile Path**: `backend/Dockerfile.prod`
2. **Frontend Dockerfile Path**: `frontend/Dockerfile.prod`

Both should work with the Docker Context set to `/`.

## Correct Railway Settings

### Backend Service:
- **Builder**: Dockerfile
- **Dockerfile Path**: `backend/Dockerfile.prod`
- **Docker Context**: `/` (or leave empty if not available)
- **Root Directory**: Leave empty
- **Start Command**: Leave empty

### Frontend Service:
- **Builder**: Dockerfile
- **Dockerfile Path**: `frontend/Dockerfile.prod`
- **Docker Context**: `/` (or leave empty if not available)
- **Root Directory**: Leave empty
- **Start Command**: Leave empty

## Alternative: Use Root-Level Dockerfiles

If Railway still has issues, you could create root-level Dockerfiles that reference the subdirectories, but the current setup should work with the correct path.

## Troubleshooting

1. **Double-check the path**: Make sure there are no extra spaces or characters
2. **Verify file exists**: The file should be at `frontend/Dockerfile.prod` in your repo
3. **Check Railway logs**: Look at the build logs to see what path Railway is trying to use
4. **Try without .prod**: Some users report success with just `frontend/Dockerfile` (if you rename it)

## Still Not Working?

If the error persists:
1. Check Railway build logs for the exact error
2. Verify the file is committed to GitHub
3. Try creating a simple test Dockerfile at root to verify Railway can read Dockerfiles
4. Contact Railway support with the build logs

