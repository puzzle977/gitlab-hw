
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}


resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index + 1}"  # Имена: web-1, web-2
  hostname    = "web-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = count.index == 0 ? "ru-central1-a" : "ru-central1-b"  # Первая ВМ в ru-central1-a, вторая в ru-central1-b

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = <<-EOT
      #cloud-config
      packages:
        - nginx
      runcmd:
        - systemctl start nginx
        - systemctl enable nginx
      users:
        - name: user
          groups: sudo
          shell: /bin/bash
          sudo: ["ALL=(ALL) NOPASSWD:ALL"]
          ssh_authorized_keys:
            - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtcRfpq0ktKOgzP5/3hpV5a/LdZr3L72hvm1oOPMcjn lama@ubuntu
    EOT
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = count.index == 0 ? yandex_vpc_subnet.develop_a.id : yandex_vpc_subnet.develop_b.id  # Подсети из исходного файла
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  }
}


resource "yandex_lb_target_group" "web_tg" {
  name = "web-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.web
    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}


resource "yandex_lb_network_load_balancer" "web_lb" {
  name = "web-load-balancer"

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80  # Перенаправление трафика на порт 80 ВМ
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_tg.id

    healthcheck {
      name                = "http-healthcheck"
      interval            = 2
      timeout             = 1
      unhealthy_threshold = 2
      healthy_threshold   = 2
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}


output "load_balancer_ip" {
  value = one(flatten([for l in yandex_lb_network_load_balancer.web_lb.listener : [for addr in l.external_address_spec : addr.address if l.name == "http-listener"]]))
}
