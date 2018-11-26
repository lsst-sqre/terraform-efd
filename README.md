terraform efd-kafka "top level" deployment
===

[![Build Status](https://travis-ci.org/lsst-sqre/terraform-kafka-demo.png)](https://travis-ci.org/lsst-sqre/terraform-kafka-demo)

Usage
---

This package is intended to be used as a "top level" deployment, rather than as
a general purpose module, and thus declares provider configuration that that
may be inappropriate in a module.

`terragrunt` configuration example:

```terraform
terragrunt = {
  terraform {
    source = "git::git@github.com:jhoblitt/terraform-efd-kafka.git//?ref=master"
  }
}
```

`helm`
---

Note that the `helm` provider is used, which requires an initialized `helm`
repo configuration.

Outputs
---

* `lb0`
* `lb1`
* `lb2`

Name of `load-balancer` service IPs.

See Also
---

* [`terraform`](https://www.terraform.io/)
* [`terragrunt`](https://github.com/gruntwork-io/terragrunt)
