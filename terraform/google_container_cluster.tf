resource "google_container_cluster" "primary" {
  name                     = "primary-zonal"
  location                 = var.zone
  initial_node_count       = var.node_count
  # remove_default_node_pool = true
  network                  = "projects/cs744-spring24/global/networks/default"
  subnetwork               = "projects/cs744-spring24/regions/us-central1/subnetworks/default"
  min_master_version       = var.k8s_version

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb

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
      enable_integrity_monitoring = false
    }
  }
  release_channel {
    channel = "REGULAR"
  }

  cluster_autoscaling {
    enabled = false
  }

  network_policy {
    enabled = false
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
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = true
    }

    network_policy_config {
      disabled = true
    }

  }
}
