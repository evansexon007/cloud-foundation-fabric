resource "google_project_service" "dns" {
  project            = "pj-hub"
  provider           = google.standalone
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns2" {
  project            = "pj-security"
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns_standalone" {
  project            = "pj-hub"
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_standalone" {
  project = "pj-hub"
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  project = "pj-security"
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

# Enable the NCC API in the project where you create the hub/spokes
resource "google_project_service" "ncc" {
  project            = "pj-hub"
  service            = "networkconnectivity.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "ncc_prod" {
  project            = "pj-security"
  service            = "networkconnectivity.googleapis.com"
  disable_on_destroy = false
}