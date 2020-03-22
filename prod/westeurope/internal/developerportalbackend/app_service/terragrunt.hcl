dependency "resource_group" {
  config_path = "../../resource_group"
}

// Common
dependency "application_insights" {
  config_path = "../../../common/application_insights"
}

dependency "key_vault" {
  config_path = "../../../common/key_vault"
}

dependency "virtual_network" {
  config_path = "../../../common/virtual_network"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_app_service?ref=v0.0.41"
}

inputs = {
  name                = "developerportalbackend"
  resource_group_name = dependency.resource_group.outputs.resource_name

  app_service_plan_info = {
    kind     = "Windows"
    sku_tier = "PremiumV2"
    sku_size = "P1v2"
  }

  app_enabled         = true
  client_cert_enabled = false
  https_only          = false

  application_insights_instrumentation_key = dependency.application_insights.outputs.instrumentation_key

  app_settings = {
    WEBSITE_NODE_DEFAULT_VERSION = "6.11.2"
    WEBSITE_NPM_DEFAULT_VERSION  = "6.1.0"
    WEBSITE_RUN_FROM_PACKAGE     = "1"
    APIM_PRODUCT_NAME            = "io-services-api"
    APIM_USER_GROUPS             = "apilimitedmessagewrite,apiinforead,apimessageread,apilimitedprofileread"
    ARM_APIM                     = "io-p-apim-api"
    ARM_RESOURCE_GROUP           = "io-p-rg-internal"
    USE_SERVICE_PRINCIPAL        = "1"
    CLIENT_NAME                  = "io-p-developer-portal-app"
    LOG_LEVEL                    = "info"
    POLICY_NAME                  = "B2C_1_SignUpIn"
    RESET_PASSWORD_POLICY_NAME   = "B2C_1_PasswordReset"
    POST_LOGIN_URL               = "https://developer.io.italia.it"
    POST_LOGOUT_URL              = "https://developer.io.italia.it"
    REPLY_URL                    = "https://developer.io.italia.it"
    ADMIN_API_URL                = "http://api-internal.io.italia.it"
    TENANT_ID                    = "agidweb.onmicrosoft.com"
  }

  app_settings_secrets = {
    key_vault_id = dependency.key_vault.outputs.id
    map = {
      ADMIN_API_KEY               = "apim-IO-SERVICE-KEY"
      ARM_SUBSCRIPTION_ID         = "devportal-ARM-SUBSCRIPTION-ID"
      ARM_TENANT_ID               = "devportal-ARM-TENANT-ID"
      CLIENT_ID                   = "devportal-CLIENT-ID" 
      CLIENT_SECRET               = "devportal-CLIENT-SECRET"
      COOKIE_IV                   = "devportal-COOKIE-IV"
      COOKIE_KEY                  = "devportal-COOKIE-KEY"
      SERVICE_PRINCIPAL_CLIENT_ID = "devportal-SERVICE-PRINCIPAL-CLIENT-ID"
      SERVICE_PRINCIPAL_SECRET    = "devportal-SERVICE-PRINCIPAL-SECRET"
      SERVICE_PRINCIPAL_TENANT_ID = "devportal-SERVICE-PRINCIPAL-TENANT-ID"
    }
  }

  // TODO: Add ip restriction
  allowed_ips = []

  virtual_network_info = {
    name                  = dependency.virtual_network.outputs.resource_name
    resource_group_name   = dependency.virtual_network.outputs.resource_group_name
    subnet_address_prefix = "10.0.106.0/24"
  }
}
