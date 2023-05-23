variable "accelerator" {
  type    = string
  default = "kvm"
}

variable "disk_size" {
  type    = string
  default = "20G"
}

variable "http_port" {
  type    = number
  default = 8080
}

//TODO add or set ip address
variable "http_bind_address" {
  type    = string
  default = "192.168.122.1"
}

variable "output_directory" {
  type    = string
  default = "build/"
}

variable "vm_cpu" {
  type    = string
  default = "2"
}

variable "vm_description" {
  type    = string
  default = "Ubuntu 22.04.1 LTS Jammy Jellyfish, Arch x86_64"
}

variable "vm_memory" {
  type    = string
  default = "2048"
}

variable "vm_name" {
  type    = string
  default = "ubuntu"
}

variable "vnc_port" {
  type    = number
  default = 5900
}

variable "iso_checksum" {
  type    = string
  default = "file:http://releases.ubuntu.com/22.04/SHA256SUMS"
}

variable "iso_url" {
  type    = string
  default = "http://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
}

variable "qemuargs_device_mac" {
  type    = string
  default = "52:54:00:3b:de:d3"
}

variable "qemuargs_netdev_br" {
  type    = string
  default = "virbr0"
}

//TODO add or set ip address
variable "ssh_host" {
  type    = string
  default = "192.168.122.250"
}

source "qemu" "jammy" {
  accelerator            = "kvm"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://${var.http_bind_address}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
  boot_wait              = "10s"
  disk_cache             = "none"
  disk_interface         = "virtio"
  disk_size              = "${var.disk_size}"
  //disk_image             = true
  format                 = "qcow2"
  headless               = true
  http_bind_address      = "${var.http_bind_address}"
  http_directory         = "http"
  http_port_max          = "${var.http_port}"
  http_port_min          = "${var.http_port}"
  iso_checksum           = "${var.iso_checksum}"
  iso_url                = "${var.iso_url}"
  net_device             = "virtio-net"
  output_directory       = "${var.output_directory}"
  qemu_binary            = "/usr/libexec/qemu-kvm"
  qemuargs               = [
    ["-m", "${var.vm_memory}M"],
    ["-smp", "${var.vm_cpu}"],
    ["-display","none"],
    ["-device","virtio-net,netdev=user.0,mac=${var.qemuargs_device_mac}"],
    ["-netdev","bridge,id=user.0,br=${var.qemuargs_netdev_br}"]
  ]
  shutdown_command       = "sudo shutdown -P now"
  skip_nat_mapping       = true
  host_port_min          = "22"
  host_port_max          = "22"
  ssh_host               = "192.168.122.250"
  ssh_password           = "ubuntu"
  ssh_username           = "ubuntu"
  ssh_wait_timeout       = "45m"
  ssh_timeout            = "45m"
  ssh_port               = "22"
  ssh_handshake_attempts = 500
  vm_name                = "${var.vm_name}"
  vnc_port_max           = "${var.vnc_port}"
  vnc_port_min           = "${var.vnc_port}"
}

build {
  description = "${var.vm_description}"
  sources = ["source.qemu.jammy"]

  //provisioner "shell" {
  //  execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
  //  inline          = ["sudo apt-get update", "sudo apt-get -y install software-properties-common", "sudo apt-add-repository --yes --update ppa:ansible/ansible", "sudo apt update", "sudo apt -y install ansible"]
  //}

  //provisioner "ansible-local" {
  //  playbook_dir  = "ansible"
  //  playbook_file = "ansible/playbook.yml"
  //}

  //provisioner "shell" {
  //  execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
  //  inline          = ["sudo apt -y remove ansible", "sudo apt-get clean", "sudo apt-get -y autoremove --purge"]
  //}

  //post-processor "shell-local" {
  //  environment_vars = ["IMAGE_NAME=${var.name}", "IMAGE_VERSION=${var.version}", "DESTINATION_SERVER=${var.destination_server}"]
  //  script           = "scripts/push-image.sh"
  //}
}
