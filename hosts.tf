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

resource "null_resource" "bootstrap" {
  depends_on = [cloudflare_record.zynaps]

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "sleep 60 && ansible-playbook bootstrap.yml dotfiles.yml --limit=${join(",", [for instance in vultr_instance.min : instance.label])}"
  }
}

resource "null_resource" "setup" {
  depends_on = [null_resource.bootstrap]

  for_each = vultr_instance.min

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "ansible-playbook ${each.value.label}.yml --limit=${each.value.label}"
  }
}
