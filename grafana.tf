locals {
  grafana_fqdn = "${local.dns_prefix}grafana-${var.deploy_name}.${var.domain_name}"
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "${local.grafana_k8s_namespace}"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "stable/grafana"
  namespace  = "${local.grafana_k8s_namespace}"

  keyring       = ""
  force_update  = true
  recreate_pods = true

  values = [
    "${file("grafana.yaml")}",
    "${data.template_file.grafana_values.rendered}",
  ]

  depends_on = ["kubernetes_secret.grafana_tls"]
}

data "template_file" "grafana_values" {
  template = <<EOF
---
service:
  # ingress on gke requires "NodePort" or "LoadBalancer"
  type: LoadBalancer
ingress:
  enabled: true
  hosts:
    - $${grafana_fqdn}
  tls:
    - secretName: grafana-server-tls
      hosts:
        - $${grafana_fqdn}
EOF

  vars {
    grafana_fqdn = "${local.grafana_fqdn}"
  }
}

resource "kubernetes_secret" "grafana_tls" {
  metadata {
    name      = "grafana-server-tls"
    namespace = "${local.grafana_k8s_namespace}"
  }

  data {
    tls.crt = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes_chain.pem")}"
    tls.key  = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes.key")}"
  }
}
