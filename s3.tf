resource "aws_s3_bucket" "cc2017bucket" {
  bucket = "cc2017tdd"
  acl    = "private"

  tags {
    Name        = "CC2017Bucket"
  }
}