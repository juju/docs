Title: Juju releases


# Get the Latest Juju

Juju is available for Ubuntu (and Debian-based OSes), Windows, and OS X.
There can be 3 concurrent releases representing the stability of Juju's
feature set. Unless you are testing new features and fixes, choose the
current stable release to manage cloud deployments.


## Stable

The current stable version of Juju is 1.25.6.

Stable juju is suitable for everyday production use.

Ubuntu
: <pre>sudo add-apt-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install juju-core</pre>
{: .instruction }

OS X Homebrew
: <pre>brew install juju</pre>
{: .instruction }

Centos
: [juju-1.25.6-centos7.tar.gz](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-centos7.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-centos7.tar.gz/+md5))
{: .instruction }

OS X
: [juju-1.25.6-osx.tar.gz](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-osx.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-1.25.6-signed.exe](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-setup-1.25.6-signed.exe) ([md5](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-setup-1.25.6-signed.exe/+md5))
{: .instruction }


## Proposed

Current proposed version is 1.25.6, which became stable.

Proposed releases may be promoted to stable releases after a period of
evaluation. They contain bug fixes and recently stablised features. They
require evaluation from the community to verify no regressions are
present. A proposed version will not be promoted to stable if a
regression is reported.

Ubuntu
: <pre>sudo add-apt-repository ppa:juju/proposed
sudo apt-get update
sudo apt-get install juju-core</pre>
{: .instruction }

Centos
: [juju-1.25.6-centos7.tar.gz](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-centos7.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-centos7.tar.gz/+md5))
{: .instruction }

OS X
: [juju-1.25.6-osx.tar.gz](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-osx.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-1.25.6-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-1.25.6.exe](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-setup-1.25.6.exe) ([md5](https://launchpad.net/juju-core/1.25/1.25.6/+download/juju-setup-1.25.6.exe/+md5))
{: .instruction }

Proposed releases use the 'proposed' simple-streams. You must configure
the 'agent-stream' option in your environments.yaml to use the matching
juju agents.

```no-highlight
agent-stream: proposed
```

## Development

2.0-beta16 is currently in development for testing.
The previous development release was 2.0-beta15.

Development releases provide new features that are being stablised.
These releases are *not* suitable for production environments. Upgrading
from stable releases to development releases is not supported. You can
upgrade test environments to development releases to test new features
and fixes.

Ubuntu
: <pre>sudo add-apt-repository ppa:juju/devel
sudo apt-get update
sudo apt-get install juju</pre>
{: .instruction }

or

: <pre>snap install juju --devmode --beta</pre>
{: .instruction }

Centos
: [juju-2.0-beta16-centos7.tar.gz](https://launchpad.net/juju-core/2.0/2.0-beta16/+download/juju-2.0-beta16-centos7.tar.gz) ([md5](https://launchpad.net/juju-core/2.0/2.0-beta16/+download/juju-2.0-beta16-centos7.tar.gz/+md5))
{: .instruction }

OS X
: [juju-2.0-beta16-osx.tar.gz](https://launchpad.net/juju-core/2.0/2.0-beta16/+download/juju-2.0-beta16-osx.tar.gz) ([md5](https://launchpad.net/juju-core/2.0/2.0-beta16/+download/juju-2.0-beta16-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-2.0-beta16.exe](https://launchpad.net/juju-core/2.0/2.0-beta16/+download/juju-setup-2.0-beta16.exe) ([md5](https://launchpad.net/juju-core/2.0/2.0-beta16/+download/juju-setup-2.0-beta16.exe/+md5))
{: .instruction }
