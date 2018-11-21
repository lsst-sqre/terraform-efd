resource "aws_route53_record" "lb0" {
  zone_id = "${var.aws_zone_id}"

  name    = "${data.template_file.fqdn.rendered}"
  type    = "A"
  ttl     = "300"
  records = ["${data.template_file.lb0_ip.rendered}"]
}

resource "aws_route53_record" "lb1" {
  zone_id = "${var.aws_zone_id}"

  name    = "${data.template_file.fqdn.rendered}"
  type    = "A"
  ttl     = "300"
  records = ["${data.template_file.lb1_ip.rendered}"]
}

resource "aws_route53_record" "lb2" {
  zone_id = "${var.aws_zone_id}"

  name    = "${data.template_file.fqdn.rendered}"
  type    = "A"
  ttl     = "300"
  records = ["${data.template_file.lb1_ip.rendered}"]
}
