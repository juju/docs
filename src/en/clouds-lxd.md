Title: Using LXD with Juju
TODO:  Warning: Ubuntu release versions hardcoded
table_of_contents: True

# Using LXD with Juju

Juju already has knowledge of the (local) LXD cloud, known to Juju as cloud
'localhost'. In addition, LXD does not require an account with a remote cloud
service nor do credentials need to be added (this is done automatically via
certificates). LXD is thus a backing cloud that is trivial to set up and has
become an essential part of every Juju operator's toolbox.

Here is a list of advanced LXD features supported by Juju that are explained
elsewhere:

 - [LXD clustering][clouds-lxd-advanced-cluster] (`v.2.4.0`)
 - [Adding a remote LXD cloud][clouds-lxd-advanced-remote] (`v.2.5.0`)
 - [Charms and LXD profiles][clouds-lxd-advanced-profiles] (`v.2.5.0`)

!!! Important:
    We'll be removing the LXD deb package and replacing it with the snap.
    Either find another system if LXD is already in use or follow the included
    instructions to migrate existing containers.

## Installing LXD

On Ubuntu, LXD is normally installed by default as an APT (deb) package. We
recommend the snap package instead:

```bash
sudo snap install lxd
```

If you're transitioning existing containers to the now-installed snap, migrate
them now. Choose 'yes' when prompted (at the end) to remove the old deb
packages:

```bash
sudo lxd.migrate
```

Otherwise, remove the deb packages manually:

```bash
sudo apt purge liblxc1 lxcfs lxd lxd-client
```

## Configuring LXD

To quickly configure LXD for general use:

```bash
lxd init --auto
```

!!! Note:
    If you get a permission denied error see
    [LXD and group membership][lxd-and-group-membership].

This will configure LXD to use the legacy 'dir' (filesystem) for storage. To
use a different backend, such as ZFS, you can do:

```bash
lxd init --auto --storage-backend zfs
```

Currently Juju does not support IPv6. You will therefore need to disable it at
the LXD level. For the default bridge of `lxdbr0`:

```bash
lxc network set lxdbr0 ipv6.address none
```

The interactive method should be used to obtain a more customised setup (e.g.
clustering, storage, etc.):

```bash
lxd init
```

In the above, ensure that you at least choose to have networking
auto-configured (answer 'auto'). You can also disable IPv6 using this method
(answer 'none').

## Subnet and firewall

The subnet can be derived from the bridge's address:

```bash
lxc network get lxdbr0 ipv4.address
```

Our example gives:

```no-highlight
10.243.67.1/24
```

So the subnet address is **10.243.67.0/24**.

LXD adds iptables (firewall) rules to allow traffic to the subnet/bridge it
created. If you subsequently add/change firewall settings, ensure that such
changes have not interfered with Juju's ability to communicate with LXD. Juju
needs access to the LXD subnet on TCP port 8443.

## Creating a controller

You are now ready to create a Juju controller for cloud 'localhost':

```bash
juju bootstrap localhost lxd-controller
```

Above, the name given to the new controller is 'lxd-controller'. LXD will
provision a container to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

View the new controller machine like this:

```bash
juju machines -m controller
```

This example yields the following output:

```no-highlight
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.243.67.177  juju-c795fe-0  bionic      Running
```

The controller's underlying container can be listed with the LXD client:

```bash
lxc list
```

Output:

```no-highlight
+---------------+---------+----------------------+------+------------+-----------+
|     NAME      |  STATE  |         IPV4         | IPV6 |    TYPE    | SNAPSHOTS |
+---------------+---------+----------------------+------+------------+-----------+
| juju-c795fe-0 | RUNNING | 10.243.67.177 (eth0) |      | PERSISTENT |           |
+---------------+---------+----------------------+------+------------+-----------+
```

## LXD specific features and additional resources

Constraints can be used with LXD containers (`v.2.4.1`). However, these are not
bound to the LXD cloud type (i.e. they can affect containers that are
themselves backed by a Juju machine running on any cloud type). See
[Constraints and LXD containers][charms-constraints-lxd] for details.

Advanced Juju usage with LXD is explained on page
[Using LXD with Juju - advanced][clouds-lxd-advanced].

For more LXD-specific information see
[Additional LXD resources][clouds-lxd-resources].

## Next steps

A controller is created with two models - the 'controller' model, which should
be reserved for Juju's internal operations, and a model named 'default', which
can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[models]: ./models.md
[charms]: ./charms.md
[controllers-creating]: ./controllers-creating.md
[clouds-lxd-resources]: ./clouds-lxd-resources.md
[clouds-lxd-advanced]: ./clouds-lxd-advanced.md
[clouds-lxd-advanced-cluster]: ./clouds-lxd-advanced.md#lxd-clustering
[clouds-lxd-advanced-remote]: ./clouds-lxd-advanced.md#adding-a-remote-lxd-cloud
[clouds-lxd-advanced-profiles]: ./clouds-lxd-advanced.md#charms-and-lxd-profiles
[charms-constraints-lxd]: ./charms-constraints.md#constraints-and-lxd-containers
[lxd-and-group-membership]: ./clouds-lxd-resources.md#lxd-and-group-membership
