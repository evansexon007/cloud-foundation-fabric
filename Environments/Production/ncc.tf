# Enable the NCC API in the project where you create the hub/spokes
resource "google_project_service" "ncc" {
  project            = "myproject-standalone"
  service            = "networkconnectivity.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "ncc_prod" {
  project            = "myproject-prod-01"
  service            = "networkconnectivity.googleapis.com"
  disable_on_destroy = false
}

# 1) NCC hub (control plane object)
resource "google_network_connectivity_hub" "hub" {
  project     = "myproject-standalone"
  name        = "ncc-hub"
  description = "NCC hub for inter-VPC connectivity"
  depends_on  = [google_project_service.ncc]
}

resource "google_network_connectivity_spoke" "vpc_main_standalone" {
  project  = "myproject-standalone"
  name     = "vpc_main_standalone"
  location = "global"
  hub      = google_network_connectivity_hub.hub.id

  linked_vpc_network {
    uri = module.vpc_main_standalone.self_link
  }
}

resource "google_network_connectivity_spoke" "spoke_vpc_vpc_main" {
  project  = "myproject-prod-01"
  name     = "vpc_main"
  location = "global"
  hub      = google_network_connectivity_hub.hub.id

  linked_vpc_network {
    uri = module.vpc_main.self_link
  }
  depends_on = [google_project_service.ncc_prod]
}