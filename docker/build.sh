#!/bin/bash
# Trusty Agent - Build Script
# Builds the custom branded OpenHands Docker image

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Trusty Agent - Docker Image Build${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Configuration
IMAGE_NAME="trusty-agent"
VERSION="0.59"
TAG="${IMAGE_NAME}:${VERSION}"
LATEST_TAG="${IMAGE_NAME}:latest"

# Check if branding directory exists
if [ ! -d "branding" ]; then
    echo -e "${RED}❌ Error: branding/ directory not found${NC}"
    echo "   Make sure you're running this script from the correct directory"
    exit 1
fi

# Check if Dockerfile exists
if [ ! -f "Dockerfile" ]; then
    echo -e "${RED}❌ Error: Dockerfile not found${NC}"
    exit 1
fi

echo -e "${GREEN}📋 Build Configuration:${NC}"
echo "   Image Name: ${IMAGE_NAME}"
echo "   Version: ${VERSION}"
echo "   Tags: ${TAG}, ${LATEST_TAG}"
echo ""

# Build the image
echo -e "${BLUE}🔨 Building Docker image...${NC}"
docker build \
    --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
    --tag ${TAG} \
    --tag ${LATEST_TAG} \
    .

# Check build status
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ Build successful!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}📦 Image Details:${NC}"
    docker images ${IMAGE_NAME} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    echo -e "${GREEN}🚀 Next Steps:${NC}"
    echo "   1. Update docker-compose.yml to use: ${TAG}"
    echo "   2. Restart the container: docker-compose up -d openhands"
    echo "   3. Verify at: https://oh.bitsync.it"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Build failed!${NC}"
    echo "   Check the error messages above for details"
    exit 1
fi
