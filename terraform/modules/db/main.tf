terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
resource "yandex_compute_instance" "db" {
  count = var.count_num
  name  = "reddit-db-${count.index}"
  labels = {
    tags = "reddit-db"
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  connection {
  type  = "ssh"
  host  = self.network_interface.0.nat_ip_address
  user  = "ubuntu"
  agent = false
  # путь до приватного ключа
  private_key = file(var.private_key_path)
  }
}
