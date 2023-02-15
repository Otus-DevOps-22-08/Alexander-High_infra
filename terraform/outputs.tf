output "internal_ip_address_reddit-app" {
  value = "${yandex_compute_instance.app.*.network_interface.0.ip_address}"
}

output "external_ip_address_reddit_app" {
  value = "${yandex_compute_instance.app.*.network_interface.0.nat_ip_address}"
}

output "external_ip_address_lb" {
    value = [for s in yandex_lb_network_load_balancer.lb.listener: s.external_address_spec.*.address].0
}
