resource "aws_route53_record" "kafka_lb0" {
  count   = "${var.dns_enable ? 1 : 0}"
  zone_id = "${var.aws_zone_id}"

  name    = "${local.dns_prefix}efd-kafka0.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${local.confluent_lb0_ip}"]
}

resource "aws_route53_record" "kafka_lb1" {
  count   = "${var.dns_enable ? 1 : 0}"
  zone_id = "${var.aws_zone_id}"

  name    = "${local.dns_prefix}efd-kafka1.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${local.confluent_lb1_ip}"]
}

resource "aws_route53_record" "kafka_lb2" {
  count   = "${var.dns_enable ? 1 : 0}"
  zone_id = "${var.aws_zone_id}"

  name    = "${local.dns_prefix}efd-kafka2.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${local.confluent_lb2_ip}"]
}

resource "aws_route53_record" "grafana" {
  count   = "${var.dns_enable ? 1 : 0}"
  zone_id = "${var.aws_zone_id}"

  name    = "${local.grafana_fqdn}"
  type    = "A"
  ttl     = "60"
  records = ["${local.nginx_ingress_ip}"]
}

resource "aws_route53_record" "prometheus" {
  count   = "${var.dns_enable ? 1 : 0}"
  zone_id = "${var.aws_zone_id}"

  name    = "${local.prometheus_fqdn}"
  type    = "A"
  ttl     = "60"
  records = ["${local.nginx_ingress_ip}"]
}

resource "aws_route53_record" "influxdb" {
  count   = "${var.dns_enable ? 1 : 0}"
  zone_id = "${var.aws_zone_id}"

  name    = "${local.influxdb_fqdn}"
  type    = "A"
  ttl     = "60"
  records = ["${local.nginx_ingress_ip}"]
}
