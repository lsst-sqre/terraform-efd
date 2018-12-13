terraform efd-kafka "top level" deployment
===

[![Build Status](https://travis-ci.org/lsst-sqre/terraform-efd-kafka.png)](https://travis-ci.org/lsst-sqre/terraform-efd-kafka)

Usage
---

This package is intended to be used as a "top level" deployment, rather than as
a general purpose module, and thus declares provider configuration that that
may be inappropriate in a module.

`terragrunt` configuration example:

```terraform
terragrunt = {
  terraform {
    source = "git::git@github.com:lsst-sqre/terraform-efd-kafka.git//?ref=master"
  }
}
```

`helm`
---

Note that the `helm` provider is used, which requires an initialized `helm`
repo configuration.

Outputs
---

`load-balancer` service IPs.

* `confluent_lb0`
* `confluent_lb1`
* `confluent_lb2`

* `nginx_ingress_ip`
* `grafana_fqdn`
* `prometheus_fqdn`

See Also
---

* [`terraform`](https://www.terraform.io/)
* [`terragrunt`](https://github.com/gruntwork-io/terragrunt)
