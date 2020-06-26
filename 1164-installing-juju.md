<!--
ARE YOU UPDATING THIS DOCUMENT WITH A NEW RELEASE?

Ctrl+F "LINKS TO CHANGE"
-->

Installing Juju is easy. It is a single binary executable that is supported on multiple operating systems and CPU architectures.

Here are the most common installation methods:

| Operating System | Recommended installation method  |
|--|--|
| MS Windows | Download and run the [installer][windows-installer] |
| macOS | `$ brew install juju` |
| Linux | `$ snap install --classic juju` |

Read the rest of this page for more options.

# Installing Juju's most recent stable release

Instructions differ for each operating system:

* [Linux](#heading--linux)
* [MS Windows](#heading--windows)
* [macOS](#heading-macos)


<h2 id="heading--windows">Windows</h2>

Download and run the [signed installer][windows-installer] ([md5][windows-installer-md5], [crytographic signature][windows-installer-sig]).


<h2 id="heading--linux">Linux</h2>

Juju can be installed with the following command:

```text
sudo snap install juju --classic
```

[note status="snap command not available?"]
If you do not have snap installed, visit [snapcraft.io for instructions](https://snapcraft.io/docs/installing-snapd). 
[/note]

<h3 id="heading--macos">macOS</h3>

Install Juju on macOS with [Homebrew](https://brew.sh/). Run the following command into Terminal:

```text
brew install juju
```

## Alternative installation methods

If you would prefer to avoid a snap-based installation, there are alternatives. 

<h3 id="heading--using-a-ppa">Using a Personal Package Archive (PPA)</h3>

To install the most recent stable version using a PPA:

```text
sudo add-apt-repository -yu ppa:juju/stable
sudo apt install juju
```

### Manual installation

Visit the [downloads section][lp-juju-downloads] of the [Launchpad project][lp-juju]. You will see an archive (with the .tar.gz) extension available with Juju's source code. To build this source code, refer to the [Contributing](https://github.com/juju/juju/blob/develop/CONTRIBUTING.md).

[note status="Using CentOS?"]
Download Juju and install an [archive of Juju][centos-manual] ([md5][centos-manual-md5]) built specifically for that distribution.
[/note]


<h1 id="heading--development-releases">Installing Juju development releases</h1>

## Linux

We recommend that you install Juju via the snap and track the edge channel:

```text
sudo snap install juju --classic
sudo snap refresh juju --edge
```

<h3 id="heading--using-a-ppa">Using a PPA</h3>

To install the development version using a PPA:

```text
sudo add-apt-repository -yu ppa:juju/devel
sudo apt install juju
```


<h3 id="heading--other-platforms">Other platforms</h3>

All development release binaries are published on [Launchpad](https://launchpad.net/juju/+series).


# Further information

### Finding release notes

[Release notes][] are available on Discourse.

<h3 id="heading--installing-multiple-juju-series">Installing multiple Juju series</h3>

Some environments may see the need to run both the 1.x and the 2.x series of Juju concurrently. See page [Running multiple versions of Juju](/t/running-multiple-versions-of-juju/1143) for guidance.

<h2 id="heading--juju-plugins">Juju plugins</h2>

Juju functionality can be extended through the use of plugins. See the [Juju plugins](/t/juju-plugins/1145) page for information.



<!-- LINKS TO CHANGE -->

[Release notes]: https://discourse.juju.is/t/juju-2-8-0-release-notes/3180
[centos-manual]: https://launchpad.net/juju/2.8/2.8.0/+download/juju-2.8.0-centos7.tar.gz
[centos-manual-md5]: https://launchpad.net/juju/2.8/2.8.0/+download/juju-2.8.0-centos7.tar.gz/+md5
[windows-installer]: https://launchpad.net/juju/2.7/2.7.6/+download/juju-setup-2.7.6-signed.exe
[windows-installer-md5]: https://launchpad.net/juju/2.7/2.7.6/+download/juju-setup-2.7.6-signed.exe/+md5
[windows-installer-sig]: https://launchpad.net/juju/2.7/2.7.6/+download/juju-setup-2.7.6-signed.exe.asc
[lp-juju]: https://launchpad.net/juju/
[lp-juju-downloads]: https://launchpad.net/juju/+download
