terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}

// use provider's creds
provider "yandex" {
  token     = ""
  cloud_id  = ""
  folder_id = ""
  zone      = "ru-central1-a"



// create manager-node
resource "yandex_compute_instance" "vm-1" {
  name                      = "manager"
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ingbofbh3j5h7i8ll"
    }

  }

  network_interface {
    subnet_id = yandex_vpc_subnet.podset.id
    nat       = true

  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_dn4g.pub")}"
  }
}
// create 1st worker

resource "yandex_compute_instance" "vm-2" {
  name                      = "worker-1"
  allow_stopping_for_update = true
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ingbofbh3j5h7i8ll"
    }

  }

  network_interface {
    subnet_id = yandex_vpc_subnet.podset.id
    nat       = true

  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_dn4g.pub")}"
  }
}

resource "yandex_compute_instance" "vm-3" {
  name                      = "worker-2"
  allow_stopping_for_update = true
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ingbofbh3j5h7i8ll"
    }

  }

  network_interface {
    subnet_id = yandex_vpc_subnet.podset.id
    nat       = true

  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_dn4g.pub")}"
  }
}

// network settings

resource "yandex_vpc_network" "set" {
  name = "set"
}

resource "yandex_vpc_subnet" "podset" {
  name           = "podset-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.set.id
  v4_cidr_blocks = ["10.0.0.0/16"]
}
