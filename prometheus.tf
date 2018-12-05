locals {
  prometheus_fqdn = "${local.dns_prefix}prometheus-${var.deploy_name}.${var.domain_name}"
}

resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "${local.prometheus_k8s_namespace}"
  }
}

resource "helm_release" "prometheus" {
  name      = "prometheus"
  chart     = "stable/prometheus"
  namespace = "${local.prometheus_k8s_namespace}"
  version   = "8.1.0"

  keyring       = ""
  force_update  = true
  recreate_pods = true

  values = ["${data.template_file.prometheus_values.rendered}"]

  depends_on = ["kubernetes_secret.prometheus_tls"]
}

data "template_file" "prometheus_values" {
  template = <<EOF
---
server:
  service:
    # ingress on gke requires "NodePort" or "LoadBalancer"
    type: LoadBalancer
  ingress:
    ## If true, Prometheus server Ingress will be created
    ##
    enabled: true

    ## Prometheus server Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - $${prometheus_fqdn}

    ## Prometheus server Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: prometheus-server-tls
        hosts:
          - $${prometheus_fqdn}
EOF

  vars {
    prometheus_fqdn = "${local.prometheus_fqdn}"
  }
}

resource "kubernetes_secret" "prometheus_tls" {
  metadata {
    name      = "prometheus-server-tls"
    namespace = "${local.prometheus_k8s_namespace}"
  }

  data {
    tls.crt = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes_chain.pem")}"
    tls.key  = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes.key")}"
  }
}
