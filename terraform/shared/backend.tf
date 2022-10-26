terraform {
  backend "s3" {
    bucket         = "fake-video-studio"
    key            = "shared/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = false
    dynamodb_table = "fake-video-studio-db"
  }
}
