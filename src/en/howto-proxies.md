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

```yaml
http-proxy: http://proxy.example.com:9000
https-proxy: https://user@10.0.0.1
no-proxy: localhost,10.0.3.1
```

There are three additional proxy options specific to apt. Juju's default
behaviour is to use the protocol-specific proxy options, but you can specify
exceptions for cases where the network has a local apt mirror.

  - apt-http-proxy
  - apt-https-proxy
  - apt-ftp-proxy

For example, with a squid-deb-proxy running on a laptop, you can specify the
apt-http-proxy to use it for the containers by specifying the host machine’s
network-bridge:

```yaml
apt-http-proxy: http://10.0.3.1:8000
```

The proxy options are exported in all hook execution contexts, and also
available in the shell through `juju ssh` or `juju run`.
