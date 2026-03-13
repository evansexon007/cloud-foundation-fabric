resource "google_project_service" "dns" {
  project            = var.standalone_service_project_id
  provider           = google.standalone
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns2" {
  project            = var.host_project_id
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns_standalone" {
  project            = var.standalone_service_project_id
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_standalone" {
  project = var.standalone_service_project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  project = var.host_project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

# Enable the NCC API in the project where you create the hub/spokes
resource "google_project_service" "ncc" {
  project            = var.standalone_service_project_id
  service            = "networkconnectivity.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "ncc_prod" {
  project            = var.host_project_id
  service            = "networkconnectivity.googleapis.com"
  disable_on_destroy = false
}