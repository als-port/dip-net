//resource "aws_s3_bucket" "s3buck" {
//  bucket = "s3buck051121"
//  acl    = "private"
//}
//
//resource "aws_dynamodb_table" "terraform_locks" {
//    name = "db_terraform_locks"
//    billing_mode     = "PROVISIONED"
//    read_capacity    = 1
//    write_capacity   = 1
//    hash_key = "LockID"
//
//    attribute {
//        name = "LockID"
//        type = "S"
//    }
//}


terraform {
  backend "s3" {
    bucket         = "s3buck051121"
    key            = "main-infra/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "db_terraform_locks"

  }
}

