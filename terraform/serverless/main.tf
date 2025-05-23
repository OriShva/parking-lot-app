terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
  service = each.key
  disable_on_destroy = false
}

# Create Artifact Registry Repository
resource "google_artifact_registry_repository" "parking_repo" {
  location      = var.region
  repository_id = "parking-lot-repo"
  description   = "Docker repository for parking lot application"
  format        = "DOCKER"
  depends_on    = [google_project_service.required_apis]
}

# Cloud Run service
resource "google_cloud_run_v2_service" "parking_service" {
  name     = "parking-lot-service"
  location = var.region
  
  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.parking_repo.repository_id}/parking-lot:latest"
      
      ports {
        container_port = 5000
      }

      env {
        name  = "PORT"
        value = "5000"
      }
    }
  }

  depends_on = [google_artifact_registry_repository.parking_repo]
}

# Make the Cloud Run service public
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.parking_service.location
  service  = google_cloud_run_v2_service.parking_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
} 