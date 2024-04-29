resource "helm_release" "koordinator" {
  name       = "kooridinator"
  repository = "https://koordinator-sh.github.io/charts/"
  chart      = "koordinator"
  version    = "1.4.1"

  set {
    name = "installation.namespace"
    value = "default"
  }

  # set {
  #   name  = "manager.replicas"
  #   value = 1
  # }
  # set {
  #   name  = "manager.resources.requests.cpu"
  #   value = "0"
  # }
  # set {
  #   name  = "manager.resources.requests.memory"
  #   value = "0"
  # }

  # set {
  #   name  = "scheduler.replicas"
  #   value = 1
  # }

  # set {
  #   name  = "scheduler.resources.requests.cpu"
  #   value = "100m"
  # }

  # set {
  #   name  = "descheduler.replicas"
  #   value = 1
  # }
  # set {
  #   name  = "descheduler.resources.requests.cpu"
  #   value = "100m"
  # }
}
