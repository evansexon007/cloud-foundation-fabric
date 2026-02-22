module "vpc_main" {
  source     = "../../modules/net-vpc"
  project_id = "myproject-prod-01"
  name       = "vpc-main"

  subnets = [
    {
      name          = "subnet-test-01"
      region        = "europe-west2"
      ip_cidr_range = "10.10.0.0/24"
    },
    {
      name          = "subnet-test-02"
      region        = "europe-west2"
      ip_cidr_range = "10.20.0.0/24"
    },
    {
      name          = "subnet-test-03"
      region        = "europe-west2"
      ip_cidr_range = "10.30.0.0/24"
    },

  ]
  depends_on = [
    google_project_service.compute
  ]
  shared_vpc_host = true
  shared_vpc_service_projects = [
    "myproject-testsexon-01"
  ]
}

resource "google_project_service" "compute" {
  project = "myproject-prod-01"
  service = "compute.googleapis.com"

  disable_on_destroy = false
}