org_id = "xxxxxxxxxx"
admin_email = ""
billing_account = ""
gcp_region    = "europe-west4"
gcp_auth_file = "./graphite-nectar-373904-c8891bacd5d8.json"
dac_folders = {
  dac-dev = {
    descriptive_name = "dac-dev"
    group_iam = {
      "team-a@gcp-pso-italy.net" = [
        "roles/viewer"
      ]
    }
    impersonation_groups = ["team-a-admins@gcp-pso-italy.net"]
  }
    dac-uat = {
    descriptive_name = "dac-dev"
    group_iam = {
      "team-a@gcp-pso-italy.net" = [
        "roles/viewer"
      ]
    }
    impersonation_groups = ["team-a-admins@gcp-pso-italy.net"]
  }
    dac-prod = {
    descriptive_name = "dac-dev"
    group_iam = {
      "team-a@gcp-pso-italy.net" = [
        "roles/viewer"
      ]
    }
    impersonation_groups = ["team-a-admins@gcp-pso-italy.net"]
  }
}