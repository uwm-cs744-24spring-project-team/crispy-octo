provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "koordinator" {
  name       = "kooridinator"
  repository = "https://koordinator-sh.github.io/charts/"
  chart      = "koordinator"
  version    = "1.4.1"
}
