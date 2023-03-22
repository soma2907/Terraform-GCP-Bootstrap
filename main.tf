# module "gcs_buckets" {
#   source  = "./modules/bucket"
#   project_id  = "module.itcore_project3.id"
#   name   = "terraform-statefile"
#   set_admin_roles = true
#   admins = ["group:foo-admins@example.com"]
#   versioning = {
#     first = true
#   }
#   bucket_admins = {
#     second = "user:spam@example.com,eggs@example.com"
#   }
# }

# module "folders" {
#   source = "../.."

#   parent            = "organizations/${var.org_id}"
#   set_roles         = true
#   all_folder_admins = var.all_folder_admins

#   names = [
#     "gis",
#     "it-shared",
#     "police",
#     "fire",
#     "it-core",
#   ]

#   per_folder_admins = {
#     gis = {
#       members = [
#         "group:test-gcp-developers@test.blueprints.joonix.net"
#       ],
#     },
#     it-shared = {
#       members = [
#         "group:test-gcp-qa@test.blueprints.joonix.net",
#       ],
#     }
#     police = {
#       members = [
#         "group:test-gcp-ops@test.blueprints.joonix.net",
#       ],
#     }
#     fire = {
#       members = [
#         "group:test-gcp-ops@test.blueprints.joonix.net",
#       ],
#     }
#     it-core = {
#       members = [
#         "group:test-gcp-ops@test.blueprints.joonix.net",
#       ],
#     }
#   }
# }


# module "sub_folders1" {
#   source   = "../../"
#   parent   = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 1)].id
#   names    = [ "dev", "uat", "prd"]
# }


# locals {
#   subnet_01 = "${var.network_name}-subnet-01"
#   subnet_02 = "${var.network_name}-subnet-02"
# }

# /******************************************
#   Shared VPC Host Project Creation
#  *****************************************/
# module "itcore_host-project" {
#   source                         = "../../"
#   random_project_id              = true
#   name                           = "dbn-network-host"
#   org_id                         = var.org_id
#   folder_id                      = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 4)].id
#   billing_account                = var.billing_account
#   enable_shared_vpc_host_project = true
#   default_network_tier           = var.default_network_tier

#   activate_apis = [
#     "compute.googleapis.com",
#     "cloudresourcemanager.googleapis.com"
#   ]

# }

# /******************************************
#   Network Creation
#  *****************************************/
# module "vpc" {
#   source  = "terraform-google-modules/network/google"
#   version = "~> 6.0"

#   project_id                             = module.host-project.project_id
#   network_name                           = var.network_name
#   delete_default_internet_gateway_routes = true

#   subnets = [
#     {
#       subnet_name   = local.subnet_01
#       subnet_ip     = "10.10.10.0/24"
#       subnet_region = "us-west1"
#     },
#     {
#       subnet_name           = local.subnet_02
#       subnet_ip             = "10.10.20.0/24"
#       subnet_region         = "us-west1"
#       subnet_private_access = true
#       subnet_flow_logs      = true
#     },
#   ]

#   secondary_ranges = {
#     (local.subnet_01) = [
#       {
#         range_name    = "${local.subnet_01}-01"
#         ip_cidr_range = "192.168.64.0/24"
#       },
#       {
#         range_name    = "${local.subnet_01}-02"
#         ip_cidr_range = "192.168.65.0/24"
#       },
#     ]

#     (local.subnet_02) = [
#       {
#         range_name    = "${local.subnet_02}-01"
#         ip_cidr_range = "192.168.66.0/24"
#       },
#     ]
#   }
# }

# /******************************************
#   Service Project Creation
#  *****************************************/
# module "service-project1" {
#   source = "./modules/svpc_service_project"

#   name              = "dbn-dac-ccai-dev"
#   random_project_id = false

#   org_id          = var.org_id
#   folder_id       = module.sub_folders1[element([ "dev", "uat", "prd"], 0)]
#   billing_account = var.billing_account

