Title: Installing Juju

# Getting the latest Juju

Juju is available as a client on many platforms and distributions. Find your
platform below and get started with Juju.

## Version 2.2.2

The current stable version of Juju is 2.2.2 and is recommended for everyday
production use.


### Ubuntu

For Ubuntu 16.04 LTS (Xenial) the best way to install Juju is to use snaps
([see the snapcraft.io site][snapcraft] for more information). With snaps, the
latest stable release of Juju can be installed with the following command:

     sudo snap install juju --classic

You can check which version of Juju you have installed with

     sudo snap list juju

And update it if necessary with:

     sudo snap refresh juju

Note: you can use the PPA for a stable deb package as well:

```bash
sudo add-apt-repository --update ppa:juju/stable
sudo apt install juju
```
### macOS

The easiest way to install Juju on macOS is with the [brew package
manager][brew]. With brew installed, simply enter the following into a
terminal:

```bash
   brew install juju
```

If you previously installed Juju with brew, the package can be
updated with the following:

```bash
   brew upgrade juju
```

Alternatively, you can manually install Juju from the following archive:
: [juju-2.2.2-osx.tar.gz](https://launchpad.net/juju/2.2/2.2.2/+download/juju-2.2.2-osx.tar.gz)([md5](https://launchpad.net/juju/2.2/2.2.2/+download/juju-2.2.2-osx.tar.gz/+md5))
{: .instruction }

### Windows

A Windows installer is available for Juju and can be found here:
: [juju-setup-2.2.2.exe](https://launchpad.net/juju/2.2/2.2.2/+download/juju-setup-2.2.2.exe)([md5](https://launchpad.net/juju/2.2/2.2.2/+download/juju-setup-2.2.2.exe/+md5))
{: .instruction }

### Centos and other Linuxes

Snaps enable installing the Juju client on an array of Linux distributions.
Note that the `--classic` flag is not supported on many of them and so you'll
need to use `--devmode` instead.

See the [span install documentation][snap-install] to get snapd onto your linux and then you
can install Juju with:

```
 sudo snap install juju --classic
```

Alternatively, the latest manual install package for Centos is 2.2.2, which
can be installed from the following archive:

: [juju-2.2.2-centos7.tar.gz](https://launchpad.net/juju/2.2/2.2.2/+download/juju-2.2.2-centos7.tar.gz)([md5](https://launchpad.net/juju/2.2/2.2.2/+download/juju-2.2.2-centos7.tar.gz/+md5))
{: .instruction }

## Getting development releases

The Juju team regularly puts out alpha, beta, and RC releases during a
development cycle. We encourage users to please test these versions out with
their workloads and use cases and [file bugs][bugs] if you hit any issues.
Remember that while in development, feedback on usability and missing
functionality is very important so don't just file bugs for things that go
wrong, but also for things that have an opportunity to be "more right".

!!! Note:
    The current beta version of Juju is the same as the stable version. This
    will change as development progresses towards the next release.

### Ubuntu

It is possible to install other versions, including beta releases of
Juju, via a snap package.

You can update to the non-stable channels of Juju releases by using the snap
command.

```bash
   sudo snap install juju --beta --classic
```

Or you can get a daily build using the edge channel.

```bash
   sudo snap install juju --edge --classic
```

### macOS

On macOS you can get development Juju from the [brew package manager][brew].
The development releases are put under the `--devel` flag in brew.

```bash
   brew install --devel juju
```

Or you can use the binary built for macOS:
: [juju-2.2.2-osx.tar.gz](https://launchpad.net/juju/2.2/2.2.2/+download/juju-2.2.2-osx.tar.gz)([md5](https://launchpad.net/juju/2.2/2.2.2/+download/juju-2.2.2-osx.tar.gz/+md5))
{: .instruction }

### Windows

The latest is version 2.2.2 located at:
: [juju-setup-2.2.2.exe](https://launchpad.net/juju/2.2/2.2.2/+download/juju-setup-2.2.2.exe)([md5](https://launchpad.net/juju/2.2/2.2.2/+download/juju-setup-2.2.2.exe/+md5))
{: .instruction }

## Building from source

Check out the [Contributing][contributing] documentation in the codebase to walk through
building Juju from source.


[brew]: https://brew.sh/
[bugs]: https://bugs.launchpad.net/juju/
[contributing]: https://github.com/juju/juju/blob/develop/CONTRIBUTING.md
[install]: ./reference-install.html
[snapcraft]: https://snapcraft.io
[snap-install]: https://snapcraft.io/docs/core/install
