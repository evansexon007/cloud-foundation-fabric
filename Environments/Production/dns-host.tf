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

module "dns_test_evancloud_private" {
  source = "../../modules/dns"

  project_id    = "myproject-prod-01"
  name          = "pz-test-evancloud-co-uk"
  description   = "Private zone for test.evancloud.co.uk"
  force_destroy = true

  zone_config = {
    domain = "test.evancloud.co.uk."

    private = {
      client_networks = [
        module.vpc_hub.self_link
      ]
    }
  }

  recordsets = {

    "A app" = {
      ttl     = 300
      records = ["10.100.10.5"]
    }

    "A api" = {
      ttl     = 300
      records = ["10.100.10.6"]
    }

    "CNAME www" = {
      ttl     = 300
      records = ["app.test.evancloud.co.uk."]
    }
  }
}