module "linux_vm_01" {
  source = "../../modules/compute-vm"

  project_id = "myproject-testsexon-01"
  name       = "linux-vm-01"
  zone       = "europe-west2-a"

  # Small machine
  instance_type = "e2-micro"

  # Boot disk (Debian)
  boot_disk = {
    initialize_params = {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 10
      type  = "pd-balanced"
    }
  }

  # Attach to your subnet
  network_interfaces = [
    {
      # ✅ Shared VPC: use SELF LINKS owned by HOST project
      network    = "projects/myproject-prod-01/global/networks/vpc-main"
      subnetwork = "projects/myproject-prod-01/regions/europe-west2/subnetworks/subnet-test-01"

      nat = true
    }
  ]

  # Optional but recommended
  tags = ["linux", "ssh"]

  service_account = {
    email  = google_service_account.web_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  depends_on = [
    module.vpc_main
  ]

}

module "linux_vm_02" {
  source = "../../modules/compute-vm"

  project_id = "myproject-testsexon-01"
  name       = "linux-vm-02"
  zone       = "europe-west2-b"

  # Small machine
  instance_type = "e2-micro"

  # Boot disk (Debian)
  boot_disk = {
    initialize_params = {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 10
      type  = "pd-balanced"
    }
  }

  # Attach to your subnet
  network_interfaces = [
    {
      # ✅ Shared VPC: use SELF LINKS owned by HOST project
      network    = "projects/myproject-prod-01/global/networks/vpc-main"
      subnetwork = "projects/myproject-prod-01/regions/europe-west2/subnetworks/subnet-test-01"

      nat = true
    }
  ]

  # Optional but recommended
  tags = ["linux", "ssh"]

  service_account = {
    email  = google_service_account.web_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  depends_on = [
    module.vpc_main
  ]

}

####


###############################################################################
# Unmanaged Instance Group (UIG) - Zone europe-west2-a (contains linux-vm-01)
###############################################################################
resource "google_compute_instance_group" "uig_linux_a" {
  project = "myproject-testsexon-01"
  name    = "uig-linux-a"
  zone    = "europe-west2-a"

  # Add VM1 (must be in the same zone)
  instances = [
    "projects/myproject-testsexon-01/zones/europe-west2-a/instances/linux-vm-01"
  ]

  # Optional but recommended for LB backend services (port_name must match)
  named_port {
    name = "http"
    port = 80
  }

  # Optional: set the network self link (Shared VPC host project)
  network = "projects/myproject-prod-01/global/networks/vpc-main"
}

###############################################################################
# Unmanaged Instance Group (UIG) - Zone europe-west2-b (contains linux-vm-02)
###############################################################################
resource "google_compute_instance_group" "uig_linux_b" {
  project = "myproject-testsexon-01"
  name    = "uig-linux-b"
  zone    = "europe-west2-b"

  # Add VM2 (must be in the same zone)
  instances = [
    "projects/myproject-testsexon-01/zones/europe-west2-b/instances/linux-vm-02"
  ]

  named_port {
    name = "http"
    port = 80
  }

  network = "projects/myproject-prod-01/global/networks/vpc-main"
}

###############################################################################
# Outputs (handy for wiring into a backend_service)
###############################################################################
output "uig_linux_a_self_link" {
  value = google_compute_instance_group.uig_linux_a.self_link
}

output "uig_linux_b_self_link" {
  value = google_compute_instance_group.uig_linux_b.self_link
}