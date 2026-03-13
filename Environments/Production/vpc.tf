module "vpc_main" {
  source     = "../../modules/net-vpc"
  project_id = var.host_project_id
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
    var.service_project_id
  ]
}



module "vpc_main_standalone" {
  source     = "../../modules/net-vpc"
  project_id = var.standalone_service_project_id
  name       = "vpc-hub"

  subnets = [
    {
      name          = "subnet-hub-01"
      region        = "europe-west2"
      ip_cidr_range = "10.210.0.0/24"
    },
    {
      name          = "subnet-hub-02"
      region        = "europe-west2"
      ip_cidr_range = "10.220.0.0/24"
    }


  ]
  depends_on = [
    google_project_service.compute_standalone
  ]
  shared_vpc_host = false
  shared_vpc_service_projects = [
  ]
}



resource "google_compute_global_address" "psc_googleapis_ip" {
  project      = var.standalone_service_project_id
  name         = "psc-googleapis-ip"
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = module.vpc_main_standalone.self_link

  address = "10.250.0.10"

  depends_on = [
  ]
}