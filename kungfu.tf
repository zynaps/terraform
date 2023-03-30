resource "vultr_instance" "kungfu" {
  label    = "kungfu"
  hostname = "kungfu"

  region = "lhr"
  plan   = "vc2-1c-1gb"
  os_id  = "477"

  user_data = file("cloud_init.yml")
}

output "kungfu_output" {
  value = [vultr_instance.kungfu.hostname, vultr_instance.kungfu.main_ip]
}

resource "cloudflare_record" "kungfu" {
  zone_id = data.cloudflare_zone.zynaps.id
  name    = "kungfu"
  value   = vultr_instance.kungfu.main_ip
  type    = "A"
  proxied = false
}
