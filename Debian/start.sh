#!/usr/bin/env bash

DISK_FORMAT="qcow2" # Define VM disk image format.. qcow2|img
DISK_PATH="/var/lib/libvirt/images" # Define path where VM disk images are stored
DISK_SIZE="30" # Define disk size in GB
EXTRA_ARGS="console=ttyS0,115200n8 serial"
LOCATION="http://sft.if.usp.br/debian/dists/stable/main/installer-amd64/current/images/netboot/"
NETWORK_BRIDGE="br0" # virbr0
OS_TYPE="linux" # Define OS type to install... linux|windows
OS_VARIANT="debian9"
PRESEED_FILE="$(pwd)/preseed.cfg" # Define preseed file for Debian based installs if desired
PRESEED_INSTALL="true" # Define if preseed install is desired
RAM="2048" # Define memory to allocate to VM in MB... 512|1024|2048
VCPUS="2" # Define number of vCPUs to allocate to VM
VMName="debian-server" # Define name of VM to create

if [ "$PRESEED_INSTALL" = false ]; then
virt-install \
--connect qemu:///system \
--virt-type kvm
--name $VMName \
--ram $RAM \
--disk path=$DISK_PATH/$VMName.$DISK_FORMAT,size=$DISK_SIZE \
--vcpus $VCPUS \
--os-type $OS_TYPE \
--os-variant $OS_VARIANT \
--network bridge=$NETWORK_BRIDGE \
--graphics none \
--console pty,target_type=serial \
--location $LOCATION \
--check disk_size=off \
--extra-args "$EXTRA_ARGS"
fi

if [ "$PRESEED_INSTALL" = true ]; then
virt-install \
--connect qemu:///system \
--virt-type kvm \
--name $VMName \
--ram $RAM \
--disk path=$DISK_PATH/$VMName.$DISK_FORMAT,size=$DISK_SIZE \
--vcpus $VCPUS \
--os-type $OS_TYPE \
--os-variant $OS_VARIANT \
--network bridge=$NETWORK_BRIDGE \
--graphics none \
--check disk_size=off \
--console pty,target_type=serial \
--location $LOCATION \
--initrd-inject=$PRESEED_FILE \
--noreboot \
--extra-args "$EXTRA_ARGS"
fi