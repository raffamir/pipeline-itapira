data "oci_core_images" "ubuntu" {

  compartment_id = var.compartment_ocid

  operating_system = "Canonical Ubuntu"

  sort_by = "TIMECREATED"

  sort_order = "DESC"
}

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

    source_id = data.oci_core_images.ubuntu.images[2].id
  }

  metadata = {

    ssh_authorized_keys = var.ssh_public_key

    user_data = base64encode(file("${path.module}/cloud.init.sh"))
  }
}

output "vm_id" {
  value = oci_core_instance.wordpress_vm.id
}