output "lb0" {
  value = "${data.template_file.lb0_ip.rendered}"
}

output "lb1" {
  value = "${data.template_file.lb1_ip.rendered}"
}

output "lb2" {
  value = "${data.template_file.lb2_ip.rendered}"
}
output "json" {
  value = "${module.gke.client_key}"
}

output "nginx_ingress" {
  value = "${data.template_file.nginx_ingress_ip.rendered}"
}
