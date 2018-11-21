provider "template" {
  version = "~> 1.0"
}

module "gke" {
  source         = "github.com/lsst-sqre/terraform-gke-std"
  name           = "${data.template_file.gke_cluster_name.rendered}"
  google_project = "${var.google_project}"
}

provider "kubernetes" {
  version = "~> 1.3"

  host                   = "${module.gke.host}"
  client_certificate     = "${base64decode(module.gke.client_certificate)}"
  client_key             = "${base64decode(module.gke.client_key)}"
  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
}

provider "helm" {
  version = "~> 0.6.2"

  kubernetes {
    host                   = "${module.gke.host}"
    client_certificate     = "${base64decode(module.gke.client_certificate)}"
    client_key             = "${base64decode(module.gke.client_key)}"
    cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
  }
}
