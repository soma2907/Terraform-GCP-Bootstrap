############### top-level folders ###############

module "dac-folder" {
  source = "./modules/folder"
  count  = var.fast_features.teams ? 1 : 0
  parent = "organizations/${var.organization.id}"
  name   = "dac"
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/teams"].id, null
    )
  }
}

module "dac-core-folder" {
  source = "./modules/folder"
  count  = var.fast_features.teams ? 1 : 0
  parent = "organizations/${var.organization.id}"
  name   = "dac-core"
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/teams"].id, null
    )
  }
}

module "dbn-dac-cicd-project" {
  source            = "./modules/gsuite_enabled"
  random_project_id = true
  name              = "dbn-dac-cicd"
  org_id            = var.org_id
  billing_account   = var.billing_account
  folder_id         = module.dac-core-folder.id
}



module "dac-gcs" {
  source        = "./modules/gcs"
  count         = var.fast_features.teams ? 1 : 0
  project_id    = var.automation.project_id
  name          = "prod-resman-teams-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
}

################## SubFolders ##################

module "dac-env-folder" {
  source   = "./modules/folder"
  for_each = var.fast_features.teams ? coalesce(var.team_folders, {}) : {}
  parent   = module.dac-folder.0.id
  name     = each.value.descriptive_name
  group_iam = each.value.group_iam == null ? {} : each.value.group_iam
}

module "dac-team-sa" {
  source       = "./modules/iam-service-account"
  for_each     = var.fast_features.teams ? coalesce(var.team_folders, {}) : {}
  project_id   = module.dbn-dac-cicd-project.id
  name         = "prod-teams-${each.key}-0"
  display_name = "Terraform team ${each.key} service account."
  prefix       = var.prefix
}

module "dac-team-gcs" {
  source        = "./modules/gcs"
  for_each      = var.fast_features.teams ? coalesce(var.team_folders, {}) : {}
  project_id    = var.automation.project_id
  name          = "prod-teams-${each.key}-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
}

# per-team environment folders where project factory SAs can create projects

module "dac-dev-folder" {
  source   = "./modules/folder"
  for_each = var.fast_features.teams ? coalesce(var.team_folders, {}) : {}
  parent   = module.dac-team-folder[each.key].id
  # naming: environment descriptive name
  name = "dac-dev"
  # environment-wide human permissions on the whole teams environment
  tag_bindings = {
    environment = try(
      module.organization.tag_values["${var.tag_names.environment}/development"].id, null
    )
  }
}


module "dac-uat-folder" {
  source   = "./modules/folder"
  for_each = var.fast_features.teams ? coalesce(var.team_folders, {}) : {}
  parent   = module.dac-team-folder[each.key].id
  # naming: environment descriptive name
  name = "dac-uat"
  # environment-wide human permissions on the whole teams environment
  tag_bindings = {
    environment = try(
      module.organization.tag_values["${var.tag_names.environment}/development"].id, null
    )
  }
}


module "dac-prod-folder" {
  source   = "./modules/folder"
  for_each = var.fast_features.teams ? coalesce(var.team_folders, {}) : {}
  parent   = module.dac-team-folder[each.key].id
  # naming: environment descriptive name
  name = "dac-prod"
  # environment-wide human permissions on the whole teams environment
  tag_bindings = {
    environment = try(
      module.organization.tag_values["${var.tag_names.environment}/production"].id, null
    )
  }
}