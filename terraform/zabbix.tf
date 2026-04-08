resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
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
    subnet_id          = yandex_vpc_subnet.public_subnet.id
    security_group_ids = [yandex_vpc_security_group.zabbix_sg.id]
    nat = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    shell: /bin/bash\n    ssh_authorized_keys:\n      - ${var.ssh_public_key}"
  }
}

output "zabbix_public_ip" {
  value = yandex_compute_instance.zabbix.network_interface[0].nat_ip_address
}
