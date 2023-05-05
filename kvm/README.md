# KVM

### One-time setup

You'll need to first install libvirt locally.  Per-distro, this is:

* fedora: `sudo dnf install @virtualization`
* ubuntu: `sudo apt install qemu-kvm libvirt-daemon-system`

and then `sudo adduser $USER libvirt`, and logout/login to reset your session

### Usage

There's a `Makefile` for convenient wrappers around the terraform commands.

`make init` is required to initialize terraform before you can create the host.

`make apply` to have terraform create the host

`make destroy` to have terraform destroy the libvirt host, storage, and network

`make recreate` to recreate the host, for if you wish to reset it or you modified cloud_init

You can ssh to the created host with `ssh rdma@$(terraform output -raw ip)`, with password `rdma`.
