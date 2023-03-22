# tfdoc:file:description Billing export project and dataset.

locals {
  # used here for convenience, in organization.tf members are explicit
  billing_ext_admins = [
    local.groups_iam.gcp-billing-admins,
    local.groups_iam.gcp-organization-admins,
    module.automation-tf-bootstrap-sa.iam_email,
    module.automation-tf-resman-sa.iam_email
  ]
  billing_mode = (
    var.billing_account.no_iam
    ? null
    : var.billing_account.is_org_level ? "org" : "resource"
  )
}

# billing account in same org (IAM is in the organization.tf file)

module "billing-export-project" {
  source          = "../modules/project"
  count           = local.billing_mode == "org" ? 1 : 0
  billing_account = var.billing_account.id
  name            = "billing-exp-0"
  parent = coalesce(
    var.project_parent_ids.billing, "organizations/${var.organization.id}"
  )
  prefix = local.prefix
  iam = {
    "roles/owner" = [module.automation-tf-bootstrap-sa.iam_email]
  }
  services = [
    # "cloudresourcemanager.googleapis.com",
    # "iam.googleapis.com",
    # "serviceusage.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "storage.googleapis.com"
  ]
}

module "billing-export-dataset" {
  source        = "../modules/bigquery-dataset"
  count         = local.billing_mode == "org" ? 1 : 0
  project_id    = module.billing-export-project.0.project_id
  id            = "billing_export"
  friendly_name = "Billing export."
  location      = var.locations.bq
}

# standalone billing account

resource "google_billing_account_iam_member" "billing_ext_admin" {
  for_each = toset(
    local.billing_mode == "resource" ? local.billing_ext_admins : []
  )
  billing_account_id = var.billing_account.id
  role               = "roles/billing.admin"
  member             = each.key
}

resource "google_billing_account_iam_member" "billing_ext_cost_manager" {
  for_each = toset(
    local.billing_mode == "resource" ? local.billing_ext_admins : []
  )
  billing_account_id = var.billing_account.id
  role               = "roles/billing.costsManager"
  member             = each.key
}
