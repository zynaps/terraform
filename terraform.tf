terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "vultr" {
  api_key = var.vultr_api_key
}

variable "vultr_api_key" {}

provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email   = var.cloudflare_email
}

variable "cloudflare_email" {}
variable "cloudflare_api_key" {}
