module "ext_lb_app" {
  source     = "../../modules/net-lb-app-ext"
  project_id = "myproject-standalone"
  name       = "app-ext-lb"

  # Define the two unmanaged instance groups already created above:
  group_configs = {
    linux-a = {
      name       = "uig-linux-a"
      project_id = "myproject-testsexon-01"
      zone       = "europe-west2-a"
      instances = [
        "projects/myproject-testsexon-01/zones/europe-west2-a/instances/linux-vm-01"
      ]
      named_ports = { http = 80 }
    }

    linux-b = {
      name       = "uig-linux-b"
      project_id = "myproject-testsexon-01"
      zone       = "europe-west2-b"
      instances = [
        "projects/myproject-testsexon-01/zones/europe-west2-b/instances/linux-vm-02"
      ]
      named_ports = { http = 80 }
    }
  }

  # Create one default backend service pointing at both groups:
  backend_service_configs = {
    default = {
      backends = [
        { backend = "linux-a" },
        { backend = "linux-b" }
      ]
    }
  }
}