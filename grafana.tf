locals {
  grafana_fqdn = "${local.dns_prefix}grafana-${var.deploy_name}.${var.domain_name}"
  grafana_secret_name = "grafana-server-tls"
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

  depends_on = [
    "kubernetes_secret.grafana_tls",
    "helm_release.nginx_ingress",
  ]
}

data "template_file" "grafana_values" {
  template = <<EOF
---
service:
  # ingress on gke requires "NodePort" or "LoadBalancer"
  type: NodePort
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/proxy-body-size: "0m"
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_set_header X-Forwarded-Proto https;
      proxy_set_header X-Forwarded-Port 443;
      proxy_set_header X-Forwarded-Path /;
  hosts:
    - $${grafana_fqdn}
  tls:
    - secretName: $${grafana_secret_name}
      hosts:
        - $${grafana_fqdn}
EOF

  vars {
    grafana_fqdn             = "${local.grafana_fqdn}"
    grafana_secret_name      = "${local.grafana_secret_name}"
  }
}

resource "kubernetes_secret" "grafana_tls" {
  metadata {
    name      = "${local.grafana_secret_name}"
    namespace = "${local.grafana_k8s_namespace}"
  }

  data {
    tls.crt = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes_chain.pem")}"
    tls.key  = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes.key")}"
  }
}
