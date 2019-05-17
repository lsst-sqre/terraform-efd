locals {
  influxdb_url = "http://influxdb-influxdb.${local.influxdb_k8s_namespace}:8086"
}

resource "kubernetes_namespace" "telegraf" {
  metadata {
    name = "${local.telegraf_k8s_namespace}"
  }
}

resource "helm_release" "telegraf" {
  provider = "helm.efd"

  name      = "telegraf"
  chart     = "stable/telegraf"
  namespace = "${kubernetes_namespace.telegraf.metadata.0.name}"
  version   = "0.3.3"

  force_update  = true
  recreate_pods = true

  values = [
    "${data.template_file.telegraf_values.rendered}",
  ]

  depends_on = [
    "module.tiller",
    "helm_release.influxdb",
    "helm_release.nginx_ingress",
  ]
}

data "template_file" "telegraf_values" {
  template = "${file("${path.module}/charts/telegraf.yaml")}"

  vars {
    influxdb_url           = "${local.influxdb_url}"
    influxdb_telegraf_pass = "${var.influxdb_telegraf_pass}"
  }
}
