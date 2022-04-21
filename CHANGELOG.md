# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Changed

- Module now requires `azurerm`-provider version `~>2.99.0`.
- Variable `resource_tags` is now named `tags`.

### Removed

- Variable `inherit_resource_group_tags` has been removed.
- Module provider has been removed.

## [0.0.1] - 2020-01-22

### Added

- Initial iteration of this Terraform module.
- A simple README file.

<!-- Version reference -->

[0.0.1]: https://github.com/RedeployAB/terraform-azurerm-keyvault-acmebot/releases/tag/v0.0.1
