# DESC: This will upload all files described in var.files to the destination
#       specified in var.destination_path.
#
# EXEC: $ terraform apply -parallelism=1

provider "vsphere" {
  user           = "${var.vsphere_server_login["user"]}"
  password       = "${var.vsphere_server_login["password"]}"
  vsphere_server = "${var.vsphere_server_login["vsphere"]}"

  # The cert is self-signed, therefore unverified.
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
        name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
        name = "${var.datastore}"
        datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# NOTE: This will override the existing files. No checksums are preformed!
# TODO: Create checksum check.
#          Need to dive in to the code of the provider for this!
#          GitHub: terraform-provider-vsphere/vsphere/resource_vsphere_file.go
resource "vsphere_file" "files" {
  count            = "${length(var.files)}"

  datacenter       = "${data.vsphere_datacenter.dc.name}"
  datastore        = "${data.vsphere_datastore.datastore.name}"

  source_file      = "${var.source_path}/${var.files[count.index]}"
  destination_file = "${var.destination_path}/${var.files[count.index]}"
}
