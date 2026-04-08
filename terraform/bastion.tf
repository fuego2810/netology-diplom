resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  allow_stopping_for_update = true

  # Мин-ая конфигурация
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  # Прерываемая ВМ (уже нет)
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
    subnet_id          = yandex_vpc_subnet.public_subnet.id
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
    # Публичный IP — для доступа снаружи
    nat = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    shell: /bin/bash\n    ssh_authorized_keys:\n      - ${var.ssh_public_key}"
  }
}

output "bastion_public_ip" {
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  description = "Public IP of bastion host"
}

output "bastion_internal_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].ip_address
}
