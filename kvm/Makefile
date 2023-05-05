.PHONY: init apply destroy recreate

init:
	terraform init

images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2:
	( cd images; ./download_images.sh )

apply: images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve

# Destroys all data.
# Required for cloud_init.yaml changes to be picked up and applied.
recreate:
	terraform apply -auto-approve -replace libvirt_cloudinit_disk.commoninit -replace libvirt_domain.fedora38 -replace libvirt_volume.fedora38-qcow2
