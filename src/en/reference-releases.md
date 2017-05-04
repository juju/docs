Title: Installing Juju
TODO: Test other distros with snap install


# Get the Latest Juju

Juju is available as a client on many platforms and distributions. Find your
platform below and get started with Juju!


## Stable

The current stable version of Juju is 2.1.2.

Stable Juju is suitable for everyday production use.

On Ubuntu, the easiest way to install Juju is from a [*snap*][snappy]:

```bash
sudo snap install juju --classic
```

You can also install Juju using `apt` by adding the following PPA:

```bash
sudo add-apt-repository --update ppa:juju/stable
sudo apt install juju
```

macOS:

The easiest way to install Juju on macOS is with the [`brew`][brew] package
manager. With `brew` installed, simply enter the following into a terminal:

CentOS:
: [juju-2.1.2-centos7.tar.gz](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-centos7.tar.gz)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-centos7.tar.gz/+md5))
{: .instruction }

Windows:
: [juju-setup-2.1.2.exe](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe/+md5))
{: .instruction }


```bash
brew install juju
```
If you previously installed Juju with `brew`, the package can be updated with
the following:

```bash
brew upgrade juju
```

Alternatively, you can manually install Juju from the following archive:
: [juju-2.1.2-osx.tar.gz](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-osx.tar.gz)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-osx.tar.gz/+md5))
{: .instruction }

## Getting development releases


Current proposed version is 2.1.2, which is the same as stable (above).

Proposed releases may be promoted to stable releases after a period of
evaluation. They contain bug fixes and recently stabilised features. They
require evaluation from the community to verify no regressions are present. A
proposed version will not be promoted to stable if a regression is reported.

To install from Ubuntu:

```bash
sudo add-apt-repository --update ppa:juju/proposed
sudo apt install juju
```

CentOS:
: [juju-2.1.2-centos7.tar.gz](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-centos7.tar.gz)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-centos7.tar.gz/+md5))
{: .instruction }

Windows:
: [juju-setup-2.1.2.exe](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe/+md5))
{: .instruction }

macOS:
: [juju-2.1.2-osx.tar.gz](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-osx.tar.gz)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-2.1.2-osx.tar.gz/+md5))
{: .instruction }

If you wish to test applications deployed to mixed OSes and architectures, you
can pass "--config agent-stream=proposed" to the bootstrap command:

```bash
juju bootstrap cloud/region my-controller --config agent-stream=proposed
```

## Development

Current development version is 2.2-beta3.

Development releases provide new features that are being stabilised.
These releases are *not* suitable for production environments. Upgrading
from stable releases to development releases is not supported. You can
upgrade test environments to development releases to test new features
and fixes.

On Ubuntu, the easiest way to install the development release of Juju is from a
[*snap*][snappy]:

```bash
sudo snap install juju --beta --classic
```

You can also install the development release using `apt` by adding the following PPA:

```bash
sudo add-apt-repository --update ppa:juju/devel
sudo apt install juju
```

CentOS:
: [juju-core_2.2-beta3-centos7.tar.gz](https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-2.2-beta3-centos7.tar.gz) ([md5](https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-2.2-beta3-centos7.tar.gz/+md5))
{: .instruction }

Windows:
: [juju-setup-2.2-beta3.exe](https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-setup-2.2-beta3.exe) ([md5](https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-setup-2.2-beta3.exe/+md5))
{: .instruction }

macOS:
: [juju-core_2.2-beta3-osx.tar.gz](https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-2.2-beta3-osx.tar.gz) ([md5](https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-2.2-beta3-osx.tar.gz/+md5))
{: .instruction }

The easiest way to install Juju on macOS is with the [`brew`][brew] package
manager. With `brew` installed, simply enter the following into a terminal:

```bash
brew install --devel juju
```

<!-- LINKS -->
[snappy]: https://snapcraft.io/
[brew]: http://brew.sh/
