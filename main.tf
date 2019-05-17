module "tiller" {
  source = "git::https://github.com/lsst-sqre/terraform-tinfoil-tiller.git//?ref=master"

  namespace       = "kube-system"
  service_account = "tiller"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
}

provider "helm" {
  alias   = "efd"
  version = "~> 0.9.1"

  service_account = "${module.tiller.service_account}"
  namespace       = "${module.tiller.namespace}"
  install_tiller  = false

  kubernetes {
    config_path      = "${var.kubeconfig_filename}"
    load_config_file = true
  }
}

provider "influxdb" {
  url      = "https://${local.dns_prefix}influxdb-${var.deploy_name}.${var.domain_name}"
  username = "${var.influxdb_admin_user}"
  password = "${var.influxdb_admin_pass}"
}
