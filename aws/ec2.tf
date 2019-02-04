resource "aws_instance" "ec2" {
  ami           = "ami-c4f98ed2"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sgroup.id}"]
  subnet_id = "${aws_subnet.snet.id}"
}

resource "aws_eip" "eip" {
  
  instance = "${aws_instance.ec2.id}"
}