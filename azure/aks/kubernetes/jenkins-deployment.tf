resource "kubernetes_deployment" "jenkinsdpl" {
  metadata {
    name      = "jenkins-deployment"
    namespace = "${var.jenkins_namespace}"

    labels {
      app = "jenkins-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "jenkins-app"
      }
    }

    template {
      metadata {
        namespace = "${var.jenkins_namespace}"

        labels {
          app = "jenkins-app"
        }
      }

      spec {
        restart_policy = "Always"

        security_context {
          fs_group    = 1000
          run_as_user = 0
        }

        container {
          name              = "jenkins-app"
          image             = "jenkins/jenkins:2.143"
          image_pull_policy = "IfNotPresent"

          # port = {}

          volume_mount {
            name       = "jenkins-home"
            mount_path = "/var/jenkins_home"
            read_only  = false
          }
        }

        volume {
          name = "jenkins-home"

          persistent_volume_claim {
            claim_name = "jenkins-volume-claim"
          }
        }
      }
    }
  }
}
