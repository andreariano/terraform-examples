
# resource "azurerm_managed_disk" "k8sjenkinsmd" {
#   name                 = "terraformk8sjenkinsmd"
#   location             = "${var.location}"
#   resource_group_name  = "${azurerm_resource_group.k8srg.name}"
#   storage_account_type = "Premium_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "5"

#   tags {
#     environment = "staging"
#   }
# }

# resource "azurerm_storage_account" "k8sjenkinssa" {
#   name                     = "terraformk8sjenkinssa"
#   resource_group_name      = "${azurerm_resource_group.k8srg.name}"
#   location                 = "${var.location}"
#   account_tier             = "Premium"
#   account_replication_type = "LRS"
# }

# resource "azurerm_storage_container" "k8sjenkinssc" {
#   name                  = "terraformsc"
#   resource_group_name   = "${azurerm_resource_group.k8srg.name}"
#   storage_account_name  = "${azurerm_storage_account.k8sjenkinssa.name}"
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "k8sjenkinsblob" {
#   name = "jenkins.vhd"

#   resource_group_name    = "${azurerm_resource_group.k8srg.name}"
#   storage_account_name   = "${azurerm_storage_account.k8sjenkinssa.name}"
#   storage_container_name = "${azurerm_storage_container.k8sjenkinssc.name}"

#   type = "page"
#   size = 5120
# }
