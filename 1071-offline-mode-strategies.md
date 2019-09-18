<!--
Todo:
- Give an example of assigning multiple assertions to `snap-store-assertions`
-->
*This is in connection with the [Working offline](/t/working-offline/1072) page. See that resource for background information.*

This page provides an overview of various types of services that can be implemented in order for Juju to live happily in an internet-deprived environment. Common tools that can be used to achieve such services are also listed.

The services of concern here are:

- HTTP/S proxy
- APT proxy
- FTP proxy
- Juju-specific proxy
- Snap-specific proxy
- APT mirror
- Juju agent mirror
- Cloud image mirror

<h2 id="heading--https-proxy">HTTP/S proxy</h2>

The purpose of a forward HTTP/S proxy is to act as an intermediary for a client making any HTTP or HTTPS request. For our purposes, the client is a Juju machine.

Most such proxies include a *caching* ability. That is, the proxy will store the resulting data locally so that any subsequent request can be quickly satisfied.

The de-facto forward proxy solution on Ubuntu is [`squid`](http://www.squid-cache.org/).

Juju uses options `http-proxy` and `https-proxy` to denote these proxies.

<h3 id="heading--no-https-proxy">No HTTP/S proxy</h3>

When an HTTP/S proxy is configured there may be destinations that should be excluded from using it.

Juju uses option `no-proxy` to represent these destinations.

In general, all instances within a cloud should be able to communicate directly with one another. It may, or it may not, be necessary to express this via the `no-proxy` variable. This is because the latter is limited to the HTTP and HTTPS protocols, which may not apply in every case. Nevertheless, it is often done out of simplicity.

<h4 id="heading--no-proxy-and-the-localhost-cloud">No proxy and the localhost cloud</h4>

This "no proxy" idea is often used extensively with the localhost cloud at both the (shell) environment level and at the Juju level. The purpose being to ensure the client can connect with the local controller and that the local machines can inter-communicate, all without going through a proxy.

Hosts to exclude from the proxy include:

- localhost & 127.0.0.1 (standard 'no proxy' settings)
- the address assigned to the regular Ethernet device
- the address assigned to the host's LXD bridge (to talk to the controller via its API)
- the entire subnet dedicated to the particular LXD installation

Page [Using the localhost cloud offline](/t/using-the-localhost-cloud-offline/1070) demonstrates how this is done.

<h2 id="heading--apt-proxy">APT proxy</h2>

An HTTP/S or FTP proxy may not be configured to accept requests for APT packages. An APT proxy is identical to that of an HTTP/S or FTP proxy except that it applies specifically to APT package requests.

Some common implementations include:

-   [`APT-cacher`](https://help.ubuntu.com/community/Apt-Cacher-Server)
-   [`Apt-Cacher NG`](https://www.unix-ag.uni-kl.de/~bloch/acng/)
-   [`squid`](http://www.squid-cache.org/)
-   [`squid-deb-proxy`](https://launchpad.net/squid-deb-proxy) (based on squid)

Juju uses options `apt-ftp-proxy`, `apt-http-proxy`, and `apt-https-proxy` to set these proxies, depending on the protocol involved (i.e. FTP, HTTP, or HTTPS).

<h2 id="heading--ftp-proxy">FTP proxy</h2>

A standard FTP proxy. Juju uses the `ftp-proxy` option for this type of proxy.

<h2 id="heading--juju-specific-proxy">Juju-specific proxy</h2>

The following suite of proxy settings have a Juju-only scope (i.e. they are not system-wide):

`juju-ftp-proxy`
`juju-http-proxy`
`juju-https-proxy`
`juju-no-proxy`

They are passed to charm hook contexts as the following environment variables, respective to the above list:

JUJU_CHARM_FTP_PROXY
JUJU_CHARM_HTTP_PROXY
JUJU_CHARM_HTTPS_PROXY
JUJU_CHARM_NO_PROXY

[note type="caution"]
These Juju-specific proxy settings are incompatible with the four corresponding legacy proxy settings described in earlier sections. Data validation is enabled to prevent collisions from occurring.
[/note]

One big benefit of using these finely-scoped settings is that `juju-no-proxy` can contain subnets (in CIDR notation) whereas its legacy counterpart cannot.

[note]
Work is underway to introduce further granularity that will allow specific libraries (e.g. `charm-helpers`) to enable a proxy setting on a per-call basis.
[/note]

<h2 id="heading--snap-specific-proxy">Snap-specific proxy</h2>

The following suite of proxy settings have a Snap-only scope:

`snap-http-proxy`
`snap-https-proxy`
`snap-store-assertions`
`snap-store-proxy`

The first two provide the standard HTTP and HTTPS proxy values for `snapd` running on a machine.

The second two are for a local snap store. Key `snap-store-proxy` is a 32-character alphanumeric key that identifies the store (i.e. its ID). Key `snap-store-assertions` is a collection of digitally signed documents that express a fact or policy about an object in the snap universe.

Here is a sample assertion:

``` text
type: store
authority-id: canonical
store: YDBQvAwC2CfJElRq2XGkqcjR4bA9yNr2
operator-id: eJ8VwwkInXdLo5nIgoSKH8j95qs6BQ7D
timestamp: 2017-11-24T12:10:19.881852Z
url: http://firestorm.local
sign-key-sha3-384: BWDEoaqyr25nF5SNCvEv2v7QnM9QsfCc0PBMYD_i2NGSQ32EF2d4D0hqUel3m8ul

AcLBUgQAAQoABgUCWhgMKwAA3gYQAK68FSpGO3MQTOHuXar15Te7nf7RKa/5gJR2jIDf45XSVhYt
fsWdX5yEaRwoXWor84Tesm1XtYodyNRbBAKmz7a/1/tT105UxtnflO1Y42Yb4AliFtvW7Sc1eHO3
pg/ZAhx/2LmchBFJURon+vWi/scCr6GkUoQ+xNvCQpA0hWPfD4BnS5TJjhiA8PyGQWTLmyms5jbK
5AhIdogFKpPfmeaSCgSjz2OsMMJYQO639A2gmoT2zSHqJs4+/bTb2Oq4j08Am7Wv28vyVglWdedc
QKZuBJ/sepmZzHcWHNb65z3+KT+VC12LLQd/I+SxUkTsBNKC1mwpY39PrAsJDMCltxCepKmti0T6
hwYCYrrA6vBXjqoSRyW/YzDKRB0VpN3GwCE/1DmuxNFN2CUn4SM+q+SYmCuIaoDCmMyk6P9jrHyv
JO8V/ctnZ0FvdrwnXFQDH6HY5rojjyEyjlZo6M8H2SunLX0u/goVh38D8o0bEmX/cZEKtTZx7ml+
lxDMSobdfIYPBl4FjVGHY+Zkdso0xQjctG1nNhkeYJQswLqfHEEdwaeCyGBh42cQfFLqxd0qK36M
M49U7JumoWH6aclbo0RXGKDI9vsBRnmOOaCUus9gbbrNUs6MTst+RCPXqXPi4tzbTtRAY5jd8LWv
9/ZUS/A2VSNUaiKvfdzG6cnzr72R
```

Note that the assertion contains the store ID (e.g. field 'store'). See the [Snapcraft documentation](https://forum.snapcraft.io/t/assertions/6155) for details.

Assign such data to key `snap-store-assertions` by first placing it into a YAML-formatted file, say `assertion.yaml`, and then proceeding as follows:

``` text
juju model-config assertion.yaml
```

The file contents look like this:

``` yaml
snap-store-assertions: |-
  type: store
  authority-id: canonical
  store: YDBQvAwC2CfJElRq2XGkqcjR4bA9yNr2
  operator-id: eJ8VwwkInXdLo5nIgoSKH8j95qs6BQ7D
  timestamp: 2017-11-24T12:10:19.881852Z
  url: http://firestorm.local
  sign-key-sha3-384: BWDEoaqyr25nF5SNCvEv2v7QnM9QsfCc0PBMYD_i2NGSQ32EF2d4D0hqUel3m8ul
  
  AcLBUgQAAQoABgUCWhgMKwAA3gYQAK68FSpGO3MQTOHuXar15Te7nf7RKa/5gJR2jIDf45XSVhYt
  fsWdX5yEaRwoXWor84Tesm1XtYodyNRbBAKmz7a/1/tT105UxtnflO1Y42Yb4AliFtvW7Sc1eHO3
  pg/ZAhx/2LmchBFJURon+vWi/scCr6GkUoQ+xNvCQpA0hWPfD4BnS5TJjhiA8PyGQWTLmyms5jbK
  5AhIdogFKpPfmeaSCgSjz2OsMMJYQO639A2gmoT2zSHqJs4+/bTb2Oq4j08Am7Wv28vyVglWdedc
  QKZuBJ/sepmZzHcWHNb65z3+KT+VC12LLQd/I+SxUkTsBNKC1mwpY39PrAsJDMCltxCepKmti0T6
  hwYCYrrA6vBXjqoSRyW/YzDKRB0VpN3GwCE/1DmuxNFN2CUn4SM+q+SYmCuIaoDCmMyk6P9jrHyv
  JO8V/ctnZ0FvdrwnXFQDH6HY5rojjyEyjlZo6M8H2SunLX0u/goVh38D8o0bEmX/cZEKtTZx7ml+
  lxDMSobdfIYPBl4FjVGHY+Zkdso0xQjctG1nNhkeYJQswLqfHEEdwaeCyGBh42cQfFLqxd0qK36M
  M49U7JumoWH6aclbo0RXGKDI9vsBRnmOOaCUus9gbbrNUs6MTst+RCPXqXPi4tzbTtRAY5jd8LWv
  9/ZUS/A2VSNUaiKvfdzG6cnzr72R
```

<h2 id="heading--apt-mirror">APT mirror</h2>

Instead of proxying client requests to an internet-based repository it is possible to maintain the repository internally. That is, you can have a copy or *mirror* of an Ubuntu package repository. This option has a large storage requirement and the initial setup/download time is considerable. Regular mirror synchronization will also be needed.

Here are some popular mirroring solutions:

-   [`apt-mirror`](https://apt-mirror.github.io/)
-   [`debmirror`](http://manpages.ubuntu.com/cgi-bin/search.py?q=debmirror)
-   [`aptly`](https://www.aptly.info/)

Juju uses the `apt-mirror` option for this.

<h3 id="heading--https-server">HTTP/S server</h3>

For any sort of mirror, an HTTP/S server (i.e. a web server) will be required to respond to the actual client requests. These are the most common ones:

-   [`Apache`](https://www.apache.org/)
-   [`nginx`](https://www.nginx.com/resources/wiki/)
-   [`lighttpd`](https://www.lighttpd.net/)

<h2 id="heading--juju-agent-mirror">Juju agent mirror</h2>

An agent that gets installed onto a Juju machine is proxied through the controller. If the latter cannot satisfy the request via its cache it will download the agent from the [official agent site](https://streams.canonical.com/juju/tools/agent/), and then pass it on to the machine. It is possible, however, to set up an agent mirror so the remote site is not solicited by the controller. Download the latest few agents and configure one of the aforementioned web servers accordingly. Updates to the mirrored agents will be needed as new versions of Juju itself become available.

Agent downloads can be performed manually from the above site where, for example, the file `juju-2.3.1-ubuntu-amd64.tgz` is the 2.3.1 agent for all Ubuntu releases for the AMD64 architecture.

Downloads can also be made with the `juju sync-agent-binaries` command. Note that this method results in a larger download as only the major and minor version numbers can be specified (e.g. 2.3 and not 2.3.1) and all architectures are retrieved. Additionally, there will be a file for every Ubuntu release even though they are all identical (e.g. `juju-2.3.1-xenial-amd64.tgz` == `juju-2.3.1-bionic-amd64.tgz`). Each one of these files is approximately 27 MiB in size.

Below, all 2.3 agents are retrieved and placed into a local directory:

``` text
mkdir -p /home/ubuntu/tmp/agents
juju sync-agent-binaries --version 2.3 --local-dir=/home/ubuntu/tmp/agents-2.3
```

[note]
Once the agents are downloaded, the `juju sync-agent-binaries` command can also be used to push them to a model, thereby foregoing the need for a mirror.
[/note]

<h2 id="heading--cloud-images-mirror">Cloud images mirror</h2>

A mirror can be made of the [official cloud images](http://cloud-images.ubuntu.com/) (`http://cloud-images.ubuntu.com`). This will primarily be useful for a localhost cloud (LXD) but a local OpenStack installation can also make use of such a mirror if LXD containers are put on its instances.

<!-- LINKS -->
