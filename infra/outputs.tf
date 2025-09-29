output "s3_bucket_name" {
  description = "my_bucket"
  value       = aws_s3_bucket.my_bucket.id
}

output "ec2_public_ip" {
  description = "13.127.229.15"
  value       = aws_instance.my_ec2.public_ip
}

output "ec2_instance_id" {
  description = "i-0ac7368236c161bgh"
  value       = aws_instance.my_ec2.id
}
