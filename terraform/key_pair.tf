/*
 * Code to create key pair for the EC2
 */

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
  key_name   = "fake-video-studio"
  public_key = tls_private_key.example.public_key_openssh
  tags = {
    "Name" = "evgeniia@uni.minerva.edu"
  }
}
