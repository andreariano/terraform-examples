resource "kubernetes_namespace" "jenkinsns" {
  metadata {
    name = "${var.jenkins_namespace}"
  }
}
