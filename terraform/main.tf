resource "oci_core_vcn" "devops_vcn" {

  compartment_id = var.compartment_ocid

  cidr_block = "10.0.0.0/16"

  display_name = "devops-vcn"

  dns_label = "devopsvcn"
}

output "vcn_id" {
  value = oci_core_vcn.devops_vcn.id
}