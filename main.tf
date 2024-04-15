terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = "cs744-spring24"
  region  = "us-central1-c"
}

# resource "google_compute_network" "vpc_network" {
#   name = "terraform-network"
# }

resource "google_container_cluster" "default" {
  name               = "gke-standard-zonal-single-zone"
  location           = "us-central1-c"
  initial_node_count = 1

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false
}
