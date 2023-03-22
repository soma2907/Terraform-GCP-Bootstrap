

terraform {
  backend "gcs" {
    bucket                      = "${bucket}"
    impersonate_service_account = "${sa}"

  }
}
provider "google" {
  impersonate_service_account = "${sa}"
}
provider "google-beta" {
  impersonate_service_account = "${sa}"
}

# end provider.tf for ${name}
