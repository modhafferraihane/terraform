terraform {
  backend "s3" {
    bucket       = "opsforalls3"
    key          = "terraform/state.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
} 