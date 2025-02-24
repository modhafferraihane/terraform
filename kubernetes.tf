resource "kubectl_manifest" "cluster_issuer" {
    yaml_body = file("./kubernetes/manifests/certificates/clusterissuer.yaml")
    depends_on = [helm_release.cert_manager]
}


resource "kubectl_manifest" "certificate_grafana" {
    yaml_body = file("./kubernetes/manifests/certificates/certificate-grafana.yaml")
depends_on = [kubectl_manifest.cluster_issuer]
}

resource "kubectl_manifest" "certificate_prometheus" {
    yaml_body = file("./kubernetes/manifests/certificates/certificate-prometheus.yaml")
depends_on = [kubectl_manifest.cluster_issuer]
}

resource "kubectl_manifest" "certificate_wildcards" {
    yaml_body = file("./kubernetes/manifests/certificates/certificate-wildcards.yaml")
depends_on = [kubectl_manifest.cluster_issuer]
}

resource "kubectl_manifest" "ingress" {
    yaml_body = file("./kubernetes/manifests/ingress.yaml")
    depends_on = [kubectl_manifest.cluster_issuer]
}

