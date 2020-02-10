### What?
Run k3os on Hetzner Cloud

### Why?
Hetzner Cloud is very good value to run test setups, and I love the simplicity and power of k3os. Unfortunatelly right now there is no way to upload your own ISO image or prepared disk image (you would have to ask the support every time). Storing the snapshot itself costs less than 0.02€ a month.

### How?
* Download and configure hcloud cli (https://github.com/hetznercloud/cli)

Execute run-all.sh or do the same manually:

* With the provided user-data file you are going to launch an ubuntu VM
```
hcloud server create --image ubuntu-18.04 --type cx11 --name k3os-install --user-data-from-file kexec-k3os.userdata
```
* This VM will automatically install kexec tools, download k3os kernel+initrd and start the installer with kexec. This will take a few minutes!
* The installer will ovewrite the disk with k3os, and insert a small config to use the hetzner user-data provider, then shutdown the VM
* Once the VM is shut down, you take a snapshot - this is the source image for all your k3os VMs
```
hcloud server create-image --description k3os_install --type snapshot k3os-install
```
* Now you can delete the installer VM
```
hcloud server delete k3os-install
```
* Launch k3os VMs from that snapshot, as many as you like.
```
IMGNAME=$(hcloud image list -o columns=id,description | grep k3os_install | awk '{print $1}')
hcloud server create --image $IMGNAME --type cx11 --name k3os-1 --user-data-from-file k3os-master.userdata
```
### Alternatives?
There is a packer provider for hetzner cloud that also creates customized disk snapshots as a bootable image source.
