#!/bin/bash

VMNAME="k3os-install"


hcloud server create --image ubuntu-18.04 --type cx11 --name $VMNAME --user-data-from-file kexec-k3os.userdata


while [ "$(hcloud server list -o columns=name,status | grep $VMNAME | awk '{print $2}')" != "off" ]; do
  echo "Waiting for $VMNAME to shutdown after successfull k3os installation"
  sleep 5
done

echo "Creating snapshot"
hcloud server create-image --description k3os_install --type snapshot $VMNAME

echo "Deleting VM $VMNAME"
hcloud server delete $VMNAME

IMGNAME=$(hcloud image list -o columns=id,description | grep k3os_install | awk '{print $1}')

echo "Snapshot is ready with ID $IMGNAME. Example for VM creation:"
echo "hcloud server create --image $IMGNAME --type cx11 --name k3os-1 --user-data-from-file k3os-node.userdata"
