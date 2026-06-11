data "oci_core_images" "ubuntu" {

  compartment_id = var.compartment_ocid

  operating_system = "Canonical Ubuntu"

  sort_by = "TIMECREATED"

  sort_order = "DESC"
}

output "ubuntu_images" {
  value = data.oci_core_images.ubuntu.images[*].display_name
}

output "ubuntu_image_ids" {
  value = data.oci_core_images.ubuntu.images[*].id
}