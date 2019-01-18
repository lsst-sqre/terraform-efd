provider "template" {
  version = "~> 1.0"
}

provider "google" {
  version = "~> 1.20"
}

provider "null" {
  version = "~> 1.0"
}

module "gke" {
  source             = "git::https://github.com/lsst-sqre/terraform-gke-std.git//?ref=master"
  name               = "${local.gke_cluster_name}"
  google_project     = "${var.google_project}"
  gke_version        = "latest"
  initial_node_count = 3
  machine_type       = "n1-standard-2"
}

# haxx...
resource "null_resource" "gcloud_container_clusters_get-credentials" {
  triggers = {
    google_container_cluster_endpoint = "${module.gke.id}"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${local.gke_cluster_name}"
  }

  depends_on = [
    "module.gke",
  ]
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
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
}

provider "helm" {
  version = "~> 0.7.0"

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

provider "grafana" {
  version = "~> 1.3"

  url  = "https://${local.grafana_fqdn}"
  auth = "${var.grafana_admin_user}:${var.grafana_admin_pass}"
}
