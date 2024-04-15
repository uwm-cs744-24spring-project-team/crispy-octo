terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

# resource "google_compute_network" "vpc_network" {
#   name = "terraform-network"
# }

resource "google_container_cluster" "primary" {
  name                     = "primary-zonal"
  location                 = var.zone
  remove_default_node_pool = true

  initial_node_count = 1
}
