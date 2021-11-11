/*
  DEPRECATED !!!
  Use instead: https://github.com/pagopa/io-infra
*/

# Common
dependency "virtual_network" {
  config_path = "../../../../common/virtual_network"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_subnet?ref=v4.0.1"
}

inputs = {
  name = "apimapi"

  resource_group_name  = dependency.virtual_network.outputs.resource_group_name
  virtual_network_name = dependency.virtual_network.outputs.resource_name
  address_prefix       = "10.0.101.0/24"

  service_endpoints = [
    "Microsoft.Web"
  ]
}
