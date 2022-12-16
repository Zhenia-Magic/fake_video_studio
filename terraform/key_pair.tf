/*
 * Code to create key pair for the EC2
 */

resource "aws_key_pair" "default" {
  key_name   = "fake-video-studio"
  public_key = "your_public_key"

  tags = {
    "Name" = "evgeniia@uni.minerva.edu"
  }
}
