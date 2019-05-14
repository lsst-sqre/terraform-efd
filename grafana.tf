# confluent dashboard copied from:
# https://raw.githubusercontent.com/confluentinc/cp-helm-charts/3d808fb200e12aff8c0bd6dde9595b6dfafa6032/grafana-dashboard/confluent-open-source-grafana-dashboard.json
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

resource "kubernetes_config_map" "confluent_grafana_dashboard" {
  metadata {
    name      = "confluent-grafana-dashboard"
    namespace = "${kubernetes_namespace.prometheus.metadata.0.name}"

    labels {
      grafana_dashboard = "1"
    }
  }

  data {
    confluent-open-source-grafana-dashboard.json = "${data.template_file.confluent_grafana_dashboard.rendered}"
  }
}
