(how-to-install-charmcraft)=
# How to install Charmcraft

> See also:
> - {ref}`Charmcraft <charmcraft-charmcraft>`

This document shows you how to install Charmcraft.

**Contents:**

- [Linux](#heading--linux)
- [MacOS](#heading--macos)
- [Windows](#heading--windows)
- [Isolated environment](#heading--isolated)


<a href="#heading--linux"><h2 id="heading--linux">Linux</h2></a>

The recommended way to install Charmcraft on Linux is from the `stable` channel via snap:

    sudo snap install charmcraft --classic

There are multiple channels other than `stable`. See the full list with `snap info charmcraft`. 

We recommend either `latest/stable` or `latest/candidate` for everyday charming. With the snap you will always be up to date as Charmhub services and APIs evolve. Charmcraft supports Kubernetes operator development.

In Linux Charmcraft defaults to LXD to build the charms in a container matching the target base(s) (Multipass can also be used). Charmcraft will offer to install LXD if required, but here are steps to set it up manually:

```text
$ sudo snap install lxd
$ sudo adduser $USER lxd
$ newgrp lxd
$ lxd init --auto
```

See also how to install Charmcraft in [an isolated environment](#heading--isolated).


<a href="#heading--macos"><h2 id="heading--macos">MacOS</h2></a>

Charmcraft is [available on homebrew](https://formulae.brew.sh/formula/charmcraft).

Installation should be straightforward if using homebrew (if not already setup, refer to [this instructions](https://brew.sh/)).

```text
$ brew install charmcraft
==> Downloading https://ghcr.io/v2/homebrew/core/charmcraft/manifests/1.3.2
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/charmcraft/blobs/sha256:ebe7aac3dcfa401762faaf339a28e64bb5fb277a7d96bbcfb72bdc
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:ebe7aac3dcfa401762faaf339a28e64bb5fb277a7d
######################################################################## 100.0%
==> Pouring charmcraft--1.3.2.mojave.bottle.tar.gz
🍺  /usr/local/Cellar/charmcraft/1.3.2: 2,205 files, 17.2MB
```

Charmhub commands work natively:

```text
$ charmcraft whoami
name:      John Doe
username:  jdoe
id:        xxxxxxxxxxxxxxxxxxxxxxxxx
```

In MacOS Charmcraft defaults to Multipass to build the charms in a container matching the target base(s). Running pack asks to setup Multipass if not already installed, and continues with the packing process:

```text
$ charmcraft pack
Multipass is required, but not installed. Do you wish to install Multipass and configure it with the defaults? [y/N]: y
==> Downloading https://github.com/canonical/multipass/releases/download/v1.7.2/multipass-1.7.2+mac-Darwin.pkg
Already downloaded: /Users/jdoe/Library/Caches/Homebrew/downloads/4237fcef800faa84459a2911c3818dfa76f1532d693b151438f1c8266318715b--multipass-1.7.2+mac-Darwin.pkg
==> Installing Cask multipass
==> Running installer for multipass; your password may be necessary.
Package installers may write to any location; options such as `--appdir` are ignored.
installer: Package name is multipass
installer: Installing at base path /
installer: The install was successful.
🍺  multipass was successfully installed!
Packing charm 'test-charm_ubuntu-20.04-amd64.charm'...
Starting charmcraft-test-charm-12886917363-0-0-amd64 ...
```

See also how to install Charmcraft in an [isolated environment](#heading--isolated).


<a href="#heading--windows"><h2 id="heading--windows">Windows</h2></a>

There is no previously packaged way to install Charmcraft in Windows, please refer to how to install it in an [isolated environment](#heading--isolated).


<a href="#heading--isolated"><h2 id="heading--isolated">Isolated environment</h2></a>

One way to install Charmcraft is via [Multipass](https://multipass.run/). This is a good way to install it on any platform, as it will give you an isolated development environment. 

First, [install Multipass](https://multipass.run/docs/how-to-install-multipass).

Second, use Multipass to provision a virtual machine. The following command will launch a fresh new VM with 4 cores, 8GB RAM and a 20GB disk and the name 'charm-dev':

```text
$ multipass launch --cpus 4 --memory 8G --disk 20G --name charm-dev
```

Last,  open  a shell in your new Ubuntu virtual machine, and install Charmcraft there:

```text
$ multipass shell charm-dev
...
ubuntu@charm-dev:~$ sudo snap install charmcraft --classic
charmcraft 2.2.0 from Canonical✓ installed
```

That's it. You can now start typing in Charmcraft commands.