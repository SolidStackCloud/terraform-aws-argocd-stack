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

resource "kubectl_manifest" "argocd_gateway" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: argocd
  namespace: argocd
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "argocd.${var.dominio}"
YAML

}

resource "kubectl_manifest" "argocd_virtual_service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: argocd
  namespace: argocd
spec:
  hosts:
  - "argocd.${var.dominio}"
  gateways:
  - argocd
  http:
  - route:
    - destination:
        host: argocd-server
        port:
          number: 80 
YAML

}