terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.17.0, < 8.0.0"
    }
  }
}

provider "google" {
  project = "myproject-prod-01"
}