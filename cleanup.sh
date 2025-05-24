#!/bin/bash

# Exit on any error
set -e

# Check if project ID is provided
if [ -z "$1" ]; then
    echo "❌ Error: Project ID is required"
    echo "Usage: ./cleanup.sh PROJECT_ID"
    echo "Example: ./cleanup.sh my-gcp-project"
    exit 1
fi

# Configuration
PROJECT_ID=$1
REGION="europe-west1"
SERVICE_NAME="parking-lot-app"

echo "🧹 Starting cleanup process for project: ${PROJECT_ID}"

# Set project
echo "📡 Setting project..."
gcloud config set project $PROJECT_ID

# Delete the Cloud Run service
echo "🗑️ Deleting Cloud Run service..."
gcloud run services delete ${SERVICE_NAME} \
  --region ${REGION} \
  --quiet

# Delete the container image
echo "🗑️ Deleting container image..."
gcloud container images delete gcr.io/${PROJECT_ID}/${SERVICE_NAME} --quiet

echo "✅ Cleanup complete!" 