Title: Juju Releases


# Get the Latest Juju

Juju is available for Ubuntu (and Debian-based OSes), Windows, and OS X.
There can be 3 concurrent releases representing the stability of Juju's
feature set. Unless you are testing new features and fixes, choose the
current stable release to manage cloud deployments.


## Stable

The current stable version of Juju is 1.23.3.

Stable juju is suitable for everyday production use.

Ubuntu
: <pre>sudo add-apt-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install juju-core</pre>
{: .instruction }

OS X Homebrew
: <pre>brew install juju</pre>
{: .instruction }

OS X
: [juju-1.23.3-osx.tar.gz](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-1.23.3-osx.tar.gz) ([md5](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-1.23.3-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-1.23.3-signed.exe](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-setup-1.23.3-signed.exe) ([md5](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-setup-1.23.3-signed.exe/+md5))
{: .instruction }


## Proposed

Current proposed version is 1.23.3, which became the stable release.

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

OS X
: [juju-1.23.3-osx.tar.gz](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-1.23.3-osx.tar.gz) ([md5](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-1.23.3-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-1.23.3-signed.exe](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-setup-1.23.3.exe) ([md5](https://launchpad.net/juju-core/1.23/1.23.3/+download/juju-setup-1.23.3.exe/+md5))
{: .instruction }

Proposed releases use the 'proposed' simple-streams. You must configure
the 'agent-stream' option in your environments.yaml to use the matching
juju agents.

    agent-stream: proposed


## Development

1.24-beta4 is currently in development for testing.
The previous development release was 1.24-beta3.

Development releases provide new features that are being stablised.
These releases are *not* suitable for production environments. Upgrading
from stable releases to development releases is not supported. You can
upgrade test environments to development releases to test new features
and fixes.

Ubuntu
: <pre>sudo add-apt-repository ppa:juju/devel
sudo apt-get update
sudo apt-get install juju-core</pre>
{: .instruction }

OS X
: [juju-1.24-beta4-osx.tar.gz](https://launchpad.net/juju-core/1.24/1.24-beta4/+download/juju-1.24-beta4-osx.tar.gz) ([md5](https://launchpad.net/juju-core/1.24/1.24-beta4/+download/juju-1.24-beta4-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-1.24-beta4.exe](https://launchpad.net/juju-core/1.24/1.24-beta4/+download/juju-setup-1.24-beta4.exe) ([md5](https://launchpad.net/juju-core/1.24/1.24-beta4/+download/juju-setup-1.24-beta4.exe/+md5))
{: .instruction }

Development releases use the 'devel' simple-streams. You must configure
the 'agent-stream' option in your environments.yaml to use the matching
juju agents.

    agent-stream: devel
