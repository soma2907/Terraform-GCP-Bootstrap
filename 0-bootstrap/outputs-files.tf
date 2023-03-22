

resource "local_file" "providers" {
  for_each        = var.outputs_location == null ? {} : local.providers
  file_permission = "0644"
  filename        = "${try(pathexpand(var.outputs_location), "")}/providers/${each.key}-providers.tf"
  content         = try(each.value, null)
}

resource "local_file" "tfvars" {
  for_each        = var.outputs_location == null ? {} : { 1 = 1 }
  file_permission = "0644"
  filename        = "${try(pathexpand(var.outputs_location), "")}/tfvars/0-bootstrap.auto.tfvars.json"
  content         = jsonencode(local.tfvars)
}

resource "local_file" "tfvars_globals" {
  for_each        = var.outputs_location == null ? {} : { 1 = 1 }
  file_permission = "0644"
  filename        = "${try(pathexpand(var.outputs_location), "")}/tfvars/globals.auto.tfvars.json"
  content         = jsonencode(local.tfvars_globals)
}

resource "local_file" "workflows" {
  for_each        = var.outputs_location == null ? {} : local.cicd_workflows
  file_permission = "0644"
  filename        = "${try(pathexpand(var.outputs_location), "")}/workflows/${each.key}-workflow.yaml"
  content         = try(each.value, null)
}
