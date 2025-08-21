resource "helm_release" "argocd" {

  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  set = [
    {
      name  = "server.extensions.enabled"
      value = "true"
    },
    {
      name  = "server.enable.proxy.extension"
      value = "true"
    },
    {
      name  = "server.extensions.image.repository"
      value = "quay.io/argoprojlabs/argocd-extension-installer"
    },
    {
      name  = "server.extensions.extensionList[0].name"
      value = "rollout-extension"
    },
    {
      name  = "server.extensions.extensionList[0].env[0].name"
      value = "EXTENSION_URL"
    },
    {
      name  = "server.extensions.extensionList[0].env[0].value"
      value = "https://github.com/argoproj-labs/rollout-extension/releases/download/v0.3.6/extension.tar"
    }
  ]

}
