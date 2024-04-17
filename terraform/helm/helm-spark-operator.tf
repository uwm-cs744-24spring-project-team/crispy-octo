resource "helm_release" "spark-operator" {
  name       = "spark-operator"
  repository = "https://kubeflow.github.io/spark-operator"
  chart      = "spark-operator"
  namespace  = "default"
}
