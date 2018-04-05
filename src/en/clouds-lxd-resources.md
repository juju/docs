Title: Additional LXD resources
TODO:  Warning: Ubuntu release versions hardcoded
       Review section: Remote LXD user credentials

# Additional LXD resources

This page offers more in-depth information on LXD itself. To learn how to set
up LXD with Juju see [Using LXD as a cloud][clouds-lxd].

The topics presented here are:

 - LXD and images
 - Remote LXD user credentials
 - LXD logs
 - Useful LXD client commands 
 - Using the LXD snap
 - Further LXD help and reading

## LXD and images

LXD is image based: all LXD containers come from images and any LXD daemon
instance (also called a "remote") can serve images. When LXD is installed a
locally-running remote is provided (Unix domain socket) and the client is
configured to talk to it (named 'local'). The client is also configured to talk
to several other, non-local, ones (named 'ubuntu', 'ubuntu-daily', and
'images').

An image is identified by its fingerprint (SHA-256 hash), and can be tagged
with multiple aliases.

For any image-related command, an image is specified by its alias or by its
fingerprint. Both are shown in image lists. An image's filename is its *full
fingerprint* while an image list displays its *partial fingerprint*. Either
type of fingerprint can be used to refer to images.

Juju pulls official cloud images from the 'ubuntu' remote
(http://cloud-images.ubuntu.com) and creates the necessary alias. Any
subsequent requests will be satisfied by the LXD cache (`/var/lib/lxd/images`).

Cached images can be seen with `lxc image list`:

```no-highlight
+-------------------+--------------+--------+---------------------------------------------+--------+----------+------------------------------+
|       ALIAS       | FINGERPRINT  | PUBLIC |                 DESCRIPTION                 |  ARCH  |   SIZE   |         UPLOAD DATE          |
+-------------------+--------------+--------+---------------------------------------------+--------+----------+------------------------------+
| juju/xenial/amd64 | b5f3a547289f | no     | ubuntu 16.04 LTS amd64 (release) (20180222) | x86_64 | 156.20MB | Feb 23, 2018 at 1:17am (UTC) |
+-------------------+--------------+--------+---------------------------------------------+--------+----------+------------------------------+
```

Image cache expiration and image synchronization mechanisms are built-in.

## Remote LXD user credentials

When working with remote users on different machines (see
[Creating users][users] for details on adding users, registering them and
granting them permissions), LXD-hosted controllers need to generate a specific
certificate credential which is shared with the remote machine. 

To do this, first run `juju autoload-credentials` on the LXD host. This will
generate output similar to the following:

```bash
Looking for cloud and credential information locally...

1. LXD credential "localhost" (new)
Select a credential to save by number, or type Q to quit:
```

Select the LXD credential (`1` in the above example) and you will be asked for
the name of a cloud to link to this credential. Enter 'localhost' to specify
the local LXD deployment. When the prompt re-appears, type 'q' to quit. The new
certificate credential will have been created.

To export this certificate credential to a file called
`localhost-credentials.yaml`, type the following:

```bash
juju credentials localhost --format=yaml > localhost-credentials.yaml
```

The output file now needs to be moved to the machine and account that requires
access to the local LXD deployment. With this file on the remote machine, the
certificate credential can be imported with the following command:

```bash
juju add-credential localhost -f localhost-credentials.yaml
```

See [Cloud credentials][credentials] for more details on how credentials are
used. 

## LXD logs

LXD itself logs to `/var/log/lxd/lxd.log` and Juju machines created via the
LXD local provider log to `/var/log/lxd/juju-{uuid}-machine-{#}`. However,
the standard way to view logs is with the `juju debug-log` command. See
[Juju logs][logs] for more details.

## Useful LXD client commands

There are many client commands available. Some common ones, including those
covered above, are given below.

<style> table td{text-align:left;}</style>

| client commands                               | meaning                            |
|-----------------------------------------------|------------------------------------|
`lxc launch`					| creates an LXD container
`lxc list`	                             	| lists all LXD containers
`lxc delete`					| deletes an LXD container
`lxc remote list`				| lists remotes
`lxc info`					| displays status of localhost
`lxc info <container>`				| displays status of container
`lxc config show <container>`			| displays config of container
`lxc image info <alias or fingerprint>`		| displays status of image
`lxc exec <container> <executable>`		| runs program on container
`lxc exec <container> /bin/bash`		| spawns shell on container
`lxc file pull <container></path/to/file> .`	| copies file from container
`lxc file push </path/to/file> <container>/`  	| copies file to container
`lxc stop <container>`				| stops container
`lxc image alias delete <alias>`		| deletes image alias
`lxc image alias create <alias> <fingerprint>`	| creates image alias

## Using the LXD snap

The LXD project will soon be moving from the APT installation method (Debian
package) to installing via a snap. Some users may want to opt in early,
*before* building their infrastructure, as moving to the snap entails a
migration of containers. The LXD snap is very well tested (as is the included
migration tool).

First ensure that `snapd` is installed:

```bash
sudo apt install snapd
```

!!! Important:
    On Ubuntu 14.04 LTS (Trusty), installing `snapd` will bring in a new kernel
    (4.4.0 series) as a dependency. You will then **need to reboot**.
    Attempting to install a snap without doing so will result in failure.

Now install the LXD snap:

```bash
sudo snap install lxd
```

If LXD is already installed via APT **and there are no existing containers**
under the current installation then simply remove the software:

```bash
sudo apt purge lxd lxd-client
```

If containers do exist under the old system the `lxd.migrate` utility should be
used to migrate them to the new system. Once the migration is complete, you
will be prompted to remove the old software automatically.

Start the migration tool by running:

```bash
sudo lxd.migrate
```

As an example, LXD 2.21 was installed from the snap but the old system (Xenial
running LXD 2.21 from the 'xenial-backports' pocket) has the following
containers :

 - Juju controller
 - Random Xenial container
 - Random Artful container

Here is the generated output:

```no-highlight
=> Connecting to source server
=> Connecting to destination server
=> Running sanity checks

=== Source server
LXD version: 2.21
LXD PID: 4839
Resources:
  Containers: 3
  Images: 2
  Networks: 1
  Storage pools: 2

=== Destination server
LXD version: 2.21
LXD PID: 10153
Resources:
  Containers: 0
  Images: 0
  Networks: 0
  Storage pools: 0

The migration process will shut down all your containers then move your data to the destination LXD.
Once the data is moved, the destination LXD will start and apply any needed updates.
And finally your containers will be brought back to their previous state, completing the migration.

Are you ready to proceed (yes/no) [default=no]? yes
=> Shutting down the source LXD
=> Stopping the source LXD units
=> Stopping the destination LXD unit
=> Unmounting source LXD paths
=> Unmounting destination LXD paths
=> Wiping destination LXD clean
=> Moving the data
=> Moving the database
=> Backing up the database
=> Opening the database
=> Updating the storage backends
=> Starting the destination LXD
=> Waiting for LXD to come online

=== Destination server
LXD version: 2.21
LXD PID: 12514
Resources:
  Containers: 3
  Images: 2
  Networks: 1
  Storage pools: 2

The migration is now complete and your containers should be back online.
Do you want to uninstall the old LXD (yes/no) [default=no]? yes

All done. You may need to close your current shell and open a new one to have the "lxc" command work.
```

The containers are running and the snap-installed client recognizes them:

```bash
/snap/bin/lxc list
```

Output:

```no-highlight
+---------------+---------+--------------------+------+------------+-----------+
|     NAME      |  STATE  |        IPV4        | IPV6 |    TYPE    | SNAPSHOTS |
+---------------+---------+--------------------+------+------------+-----------+
| juju-1fbdc5-0 | RUNNING | 10.79.40.75 (eth0) |      | PERSISTENT | 0         |
+---------------+---------+--------------------+------+------------+-----------+
| Xenial        | RUNNING | 10.79.40.12 (eth0) |      | PERSISTENT | 0         |
+---------------+---------+--------------------+------+------------+-----------+
| Artful        | RUNNING | 10.79.40.8 (eth0)  |      | PERSISTENT | 0         |
+---------------+---------+--------------------+------+------------+-----------+
```

## Further help and reading

See `lxc --help` for more information on LXD client usage and `lxd --help` for
assistance with the daemon. See upstream documentation for
[LXD configuration][lxd-upstream].


<!-- LINKS -->

[clouds-lxd]: ./clouds-LXD.html
[lxd-upstream]: https://github.com/lxc/lxd/blob/master/doc/configuration.md
[logs]: ./troubleshooting-logs.html
[credentials]: ./credentials.html
