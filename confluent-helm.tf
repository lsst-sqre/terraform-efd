resource "helm_repository" "confluentinc" {
  name = "confluentinc"
  url  = "https://raw.githubusercontent.com/lsst-sqre/cp-helm-charts/master"
}

resource "helm_release" "confluent" {
  name       = "confluent"
  repository = "${helm_repository.confluentinc.metadata.0.name}"
  chart      = "cp-helm-charts"
  namespace  = "${data.template_file.k8s_namespace.rendered}"

  force_update  = true
  recreate_pods = true
}

data "kubernetes_service" "lb0" {
  metadata {
    name = "confluent-0-loadbalancer"
    namespace = "${data.template_file.k8s_namespace.rendered}"
  }
  depends_on = ["helm_release.confluent"]
}

data "kubernetes_service" "lb1" {
  metadata {
    name = "confluent-1-loadbalancer"
    namespace = "${data.template_file.k8s_namespace.rendered}"
  }
  depends_on = ["helm_release.confluent"]
}

data "kubernetes_service" "lb2" {
  metadata {
    name = "confluent-2-loadbalancer"
    namespace = "${data.template_file.k8s_namespace.rendered}"
  }
  depends_on = ["helm_release.confluent"]
}

data "template_file" "lb0_ip" {
  template = "${lookup(data.kubernetes_service.lb0.load_balancer_ingress[0], "ip")}"
}

data "template_file" "lb1_ip" {
  template = "${lookup(data.kubernetes_service.lb1.load_balancer_ingress[0], "ip")}"
}

data "template_file" "lb2_ip" {
  template = "${lookup(data.kubernetes_service.lb2.load_balancer_ingress[0], "ip")}"
}
