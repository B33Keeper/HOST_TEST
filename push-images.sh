#!/bin/bash

# Push Docker Images to Registry
# Usage: ./push-images.sh [registry] [version]
# Example: ./push-images.sh docker.io/username v1.0.0

set -e

REGISTRY="${1:-docker.io/yourusername}"
VERSION="${2:-latest}"

echo "📤 Pushing images to registry: $REGISTRY"
echo "📦 Version: $VERSION"
echo ""

# Check if logged in to registry
if ! docker info | grep -q "Username"; then
    echo "⚠️  Not logged in to Docker registry."
    echo "Please login first using: docker login"
    echo "Or for specific registry: docker login $REGISTRY"
    read -p "Do you want to login now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker login
    else
        echo "❌ Please login and try again."
        exit 1
    fi
fi

# Check if images are tagged
if ! docker images | grep -q "$REGISTRY/budz-reserve-backend"; then
    echo "⚠️  Images not tagged for registry: $REGISTRY"
    echo "Tagging images first..."
    ./tag-images.sh "$REGISTRY" "$VERSION"
fi

# Push backend images
echo "📤 Pushing backend images..."
docker push $REGISTRY/budz-reserve-backend:$VERSION
docker push $REGISTRY/budz-reserve-backend:latest
echo "✅ Backend images pushed successfully!"

# Push frontend images
echo "📤 Pushing frontend images..."
docker push $REGISTRY/budz-reserve-frontend:$VERSION
docker push $REGISTRY/budz-reserve-frontend:latest
echo "✅ Frontend images pushed successfully!"

echo ""
echo "🎉 All images pushed successfully!"
echo ""
echo "📋 Pushed images:"
echo "   - $REGISTRY/budz-reserve-backend:$VERSION"
echo "   - $REGISTRY/budz-reserve-backend:latest"
echo "   - $REGISTRY/budz-reserve-frontend:$VERSION"
echo "   - $REGISTRY/budz-reserve-frontend:latest"
echo ""
echo "🌐 Next step: Update docker-compose.prod.yml to use these images"
echo "   See DEPLOYMENT_GUIDE.md for details"

