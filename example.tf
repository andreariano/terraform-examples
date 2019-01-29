provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "172.21.0.0/16"
}

resource "aws_subnet" "mysn" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "172.21.0.0/24"
}

resource "aws_security_group" "mysg" {
  vpc_id = "${aws_vpc.myvpc.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = "${aws_vpc.myvpc.id}"
}

resource "aws_route" "myrt" {
  route_table_id         = "${aws_vpc.myvpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.myigw.id}"
}

resource "aws_instance" "myec2" {
  ami           = "ami-c4f98ed2"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.mysg.id}"]
  subnet_id = "${aws_subnet.mysn.id}"
}

resource "aws_eip" "myip" {
  instance = "${aws_instance.myec2.id}"
}

output "ip" {
  value = "${aws_eip.myip.public_ip}"
}
