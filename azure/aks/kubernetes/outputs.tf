# Outputs the volume created
output "jenkins_pvc_volume_name" {
  value = "${kubernetes_persistent_volume_claim.jenkinspvc.spec.0.volume_name}"
}
