# Backend Configuration
# https://www.terraform.io/language/settings/backends/configuration

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

}
