module "linux_vm_01" {
  source = "../../modules/compute-vm"

  project_id = "pj-serviceproject"
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
      network    = "projects/pj-security/global/networks/vpc-main"
      subnetwork = "projects/pj-security/regions/europe-west2/subnetworks/subnet-test-01"

      nat = false
    }
  ]

  # Optional but recommended
  tags = ["lb-backend"]

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

  project_id = "pj-serviceproject"
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
      network    = "projects/pj-security/global/networks/vpc-main"
      subnetwork = "projects/pj-security/regions/europe-west2/subnetworks/subnet-test-01"

      nat = false
    }
  ]

  # Optional but recommended
  tags = ["lb-backend"]

  service_account = {
    email  = google_service_account.web_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  depends_on = [
    module.vpc_main
  ]

}
