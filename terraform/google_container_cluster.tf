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
