provider "template" {
  version = "~> 1.0"
}

module "gke" {
  source         = "github.com/lsst-sqre/terraform-gke-std"
  name           = "${data.template_file.gke_cluster_name.rendered}"
  name           = "${local.gke_cluster_name}"
  google_project = "${var.google_project}"
  gke_version    = "1.11.3-gke.18"
  machine_type   = "n1-standard-2"
}

provider "kubernetes" {
  version = "~> 1.4.0"

  load_config_file = true

  host                   = "${module.gke.host}"
  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
}

module "tiller" {
  source          = "git::https://github.com/lsst-sqre/terraform-tinfoil-tiller.git//?ref=master"
  namespace       = "kube-system"
  service_account = "tiller"
}

provider "helm" {
  version = "~> 0.6.2"

  service_account = "${module.tiller.service_account}"
  namespace       = "${module.tiller.namespace}"
  install_tiller  = false

  kubernetes {
    host                   = "${module.gke.host}"
    cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
  }
}

provider "aws" {
  version = "~> 1.21"
  region  = "us-east-1"
}
