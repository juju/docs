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

Now install the local provider and the KVM/libvirt software and associated
helper tools:

```bash
sudo apt-get install juju-local qemu-kvm libvirt-bin bridge-utils virt-manager qemu-system uvtool-libvivrt uvtool
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
juju add-machine --constraints "root-disk=4G mem=1G"
```

A KVM guest should appear when using the libvirt client:


```bash
virsh list --all
 Id    Name                           State
----------------------------------------------------
 1     ubuntu-local-machine-1         running
```

And `juju status` should correspondingly give something similar to:

```no-highlight
  "1":
    agent-state: started
    agent-version: 1.24.2.1
    dns-name: 192.168.122.179
    instance-id: ubuntu-local-machine-1
    series: trusty
    hardware: arch=amd64 cpu-cores=1 mem=1024M root-disk=4096M
```
