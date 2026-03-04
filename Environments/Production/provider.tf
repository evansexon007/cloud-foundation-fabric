terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.17.0, < 8.0.0"
    }
  }
}

provider "google" {
  project = "pj-security"
}

provider "google" {
  alias   = "standalone"
  project = "pj-hub"
}

provider "google" {
  alias   = "serviceproject"
  project = "pj-serviceproject"
}