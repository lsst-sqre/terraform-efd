provider "template" {
  version = "~> 1.0"
}

provider "null" {
  version = "~> 1.0"
}

provider "kubernetes" {
  version     = "~> 1.4.0"
  config_path = "${var.config_path}"
}

module "tiller" {
  source = "git::https://github.com/lsst-sqre/terraform-tinfoil-tiller.git//?ref=master"

  namespace       = "kube-system"
  service_account = "tiller"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
}

provider "helm" {
  version = "~> 0.7.0"

  service_account = "${module.tiller.service_account}"
  namespace       = "${module.tiller.namespace}"
  install_tiller  = false

  kubernetes {
    config_path = "${var.config_path}"
  }
}

provider "aws" {
  version = "~> 1.21"
  region  = "us-east-1"
}

provider "grafana" {
  version = "~> 1.3"

  url  = "https://${local.grafana_fqdn}"
  auth = "${var.grafana_admin_user}:${var.grafana_admin_pass}"
}

provider "influxdb" {
  url      = "https://${local.dns_prefix}influxdb-${var.deploy_name}.${var.domain_name}"
  username = "${var.influxdb_admin_user}"
  password = "${var.influxdb_admin_pass}"
}
