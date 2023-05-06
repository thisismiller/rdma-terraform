resource "libvirt_pool" "benchmark" {
  name = "benchmark"
  type = "dir"
  path = "~/libvirt/benchmark"
}

resource "libvirt_volume" "fedora38-qcow2" {
  count = 2

  name   = "fedora38-${count.index}.qcow2"
  pool   = libvirt_pool.benchmark.name
  source = "./images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2"
  format = "qcow2"
}

# get user data info
data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.yaml")}"
}

# Use CloudInit to add the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit.iso"
  pool = libvirt_pool.benchmark.name
  user_data      = "${data.template_file.user_data.rendered}"
}

resource "libvirt_network" "benchmark" {
  name = "benchmark_net"
  mode = "nat"
  domain = "local"
  addresses = ["10.0.0.0/24"]

  dns {
    enabled = true
    local_only = true
  }

  dhcp {
    enabled = true
  }
}

# Define KVM domain to create
resource "libvirt_domain" "fedora38" {
  count = 2

  name   = "fedora38-${count.index}"
  memory = "2048"
  vcpu   = 1

  network_interface {
    network_id = libvirt_network.benchmark.id
    hostname = "virt${count.index}"
    wait_for_lease = true
  }

  disk {
    volume_id = "${element(libvirt_volume.fedora38-qcow2.*.id, count.index)}"
  }

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "0"
  }

  provisioner "remote-exec" {
    inline = ["cloud-init status --wait >/dev/null"]

    connection {
      type = "ssh"
      user = "rdma"
      password = "rdma"
      host = self.network_interface.0.addresses.0
    }
  }
}

# Output Server IP
output "ips" {
  value = libvirt_domain.fedora38.*.network_interface.0.addresses.0
}
output "ip0" {
  value = libvirt_domain.fedora38.0.network_interface.0.addresses.0
}
output "ip1" {
  value = libvirt_domain.fedora38.1.network_interface.0.addresses.0
}
