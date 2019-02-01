resource "kubernetes_service" "jenkinsagentsvc" {
  metadata {
    name = "jenkins-agent-service"
    namespace = "${var.jenkins_namespace}"
  }
  spec {
    type = "ClusterIP"

    port {
      port = 50000
    }

    selector {
      app = "jenkins-app"
    }
  }
}