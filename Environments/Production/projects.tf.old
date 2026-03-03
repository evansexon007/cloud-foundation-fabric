module "project_test" {
  source = "../../modules/project"

  name                = "testsexon-01"
  prefix              = "myproject"
  parent              = "organizations/${var.org_id}"
  billing_account     = var.billing_account
  auto_create_network = false

  services = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}