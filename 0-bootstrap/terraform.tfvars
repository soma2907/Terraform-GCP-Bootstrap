# use `gcloud beta billing accounts list`
# if you have too many accounts, check the Cloud Console :)
billing_account = {
  id = "012345-67890A-BCDEF0"
}

# use `gcloud organizations list`
organization = {
  domain      = "example.org"
  id          = 1234567890
  customer_id = "C000001"
}

outputs_location = "~/fast-config"

# use something unique and no longer than 9 characters
prefix = "dac"

