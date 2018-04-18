Title: Installing Juju
TODO:  Warning: Ubuntu release versions hardcoded

# Installing Juju

Stable versions of Juju are available on Ubuntu, various other Linux
distributions, macOS, and Windows. Development releases are also available for
testing. Read on for how to install a stable or development version of Juju on
your chosen platform.

## Version 2.3.6

The most recent stable version of Juju is 2.3.6. This is the version we
recommend for production use. See the [Release Notes][release-notes-2].

### Ubuntu

Since Ubuntu 14.04 LTS (Trusty) the recommended way to install Juju is with
snaps. Nevertheless, the PPA install method is still supported and is mentioned
lower down.

On Ubuntu 16.04 LTS (and greater) `snapd` is installed by default. If you're
using Ubuntu 14.04 LTS you will need to install it prior to installing Juju:

```bash
sudo apt install snapd
```

!!! Note:
    A reboot will be needed after having installed `snapd` on Trusty since a
    new kernel (4.4.0 series) will be installed as a dependency.

Juju can be installed with the following command:

```bash
sudo snap install juju --classic
```

In the above, the 'stable' snap channel is used by default.

The current version of an installed Juju snap is given by:

```bash
snap list juju
```

And can be updated with:

```bash
sudo snap refresh juju
```

See the [Snapcraft documentation][snapcraft] for more information on snaps. 

#### Using a PPA

To install the most recent stable version using a PPA:

```bash
sudo add-apt-repository -yu ppa:juju/stable
sudo apt install juju
```

### CentOS and other Linuxes

Juju can be installed on various Linux distributions via snaps. On Ubuntu 
snapd comes pre-installed but if you're running something else you'll need to
visit [Install snapd][snapd-install] to get started.

You can now install Juju with:

```bash
sudo snap install juju --classic
```

!!! Note:
    The `--classic` flag is not supported on all distros. In that case, you'll
    need to use `--devmode` instead.

For CentOS, you can download Juju from the following archive and install it
manually:

[**juju-2.3.6-centos7.tar.gz**][juju-centos] ([md5][juju-centos-md5])

### macOS

Install Juju on macOS with [Homebrew][homebrew]. Simply enter the following
into a terminal:

```bash
brew install juju
```

And upgrade Juju with the following:

```bash
brew upgrade juju
```

### Windows

A Windows installer is available for Juju and can be found here:

[**juju-setup-2.3.6-signed.exe**][juju-win-signed] ([md5][juju-win-signed-md5])

## Development releases

Development releases (alpha, beta, rc) are regularly published and we encourage
users to test these versions with real workloads and use cases. We kindly ask
you to [file a bug][juju-new-bug] when encountering an issue. Feedback on
usability and missing functionality is also very important to us.

### Using snaps

See [above][centos-and-other-linuxes] for how to get started with snaps if
you're running a non-Ubuntu Linux distro.

To install a development release using snaps, instead of the 'stable' channel,
use the 'beta' channel:

```bash
sudo snap install juju --beta --classic
```

For a cutting edge experience choose the 'edge' channel:

```bash
sudo snap install juju --edge --classic
```

To upgrade or downgrade, use the `refresh` command with a suitable channel.
Below we install 'edge' and then downgrade to 'beta':

```bash
sudo snap install juju --edge --classic
sudo snap refresh juju --beta
```

### Using a PPA

To install the development version using a PPA:

```bash
sudo add-apt-repository -yu ppa:juju/devel
sudo apt install juju
```

Leading edge builds are only available with snaps (via the 'edge' channel).

### Other platforms

All development release binaries are published on
[Launchpad][juju-launchpad-binaries]. Note that leading edge builds are only
available with snaps (via the 'edge' channel).

## Building from source

Refer to the [Contributing][contributing] documentation in the codebase for
instructions on how to build Juju from source.


<!-- LINKS -->

[release-notes-2]: ./reference-release-notes.html
[homebrew]: https://brew.sh/
[contributing]: https://github.com/juju/juju/blob/develop/CONTRIBUTING.md
[snapcraft]: https://snapcraft.io
[snapd-install]: https://snapcraft.io/docs/core/install
[juju-new-bug]: https://bugs.launchpad.net/juju/+filebug
[juju-win-signed]: https://launchpad.net/juju/2.3/2.3.6/+download/juju-setup-2.3.6-signed.exe
[juju-win-signed-md5]: https://launchpad.net/juju/2.3/2.3.6/+download/juju-setup-2.3.6-signed.exe/+md5
[juju-centos]: https://launchpad.net/juju/2.3/2.3.6/+download/juju-2.3.6-centos7.tar.gz
[juju-centos-md5]: https://launchpad.net/juju/2.3/2.3.6/+download/juju-2.3.6-centos7.tar.gz/+md5
[juju-launchpad-binaries]: https://launchpad.net/juju/+series
[centos-and-other-linuxes]: #centos-and-other-linuxes
