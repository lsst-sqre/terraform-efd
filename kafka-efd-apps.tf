resource "kubernetes_namespace" "kafka-efd-apps" {
  metadata {
    name = "${local.kafka_efd_apps_k8s_namespace}"
  }
}

resource "helm_release" "kafka-efd-apps" {
  name      = "kafka-efd-apps"
  chart     = "lsstsqre/kafka-efd-apps"
  namespace = "${kubernetes_namespace.kafka-efd-apps.metadata.0.name}"
  version   = "0.1.0"

  force_update  = true
  recreate_pods = true

  values = [
    "${data.template_file.kafka_efd_apps_values.rendered}",
  ]

  depends_on = [
    "helm_release.influxdb",
    "helm_release.confluent",
  ]
}

data "template_file" "kafka_efd_apps_values" {
  template = "${file("${path.module}/charts/kafka-efd-apps.yaml")}"

  vars {
    github_user  = "${var.github_user}"
    github_token = "${var.github_token}"
  }
}
