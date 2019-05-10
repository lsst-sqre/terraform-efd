locals {
  grafana_fqdn        = "${local.dns_prefix}grafana-${var.deploy_name}.${var.domain_name}"
  grafana_secret_name = "grafana-server-tls"
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "${local.grafana_k8s_namespace}"
  }
}

resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "stable/grafana"
  namespace = "${kubernetes_namespace.grafana.metadata.0.name}"
  version   = "1.20.0"

  keyring       = ""
  force_update  = true
  recreate_pods = true

  values = [
    "${data.template_file.grafana_values.rendered}",
  ]

  depends_on = [
    "kubernetes_secret.grafana_tls",
    "module.tiller",
    "helm_release.nginx_ingress",
  ]
}

resource "kubernetes_secret" "grafana_tls" {
  metadata {
    name      = "${local.grafana_secret_name}"
    namespace = "${kubernetes_namespace.grafana.metadata.0.name}"
  }

  data {
    tls.crt = "${local.tls_crt}"
    tls.key = "${local.tls_key}"
  }
}

data "template_file" "grafana_values" {
  template = "${file("${path.module}/charts/grafana.yaml")}"

  vars {
    grafana_fqdn             = "${local.grafana_fqdn}"
    grafana_secret_name      = "${local.grafana_secret_name}"
    grafana_admin_user       = "${var.grafana_admin_user}"
    grafana_admin_pass       = "${var.grafana_admin_pass}"
    prometheus_k8s_namespace = "${kubernetes_namespace.prometheus.metadata.0.name}"
    client_id                = "${var.grafana_oauth_client_id}"
    client_secret            = "${var.grafana_oauth_client_secret}"
    team_ids                 = "${var.grafana_oauth_team_ids}"
  }
}

resource "grafana_dashboard" "confluent" {
  count = "${var.dns_enable ? 1 : 0}"

  config_json = "${data.template_file.confluent_grafana_dashboard.rendered}"

  depends_on = [
    "helm_release.grafana",
    "aws_route53_record.grafana",
  ]
}

# confluent dashboard copied from:
# https://raw.githubusercontent.com/confluentinc/cp-helm-charts/700b4326352cf5220e66e6976064740b8c1976c7/grafana-dashboard/confluent-open-source-grafana-dashboard.json
data "template_file" "confluent_grafana_dashboard" {
  template = "${file("${path.module}/grafana-dashboards/confluent-open-source-grafana-dashboard.json")}"

  # The confluent provided json includes the variable `${DS_PROMETHEUS}` to be
  # templated by grafana.  However, neither the stable/grafana chart or the
  # current tf grafana provider is able to configure "variables".
  # Coincidentally, this is the same format tf uses for templates...
  vars {
    DS_PROMETHEUS = "Prometheus"
  }
}
