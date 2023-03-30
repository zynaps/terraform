terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }

    vultr = {
      source = "vultr/vultr"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

variable "cloudflare_email" {}
variable "cloudflare_api_key" {}

data "cloudflare_zone" "zynaps" {
  name = "zynaps.ru"
}

provider "vultr" {
  api_key = var.vultr_api_key
}

variable "vultr_api_key" {}
