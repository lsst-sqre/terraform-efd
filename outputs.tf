output "confluent_lb_ips" {
  value = "${local.confluent_lb_ips}"
}

output "nginx_ingress_ip" {
  value = "${local.nginx_ingress_ip}"
}

output "grafana_fqdn" {
  value = "${local.grafana_fqdn}"
}

output "prometheus_fqdn" {
  value = "${local.prometheus_fqdn}"
}

output "influxdb_fqdn" {
  value = "${local.influxdb_fqdn}"
}
