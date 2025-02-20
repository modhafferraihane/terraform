resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.6"  
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  depends_on = [module.eks, kubernetes_namespace.ingress_nginx ]
  timeout = 300
} 

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.11.0"  # Vous pouvez spécifier la version souhaitée
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }

  create_namespace = true
  depends_on       = [module.eks]
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "69.3.2"  
  namespace  = "monitoring"
  create_namespace = true
  depends_on       = [module.eks]
}
resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.15.2"  
  namespace  = kubernetes_namespace.external_dns.metadata[0].name

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "aws.region"
    value = "us-east-1"
  }

  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "rbac.serviceAccountAnnotations.eks.amazonaws.com/role-arn"
    value = aws_iam_role.external_dns_role.arn
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
  set {
    name  = "domainFilters[0]"
    value = "eksops.site"
  }
  depends_on = [module.eks, kubernetes_namespace.external_dns, aws_iam_role_policy_attachment.external_dns_policy_attachment]
}