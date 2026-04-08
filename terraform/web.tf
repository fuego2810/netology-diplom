resource "yandex_compute_instance" "web1" {
  name        = "web1"
  hostname    = "web1"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = false
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_subnet_a.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
    # nat = false — нет внешнего IP, выход через NAT-шлюз
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    shell: /bin/bash\n    ssh_authorized_keys:\n      - ${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "web2" {
  name        = "web2"
  hostname    = "web2"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = false
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_subnet_b.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    shell: /bin/bash\n    ssh_authorized_keys:\n      - ${var.ssh_public_key}"
  }
}

output "web1_internal_ip" {
  value = yandex_compute_instance.web1.network_interface[0].ip_address
}

output "web2_internal_ip" {
  value = yandex_compute_instance.web2.network_interface[0].ip_address
}
