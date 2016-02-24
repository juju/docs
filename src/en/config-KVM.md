Title: Configuring for KVM  

# Configuring for KVM

## Prerequisites

On Linux, it is very easy to use the local provider with KVM-based virtual
machines. However, as the local provider is typically used with LXC containers
users wishing to use KVM instead are urged to first read the more general
writeup on [Installing and configuring Juju for LXC (Linux)](./config-LXC.html).

Begin by adding the Juju stable release PPA:

```bash
sudo apt-add-repository ppa:juju/stable
sudo apt-get update
```

Now install the local provider and the KVM/libvirt software, including helper
tools:

```bash
sudo apt-get install juju-local qemu-kvm libvirt-bin bridge-utils virt-manager qemu-system uvtool-libvirt uvtool
```


## Configuration

Start by generating a generic configuration file for Juju and then switching to
the local provider:

```bash
juju generate-config
juju switch local
```

This will generate a file, `environments.yaml` (if it doesn't already exist),
which will live, on Ubuntu, in your `~/.juju/` directory (and will create the
directory if it doesn't already exist).

**Note:** If you have an existing configuration, you can use
`juju generate-config --show` to output the new config file, then copy and
paste relevant areas in a text editor etc.

The key ingredient necessary to use KVM virtual machines is `container: kvm`.
An example working configuration for using them with the local provider is:

```yaml
kvm:
    type: local
    container: kvm
```

Note that the name of this provider has been changed from "local" to "kvm".
Recall that this label is arbitrary and therefore useful for description
purposes.


## Bootstrap

Proceed to bootstrap your environment:

```bash
juju bootstrap
```

## Verification

Verify the setup by adding a machine:

```bash
juju add-machine --constraints "root-disk=6G mem=2G"
```

A KVM guest should appear when using the libvirt client:

```bash
virsh list --all
 Id    Name                           State
----------------------------------------------------
 1     ubuntu-local-machine-1         running
```

And `juju status` should give something similar to:

```no-highlight
  "1":
    agent-state: started
    agent-version: 1.24.2.1
    dns-name: 192.168.122.9
    instance-id: ubuntu-local-machine-1
    series: trusty
    hardware: arch=amd64 cpu-cores=1 mem=2048M root-disk=6144M
```


## LXC containers within a KVM guest

You can go further and use the KVM guest as a hosting system for LXC
containers. This is achieved in the manner in which Juju commands are invoked;
no extra Juju configuration is required. What is required, however, is the
creation of a network bridge on the KVM guest (LXC host) in order for the
containers to have access to the external network (that of the LXC host, or
KVM guest).

Although not required, as covered in
[Installing and configuring Juju for LXC (Linux)](./config-LXC.html), it is
recommended to use LXC cloning to speed up the creation of LXC containers.  
Unfortunately, `lxc-clone` cannot be specified during run-time with `juju
set-env`.

### KVM guest network bridge

Connect to the KVM guest, assuming a Juju machine # of '1' (based on the above
output for `juju status`):

```bash
juju ssh 1
```

Create a simple bridge ('lxcbr0') by editing the primary interface network
('eth0' here, and using DHCP) configuration so it looks like:

```no-highlight
auto lxcbr0
 iface lxcbr0 inet dhcp
 bridge_ports eth0
```

Reboot the KVM guest to ensure the bridge comes up reliably.

### Managing KVM-based LXC containers

To add two (to test connectivity) LXC containers to the KVM guest (machine #1):

```bash
juju add-machine lxc:1
juju add-machine lxc:1
```

The output to `juju status` should now look like:

```no-highlight
  "1":
    agent-state: started
    agent-version: 1.24.2.1
    dns-name: 192.168.122.9
    instance-id: ubuntu-local-machine-1
    series: trusty
    containers:
      1/lxc/0:
        agent-state: started
        agent-version: 1.24.2.1
        dns-name: 10.0.3.58
        instance-id: ubuntu-local-machine-1-lxc-0
        series: trusty
        hardware: arch=amd64
      1/lxc/1:
        agent-state: started
        agent-version: 1.24.2.1
        dns-name: 10.0.3.154
        instance-id: ubuntu-local-machine-1-lxc-1
        series: trusty
        hardware: arch=amd64
    hardware: arch=amd64 cpu-cores=1 mem=2048M root-disk=6144M
```

And from the KVM guest:

```bash
sudo lxc-ls --fancy
```

```no-highlight
NAME                          STATE    IPV4        IPV6  AUTOSTART
------------------------------------------------------------------
juju-trusty-lxc-template      STOPPED  -           -     NO 
ubuntu-local-machine-1-lxc-0  RUNNING  10.0.3.58   -     YES
ubuntu-local-machine-1-lxc-1  RUNNING  10.0.3.154  -     YES
```

Note: The template container is used for cloning.

To remove one of these containers (1/lxc/0 here):

```bash
juju destroy-machine --force 1/lxc/0
```
