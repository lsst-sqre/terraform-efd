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
