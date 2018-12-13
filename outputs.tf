output "confluent_lb0" {
  value = "${local.confluent_lb0_ip}"
}

output "confluent_lb1" {
  value = "${local.confluent_lb1_ip}"
}

output "confluent_lb2" {
  value = "${local.confluent_lb2_ip}"
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
