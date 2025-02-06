
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.6"  # Vous pouvez spécifier la version souhaitée

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  depends_on = [aws_eks_access_entry.devops, aws_eks_access_policy_association.devops ]
  timeout = 300
} 