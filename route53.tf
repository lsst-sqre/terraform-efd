resource "aws_route53_record" "kafka_lb0" {
  zone_id = "${var.aws_zone_id}"

  name    = "${local.dns_prefix}efd-kafka0.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${local.confluent_lb0_ip}"]
}

resource "aws_route53_record" "kafka_lb1" {
  zone_id = "${var.aws_zone_id}"

  name    = "${local.dns_prefix}efd-kafka1.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${local.confluent_lb1_ip}"]
}

resource "aws_route53_record" "kafka_lb2" {
  zone_id = "${var.aws_zone_id}"

  name    = "${local.dns_prefix}efd-kafka2.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${local.confluent_lb2_ip}"]
}

resource "aws_route53_record" "grafana" {
  zone_id = "${var.aws_zone_id}"

  name    = "${local.grafana_fqdn}"
  type    = "A"
  ttl     = "300"
  records = ["${local.nginx_ingress_ip}"]
}

resource "aws_route53_record" "prometheus" {
  zone_id = "${var.aws_zone_id}"

  name    = "${local.prometheus_fqdn}"
  type    = "A"
  ttl     = "300"
  records = ["${local.nginx_ingress_ip}"]
}
