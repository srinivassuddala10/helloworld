variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "my_ec2"
  type        = string
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "my_bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project = "HelloWorld"
    Env     = "dev"
  }
}
