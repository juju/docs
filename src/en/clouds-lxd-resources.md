Title: Additional LXD resources
TODO:  Add details on remote access

# Additional LXD resources

This page offers more in-depth information on LXD itself. To learn how to set
up LXD with Juju see [Using LXD as a cloud][clouds-lxd].

The topics presented here are:

 - LXD and images
 - Remote LXD user credentials
 - LXD logs
 - Useful LXD client commands 
 - Further LXD help and reading

## LXD and images

LXD is image based: all LXD containers come from images and any LXD daemon
instance (also called a "remote") can serve images. When LXD is installed a
locally-running remote is provided (Unix domain socket) and the client is
configured to talk to it (named 'local'). The client is also configured to talk
to several other, non-local, ones (named 'ubuntu', 'ubuntu-daily', and
'images').

An image is identified by its fingerprint (SHA-256 hash), and can be tagged
with multiple aliases. Juju looks for images with aliases in the format
ubuntu-&lt;codename&gt;, for instance 'ubuntu-trusty' or 'ubuntu-xenial'.

For any image-related command, an image is specified by its alias or by its
fingerprint. Both are shown in image lists. An image's filename is its *full
fingerprint* while an image list displays its *partial fingerprint*. Either
type of fingerprint can be used to refer to images.

Juju pulls official cloud images from the 'ubuntu' remote
(http://cloud-images.ubuntu.com) and creates the necessary alias. Any
subsequent requests will be satisfied by the LXD cache (`/var/lib/lxd/images`).
Cached images can be seen with `lxc image list`:

![lxc image list after importing](./media/image_list-imported_image-reduced70.png)

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
[Viewing logs][logs] for more details.

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

## Further help and reading

See `lxc --help` for more information on LXD client usage and `lxd --help` for
assistance with the daemon. See upstream documentation for
[LXD configuration][lxd-upstream].


<!-- LINKS -->

[clouds-lxd]: ./clouds-LXD.html
[lxd-upstream]: https://github.com/lxc/lxd/blob/master/doc/configuration.md
