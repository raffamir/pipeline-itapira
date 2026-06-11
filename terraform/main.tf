data "oci_core_images" "oracle_linux" {

  compartment_id = var.compartment_ocid

  operating_system = "Oracle Linux"

  operating_system_version = "9"

  sort_by = "TIMECREATED"

  sort_order = "DESC"
}

output "oracle_images" {
  value = data.oci_core_images.oracle_linux.images[*].display_name
}

output "oracle_image_ids" {
  value = data.oci_core_images.oracle_linux.images[*].id
}