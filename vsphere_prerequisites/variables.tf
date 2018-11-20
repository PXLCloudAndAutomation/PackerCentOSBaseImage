variable "vsphere_server_login" {
  description = "The credentials for the VMware cluster."
  type = "map"
}

variable "datacenter" {
  type = "string"
}

variable "datastore" {
  type = "string"
}

variable source_path {
  type = "string"
}

variable destination_path {
  type = "string"
}

variable files {
  type = "list"
}
