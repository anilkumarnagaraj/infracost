provider "google" {
  credentials = "{\"type\":\"service_account\"}"
  region      = "us-central1"
}

resource "google_compute_forwarding_rule" "default" {
  name = "website-forwarding-rule"
}
