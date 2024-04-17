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

resource "google_service_account_iam_binding" "default_iam_binding" {
  service_account_id = google_service_account.default.name
  role               = "roles/logging.logWriter"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}
resource "google_service_account_iam_binding" "default_iam_binding" {
  service_account_id = google_service_account.default.name
  role               = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}
resource "google_service_account_iam_binding" "default_iam_binding" {
  service_account_id = google_service_account.default.name
  role               = "roles/stackdriver.resourceMetadata.writer"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}
