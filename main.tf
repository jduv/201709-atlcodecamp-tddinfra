// Set the backend bucket for saving state across
// terraform runs. Annoying to get right so don't
// change it unless you have a very good reason.
terraform {
  backend "s3" {
    bucket = "7f-terraform"
    key    = "tfstate"
    region = "us-east-1"
  }
}

// Basic providers, use profiles to access the
// infrastructure as described in the README
provider "aws" {
  region = "${var.region}"
}
