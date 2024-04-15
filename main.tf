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

resource "google_service_account" "default" {
  account_id   = "default-service-account"
  display_name = "Default Service Account"
}

resource "google_service_account_iam_binding" "default_iam_binding" {
  service_account_id = google_service_account.default.name
  role               = "roles/editor"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}

resource "google_container_cluster" "primary" {
  name                     = "primary-zonal"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = "projects/cs744-spring24/global/networks/default"
  subnetwork               = "projects/cs744-spring24/regions/us-central1/subnetworks/default"
  min_master_version       = var.k8s_version

  release_channel {
    channel = "REGULAR"
  }

  cluster_autoscaling {
    enabled = false
  }

  network_policy {
    enabled = true
  }
  binary_authorization {
    evaluation_mode = "DISABLED"
  }
  workload_identity_config {
    workload_pool = "cs744-spring24.svc.id.goog"
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = true
    }

    network_policy_config {
      disabled = false
    }

  }
}

resource "google_container_node_pool" "primary_nodes" {
  version    = var.k8s_version
  name       = "primary-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.zone
  node_count = 1
  # deletion_protection = false

  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_size_gb = 20

    service_account = google_service_account.default.email
    image_type      = "COS_CONTAINERD"
    disk_type       = "pd-balanced"
    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
    shielded_instance_config {
      enable_integrity_monitoring = true
    }
  }

  upgrade_settings {
    max_surge = 1
    strategy  = "SURGE"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

}
