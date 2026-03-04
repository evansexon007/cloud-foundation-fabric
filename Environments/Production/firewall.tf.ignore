module "fw_policy_shared_vpc_admin" {
  source = "../../modules/net-firewall-policy"

  name        = "fw-sharedvpc-admin"
  description = "Shared VPC firewall rules"
  parent_id   = var.host_project_id
  region      = "global"

  attachments = {
    shared-vpc = "https://www.googleapis.com/compute/v1/projects/pj-security-489212/global/networks/vpc-main"
  }

  ingress_rules = {

    #######################################################################
    # SSH via IAP (existing rule)
    #######################################################################
    ssh_from_iap = {
      priority       = 1000
      action         = "allow"
      enable_logging = true
      description    = "IAP TCP forwarding to SSH (tcp/22)"

      target_service_accounts = [google_service_account.web_sa.email]

      match = {
        source_ranges = ["35.235.240.0/20"]
        layer4_configs = [{
          protocol = "tcp"
          ports    = ["22"]
        }]
      }
    }

    #######################################################################
    # External Application Load Balancer - Health Checks
    #######################################################################
    allow_lb_healthchecks = {
      priority       = 1010
      action         = "allow"
      enable_logging = true
      description    = "Allow Google LB health checks to backend VMs (tcp/80)"

      target_service_accounts = [google_service_account.web_sa.email]

      match = {
        source_ranges = [
          "35.191.0.0/16",
          "130.211.0.0/22"
        ]
        layer4_configs = [{
          protocol = "tcp"
          ports    = ["80"]
        }]
      }
    }

    #######################################################################
    # External Application Load Balancer - Proxy Traffic
    #######################################################################
    allow_lb_proxy = {
      priority       = 1020
      action         = "allow"
      enable_logging = true
      description    = "Allow External Application LB proxy traffic (tcp/80)"

      target_service_accounts = [google_service_account.web_sa.email]

      match = {
        source_ranges = [
          "0.0.0.0/0"
        ]
        layer4_configs = [{
          protocol = "tcp"
          ports    = ["80"]
        }]
      }
    }
  }
}