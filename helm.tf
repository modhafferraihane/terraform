resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
  depends_on = [module.eks]
}
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.12.0"  
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  values     = [ "${file("${path.root}/kubernetes/helm/ingress-nginx/values.yaml")}" ]
  depends_on = [kubernetes_namespace.ingress_nginx ]
  timeout = 300
} 

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
  depends_on = [module.eks]
}
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.11.0"  
  namespace  = "cert-manager"
  values = [ "${file("${path.root}/kubernetes/helm/cert-manager/values.yaml")}" ]
  create_namespace = true
  # timeout    = 1200
  depends_on       = [kubernetes_namespace.cert-manager]
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  depends_on = [module.eks]
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "69.3.2"  
  namespace  = "monitoring"
  create_namespace = true
  values = [ "${file("${path.root}/kubernetes/helm/kube-prometheus-stack/values.yaml")}" ]
  depends_on       = [kubernetes_namespace.monitoring]
}
resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
  depends_on = [ module.eks, kubernetes_namespace.monitoring ]
}

# resource "helm_release" "external_dns" {
#   name       = "external-dns"
#   repository = "https://kubernetes-sigs.github.io/external-dns/"
#   chart      = "external-dns"
#   version    = "1.15.2"  
#   values     = [ "${file("${path.root}/kubernetes/helm/kube-prometheus-stack/values.yaml")}" ]
#   namespace  = "kube-system"
#   set = [ {
#     name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.eks.external_dns_role_arn
#   }
#   ]
#   depends_on = [module.eks, kubernetes_namespace.external_dns, helm_release.kube_prometheus_stack]
# }

# resource "random_password" "redis_password" {
#   length  = 16
#   special = false
# }

# resource "kubernetes_secret" "argocd_redis" {
#   metadata {
#     name      = "argocd-redis"
#     namespace = "argocd"
#   }

#   data = {
#     password = random_password.redis_password.result
#   }
# }

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [module.eks] 
}


resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.0"  
  namespace  = "argocd"
  values     = [ "${file("${path.root}/kubernetes/helm/argocd/values.yaml")}" ]
  # timeout    = 1200
  depends_on = [kubernetes_namespace.argocd, helm_release.cert_manager]
}
