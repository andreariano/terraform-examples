variable "module1_file_content" {
  default = ""
}

resource "local_file" "module2" {
  content = "${var.module1_file_content}"
  filename = "./module2.txt"
}