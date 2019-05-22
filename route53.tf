resource "aws_route53_record" "kafka_lb" {
  count           = "${var.dns_enable ? var.kafka_loadbalancers : 0}"
  zone_id         = "${var.aws_zone_id}"
  allow_overwrite = "${var.dns_overwrite}"

  name    = "${local.dns_prefix}${var.deploy_name}${count.index}.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${element(local.confluent_lb_ips, count.index)}"]
}

resource "aws_route53_record" "grafana" {
  count           = "${var.dns_enable ? 1 : 0}"
  zone_id         = "${var.aws_zone_id}"
  allow_overwrite = "${var.dns_overwrite}"

  name    = "${local.grafana_fqdn}"
  type    = "A"
  ttl     = "60"
  records = ["${local.nginx_ingress_ip}"]
}

resource "aws_route53_record" "prometheus" {
  count           = "${var.dns_enable ? 1 : 0}"
  zone_id         = "${var.aws_zone_id}"
  allow_overwrite = "${var.dns_overwrite}"

  name    = "${local.prometheus_fqdn}"
  type    = "A"
  ttl     = "60"
  records = ["${local.nginx_ingress_ip}"]
}

resource "aws_route53_record" "influxdb" {
  count           = "${var.dns_enable ? 1 : 0}"
  zone_id         = "${var.aws_zone_id}"
  allow_overwrite = "${var.dns_overwrite}"

  name    = "${local.influxdb_fqdn}"
  type    = "A"
  ttl     = "60"
  records = ["${local.nginx_ingress_ip}"]
}
