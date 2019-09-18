<!--
Todo:
- bug tracking: https://bugs.launchpad.net/juju/+bug/1793291
- non-admin section should be moved to lxd-advanced
-->

This page offers more in-depth information on LXD itself. To learn how to set up LXD with Juju see [Using LXD with Juju](/t/using-lxd-with-juju/1093).

The topics presented here are:

- LXD and images
- LXD and group membership
- Non-admin user credentials
- Useful LXD client commands
- Using the LXD snap
- LXD logs
- Further LXD help and reading

<h2 id="heading--lxd-and-images">LXD and images</h2>

LXD is image based: all LXD containers come from images and any LXD daemon instance (also called a "remote") can serve images. When LXD is installed a locally-running remote is provided (Unix domain socket) and the client is configured to talk to it (named 'local'). The client is also configured to talk to several other, non-local, ones (named 'ubuntu', 'ubuntu-daily', and 'images').

An image is identified by its fingerprint (SHA-256 hash), and can be tagged with multiple aliases.

For any image-related command, an image is specified by its alias or by its fingerprint. Both are shown in image lists. An image's filename is its *full fingerprint* while an image list displays its *partial fingerprint*. Either type of fingerprint can be used to refer to images.

Juju pulls official cloud images from the 'ubuntu' remote (http://cloud-images.ubuntu.com) and creates the necessary alias. Any subsequent requests will be satisfied by the LXD cache (`/var/lib/lxd/images`).

Image cache expiration and image synchronization mechanisms are built-in.

<h2 id="heading--lxd-and-group-membership">LXD and group membership</h2>

In order to use LXD, the system user who will act as the Juju operator must be an active member of the 'lxd' user group. Ensure that this is the case (below we assume this user is 'john'):

``` text
sudo adduser john lxd
```

The user will be in the 'lxd' group when they next log in. If the intended Juju operator is the current user all that's needed is a group membership refresh:

``` text
newgrp lxd
```

You can confirm the active group membership for the current user in this way:

``` text
groups
```

<h2 id="heading--non-admin-user-credentials">Non-admin user credentials</h2>

To grant a regular user access to a LXD-based controller a certificate credential is required. This certificate is generated and shared with the user who will then use it as a credential. See [Working with multiple users](/t/working-with-multiple-users/1156) for details on adding users, granting them permissions, and registering controllers.

On the LXD host generate the certificate with the `autoload-credentials` command. Use the below sample session as a guide:

``` text
Looking for cloud and credential information locally...

1. LXD credential "localhost" (new)
Select a credential to save by number, or type Q to quit: 1

Select the cloud it belongs to, or type Q to quit []: localhost

Saved LXD credential "localhost" to cloud localhost

1. LXD credential "localhost" (existing, will overwrite)
Select a credential to save by number, or type Q to quit: Q
```

A certificate credential will have been created. Export it to a file, say `localhost-credentials.yaml`, by typing the following:

``` text
juju credentials localhost --format=yaml > localhost-credentials.yaml
```

Now transfer the file to the user that requires access to the cloud. Once done, on that user's system, the credential can be added:

``` text
juju add-credential localhost -f localhost-credentials.yaml
```

See [Credentials](/t/credentials/1112) for more details on how credentials are used.

<h2 id="heading--useful-lxd-client-commands">Useful LXD client commands</h2>

There are many client commands available. Some common ones, including those covered above, are given below.

| client commands                                | meaning                                  |
|------------------------------------------------|------------------------------------------|
| `lxc launch`                                   | creates an LXD container                 |
| `lxc list`                                     | lists all LXD containers                 |
| `lxc delete`                                   | deletes an LXD container                 |
| `lxc remote list`                              | lists remotes                            |
| `lxc info`                                     | displays status of localhost             |
| `lxc info <container>`                         | displays status of container             |
| `lxc config show <container>`                  | displays configuration of container      |
| `lxc image info <alias or fingerprint>`        | displays status of image                 |
| `lxc exec <container> <executable>`            | runs program on container                |
| `lxc exec <container> /bin/bash`               | spawns shell on container                |
| `lxc file pull <container></path/to/file> .`   | copies file from container               |
| `lxc file push </path/to/file> <container>/`   | copies file to container                 |
| `lxc stop <container>`                         | stops container                          |
| `lxc image list`                               | lists cached images                      |
| `lxc image alias delete <alias>`               | deletes image alias                      |
| `lxc image alias create <alias> <fingerprint>` | creates image alias                      |
| `lxc cluster list`                             | lists cluster nodes                      |
| `lxc cluster show <container>`                 | displays configuration of a cluster node |

<h2 id="heading--using-the-lxd-snap">Using the LXD snap</h2>

The LXD project will soon be moving from the APT installation method (Debian package) to installing via a snap. Some users may want to opt in early, *before* building their infrastructure, as moving to the snap entails a migration of containers. The LXD snap is very well tested (as is the included migration tool).

First ensure that `snapd` is installed:

``` text
sudo apt install snapd
```

[note type="caution"]
On Ubuntu 14.04 LTS (Trusty), installing `snapd` will bring in a new kernel (4.4.0 series) as a dependency. You will then **need to reboot**. Attempting to install a snap without doing so will result in failure.
[/note]

Now install the LXD snap:

``` text
sudo snap install lxd
```

If LXD is already installed via APT **and there are no existing containers** under the current installation then simply remove the software:

``` text
sudo apt purge liblxc1 lxcfs lxd lxd-client
```

<h3 id="heading--migrating-containers">Migrating containers</h3>

If containers do exist under the old system the `lxd.migrate` utility should be used to migrate them so that they can be managed by the snap binaries. Once the migration is complete, you will be prompted to have the old software removed.

Start the migration tool by running:

``` text
sudo lxd.migrate
```

<h2 id="heading--lxd-logs">LXD logs</h2>

LXD itself logs to `/var/log/lxd/lxd.log` and Juju machines created via the LXD local provider log to `/var/log/lxd/juju-UUID-machine-ID`. However, the standard way to view logs is with the `debug-log` command (see the [Juju logs](/t/juju-logs/1184) page for details).

[note]
For LXD snap users, the log directory is located at `/var/snap/lxd/common/lxd/logs`.
[/note]

<h2 id="heading--further-help-and-reading">Further help and reading</h2>

See `lxc --help` for more information on LXD client usage and `lxd --help` for assistance with the daemon. See upstream documentation for [LXD configuration](https://lxd.readthedocs.io/en/latest/configuration/).
