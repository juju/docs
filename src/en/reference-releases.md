Title: Juju releases


# Get the Latest Juju

Juju is available for Ubuntu (and Debian-based OSes), CentOS, Microsoft Windows
and Apple OS X. 

There can be 3 concurrent releases representing the stability of Juju's feature
set: stable, proposed and development. 

Currently, with the recent release of Juju 2.0, all three channels contain the same
version of Juju.

Unless you are testing new features and fixes, choose the current stable
release to manage cloud deployments.

## Stable

The current stable version of Juju is 2.0.0.

Stable juju is suitable for everyday production use.

To install from Ubuntu:
```bash
sudo add-apt-repository ppa:juju/stable
sudo apt update
sudo apt install juju
```
CentOS:
: [juju-2.0.0-centos7.tar.gz](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-centos7.tar.gz)([md5](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-centos7.tar.gz/+md5))
{: .instruction }

OS X:
: [juju-2.0.0-osx.tar.gz](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-osx.tar.gz)([md5](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-osx.tar.gz/+md5))
{: .instruction }

Windows:
: [juju-setup-2.0.0.exe](https://launchpad.net/juju/2.0/2.0.0/+download/juju-setup-2.0.0.exe)([md5](https://launchpad.net/juju/2.0/2.0.0/+download/juju-setup-2.0.0.exe/+md5))
{: .instruction }


## Proposed

Current proposed version is 2.0.0, which is the same as stable (above).

Proposed releases may be promoted to stable releases after a period of
evaluation. They contain bug fixes and recently stabilised features. They
require evaluation from the community to verify no regressions are present. A
proposed version will not be promoted to stable if a regression is reported.

To install from Ubuntu:

```bash
sudo add-apt-repository ppa:juju/proposed
sudo apt update
sudo apt install juju
```

CentOS:
: [juju-2.0.0-centos7.tar.gz](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-centos7.tar.gz)([md5](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-centos7.tar.gz/+md5))
{: .instruction }

OS X:
: [juju-2.0.0-osx.tar.gz](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-osx.tar.gz)([md5](https://launchpad.net/juju/2.0/2.0.0/+download/juju-2.0.0-osx.tar.gz/+md5))
{: .instruction }

Windows:
: [juju-setup-2.0.0.exe](https://launchpad.net/juju/2.0/2.0.0/+download/juju-setup-2.0.0.exe)([md5](https://launchpad.net/juju/2.0/2.0.0/+download/juju-setup-2.0.0.exe/+md5))
{: .instruction }

If you wish to test applications deployed to mixed OSes and architectures, you
can pass "--config agent-stream=proposed" to the bootstrap command:

```bash
juju bootstrap cloud/region my-controller --config agent-stream=proposed
```

## Development

Current development version is 2.0.0, which is the same as proposed and stable (above).

The previous development release was 2.0-rc3.

Development releases provide new features that are being stabilised.
These releases are *not* suitable for production environments. Upgrading
from stable releases to development releases is not supported. You can
upgrade test environments to development releases to test new features
and fixes.

To install from Ubuntu:

```bash
sudo add-apt-repository ppa:juju/devel
sudo apt update
sudo apt install juju
```
or

```bash
snap install juju --beta --devmode
```

CentOS:
: [juju-core_2.0-rc3-centos7.tar.gz](https://launchpad.net/juju/2.0/2.0-rc3/+download/juju-core_2.0-rc3.tar.gz) ([md5](https://launchpad.net/juju/2.0/2.0-rc3/+download/juju-core_2.0-rc3.tar.gz/+md5))
{: .instruction }

OS X:
: [juju-core_2.0-rc3-osx.tar.gz](https://launchpad.net/juju/2.0/2.0-rc3/+download/juju-2.0-rc3-osx.tar.gz) ([md5](https://launchpad.net/juju/2.0/2.0-rc3/+download/juju-2.0-rc3-osx.tar.gz/+md5))
{: .instruction }

Windows:
: [juju-setup-2.0-rc3.exe](https://launchpad.net/juju/2.0/2.0-rc3/+download/juju-setup-2.0-rc3.exe) ([md5](https://launchpad.net/juju/2.0/2.0-rc3/+download/juju-setup-2.0-rc3.exe/+md5))
{: .instruction }

