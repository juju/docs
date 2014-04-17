[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# Configure Proxy Access

Juju supports proxies and has special support for proxying apt. Proxies can be
configured for the providers in the environments.yaml file, or added to an
existing environment using `juju set-env` The configuration options are:

  - http-proxy
  - https-proxy
  - ftp-proxy
  - no-proxy

Each protocol-specific option accepts a URL. The `no-proxy` option is a list of
host names and addresses that services can directly connect to. For example:

    http-proxy: http://proxy.example.com:9000
    https-proxy: https://user@10.0.0.1
    no-proxy: localhost,10.0.3.1

There are three additional proxy options specific to apt. Juju's default
behaviour is to use the protocol-specific proxy options, but you can specify
exceptions for cases where the network has a local apt mirror.

  - apt-http-proxy
  - apt-https-proxy
  - apt-ftp-proxy

For example, with a squid-deb-proxy running on a laptop, you can specify the
apt-http-proxy to use it for the containers by specifying the host machine’s
network-bridge:

    apt-http-proxy: http://10.0.3.1:8000

The proxy options are exported in all hook execution contexts, and also
available in the shell through `juju ssh` or `juju run`.

  - ## [Juju](/)

    - [Charms](/charms/)
    - [Features](/features/)
    - [Deployment](/deployment/)
  - ## [Resources](/resources/)

    - [Overview](/resources/overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/communiy/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013-2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://www.canonical.com).

