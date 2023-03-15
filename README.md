# Terraform modules for Azure resources
The modules are wrappers over `azurerm` provider resources that sets default values for most parameters so that deploying those resources is easier but the devs still have enough flexibility.
They implement the same parameter structure as the resources so the official documentation can be used for information about how parameters work and how are they called.
They implement a few extra parameters as well with the same purpose of making the usage easier.
Additional usage information and details about the additional parameters and the default values should be found in the README of each module.

Passing blocks as parameters for a module is not possible
```hcl
module "container_app_second_component" {
  source                    = "bcc-code/platform/azure//modules/container_app"
  template { # Not supported by terraform
    # ...
  }
}
```

The blocks should be instead passed as objects
```hcl
module "container_app_second_component" {
  source                    = "bcc-code/platform/azure//modules/container_app"
  template = { # Note the equal
    # ...
  }
}
```

## Documentation
The documentation for this project was automatically generated using `terraform-docs .`.
<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->