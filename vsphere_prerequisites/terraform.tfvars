# login information
vsphere_server_login {
  "user" = ""
  "password" = ""
  "vsphere" = ""
}

# Datacenter information
datacenter = ""
datastore  = ""

# File information
source_path = "./files"
destination_path = "/packer"

files = [
  "CentOS-7-x86_64-Minimal-1804.iso",
]
