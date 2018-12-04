variable "google_project" {
  description = "google cloud project ID"
  default     = "plasma-geode-127520"
}

variable "env_name" {
  description = "Name of deployment environment."
}

variable "deploy_name" {
  description = "Name of deployment."
  default     = "efd-kafka"
}

# Name of google cloud container cluster to deploy into
data "template_file" "gke_cluster_name" {
  template = "${var.deploy_name}-${var.env_name}"
}

variable "aws_zone_id" {
  description = "route53 Hosted Zone ID to manage DNS records in."
  default     = "Z3TH0HRSNU67AM"
}

variable "domain_name" {
  description = "DNS domain name to use when creating route53 records."
  default     = "lsst.codes"
}

# remove "<env>-" prefix for production
data "template_file" "dns_prefix" {
  template = "${replace("${var.env_name}-", "prod-", "")}"
}

variable "grafana_oauth_client_id" {
  description = "github oauth Client ID for grafana"
}

variable "grafana_oauth_client_secret" {
  description = "github oauth Client Secret for grafana."
}

locals {
  dns_prefix                  = "${data.template_file.dns_prefix.rendered}"
  prometheus_k8s_namespace    = "prometheus"
  kafka_k8s_namespace         = "kafka"
  grafana_k8s_namespace       = "grafana"
  nginx_ingress_k8s_namespace = "nginx-ingress"
}
