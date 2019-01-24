variable "google_project" {
  description = "google cloud project ID"
}

variable "env_name" {
  description = "Name of deployment environment."
}

variable "deploy_name" {
  description = "Name of deployment."
  default     = "efd-kafka"
}

variable "aws_zone_id" {
  description = "route53 Hosted Zone ID to manage DNS records in."
}

variable "domain_name" {
  description = "DNS domain name to use when creating route53 records."
}

variable "grafana_oauth_client_id" {
  description = "github oauth Client ID for grafana"
}

variable "grafana_oauth_client_secret" {
  description = "github oauth Client Secret for grafana."
}

variable "grafana_oauth_team_ids" {
  description = "github team id (integer value treated as string)"
}

variable "grafana_admin_user" {
  description = "grafana admin account name."
  default     = "admin"
}

variable "grafana_admin_pass" {
  description = "grafana admin account passphrase."
}

variable "tls_crt_path" {
  description = "wildcard tls certificate."
}

variable "tls_key_path" {
  description = "wildcard tls private key."
}

variable "dns_enable" {
  description = "create route53 dns records."
  default     = false
}

variable "initial_node_count" {
  description = "number of gke nodes to start"
  default     = 3
}

variable "gke_version" {
  description = "gke master/node version"
  default     = "latest"
}

variable "machine_type" {
  description = "machine type of default gke pool nodes"
  default     = "n1-standard-2"
}

locals {
  # remove "<env>-" prefix for production
  dns_prefix = "${replace("${var.env_name}-", "prod-", "")}"

  # Name of google cloud container cluster to deploy into
  gke_cluster_name = "${var.deploy_name}-${var.env_name}"

  prometheus_k8s_namespace    = "prometheus"
  kafka_k8s_namespace         = "kafka"
  grafana_k8s_namespace       = "grafana"
  influxdb_k8s_namespace       = "influxdb"
  nginx_ingress_k8s_namespace = "nginx-ingress"
  tls_crt                     = "${file(var.tls_crt_path)}"
  tls_key                     = "${file(var.tls_key_path)}"
}

variable "influxdb_admin_user" {
  description = "influxdb admin account name."
  default     = "admin"
}

variable "influxdb_admin_pass" {
  description = "influxdb admin account passphrase."
}
