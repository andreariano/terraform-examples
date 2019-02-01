variable "fileContent" {
  default = "module1"
}

resource "local_file" "module1" {
  content  = "${var.fileContent}"
  filename = "./module1.txt"
}

output "file_content" {
  value = "${var.fileContent}"
}
