provider "kubernetes" {
  host = "${var.cluster_fqdn}"

  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "jenkinsns" {
  metadata {
    name = "jenkins"
  }
}

# resource "kubernetes_persistent_volume" "jenkinspv" {
#   metadata {
#     name = "jenkins-volume"
#   }

#   spec {
#     capacity {
#       storage = "5Gi"
#     }

#     access_modes = ["ReadWriteOnce"]
#     persistent_volume_reclaim_policy = "Retain"

#     persistent_volume_source {
#       azure_disk {
#         caching_mode  = "None"
#         disk_name     = "jenkins_disk"
#         data_disk_uri = "${var.jenkins_blob_url}"
#       }
#     }
#   }
# }

resource "kubernetes_persistent_volume_claim" "jenkinspvc" {
  metadata {
    name      = "jenkins-volume-claim"
    namespace = "jenkins"
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

  # provisioner "local-exec" {
  #   command = "kubectl patch pv ${kubernetes_persistent_volume_claim.jenkinspvc.spec.0.volume_name} -p '{\"spec\":{\"persistentVolumeReclaimPolicy\":\"Retain\"}}'"
  # }
}

