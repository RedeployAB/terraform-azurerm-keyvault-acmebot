> **Note**
>
> This module has been deprecated in favor of the [official Terraform module](https://registry.terraform.io/modules/shibayan/keyvault-acmebot/azurerm/latest).

# Terraform Key Vault Acmebot

Terraform module of [@shibayan](https://github.com/shibayan)'s automated ACME issuer [Key Vault Acmebot](https://github.com/shibayan/keyvault-acmebot).

The module can be used to automate issuing of certificates, integrating with many Azure services via Key Vault.

For details about how to use the application itself, see the [original project](https://github.com/shibayan/keyvault-acmebot#usage).

## Quick start

```bash
RESOURCE_GROUP_NAME=<your_existing_resource_group>
ACME_MAIL_ADDRESS=<acme_email_contact>

terraform init
terraform apply -var "resource_group_name=$RESOURCE_GROUP_NAME" -var "acme_mail_address=$ACME_MAIL_ADDRESS"
```

For a complete list of the supported parameters, see [`variables.tf`](./variables.tf).

## Prerequisites

* A resource group where you have Owner access.
* Permission to create app registrations in Azure AD.
* User Access Administrator access for the DNS zones you want to manage with Key Vault Acmebot (Optional).

## Constraints

* Only AzureCloud environments are supported.
* Only Azure DNS Zones within the same subscription are supported.
* Can't be used with an existing Key Vault.

## License

This module is licensed under [Apache License 2.0](./LICENSE).
