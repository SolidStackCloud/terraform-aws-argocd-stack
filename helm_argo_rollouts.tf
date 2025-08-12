resource "helm_release" "argo_rollouts" {

  name       = "argo-rollouts"
  chart      = "argo-rollouts"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argo-rollouts"

  version = "2.40.3"

  create_namespace = true

  set = [
    {
      name  = "dashboard.enabled"
      value = true
    },
    {
      name  = "controller.metrics.enabled"
      value = true
    },
    {
      name  = "controller.metrics.serviceMonitor.enabled"
      value = true
    }
  ]
}