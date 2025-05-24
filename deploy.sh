#!/bin/bash

# Exit on any error
set -e

# Check if project ID is provided
if [ -z "$1" ]; then
    echo "❌ Error: Project ID is required"
    echo "Usage: ./deploy.sh PROJECT_ID"
    echo "Example: ./deploy.sh my-gcp-project"
    exit 1
fi

# Configuration
PROJECT_ID=$1
REGION="europe-west1"
SERVICE_NAME="parking-lot-app"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo "🚀 Starting deployment to project: ${PROJECT_ID}"

# Set project and enable APIs
echo "📡 Setting project and enabling APIs..."
gcloud config set project $PROJECT_ID
gcloud services enable run.googleapis.com artifactregistry.googleapis.com

# Build and push the image
echo "🏗️ Building and pushing Docker image..."
gcloud builds submit --tag ${IMAGE_NAME}

# Deploy to Cloud Run
echo "🚀 Deploying to Cloud Run..."
gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --platform managed \
  --region ${REGION} \
  --allow-unauthenticated

# Get the service URL
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} --region ${REGION} --format='value(status.url)')

echo "✅ Deployment complete!"
echo "🌐 Your application is available at: ${SERVICE_URL}" 