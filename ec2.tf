resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "shubham"
  count = 2
  user_data = "${file("userdata.sh")}"

  tags = {
     Name = "server-${count.index}"
    }
}
