# Target Group: список вм, которые балансируем
resource "yandex_alb_target_group" "web_tg" {
  name = "web-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private_subnet_a.id
    ip_address = yandex_compute_instance.web1.network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.private_subnet_b.id
    ip_address = yandex_compute_instance.web2.network_interface[0].ip_address
  }
}

# Backend Group: настройки healthcheck и балансировки
resource "yandex_alb_backend_group" "web_bg" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_tg.id]

    healthcheck {
      timeout             = "5s"
      interval            = "10s"
      healthy_threshold   = 2
      unhealthy_threshold = 3

      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP Router: правила маршрутизации запросов
resource "yandex_alb_http_router" "web_router" {
  name = "web-http-router"
}

resource "yandex_alb_virtual_host" "web_vh" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web_router.id

  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_bg.id
        timeout          = "30s"
      }
    }
  }
}

# Application Load Balancer
resource "yandex_alb_load_balancer" "web_alb" {
  name               = "web-alb"
  network_id         = yandex_vpc_network.diplom_network.id
  security_group_ids = [yandex_vpc_security_group.alb_sg.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public_subnet.id
    }
  }

  listener {
    name = "web-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
}

output "alb_public_ip" {
  value       = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
  description = "Public IP of Application Load Balancer"
}
