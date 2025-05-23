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
    "compute.googleapis.com"
  ])
  service = each.key
  disable_on_destroy = false
}

# VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "parking-lot-network"
  auto_create_subnetworks = false
  depends_on             = [google_project_service.required_apis]
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "parking-lot-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.id
  region        = var.region
}

# Firewall rule for HTTP
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Compute Engine instance
resource "google_compute_instance" "parking_server" {
  name         = "parking-lot-server"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3-pip git
    git clone https://github.com/${var.github_repo} /app
    cd /app
    pip3 install -r requirements.txt
    python3 -m gunicorn --bind 0.0.0.0:5000 'app.main:app'
  EOF

  tags = ["http-server"]

  service_account {
    scopes = ["cloud-platform"]
  }

  depends_on = [google_compute_subnetwork.subnet]
} 