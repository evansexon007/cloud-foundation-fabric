resource "google_dns_policy" "inbound_forwarding" {
  provider                  = google.standalone
  name                      = "dns-inbound-forwarding"
  enable_inbound_forwarding = true
  enable_logging            = true

  networks {
    network_url = module.vpc_main_standalone.self_link
  }

  depends_on = [
    module.vpc_main_standalone,
    google_project_service.dns
  ]
}

resource "google_project_service" "dns" {
  project = "myproject-standalone"
  provider = google.standalone
  service = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns2" {
  project = "myproject-prod-01"
  service = "dns.googleapis.com"
  disable_on_destroy = false
}

module "dns_test_evancloud_private" {
  source = "../../modules/dns"

  project_id    = "myproject-standalone"
  name          = "pz-test-evancloud-co-uk"
  description   = "Private zone for test.evancloud.co.uk"
  force_destroy = true

  zone_config = {
    domain = "test.evancloud.co.uk."

    private = {
      client_networks = [
        module.vpc_main_standalone.self_link
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

resource "google_project_service" "dns_standalone" {
  project = "myproject-standalone"
  service = "dns.googleapis.com"
  disable_on_destroy = false
}


module "dns_peer_testevan_to_hub" {
  source = "../../modules/dns"

  project_id  = var.host_project_id
  name        = "peer-testevan-to-hub"
  description = "Peering zone so Shared VPC can resolve testevan.co.uk via Hub DNS"

  zone_config = {
    domain = "test.evancloud.co.uk."
    peering = {
      client_networks = [
        module.vpc_main.self_link
      ]
      peer_network = module.vpc_main_standalone.self_link
    }
  }
  depends_on = [
    google_project_service.dns2
  ]
}

## custom forwarders

module "dns_forward_rws_local" {
  source      = "../../modules/dns"

  project_id  = var.host_project_id
  name        = "fz-rws-local"
  description = "Forwarding zone for AD domain rws.local"
  force_destroy = false

  zone_config = {
    domain = "rws.local."

    forwarding = {
      client_networks = [
        module.vpc_main.self_link   # Shared VPC HOST network self_link
      ]

      # map(name => ipv4)
      forwarders = {
        "10.194.22.1" = "private"
        "10.194.22.2" = "private"
      }
    }
  }

  # No recordsets for forwarding zones
  recordsets = {}

  depends_on = [
    google_project_service.dns2
  ]
}