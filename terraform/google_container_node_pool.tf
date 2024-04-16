resource "google_container_node_pool" "primary_nodes" {
  version    = var.k8s_version
  name       = "primary-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.zone
  node_count = var.node_count
  # deletion_protection = false

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

  upgrade_settings {
    max_surge = 1
    strategy  = "SURGE"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

}
