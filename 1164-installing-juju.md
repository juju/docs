Stable versions of Juju are available on Ubuntu, various other Linux distributions, macOS, and Windows. Development releases are also available for testing.

## Version 2.6.9

The most recent stable version of Juju is 2.6.9. This is the version we recommend for production use. See the [Release Notes](https://discourse.jujucharms.com/t/juju-2-6-9-release-notes/2100).

<h3 id="heading--ubuntu">Ubuntu</h3>

The recommended way to install Juju is with a [snap](https://snapcraft.io). Nevertheless, installing [Juju via a PPA](https://help.launchpad.net/PPA) is still supported and is mentioned lower down.

<h4 id="heading--as-a-snap">As a snap</h4>

Juju can be installed with the following command:

```text
sudo snap install juju --classic
```

This will track the `stable` snap channel. Other channels are available, as described on [Juju's snapcraft page](http://snapcraft.io/juju).

[note]
If you're using Ubuntu 14.04 LTS (Trusty Tahr), then you will need to install `snapd` before installing Juju. To do this, execute `sudo apt install snapd` and then reboot your computer.

Rebooting is necessary as a your computer's Linux kernel will be updated to the 4.4.0 series.
[/note]

<h4 id="heading--using-a-ppa">Using a PPA</h4>

To install the most recent stable version using a PPA:

```text
sudo add-apt-repository -yu ppa:juju/stable
sudo apt install juju
```

<h3 id="heading--centos-and-other-linuxes">CentOS and other Linuxes</h3>

Juju can be installed on various Linux distributions via snaps. On Ubuntu snapd comes pre-installed but if you're running something else you'll need to visit [Install snapd](https://snapcraft.io/docs/core/install) to get started.

You can now install Juju with:

```text
sudo snap install juju --classic
```

[note]
In the advent that option `--classic` is not supported on your chosen distro, use the `--devmode` option.
[/note]

For CentOS, download Juju and install it manually: [**juju-2.6.9-centos7.tar.gz**](https://launchpad.net/juju/2.6/2.6.9/+download/juju-2.6.9-centos7.tar.gz) ([md5](https://launchpad.net/juju/2.6/2.6.9/+download/juju-2.6.9-centos7.tar.gz/+md5))

<h3 id="heading--macos">macOS</h3>

Install Juju on macOS with [Homebrew](https://brew.sh/). Simply enter the following into a terminal:

```text
brew install juju
```

And upgrade Juju with the following:

```text
brew upgrade juju
```

<h3 id="heading--windows">Windows</h3>

For Windows, an installer is available: [**juju-setup-2.6.9-signed.exe**](https://launchpad.net/juju/2.6/2.6.9/+download/juju-setup-2.6.9-signed.exe) ([md5](https://launchpad.net/juju/2.6/2.6.9/+download/juju-setup-2.6.9-signed.exe/+md5))

<h2 id="heading--development-releases">Development releases</h2>

Development releases (alpha, beta, rc) are regularly published and we encourage users to test these versions with real workloads and use cases. We kindly ask you to [file a bug](https://bugs.launchpad.net/juju/+filebug) when encountering an issue. Feedback on usability and missing functionality is also very important to us.

<h3 id="heading--using-snaps">Using snaps</h3>

See [above](#heading--centos-and-other-linuxes) for how to get started with snaps if you're running a non-Ubuntu Linux distro.

To install a development release using snaps, instead of the 'stable' channel, use the 'beta' channel:

```text
sudo snap install juju --beta --classic
```

For a cutting edge experience choose the 'edge' channel:

```text
sudo snap install juju --edge --classic
```

To upgrade or downgrade, use the `refresh` command with a suitable channel.
Below we install 'edge' and then downgrade to 'beta':

```text
sudo snap install juju --edge --classic
sudo snap refresh juju --beta
```

<h3 id="heading--using-a-ppa">Using a PPA</h3>

To install the development version using a PPA:

```text
sudo add-apt-repository -yu ppa:juju/devel
sudo apt install juju
```

[note]
The alpha builds are only available with snaps (via the 'edge' channel).
[/note]

<h3 id="heading--installing-multiple-juju-series">Installing multiple Juju series</h3>

Some environments may see the need to run both the 1.x and the 2.x series of Juju concurrently. See page [Running multiple versions of Juju](/t/running-multiple-versions-of-juju/1143) for guidance.

<h3 id="heading--other-platforms">Other platforms</h3>

All development release binaries are published on [Launchpad](https://launchpad.net/juju/+series). Note that leading edge builds are only available with snaps (via the 'edge' channel).

<h2 id="heading--juju-plugins">Juju plugins</h2>

Juju functionality can be extended through the use of plugins. See the [Juju plugins](/t/juju-plugins/1145) page for information.

<h2 id="heading--building-from-source">Building from source</h2>

Refer to the [Contributing](https://github.com/juju/juju/blob/develop/CONTRIBUTING.md) documentation in the codebase for instructions on how to build Juju from source.
