resource "kubernetes_persistent_volume_claim" "jenkinspvc" {
  metadata {
    name      = "jenkins-volume-claim"
    namespace = "${var.jenkins_namespace}"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "5Gi"
      }
    }

    storage_class_name = "managed-premium"
  }
}

