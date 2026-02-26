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

module "dns_peer_testevan_to_hub_storageapi" {
  source = "../../modules/dns"

  project_id  = var.host_project_id
  name        = "peer-storageapi-to-hub"
  description = "Peering zone so Shared VPC can resolve storageapivia Hub DNS"

  zone_config = {
    domain = "storage.googleapis.com."
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
  source = "../../modules/dns"

  project_id    = var.host_project_id
  name          = "fz-rws-local"
  description   = "Forwarding zone for AD domain rws.local"
  force_destroy = false

  zone_config = {
    domain = "rws.local."

    forwarding = {
      client_networks = [
        module.vpc_main.self_link # Shared VPC HOST network self_link
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

###


#module "dns_googleapis_private_hub" {
# source = "../../modules/dns"
#
# project_id    = "myproject-standalone"
# name          = "pz-googleapis"
# description   = "Private zone override for googleapis.com -> private.googleapis.com (PGA)"
# force_destroy = false

# zone_config = {
#   domain = "googleapis.com."
#
#    private = {
#      client_networks = [
#        module.vpc_main_standalone.self_link
#      ]
#    }
#  }

#  recordsets = {
#    # A records for the PGA VIPs
#    "A private" = {
#      ttl     = 300
#      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
#    }
#
#    # Wildcard all Google APIs to private.googleapis.com
#    "CNAME *" = {
#      ttl     = 300
#      records = ["private.googleapis.com."]
#    }
#  }

#  depends_on = [
#    google_project_service.dns
#  ]
#}

#module "dns_peer_googleapis_to_hub" {
#  source = "../../modules/dns"

#  project_id  = var.host_project_id
#  name        = "peer-googleapis-to-hub"
#  description = "Peering zone so Shared VPC can resolve googleapis.com via Hub DNS"

#  zone_config = {
#    domain = "googleapis.com."
##    peering = {
#      client_networks = [
#        module.vpc_main.self_link
#      ]
#      peer_network = module.vpc_main_standalone.self_link
#    }
#  }

#  recordsets = {}

#  depends_on = [
#    google_project_service.dns2,
#    module.dns_googleapis_private_hub
#    # or module.dns_googleapis_restricted_private_hub if you used restricted
#  ]
#}

resource "google_dns_managed_zone" "pz_storage_googleapis" {
  project    = "myproject-standalone"
  name       = "pz-storage-googleapis"
  dns_name   = "storage.googleapis.com."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.vpc_main_standalone.self_link
    }
  }

  depends_on = [
    google_project_service.dns_standalone
  ]
}

resource "google_dns_record_set" "storage_a_psc" {
  project      = "myproject-standalone"
  managed_zone = google_dns_managed_zone.pz_storage_googleapis.name

  name    = "storage.googleapis.com."
  type    = "A"
  ttl     = 300
  rrdatas = [google_compute_global_address.psc_googleapis_ip.address]
}

resource "google_compute_global_forwarding_rule" "psc_googleapis" {
  project               = "myproject-standalone"
  name                  = "googleapis"
  network               = module.vpc_main_standalone.self_link   # must be self_link
  ip_address            = google_compute_global_address.psc_googleapis_ip.address
  target                = "all-apis"    # or "vpc-sc"
  load_balancing_scheme = ""
}
