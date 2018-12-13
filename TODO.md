minimum-viable-prod
===

- ~~grafana admin teams/orgs~~
- ~~restrict access to tiller from other namespaces~~
    https://engineering.bitnami.com/articles/helm-security.html
- ~~mv tls certs to tg level~~
- ~~prometheus dns record~~
- ~~organize yaml/json data files~~
- ~~always use latest gke version~~

Wishlist
---

- **kafka auth**
- fix helm_release to not show values which may contain secrets
- minikube/etc. testing
- up/down alerts
- fetch secrets from a proper secret store (ie., `value`)
- grafana sql backend other than sqlite
- evaluate grafana sidecar/configmap pattern for dashboards & datasources to
  replace tf grafana provider
- evaluate https://github.com/kubernetes-incubator/external-dns
- evaluate https://github.com/jetstack/cert-manager/
