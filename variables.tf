variable "env_name" {
  description = "Name of deployment environment."
}

variable "deploy_name" {
  description = "Name of deployment."
  default     = "efd"
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

variable "tls_crt" {
  description = "wildcard tls certificate."
}

variable "tls_key" {
  description = "wildcard tls private key."
}

variable "dns_enable" {
  description = "create route53 dns records."
  default     = false
}

variable "dns_overwrite" {
  description = "overwrite pre-existing DNS records."
  default     = false
}

locals {
  # remove "<env>-" prefix for production
  dns_prefix = "${replace("${var.env_name}-", "prod-", "")}"

  prometheus_k8s_namespace     = "monitoring"
  kafka_k8s_namespace          = "kafka"
  grafana_k8s_namespace        = "grafana"
  influxdb_k8s_namespace       = "influxdb"
  telegraf_k8s_namespace       = "telegraf"
  nginx_ingress_k8s_namespace  = "nginx-ingress"
  kafka_efd_apps_k8s_namespace = "kafka-efd-apps"
  tls_crt                      = "${var.tls_crt}"
  tls_key                      = "${var.tls_key}"
}

variable "influxdb_admin_user" {
  description = "influxdb admin account name."
  default     = "admin"
}

variable "influxdb_admin_pass" {
  description = "influxdb admin account passphrase."
}

variable "influxdb_disk_size" {
  description = "Disk size for InfluxDB."
  default     = "128Gi"
}

variable "github_user" {
  description = "GitHub username for authenticating to the GitHub API."
}

variable "github_token" {
  description = "GitHub personal access token for authenticating to the GitHub API"
}

variable "brokers_disk_size" {
  description = "Disk size for the cp-kafka brokers."
  default     = "15Gi"
}

variable "zookeeper_data_dir_size" {
  description = "Size for Data dir, where ZooKeeper will store the in-memory database snapshots."
  default     = "15Gi"
}

variable "zookeeper_log_dir_size" {
  description = "Size for data log dir, which is a dedicated log device to be used, and helps avoid competition between logging and snaphots."
  default     = "15Gi"
}

variable "influxdb_telegraf_pass" {
  description = "InfluxDB password for the telegraf user."
}

variable "prometheus_oauth_github_org" {
  description = "limit access to prometheus dashboard to members of this org"
}

variable "prometheus_oauth_client_id" {
  description = "github oauth client id"
}

variable "prometheus_oauth_client_secret" {
  description = "github oauth client secret"
}

variable "storage_class" {
  description = "Storage class to be used for all persistent disks. For a deployment on k3s use 'local-path'."
  default     = "pd-ssd"
}

variable "enable_telegraf_daemonset" {
  description = "If true Telegraf client will run on all nodes. Set false for k3s single node deployment."
  default     = "true"
}
