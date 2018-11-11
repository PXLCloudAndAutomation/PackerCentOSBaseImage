# Packer CentOS 7 base image
An easy to understand example how to build a clean and updated CentOS 7 image using Packer from HashiCorp. 

There are three builders used to create the image: VMWare Workstation, VirtualBox and Docker. The first two use an ISO to install the operating system and will create a VMDK and an OVF. The Docker builder uses the official CentOS 7 docker image and will produce a tar file.

## Prerequisites
 
 * Packer (version 1.3.1)
 * VMware Workstation (version 15)/Fusion (version 11)
 * VirtualBox (version 5.2.22)
 * Docker (version 18.06.1-ce)

## Run Packer
The first command below will execute Packer and create, if all goes well, the different versions of the image. A subdirectory called `output-centos-7-virtualbox-base` will contain the OVF and VMDK made by VirtualBox. Inside the `output-centos-7-vmware-base` directory are the versions made by VMware. The tar file from docker will be created in the working directory. 

```bash
$ packer build centos-7-base.json
```

Thanks to the `-only` argument it's possible to specify the needed builders. For example, to only execute the VirtualBox and VMware builders use the following command:

```bash
$ packer build -only=centos-7-virtualbox-base,centos-7-vmware-base centos-7-base.json
```

### Note for Linux users
The user must be able to execute docker. Therefore, it's necessary to add the user to docker group. Do this with the command below:

```
sudo usermod -aG docker $USER
```


### Note for Fusion users
The VMware commands aren't automatically added to the environment variable PATH. At some point Packer will execute OVF Tool command. Therefore, this command needs to be added to PATH. The following statement will add this.

```bash
$ PATH=/Applications/VMware\ Fusion.app/Contents/Library/VMware\ OVF\ Tool/:$PATH
```