#   shared_vpc         = module.host-project.project_id
#   shared_vpc_subnets = module.vpc.subnets_self_links

#   activate_apis = [
#     "compute.googleapis.com",
#     "container.googleapis.com",
#     "dataproc.googleapis.com",
#     "dataflow.googleapis.com",
#   ]

#   disable_services_on_destroy = false
# }

# module "service-project2" {
#   source = "./modules/svpc_service_project"

#   name              = "cbn-dac-docs-dev"
#   random_project_id = false

#   org_id          = var.org_id
#   folder_id       = module.sub_folders1[element([ "dev", "uat", "prd"], 0)]
#   billing_account = var.billing_account

#   shared_vpc         = module.host-project.project_id
#   shared_vpc_subnets = module.vpc.subnets_self_links

#   activate_apis = [
#     "compute.googleapis.com",
#     "container.googleapis.com",
#     "dataproc.googleapis.com",
#     "dataflow.googleapis.com",
#   ]

#   disable_services_on_destroy = false
# }

# module "service-project3" {
#   source = "./modules/svpc_service_project"

#   name              = "dbn-dac-dw-dev"
#   random_project_id = false

#   org_id          = var.org_id
#   folder_id       = module.sub_folders1[element([ "dev", "uat", "prd"], 0)]
#   billing_account = var.billing_account

#   shared_vpc         = module.host-project.project_id
#   shared_vpc_subnets = module.vpc.subnets_self_links

#   activate_apis = [
#     "compute.googleapis.com",
#     "container.googleapis.com",
#     "dataproc.googleapis.com",
#     "dataflow.googleapis.com",
#   ]

#   disable_services_on_destroy = false
# }

# module "service-project4" {
#   source = "./modules/svpc_service_project"

#   name              = "dbn-dac-web-dev"
#   random_project_id = false

#   org_id          = var.org_id
#   folder_id       = module.sub_folders1[element([ "dev", "uat", "prd"], 2)].id
#   billing_account = var.billing_account

#   shared_vpc         = module.host-project.project_id
#   shared_vpc_subnets = module.vpc.subnets_self_links

#   activate_apis = [
#     "compute.googleapis.com",
#     "container.googleapis.com",
#     "dataproc.googleapis.com",
#     "dataflow.googleapis.com",
#   ]

#   disable_services_on_destroy = false
# }


# module "itcore_project1" {
#   source            = "./modules/gsuite_enabled"
#   random_project_id = true
#   name              = "dbn-billing"
#   org_id            = var.org_id
#   billing_account   = var.billing_account
#   folder_id         = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 4)]
# }

# module "itcore_project2" {
#   source            = "./modules/gsuite_enabled"
#   random_project_id = true
#   name              = "dbn-cicd"
#   org_id            = var.org_id
#   billing_account   = var.billing_account
#   folder_id         = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 4)]
# }

# module "itcore_project3" {
#   source            = "./modules/gsuite_enabled"
#   random_project_id = true
#   name              = "dbn-prd-security"
#   org_id            = var.org_id
#   billing_account   = var.billing_account
#   folder_id         = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 4)]
# }

# module "itcore_project4" {
#   source            = "./modules/gsuite_enabled"
#   random_project_id = true
#   name              = "dbn-np-monitor"
#   org_id            = var.org_id
#   billing_account   = var.billing_account
#   folder_id         = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 4)]
# }

# module "itcore_project5" {
#   source            = "./modules/gsuite_enabled"
#   random_project_id = true
#   name              = "dbn-np-security"
#   org_id            = var.org_id
#   billing_account   = var.billing_account
#   folder_id         = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 4)]
# }

# module "itcore_project6" {
#   source            = "./modules/gsuite_enabled"
#   random_project_id = true
#   name              = "dbn-prd-monitor"
#   org_id            = var.org_id
#   billing_account   = var.billing_account
#   folder_id         = module.folders[element([ "gis", "it-shared", "police", "fire", "it-core"], 4)]
# }