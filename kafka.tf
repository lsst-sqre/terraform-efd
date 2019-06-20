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
  namespace  = "${kubernetes_namespace.kafka.metadata.0.name}"
  version    = "0.1.2"

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
    kafka_loadbalancers     = "${var.kafka_loadbalancers}"
  }
}

data "kubernetes_service" "lb" {
  count = "${var.kafka_loadbalancers}"

  metadata {
    name      = "confluent-${count.index}-loadbalancer"
    namespace = "${kubernetes_namespace.kafka.metadata.0.name}"
  }

  depends_on = ["helm_release.confluent"]
}

locals {
  confluent_lb_ips = ["${data.kubernetes_service.lb.0.load_balancer_ingress.0.ip}"]
}
