variable "tenancy_ocid" {
  sensitive = true
}

variable "user_ocid" {
  sensitive = true
}

variable "fingerprint" {
  sensitive = true
}

variable "private_key" {
  sensitive = true
}

variable "region" {}

variable "compartment_ocid" {}

variable "ssh_public_key" {
  sensitive = true
}