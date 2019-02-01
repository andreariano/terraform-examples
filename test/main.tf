module "module1" {
  source = "./module1"
}

module "module2" {
  source = "./module2"

  module1_file_content = "${module.module1.file_content}"
}