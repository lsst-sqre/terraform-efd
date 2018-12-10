resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "${local.kafka_k8s_namespace}"
  }
}

resource "helm_repository" "confluentinc" {
  name = "confluentinc"
  url  = "https://raw.githubusercontent.com/lsst-sqre/cp-helm-charts/master"
}

resource "helm_release" "confluent" {
  name       = "confluent"
  repository = "${helm_repository.confluentinc.metadata.0.name}"
  chart      = "cp-helm-charts"
  namespace  = "${local.kafka_k8s_namespace}"

  keyring       = ""
  force_update  = true
  recreate_pods = true

  values = [
    "${file("${path.module}/charts/cp-helm-charts-values.yaml")}",
    "${data.template_file.confluent_values.rendered}",
  ]

  depends_on = [
    "module.tiller",
  ]
}

data "template_file" "confluent_values" {
  template = <<EOF
---
cp-kafka:
  configurationOverrides:
    "advertised.listeners": |-
      EXTERNAL://$${dns_prefix}efd-kafka$$$${KAFKA_BROKER_ID}.$${domain_name}:9094
EOF

  vars {
    dns_prefix  = "${local.dns_prefix}"
    domain_name = "${var.domain_name}"
  }
}

data "kubernetes_service" "lb0" {
  metadata {
    name      = "confluent-0-loadbalancer"
    namespace = "${local.kafka_k8s_namespace}"
  }

  depends_on = ["helm_release.confluent"]
}

data "kubernetes_service" "lb1" {
  metadata {
    name      = "confluent-1-loadbalancer"
    namespace = "${local.kafka_k8s_namespace}"
  }

  depends_on = ["helm_release.confluent"]
}

data "kubernetes_service" "lb2" {
  metadata {
    name      = "confluent-2-loadbalancer"
    namespace = "${local.kafka_k8s_namespace}"
  }

  depends_on = ["helm_release.confluent"]
}

locals {
  confluent_lb0_ip = "${lookup(data.kubernetes_service.lb0.load_balancer_ingress[0], "ip")}"
  confluent_lb1_ip = "${lookup(data.kubernetes_service.lb1.load_balancer_ingress[0], "ip")}"
  confluent_lb2_ip = "${lookup(data.kubernetes_service.lb2.load_balancer_ingress[0], "ip")}"
}
