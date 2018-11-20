resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "${data.template_file.k8s_namespace.rendered}"
  }
}
