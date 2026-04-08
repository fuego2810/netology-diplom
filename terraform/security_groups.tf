resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol       = "TCP"
    description    = "SSH from internet"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent"
    port           = 10050
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion only"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  ingress {
    protocol       = "TCP"
    description    = "HTTP from ALB and healthcheck"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent"
    port           = 10050
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "zabbix_sg" {
  name       = "zabbix-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  ingress {
    protocol       = "TCP"
    description    = "Zabbix web UI"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    description    = "Zabbix trapper"
    port           = 10051
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "elastic_sg" {
  name       = "elastic-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  ingress {
    protocol       = "TCP"
    description    = "Elasticsearch API"
    port           = 9200
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent"
    port           = 10050
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "kibana_sg" {
  name       = "kibana-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  ingress {
    protocol       = "TCP"
    description    = "Kibana web UI"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent"
    port           = 10050
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "alb_sg" {
  name       = "alb-sg"
  network_id = yandex_vpc_network.diplom_network.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP from internet"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Healthcheck диапазоны Yandex Cloud ALB
  ingress {
    protocol       = "TCP"
    description    = "ALB healthchecks from Yandex ranges"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}






