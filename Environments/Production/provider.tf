terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.17.0, < 8.0.0"
    }
  }
}

provider "google" {
  project = "pj-security-489212"
}

provider "google" {
  alias   = "standalone"
  project = "project-b73220da-bbd3-45c3-89d"
}

provider "google" {
  alias   = "serviceproject"
  project = "pf-serviceproject"
}