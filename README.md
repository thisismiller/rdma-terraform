# rdma-terraform

Terraform for creating rdma-enabled hosts for benchmarking experiments in various environments.

`kvm/` -- Uses [libvirt](https://libvirt.org/) (a wrapper around qemu and kvm) and the [libvirt terraform provider](https://registry.terraform.io/providers/multani/libvirt/latest/docs) to create a local VM that supports RMDA via [Soft-RoCE](https://www.roceinitiative.org/software-based-roce-a-new-way-to-experience-rdma/)
