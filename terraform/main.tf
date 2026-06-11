resource "oci_core_vcn" "devops_vcn" {

  compartment_id = var.compartment_ocid

  cidr_block = "10.0.0.0/16"

  display_name = "devops-vcn"

  dns_label = "devopsvcn"
}

resource "oci_core_internet_gateway" "devops_igw" {

  compartment_id = var.compartment_ocid

  vcn_id = oci_core_vcn.devops_vcn.id

  display_name = "devops-igw"

  enabled = true
}

resource "oci_core_route_table" "devops_rt" {

  compartment_id = var.compartment_ocid

  vcn_id = oci_core_vcn.devops_vcn.id

  display_name = "devops-rt"

  route_rules {

    destination = "0.0.0.0/0"

    destination_type = "CIDR_BLOCK"

    network_entity_id = oci_core_internet_gateway.devops_igw.id
  }
}

resource "oci_core_security_list" "devops_sl" {

  compartment_id = var.compartment_ocid

  vcn_id = oci_core_vcn.devops_vcn.id

  display_name = "devops-sl"

  ingress_security_rules {

    protocol = "6"

    source = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {

    protocol = "6"

    source = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  egress_security_rules {

    protocol = "all"

    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "devops_subnet" {

  compartment_id = var.compartment_ocid

  vcn_id = oci_core_vcn.devops_vcn.id

  cidr_block = "10.0.1.0/24"

  display_name = "devops-subnet"

  route_table_id = oci_core_route_table.devops_rt.id

  security_list_ids = [
    oci_core_security_list.devops_sl.id
  ]

  prohibit_public_ip_on_vnic = false

  dns_label = "publicsubnet"
}

output "subnet_id" {
  value = oci_core_subnet.devops_subnet.id
}

output "vcn_id" {
  value = oci_core_vcn.devops_vcn.id
}

data "oci_core_images" "ubuntu" {

  compartment_id = var.compartment_ocid

  operating_system = "Canonical Ubuntu"

  operating_system_version = "24.04"

  sort_by = "TIMECREATED"

  sort_order = "DESC"
}

resource "oci_core_instance" "wordpress_vm" {

  availability_domain = "XHPb:SA-SAOPAULO-1-AD-1"

  compartment_id = var.compartment_ocid

  display_name = "wordpress-devops-vm"

  shape = "VM.Standard.E2.1.Micro"

  create_vnic_details {

    subnet_id = oci_core_subnet.devops_subnet.id

    assign_public_ip = true

    display_name = "wordpress-vnic"
  }

  source_details {

    source_type = "image"

    source_id = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {

    ssh_authorized_keys = var.ssh_public_key

    user_data = base64encode(file("${path.module}/cloud-init.sh"))
  }
}

output "vm_id" {
  value = oci_core_instance.wordpress_vm.id
}