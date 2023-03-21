output "internal_ip_address_reddit-db" {
  value = "${yandex_compute_instance.db.*.network_interface.0.ip_address}"
}

output "external_ip_address_reddit_db" {
  value = "${yandex_compute_instance.db.*.network_interface.0.nat_ip_address}"
}
