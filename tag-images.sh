#!/bin/bash

# Tag Docker Images for Registry
# Usage: ./tag-images.sh [registry] [version]
# Example: ./tag-images.sh docker.io/username v1.0.0

set -e

REGISTRY="${1:-docker.io/yourusername}"
VERSION="${2:-latest}"

echo "🏷️  Tagging images for registry: $REGISTRY"
echo "📦 Version: $VERSION"
echo ""

# Check if images exist
if ! docker images | grep -q "capstone-2025-budz-reserve--backend"; then
    echo "❌ Backend image not found. Building it first..."
    docker-compose -f docker-compose.prod.yml build backend
fi

if ! docker images | grep -q "capstone-2025-budz-reserve--frontend"; then
    echo "❌ Frontend image not found. Building it first..."
    docker-compose -f docker-compose.prod.yml build frontend
fi

# Get image IDs
BACKEND_IMAGE=$(docker images capstone-2025-budz-reserve--backend:latest -q | head -1)
FRONTEND_IMAGE=$(docker images capstone-2025-budz-reserve--frontend:latest -q | head -1)

if [ -z "$BACKEND_IMAGE" ]; then
    echo "❌ Backend image not found!"
    exit 1
fi

if [ -z "$FRONTEND_IMAGE" ]; then
    echo "❌ Frontend image not found!"
    exit 1
fi

# Tag backend
echo "🏷️  Tagging backend image..."
docker tag $BACKEND_IMAGE $REGISTRY/budz-reserve-backend:$VERSION
docker tag $BACKEND_IMAGE $REGISTRY/budz-reserve-backend:latest
echo "✅ Backend tagged as: $REGISTRY/budz-reserve-backend:$VERSION"
echo "✅ Backend tagged as: $REGISTRY/budz-reserve-backend:latest"

# Tag frontend
echo "🏷️  Tagging frontend image..."
docker tag $FRONTEND_IMAGE $REGISTRY/budz-reserve-frontend:$VERSION
docker tag $FRONTEND_IMAGE $REGISTRY/budz-reserve-frontend:latest
echo "✅ Frontend tagged as: $REGISTRY/budz-reserve-frontend:$VERSION"
echo "✅ Frontend tagged as: $REGISTRY/budz-reserve-frontend:latest"

echo ""
echo "🎉 All images tagged successfully!"
echo ""
echo "📋 Tagged images:"
docker images | grep "$REGISTRY/budz-reserve"

echo ""
echo "📤 Next step: Push images using:"
echo "   docker push $REGISTRY/budz-reserve-backend:$VERSION"
echo "   docker push $REGISTRY/budz-reserve-backend:latest"
echo "   docker push $REGISTRY/budz-reserve-frontend:$VERSION"
echo "   docker push $REGISTRY/budz-reserve-frontend:latest"
echo ""
echo "   Or use: ./push-images.sh $REGISTRY $VERSION"

