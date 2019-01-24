provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "consul" {
  source = "hashicorp/consul/aws"

  num_servers = "3"
}