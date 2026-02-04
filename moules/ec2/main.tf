resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "pem_file" {
  filename = "${var.key_name}.pem"
  content  = tls_private_key.key.private_key_pem
}

resource "aws_instance" "ec2" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name

  tags = {
    Name = "Strapi-EC2"
  }
}
