variable "aws_region" {
  type        = string
  description = "Region to use"
  default     = "us-west-2"
}

variable "aws_access_key_id" {
  type        = string
  default     = "AKIAYMT4DKDEKEUPBXXH"
}

variable "aws_secret_access_key" {
  type        = string
  default     = "LfT95SO7VERzuYMQ+zy/isu1QkSREJUqSLYKDXwe"
}

variable "aws_zones" {
  type        = list(string)
  description = "List of availability zones to use"
  default     = ["us-west-2a", "us-west-2b"]
}


/*
variable "cloudflare_account_id" {
  type        = string
}

variable "cloudflare_domain" {
  type        = string
  default     = "evgeniia-cloud-tutorial.site"
}

variable "cloudflare_key" {
  type        = string
}
*/