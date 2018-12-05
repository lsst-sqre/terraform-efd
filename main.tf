provider "template" {
  version = "~> 1.0"
}

module "gke" {
  source         = "github.com/lsst-sqre/terraform-gke-std"
  name           = "${data.template_file.gke_cluster_name.rendered}"
  google_project = "${var.google_project}"
  gke_version    = "1.11.3-gke.18"
  machine_type   = "n1-standard-2"
}

provider "kubernetes" {
  version = "~> 1.3"

  #XXX auth is broken
  #load_config_file = false

  host                   = "${module.gke.host}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
}

# XXX helm needs either client auth enabled or a network policy applied to
# prevent it being accessed from other namespaces.

# XXX tf helm provider 0.6.2 vendors helm 2.9.0 -- helm does not correctly
# configure RBAC until helm 2.11.0.  a kludge around is to manually run after
# tf fails:
# kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"automountServiceAccountToken":true}}}}'
# see: https://github.com/terraform-providers/terraform-provider-helm/issues/148
provider "helm" {
  version = "~> 0.6.2"

  service_account = "tiller"
  install_tiller = true

  kubernetes {
    host                   = "${module.gke.host}"
    client_key             = "${module.gke.client_key}"
    cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  subject {
    kind = "ServiceAccount"
    name = "tiller"
    namespace = "kube-system"
    api_group = ""
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind  = "ClusterRole"
    name = "cluster-admin"
  }
}

provider "aws" {
  version = "~> 1.21"
  region  = "us-east-1"
}
