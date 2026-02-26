resource "google_project_service" "dns" {
  project            = "myproject-standalone"
  provider           = google.standalone
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns2" {
  project            = "myproject-prod-01"
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns_standalone" {
  project            = "myproject-standalone"
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_standalone" {
  project = "myproject-standalone"
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  project = "myproject-prod-01"
  service = "compute.googleapis.com"

  disable_on_destroy = false
}