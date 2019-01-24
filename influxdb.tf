locals {
  influxdb_fqdn        = "${local.dns_prefix}influxdb-${var.deploy_name}.${var.domain_name}"
  influxdb_secret_name = "influxdb-server-tls"
}

resource "kubernetes_namespace" "influxdb" {
  metadata {
    name = "${local.influxdb_k8s_namespace}"
  }
}

resource "helm_release" "influxdb" {
  name      = "influxdb"
  chart     = "stable/influxdb"
  namespace = "${kubernetes_namespace.influxdb.metadata.0.name}"
  version   = "1.1.1"

  keyring       = ""
  force_update  = true
  recreate_pods = true

  values = [
    "${data.template_file.influxdb_values.rendered}",
  ]

  depends_on = [
    "kubernetes_secret.influxdb_tls",
    "module.tiller",
    "helm_release.nginx_ingress",
  ]
}

resource "kubernetes_secret" "influxdb_tls" {
  metadata {
    name      = "${local.influxdb_secret_name}"
    namespace = "${kubernetes_namespace.influxdb.metadata.0.name}"
  }

  data {
    tls.crt = "${local.tls_crt}"
    tls.key = "${local.tls_key}"
  }
}

data "template_file" "influxdb_values" {
  template = "${file("${path.module}/charts/influxdb.yaml")}"

  vars {
    influxdb_fqdn             = "${local.influxdb_fqdn}"
    influxdb_secret_name      = "${local.influxdb_secret_name}"
    influxdb_admin_user       = "${var.influxdb_admin_user}"
    influxdb_admin_pass       = "${var.influxdb_admin_pass}"
  }
}
