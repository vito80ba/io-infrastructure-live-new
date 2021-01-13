# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_resource_group?ref=v2.1.25"
}

inputs = {
  resource_group_name = "io-infra-rg"
}