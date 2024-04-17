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

resource "google_project_iam_binding" "default_iam_binding" {
  project = var.project
  role    = "roles/editor"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}
