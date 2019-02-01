resource "kubernetes_service" "jenkinsmastersvc" {
  metadata {
    name = "jenkins-service"
    namespace = "${var.jenkins_namespace}"
  }
  spec {
    type = "LoadBalancer"

    port {
      port = 8080
    }

    selector {
      app = "jenkins-app"
    }
  }
}