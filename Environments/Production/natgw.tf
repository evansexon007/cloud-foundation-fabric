module "nat_shared_vpc" {
  source     = "../../modules/net-cloudnat"
  project_id = var.host_project_id
  region     = "europe-west2"
  name       = "nat-europe-west2"
  # Create router automatically
  router_create  = true
  router_network = data.google_compute_network.shared_vpc.name
  # Optional but recommended (internal ASN)
  router_asn = 64514
  type       = "PUBLIC"
  config_source_subnetworks = {
    all = true
  }
  logging_filter = "ERRORS_ONLY"
  endpoint_types = ["ENDPOINT_TYPE_VM"]
}

data "google_compute_network" "shared_vpc" {
  project = var.host_project_id
  name    = "vpc-main"
}