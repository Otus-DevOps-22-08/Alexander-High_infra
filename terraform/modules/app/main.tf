resource "yandex_compute_instance" "app" {
  count = var.count_num
  name  = "reddit-app-${count.index}"
  labels = {
    tags = "reddit-app"
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
  }

  }
