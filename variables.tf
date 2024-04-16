variable "project" {
  default = "cs744-spring24"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "k8s_version" {
  default = "1.28"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "node_count" {
  default = 2
}
