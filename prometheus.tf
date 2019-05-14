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
  namespace = "${kubernetes_namespace.prometheus.metadata.0.name}"
  version   = "8.1.0"

  keyring       = ""
  force_update  = true
  recreate_pods = true

  values = [
    "${data.template_file.prometheus_values.rendered}",
  ]

  depends_on = [
    "kubernetes_secret.prometheus_tls",
    "module.tiller",
    "helm_release.nginx_ingress",
  ]
}

data "template_file" "prometheus_values" {
  template = "${file("${path.module}/charts/prometheus.yaml")}"

  vars {
    prometheus_fqdn = "${local.prometheus_fqdn}"
    storage_class   = "${var.storage_class}"
  }
}

resource "kubernetes_secret" "prometheus_tls" {
  metadata {
    name      = "prometheus-server-tls"
    namespace = "${kubernetes_namespace.prometheus.metadata.0.name}"
  }

  data {
    tls.crt = "${local.tls_crt}"
    tls.key = "${local.tls_key}"
  }
}
