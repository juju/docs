<!--
Todo:
- Warning: Ubuntu release versions hardcoded
-->

Juju already has knowledge of the (local) LXD cloud, known to Juju as cloud 'localhost'. In addition, LXD does not require an account with a remote cloud service nor do credentials need to be added (this is done automatically via certificates). LXD is thus a backing cloud that is trivial to set up and has become an essential part of every Juju operator's toolbox.

Here is a list of advanced LXD features supported by Juju that are explained elsewhere:

-   [LXD clustering](/t/using-lxd-with-juju-advanced/1091#heading--lxd-clustering) (`v.2.4.0`)
-   [Adding a remote LXD cloud](/t/using-lxd-with-juju-advanced/1091#heading--adding-a-remote-lxd-cloud) (`v.2.5.0`)
-   [Charms and LXD profiles](/t/using-lxd-with-juju-advanced/1091#heading--charms-and-lxd-profiles) (`v.2.5.0`)

[note type="caution"]
Most Ubuntu releases have LXD installed by default as a deb package. We'll be removing that package and replacing it with the snap. Either find another system if LXD is already in use or follow the included instructions to migrate existing containers.
[/note]

<h2 id="heading--installing-lxd">Installing LXD</h2>

On Ubuntu, LXD is normally installed by default as an APT (deb) package. We recommend the snap package instead:

``` text
sudo snap install lxd
```

If you're transitioning existing containers to the now-installed snap, migrate them now. Choose 'yes' when prompted (at the end) to remove the old deb packages:

``` text
sudo lxd.migrate
```

Otherwise, remove the deb packages manually:

``` text
sudo apt purge liblxc1 lxcfs lxd lxd-client
```

<h2 id="heading--configuring-lxd">Configuring LXD</h2>

To quickly configure LXD for general use:

``` text
lxd init --auto
```

[note]
If you get a permission denied error see [LXD and group membership](/t/additional-lxd-resources/1092#heading--lxd-and-group-membership).
[/note]

This will configure LXD to use the legacy 'dir' (filesystem) for storage. To use a different backend, such as ZFS, you can do:

```text
lxd init --auto --storage-backend zfs
```

Currently Juju does not support IPv6. You will therefore need to disable it at the LXD level. For the default bridge of `lxdbr0`:

``` text
lxc network set lxdbr0 ipv6.address none
```

The interactive method should be used to obtain a more customised setup (e.g. clustering, storage, etc.):

``` text
lxd init
```

In the above, ensure that you at least choose to have networking auto-configured (answer 'auto'). You can also disable IPv6 using this method (answer 'none').

<h2 id="heading--subnet-and-firewall">Subnet and firewall</h2>

The subnet can be derived from the bridge's address:

``` text
lxc network get lxdbr0 ipv4.address
```

Our example gives:

``` text
10.243.67.1/24
```

So the subnet address is **10.243.67.0/24**.

LXD adds iptables (firewall) rules to allow traffic to the subnet/bridge it created. If you subsequently add/change firewall settings, ensure that such changes have not interfered with Juju's ability to communicate with LXD. Juju needs access to the LXD subnet on TCP port 8443.

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'localhost':

``` text
juju bootstrap localhost lxd-controller
```

Above, the name given to the new controller is 'lxd-controller'. LXD will provision a container to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

View the new controller machine like this:

``` text
juju machines -m controller
```

This example yields the following output:

``` text
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.243.67.177  juju-c795fe-0  bionic      Running
```

The controller's underlying container can be listed with the LXD client:

``` text
lxc list
```

Output:

``` text
+---------------+---------+----------------------+------+------------+-----------+
|     NAME      |  STATE  |         IPV4         | IPV6 |    TYPE    | SNAPSHOTS |
+---------------+---------+----------------------+------+------------+-----------+
| juju-c795fe-0 | RUNNING | 10.243.67.177 (eth0) |      | PERSISTENT |           |
+---------------+---------+----------------------+------+------------+-----------+
```

<h2 id="heading--lxd-specific-features-and-additional-resources">LXD specific features and additional resources</h2>

Constraints can be used with LXD containers (`v.2.4.1`). However, these are not bound to the LXD cloud type (i.e. they can affect containers that are themselves backed by a Juju machine running on any cloud type). See [Constraints and LXD containers](/t/using-constraints/1060#heading--constraints-and-lxd-containers) for details.

Advanced Juju usage with LXD is explained on page [Using LXD with Juju - advanced](/t/using-lxd-with-juju-advanced/1091).

For more LXD-specific information see [Additional LXD resources](/t/additional-lxd-resources/1092).

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
