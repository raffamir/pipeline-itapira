resource "oci_core_instance" "wordpress_vm" {

  availability_domain = "XHPb:SA-SAOPAULO-1-AD-1"

  compartment_id = var.compartment_ocid

  display_name = "wordpress-devops-vm"

  shape = "VM.Standard.E2.1.Micro"

  create_vnic_details {

    subnet_id = var.subnet_ocid

    assign_public_ip = true

    display_name = "wordpress-vnic"
  }

  source_details {

    source_type = "image"

    source_id = "ocid1.image.oc1.***.aaaaaaaakvwmxajgkw5qcdsfyvzrx7q6btz6wz52npxstonpnd3cuxu4p65q"
  }

  metadata = {

    ssh_authorized_keys = var.ssh_public_key

    user_data = base64encode(<<-EOF
#!/bin/bash

fallocate -l 2G /swapfile

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

echo "Cloud Init OK" > /tmp/cloud-init-ok.txt

EOF
    )
  }
}

output "vm_id" {
  value = oci_core_instance.wordpress_vm.id
}