resource "yandex_compute_instance" "elastic" {
  name        = "elastic"
  hostname    = "elastic"
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
      # Elasticsearch требует больше места
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_subnet_a.id
    security_group_ids = [yandex_vpc_security_group.elastic_sg.id]
    # Private_net, без внешнего ipишника
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    shell: /bin/bash\n    ssh_authorized_keys:\n      - ${var.ssh_public_key}"
  }
}

output "elastic_internal_ip" {
  value = yandex_compute_instance.elastic.network_interface[0].ip_address
}
