module "fw_policy_shared_vpc_admin" {
  source = "../../modules/net-firewall-policy"

  name        = "fw-sharedvpc-iap-ssh"
  description = "Allow SSH via IAP TCP forwarding to specific VM SA"
  parent_id   = var.host_project_id
  region      = "global"

  attachments = {
    shared-vpc = "https://www.googleapis.com/compute/v1/projects/myproject-prod-01/global/networks/vpc-main"
  }

  ingress_rules = {
    ssh_from_iap = {
      priority       = 1000
      action         = "allow"
      enable_logging = true
      description    = "IAP TCP forwarding to SSH (tcp/22)"

      # keep this tight: only instances using this service account get SSH opened
      target_service_accounts = [google_service_account.web_sa.email]

      match = {
        source_ranges = ["35.235.240.0/20"]
        layer4_configs = [{
          protocol = "tcp"
          ports    = ["22"]
        }]
      }
    }
  }
}