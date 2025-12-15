#!/bin/bash

# Configuration
GITHUB_USER="R-Gld"
REPO_NAME="maven-with-texlive"
# Docker requires lowercase repository names
IMAGE_NAME="ghcr.io/$(echo ${GITHUB_USER} | tr '[:upper:]' '[:lower:]')/${REPO_NAME}"

# Detect current architecture
ARCH=$(uname -m)

# Map architecture to Docker platform and tags
case "${ARCH}" in
  x86_64|amd64)
    PLATFORM="linux/amd64"
    ARCH_TAG="amd64"
    TAGS="${IMAGE_NAME}:${ARCH_TAG} ${IMAGE_NAME}:latest"
    echo "Detected architecture: amd64"
    echo "Tags: ${ARCH_TAG}, latest"
    ;;
  arm64|aarch64)
    PLATFORM="linux/arm64"
    ARCH_TAG="arm64"
    TAGS="${IMAGE_NAME}:${ARCH_TAG}"
    echo "Detected architecture: arm64"
    echo "Tag: ${ARCH_TAG}"
    ;;
  *)
    echo "Error: Unsupported architecture: ${ARCH}"
    echo "Supported architectures: x86_64/amd64, arm64/aarch64"
    exit 1
    ;;
esac

echo ""
echo "Building Docker image..."
echo "Platform: ${PLATFORM}"
echo "Image: ${IMAGE_NAME}"
echo ""

# Build the image with appropriate tags
BUILD_CMD="docker build --platform ${PLATFORM}"
for TAG in ${TAGS}; do
  BUILD_CMD="${BUILD_CMD} -t ${TAG}"
done
BUILD_CMD="${BUILD_CMD} ."

eval "${BUILD_CMD}"
BUILD_STATUS=$?

echo ""

if [ ${BUILD_STATUS} -ne 0 ]; then
  echo "Build failed with exit code ${BUILD_STATUS}"
  exit ${BUILD_STATUS}
fi

echo "Build completed successfully!"
echo ""
echo "Tagged images:"
for TAG in ${TAGS}; do
  echo "  - ${TAG}"
done
echo ""

# Ask user if they want to push
read -p "Do you want to push the image(s) to GitHub Container Registry? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Pushing to GitHub Container Registry..."
  echo ""

  for TAG in ${TAGS}; do
    echo "Pushing ${TAG}..."
    docker push "${TAG}"
    PUSH_STATUS=$?

    if [ ${PUSH_STATUS} -ne 0 ]; then
      echo "Failed to push ${TAG} (exit code ${PUSH_STATUS})"
      exit ${PUSH_STATUS}
    fi
  done

  echo ""
  echo "Image(s) pushed successfully!"
else
  echo "Push cancelled. You can manually push later with:"
  for TAG in ${TAGS}; do
    echo "  docker push ${TAG}"
  done
fi
