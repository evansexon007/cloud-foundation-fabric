module "linux_vm_01" {
  source = "../../modules/compute-vm" # adjust if path differs

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
}