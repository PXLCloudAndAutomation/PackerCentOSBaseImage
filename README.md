# Packer CentOS 7 base image
A complete example how to build a clean and updated CentOS 7 image using Packer from HashiCorp. 

There are five builders used to create an image: VMWare Workstation, VirtualBox, VMWare vSphere, Docker and AWS. The first two use an ISO to install the operating system and will create a VMDK and an OVF. The vSphere builder expects an ISO file on a datastore and creates a template. The Docker builder uses the official CentOS 7 docker image and will produce a tar file. The last builder, the one for AWS, also uses an official CentOS image to create an own AMI.

## Prerequisites

 * Packer (version 1.3.1)
 * VMware Workstation (version 15)/Fusion (version 11)
 * VirtualBox (version 5.2.22)
 * Docker (version 18.06.1-ce)
 * Login credentials for vSphere (versions 6.5 or 6.7)
 * [Packer plugin for remote builds on VMware vSphere](https://github.com/jetbrains-infra/packer-builder-vsphere)
 * Amazon AWS credentials (located in `~/.aws/credentials`)

## Install Packer and the plugin
Download the Packer binary  and extract it to `~/bin`. Do not forget to add this directory to the `PATH` variable.

### Packer plugin for remote builds on VMware vSphere
Download the binary from the site and place it in the same directory as `packer`. **Note**: It might be necessary to rename the binary file after extracting.

## Run Packer
The first command below will execute Packer and create, if all goes well, the different versions of the image. A subdirectory called `output-centos-7-virtualbox-base` will contain the OVF and VMDK made by VirtualBox. Inside the `output-centos-7-vmware-base` directory are the versions made by VMware. The tar file from docker will be created in the working directory. 

Build everything (This will take some time.): 

```bash
$ packer build   -var-file=variables.json linux-base.json
aws output will be in this color.
docker output will be in this color.
virtualbox output will be in this color.
vmware output will be in this color.
vsphere output will be in this color.

 . . . 

```

Thanks to the `-only` argument it's possible to specify the needed builders. For example, to only execute the VirtualBox builder use the following command:

```bash
$ packer build -only=virtualbox  -var-file=variables.json linux-base.json
```

Example output:

```bash
virtualbox output will be in this color.

==> virtualbox: Retrieving Guest additions
    virtualbox: Using file in-place: file:///Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
==> virtualbox: Retrieving ISO
    virtualbox: Found already downloaded, initial checksum matched, no download needed: http://mirror.unix-solutions.be/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso
==> virtualbox: Starting HTTP server on port 8641
==> virtualbox: Creating virtual machine...
==> virtualbox: Creating hard drive...
==> virtualbox: Creating forwarded port mapping for communicator (SSH, WinRM, etc) (host port 3114)
==> virtualbox: Executing custom VBoxManage commands...
    virtualbox: Executing: modifyvm CentOS-7-1NIC-base-small --memory 2048
    virtualbox: Executing: modifyvm CentOS-7-1NIC-base-small --cpus 2
==> virtualbox: Starting the virtual machine...
    virtualbox: The VM will be run headless, without a GUI. If you want to
    virtualbox: view the screen of the VM, connect via VRDP without a password to
    virtualbox: rdp://127.0.0.1:5986
==> virtualbox: Waiting 10s for boot...
==> virtualbox: Typing the boot command...
==> virtualbox: Using ssh communicator to connect: 127.0.0.1
==> virtualbox: Waiting for SSH to become available...
==> virtualbox: Connected to SSH!
==> virtualbox: Uploading VirtualBox version info (5.2.22)
==> virtualbox: Uploading VirtualBox guest additions ISO...
==> virtualbox: Provisioning with shell script: /var/folders/l6/1fv09zp10f5_hc4932dfxy5m0000gn/T/packer-shell995867820
    virtualbox: Loaded plugins: fastestmirror
    virtualbox: Loading mirror speeds from cached hostfile
    virtualbox:  * base: ftp.belnet.be
    virtualbox:  * extras: ftp.belnet.be
    virtualbox:  * updates: ftp.belnet.be
    virtualbox: No packages marked for update
    virtualbox: Loaded plugins: fastestmirror
    virtualbox: Cleaning repos: base extras updates
    virtualbox: Cleaning up list of fastest mirrors
==> virtualbox: Gracefully halting virtual machine...
==> virtualbox: Preparing to export machine...
    virtualbox: Deleting forwarded port mapping for the communicator (SSH, WinRM, etc) (host port 3114)
==> virtualbox: Exporting virtual machine...
    virtualbox: Executing: export CentOS-7-1NIC-base-small --output output-virtualbox/CentOS-7-1NIC-base-small.ovf
==> virtualbox: Deregistering and deleting VM...
Build 'virtualbox' finished.

==> Builds finished. The artifacts of successful builds are:
--> virtualbox: VM files in directory: output-virtualbox
$ ls output-virtualbox/
CentOS-7-1NIC-base-small-disk001.vmdk CentOS-7-1NIC-base-small.ovf
```

Only the Docker builder:

```bash
$ packer build -only=docker -var-file=variables.json linux-base.json
docker output will be in this color.

==> docker: Creating a temporary directory for sharing data...
==> docker: Pulling Docker image: centos:7
    docker: 7: Pulling from library/centos
    docker: a02a4930cb5d: Pulling fs layer
    docker: a02a4930cb5d: Verifying Checksum
    docker: a02a4930cb5d: Download complete
    docker: a02a4930cb5d: Pull complete
    docker: Digest: sha256:184e5f35598e333bfa7de10d8fb1cebb5ee4df5bc0f970bf2b1e7c7345136426
    docker: Status: Downloaded newer image for centos:7
==> docker: Starting docker container...
    docker: Run command: docker run -v /Users/tim/.packer.d/tmp/packer-docker138832190:/packer-files -d -i -t centos:7 /bin/bash
    docker: Container ID: a32e2646a7351bbf64fb8d5215d7710f1abf29a6a4d430495ae647dd4a4286fe
==> docker: Using docker communicator to connect: 172.17.0.2
==> docker: Provisioning with shell script: /var/folders/l6/1fv09zp10f5_hc4932dfxy5m0000gn/T/packer-shell497215314
    docker: Loaded plugins: fastestmirror, ovl
    docker: Determining fastest mirrors
    docker:  * base: centos.cu.be
    docker:  * extras: centos.cu.be
    docker:  * updates: mirrors.atosworldline.com
    docker: No packages marked for update
    docker: Loaded plugins: fastestmirror, ovl
    docker: Cleaning repos: base extras updates
    docker: Cleaning up list of fastest mirrors
==> docker: Exporting the container
==> docker: Killing the container: a32e2646a7351bbf64fb8d5215d7710f1abf29a6a4d430495ae647dd4a4286fe
Build 'docker' finished.

==> Builds finished. The artifacts of successful builds are:
--> docker: Exported Docker file: CentOS-7-base.tar
$ ls CentOS-7-base.tar
CentOS-7-base.tar
```

The Docker and AWS builders:

```bash
$ packer build -only=docker,aws -var-file=variables.json linux-base.json
docker output will be in this color.
aws output will be in this color.

==> aws: Prevalidating AMI Name: packer-example 1546784654
==> docker: Creating a temporary directory for sharing data...
==> docker: Pulling Docker image: centos:7
    aws: Found Image ID: ami-01d5b8c6e4958a724
==> aws: Creating temporary keypair: packer_5c320f8f-12cc-e4ad-eb35-e9ee42d05e86
==> aws: Creating temporary security group for this instance: packer_5c320f90-d299-e8bc-cdf1-ca4c1417fbf1
    docker: 7: Pulling from library/centos
==> aws: Authorizing access to port 22 from 0.0.0.0/0 in the temporary security group...
    docker: Digest: sha256:184e5f35598e333bfa7de10d8fb1cebb5ee4df5bc0f970bf2b1e7c7345136426
    docker: Status: Image is up to date for centos:7
==> docker: Starting docker container...
    docker: Run command: docker run -v /Users/tim/.packer.d/tmp/packer-docker003582871:/packer-files -d -i -t centos:7 /bin/bash
==> aws: Launching a source AWS instance...
==> aws: Adding tags to source instance
    aws: Adding tag: "Name": "Packer Builder"
    docker: Container ID: 11a12a9a80cd300c64b2bd6861ab5377210c545776f77f98e75c7352e3516a79
==> docker: Using docker communicator to connect: 172.17.0.2
==> docker: Provisioning with shell script: /var/folders/l6/1fv09zp10f5_hc4932dfxy5m0000gn/T/packer-shell689535451
    aws: Instance ID: i-08fdfe132696f0ccd
==> aws: Waiting for instance (i-08fdfe132696f0ccd) to become ready...
    docker: Loaded plugins: fastestmirror, ovl
    docker: Determining fastest mirrors
    docker:  * base: mirror.unix-solutions.be
    docker:  * extras: mirror.unix-solutions.be
    docker:  * updates: mirror.widexs.nl
    docker: No packages marked for update
    docker: Loaded plugins: fastestmirror, ovl
    docker: Cleaning repos: base extras updates
    docker: Cleaning up list of fastest mirrors
==> docker: Exporting the container
==> docker: Killing the container: 11a12a9a80cd300c64b2bd6861ab5377210c545776f77f98e75c7352e3516a79
Build 'docker' finished.
==> aws: Using ssh communicator to connect: 54.227.229.116
==> aws: Waiting for SSH to become available...
==> aws: Connected to SSH!
==> aws: Provisioning with shell script: /var/folders/l6/1fv09zp10f5_hc4932dfxy5m0000gn/T/packer-shell133005011
    aws: Loaded plugins: fastestmirror
    aws: Determining fastest mirrors
    aws:  * base: mirrors.advancedhosters.com
    aws:  * extras: mirrors.advancedhosters.com
    aws:  * updates: repos-va.psychz.net
    aws: Resolving Dependencies
    aws: --> Running transaction check
    aws: ---> Package deltarpm.x86_64 0:3.6-3.el7 will be installed
    aws: --> Finished Dependency Resolution
    aws:
    aws: Dependencies Resolved
    aws:
    aws: ================================================================================
    aws:  Package            Arch             Version               Repository      Size
    aws: ================================================================================
    aws: Installing:
    
    . . . 
    
    aws:
    aws: Complete!
    aws: Loaded plugins: fastestmirror
    aws: Cleaning repos: base extras updates
    aws: Cleaning up list of fastest mirrors
==> aws: Stopping the source instance...
    aws: Stopping instance, attempt 1
==> aws: Waiting for the instance to stop...
==> aws: Creating unencrypted AMI packer-example 1546784654 from instance i-08fdfe132696f0ccd
    aws: AMI: ami-00d57a5052151c272
==> aws: Waiting for AMI to become ready...
==> aws: Adding tags to AMI (ami-00d57a5052151c272)...
==> aws: Tagging snapshot: snap-0fd7c8dc132645997
==> aws: Creating AMI tags
    aws: Adding tag: "Name": "CentOS-7-1NIC-base-small-template"
==> aws: Creating snapshot tags
==> aws: Terminating the source AWS instance...
==> aws: Cleaning up any extra volumes...
==> aws: Destroying volume (vol-01963e9a08246b3f6)...
==> aws: Deleting temporary security group...
==> aws: Deleting temporary keypair...
Build 'aws' finished.

==> Builds finished. The artifacts of successful builds are:
--> docker: Exported Docker file: CentOS-7-base.tar
--> aws: AMIs were created:
us-east-1: ami-00d57a5052151c272
```

### Note for Linux users
The user must be able to execute docker. Therefore, it's necessary to add the user to docker group. Do this with the command below:

```
sudo usermod -aG docker $USER
```

To see the effects of this command, log out and back in.

### Note for Fusion users
The VMware commands aren't automatically added to the environment variable PATH. At some point Packer will execute OVF Tool command. Therefore, this command needs to be added to PATH. The following statement will add this.

```bash
$ PATH=/Applications/VMware\ Fusion.app/Contents/Library/VMware\ OVF\ Tool/:$PATH
```
