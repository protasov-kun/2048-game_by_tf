
resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = "fd8c3t86dc563mtmnqce" #Ubuntu 20.04
#  image_id = "fd89lpj26v9fmnhkrq27" #LEMP
}


resource "yandex_compute_instance" "game01" {
  name = "game01"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
#    user-data = "${file("~/linux_game/meta.txt")}"
  }

    provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx"
    ]
  }

    provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y git",
      "git clone https://gitfront.io/r/deusops/JnacRhR4iD8q/2048-game.git"
    ]
  }

    provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y npm"
    ]
  }  

   provisioner "remote-exec" {
    inline = [
      "curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -",
#      "deb https://deb.nodesource.com/node_16.x focal main",
#      "deb-src https://deb.nodesource.com/node_16.x focal main"
    ]
  } 

    provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y nodejs"
    ]
  }       

    provisioner "remote-exec" {
    inline = [
      "cd ~/2048-game/",
      "npm install --include=dev"
    ]
  }

    provisioner "remote-exec" {
    inline = [
      "cd ~/2048-game/",
      "npm audit fix"
    ]
  }

    provisioner "remote-exec" {
    inline = [
      "cd ~/2048-game/",
      "npm run build" 
    ]
  }

    provisioner "remote-exec" {
    inline = [
      "cd ~/2048-game/",
      "npm start" 
    ]
  }
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_ed25519")}"
    host        = yandex_compute_instance.game01.network_interface.0.nat_ip_address
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_game01" {
  value = yandex_compute_instance.game01.network_interface.0.ip_address
}


output "external_ip_address_game01" {
  value = yandex_compute_instance.game01.network_interface.0.nat_ip_address
}