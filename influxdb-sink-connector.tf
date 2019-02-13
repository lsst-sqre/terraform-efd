resource "kubernetes_deployment" "influxdb-sink-connector" {
  metadata {
    name      = "influxdb-sink-connector"
    namespace = "${local.kafka_k8s_namespace}"
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "influxdb-sink-connector"
      }
    }

    template {
      metadata {
        labels {
          app = "influxdb-sink-connector"
        }
      }

      spec {
        container {
          image             = "lsstsqre/kafka-efd-demo:latest"
          name              = "create-influxdb-sink"
          image_pull_policy = "Always"

          command = ["/bin/sh"]
          args    = ["-c", "kafkaefd admin connectors create influxdb-sink --influxdb https://${local.dns_prefix}influxdb-${var.deploy_name}.${var.domain_name} --database efd --daemon $(kafkaefd admin topics list --inline --filter lsst.sal.*)"]

          env = [{
            name  = "BROKER"
            value = "confluent-cp-kafka-headless.${local.kafka_k8s_namespace}:9092"
          },
            {
              name  = "SCHEMAREGISTRY"
              value = "http://confluent-cp-schema-registry.${local.kafka_k8s_namespace}:8081"
            },
            {
              name  = "KAFKA_CONNECT"
              value = "http://confluent-cp-kafka-connect.${local.kafka_k8s_namespace}:8083"
            },
          ]
        }
      }
    }
  }

  depends_on = [
    "helm_release.confluent",
  ]
}
