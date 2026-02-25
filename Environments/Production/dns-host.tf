resource "google_dns_policy" "inbound_forwarding" {
  name                      = "dns-inbound-forwarding"
  enable_inbound_forwarding = true
  enable_logging            = true

  networks {
    network_url = module.vpc_main.self_link
  }
 depends_on = [module.vpc_main, google_project_service.dns]
}

resource "google_project_service" "dns" {
  project = "myproject-prod-01"
  service = "dns.googleapis.com"
  disable_on_destroy = false
}