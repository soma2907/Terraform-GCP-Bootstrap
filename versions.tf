terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.45, < 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-folders/v3.1.0"
  }
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region
}
provider "google-beta" {
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region
}

terraform {
  backend "gcs" {
    bucket  = "terraform-statefile"
    prefix  = "terraform/state"
  }
}

provider "gsuite" {
  impersonated_user_email = var.admin_email

  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/admin.directory.group.member",
  ]
}