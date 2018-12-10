# https://cloud.google.com/community/tutorials/nginx-ingress-gke

resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "${local.nginx_ingress_k8s_namespace}"
  }
}

resource "helm_release" "nginx_ingress" {
  name      = "nginx-ingress"
  chart     = "stable/nginx-ingress"
  namespace = "${local.nginx_ingress_k8s_namespace}"
  version   = "1.0.1"

  keyring       = ""
  force_update  = true
  recreate_pods = true

  values = [
    "${data.template_file.nginx_ingress_values.rendered}",
  ]

  depends_on = [
    "module.tiller",
  ]
}

data "template_file" "nginx_ingress_values" {
  template = "${file("${path.module}/charts/nginx-ingress.yaml")}"
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "${local.nginx_ingress_k8s_namespace}"
  }

  depends_on = ["helm_release.nginx_ingress"]
}

data "template_file" "nginx_ingress_ip" {
  template = "${lookup(data.kubernetes_service.nginx_ingress.load_balancer_ingress[0], "ip")}"
}
