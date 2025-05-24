# Parking Lot Application (Flask + Google Cloud Run)

This is a **serverless parking lot REST API** built using **Python + Flask** and deployed on **Google Cloud Run**.


## Requirements
- A GCP project with billing enabled
- Google Cloud SDK installed: https://cloud.google.com/sdk
- Python & Git installed
- Your Google Cloud user must have at least one of these roles:
  - `Editor`
  - or the combination of:
    - `Cloud Run Admin`
    - `Cloud Build Editor`
    - `Storage Admin`

## Clone the repository
    git clone https://github.com/YOUR_USERNAME/parking-lot-app.git
    cd parking-lot-app



## Deployment

1. **Authenticate and set your GCP project**
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **Enable required APIs**
   ```bash
   gcloud services enable run.googleapis.com \
                      artifactregistry.googleapis.com \
                      cloudbuild.googleapis.com
   ```

3. **Deploy using the script**
   ```bash
   ./deploy.sh YOUR_PROJECT_ID
   ```
   Note: After successful deployment, you'll receive a URL where your application is accessible.

## Test the endpoints
```bash
# Create ticket
curl -X POST "YOUR_APP_URL/entry?plate=ABC123&parkingLot=A1"

# Close ticket
curl -X POST "YOUR_APP_URL/exit?ticketId=TICKET_ID"
```

## Cleanup
```bash
./cleanup.sh YOUR_PROJECT_ID
``` 