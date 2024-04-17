resource "helm_release" "spark-operator" {
  name       = "spark-operator"
  repository = "https://kubeflow.github.io/spark-operator"
  chart      = "spark-operator"
  namespace  = "spark-operator"
  create_namespace = true
}
