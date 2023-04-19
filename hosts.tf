variable "instance_label" {
  type    = list(string)
  default = ["kungfu"]
}

resource "vultr_instance" "min" {
  for_each = { for label in var.instance_label : label => label }

  label    = each.value
  hostname = each.value

  region = "lhr"
  plan   = "vc2-1c-1gb"
  os_id  = "477"

  user_data = file("cloud_init.yml")
}

data "cloudflare_zone" "zynaps" {
  name = "zynaps.ru"
}

resource "cloudflare_record" "zynaps" {
  for_each = vultr_instance.min

  zone_id = data.cloudflare_zone.zynaps.id
  name    = each.value.label
  value   = each.value.main_ip
  type    = "A"
  ttl     = 60
  proxied = false
}
