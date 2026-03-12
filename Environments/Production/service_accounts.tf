
### service accounts

resource "google_service_account" "web_sa" {
  account_id   = "sa-web"
  provider     = google.serviceproject
  display_name = "Web server service account"
}