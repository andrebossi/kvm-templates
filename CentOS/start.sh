#!/usr/bin/env bash

DISK_FORMAT="qcow2" # Define VM disk image format.. qcow2|img
DISK_PATH="/var/lib/libvirt/images" # Define path where VM disk images are stored
DISK_SIZE="30" # Define disk size in GB
EXTRA_ARGS="ks=file:/ks.cfg network --bootproto=dhcp --device=eth0 console=ttyS0,115200n8 serial"
LOCATION="http://mirror.centos.org/centos/7/os/x86_64/"
NETWORK_BRIDGE="br0" # virbr0
OS_TYPE="linux" # Define OS type to install... linux|windows
OS_VARIANT="centos7.0" # centos7.0
KICKSTART_FILE="$(cd)/ks.cfg" # Define kickstart file for CentOS based installs if desired
KICKSTART_INSTALL="true" # Define if kickstart install is desired
RAM="2048" # Define memory to allocate to VM in MB... 512|1024|2048
VCPUS="2" # Define number of vCPUs to allocate to VM
VMName="centos7" # Define name of VM to create

# Provision VM without ks.cfg
if [ "$KICKSTART_INSTALL" = false ]; then
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

# Provision VM with ks.cfg
if [ "$KICKSTART_INSTALL" = true ]; then
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
--initrd-inject=$KICKSTART_FILE \
--noreboot \
--extra-args "$EXTRA_ARGS"
fi