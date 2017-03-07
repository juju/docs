Title: Juju releases


# Get the Latest Juju 1.x

Juju is available for Ubuntu (and Debian-based OSes), Windows, and MacOS.
There can be 2 concurrent releases representing the stability of Juju's
feature set. Unless you are testing new features and fixes, choose the
current stable release to manage cloud deployments.


## Stable

The current stable version of Juju 1.x is 1.25.10.

Stable juju 1.x is suitable for everyday production use.

Ubuntu
: <pre>sudo add-apt-repository ppa:juju/1.25
sudo apt-get update
sudo apt-get install juju-core</pre>
{: .instruction }

OS X Homebrew
: <pre>brew install juju@1.25</pre>
{: .instruction }

Centos
: [juju-1.25.10-centos7.tar.gz](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-centos7.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-centos7.tar.gz/+md5))
{: .instruction }

MacOS
: [juju-1.25.10-osx.tar.gz](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-osx.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-1.25.10-signed.exe](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-setup-1.25.10-signed.exe) ([md5](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-setup-1.25.10-signed.exe/+md5))
{: .instruction }


## Proposed

Current proposed version is 1.25.10, which became stable.

Proposed releases may be promoted to stable releases after a period of
evaluation. They contain bug fixes and recently stablised features. They
require evaluation from the community to verify no regressions are
present. A proposed version will not be promoted to stable if a
regression is reported.

Ubuntu
: <pre>sudo add-apt-repository ppa:juju/1.25-proposed
sudo apt-get update
sudo apt-get install juju-core</pre>
{: .instruction }

Centos
: [juju-1.25.10-centos7.tar.gz](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-centos7.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-centos7.tar.gz/+md5))
{: .instruction }

MacOS
: [juju-1.25.10-osx.tar.gz](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-osx.tar.gz) ([md5](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-1.25.10-osx.tar.gz/+md5))
{: .instruction }

Windows
: [juju-setup-1.25.10.exe](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-setup-1.25.10.exe) ([md5](https://launchpad.net/juju-core/1.25/1.25.10/+download/juju-setup-1.25.10.exe/+md5))
{: .instruction }

Proposed releases use the 'proposed' simple-streams. You must configure
the 'agent-stream' option in your environments.yaml to use the matching
juju agents.

```no-highlight
agent-stream: proposed
```

