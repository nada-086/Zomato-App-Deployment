# resource "aws_s3_bucket" "backend_bucket" {
#   bucket = "zomato-app-backend-bucket"

#   tags = {
#     Name = "Backend Bucket"
#   }
# }

# terraform {
#   backend "s3" {
#     bucket = "zomato-app-backend-bucket"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }