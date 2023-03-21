output "internal_ip_address_reddit-app" {
  value = "${yandex_compute_instance.app.*.network_interface.0.ip_address}"
}

output "external_ip_address_reddit_app" {
  value = "${yandex_compute_instance.app.*.network_interface.0.nat_ip_address}"
}
