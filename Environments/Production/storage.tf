module "gcs_bucket" {
  source = "../../modules/gcs"

  bucket_create = true
  project_id    = var.service_project_id
  location      = "europe-west2-a"
  prefix        = "evancloud"
  name          = "tf-state"

  storage_class = "STANDARD"

  # Recommended defaults
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  versioning                  = true
  force_destroy               = false

  labels = {
    owner = "platform"
    env   = "prod"
    app   = "terraform"
  }

  # Simple lifecycle example (optional)
  lifecycle_rules = {
    delete_noncurrent_after_30d = {
      action = {
        type = "Delete"
      }
      condition = {
        days_since_noncurrent_time = 30
        with_state                 = "ARCHIVED"
      }
    }
  }
}