## Installing LXD

Your system may already come with LXD pre-installed, but we recommend installing the latest version of LXD via snap. This has the advantage of atomic updates as well as built-in support for the ZFS storage backend, which offers greater performance.


```bash
# Remove the apt-installed version of LXD
sudo apt-get remove --purge lxd lxd-client lxcfs liblxc1 liblxc-common

# Install the latest LXD via snap
sudo snap install lxd
```

Next, we want to initialise LXD:

```bash
$ lxd init
Would you like to use LXD clustering? (yes/no) [default=no]: 
Do you want to configure a new storage pool? (yes/no) [default=yes]: 
Name of the new storage pool [default=default]: 
Name of the storage backend to use (btrfs, ceph, cephfs, dir, lvm, zfs) [default=zfs]:   
Create a new ZFS pool? (yes/no) [default=yes]: 
Would you like to use an existing block device? (yes/no) [default=no]: 
Size in GB of the new loop device (1GB minimum) [default=15GB]: 
Would you like to connect to a MAAS server? (yes/no) [default=no]: 
Would you like to create a new local network bridge? (yes/no) [default=yes]: 
What should the new bridge be called? [default=lxdbr0]: 
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: 
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: none
Would you like LXD to be available over the network? (yes/no) [default=no]: 
Would you like stale cached images to be updated automatically? (yes/no) [default=yes] 
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: 
```
