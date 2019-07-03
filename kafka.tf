resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "${local.kafka_k8s_namespace}"
  }
}

data "helm_repository" "confluentinc" {
  name = "confluentinc"

  # cp-helm-charts 0.1.1
  url = "https://raw.githubusercontent.com/lsst-sqre/cp-helm-charts/0.1.1"
}

resource "helm_release" "confluent" {
  name       = "confluent"
  repository = "${data.helm_repository.confluentinc.metadata.0.name}"
  chart      = "cp-helm-charts"
  namespace  = "${kubernetes_namespace.kafka.metadata.0.name}"
  version    = "0.1.1"

  force_update  = true
  recreate_pods = true

  values = [
    "${data.template_file.cp-helm-charts-values.rendered}",
  ]
}

data "template_file" "cp-helm-charts-values" {
  template = "${file("${path.module}/charts/cp-helm-charts-values.yaml")}"

  vars {
    brokers_disk_size       = "${var.brokers_disk_size}"
    deploy_name             = "${var.deploy_name}"
    dns_prefix              = "${local.dns_prefix}"
    domain_name             = "${var.domain_name}"
    zookeeper_data_dir_size = "${var.zookeeper_data_dir_size}"
    zookeeper_log_dir_size  = "${var.zookeeper_log_dir_size}"
    storage_class           = "${var.storage_class}"
  }
}

data "kubernetes_service" "lb0" {
  metadata {
    name      = "confluent-0-loadbalancer"
    namespace = "${kubernetes_namespace.kafka.metadata.0.name}"
  }

  depends_on = ["helm_release.confluent"]
}

data "kubernetes_service" "lb1" {
  metadata {
    name      = "confluent-1-loadbalancer"
    namespace = "${kubernetes_namespace.kafka.metadata.0.name}"
  }

  depends_on = ["helm_release.confluent"]
}

data "kubernetes_service" "lb2" {
  metadata {
    name      = "confluent-2-loadbalancer"
    namespace = "${kubernetes_namespace.kafka.metadata.0.name}"
  }

  depends_on = ["helm_release.confluent"]
}

locals {
  confluent_lb0_ip = "${lookup(data.kubernetes_service.lb0.load_balancer_ingress[0], "ip")}"
  confluent_lb1_ip = "${lookup(data.kubernetes_service.lb1.load_balancer_ingress[0], "ip")}"
  confluent_lb2_ip = "${lookup(data.kubernetes_service.lb2.load_balancer_ingress[0], "ip")}"
}
