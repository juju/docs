Title: Management tasks; Miscellaneous

# Miscellaneous management tasks


## Manage access with authorised SSH keys

Juju's SSH key management allows people other than the person who bootstrapped
an environment to ssh into Juju machines. This is achieved with the
`juju authorised-keys` command.

For syntax use `juju authorised-keys --help` or `juju authorised-keys
<sub-command> --help` or see the
[command reference page](./commands.html#user).

Import a public SSH key from Launchpad (or Github):

```bash
juju authorised-keys import lp:some_launchpad_user
```

Or add an ssh key (for an environment without internet access):

```bash
juju authorised-keys import 'ssh-rsa AAAAB3NzaC1... comment'
# you can also use something like this:
juju authorised-keys import "$(cat id_rsa.pub)"
```

Use the key fingerprint or comment to specify which key to `delete`. The
fingerprint can be found with:

```bash
ssh-keygen -l -f <public or private key file>
```

When Juju adds/imports a key, the string "Juju:" will be prefixed to the key's
comment. Juju can only manage (`list` or `delete`) the keys which it has
added/imported.

Keys grant access to all machines. When a key is added, it is propagated to all
machines in the environment, even those created prior to the addition of the
key. When a key is deleted, it is removed from all machines.


## Configure Proxy Access

Juju supports proxies and has special support for proxying APT. Proxies can be
configured for the providers in the environments.yaml file, or added to an
existing environment using `juju set-env`. The configuration options are:

- http-proxy
- https-proxy
- ftp-proxy
- no-proxy

Each protocol-specific option accepts a URL. The `no-proxy` option is a list of
host names and addresses that applications can directly connect to. For example:

```yaml
http-proxy: http://proxy.example.com:9000
https-proxy: https://user@10.0.0.1
no-proxy: localhost,10.0.3.1
```

There are three additional proxy options specific to APT. Juju's default
behaviour is to use the protocol-specific proxy options, but you can specify
exceptions for cases where the network has a local APT mirror.

- apt-http-proxy
- apt-https-proxy
- apt-ftp-proxy

For example, with `squid-deb-proxy` and containers running on a laptop, you can
use apt-http-proxy by specifying the host machine’s network-bridge:

```yaml
apt-http-proxy: http://10.0.3.1:8000
```

The proxy options are exported in all hook execution contexts, and also
available in the shell through `juju ssh` or `juju run`.


## Inspect API connection settings

The `juju api-info` command shows the settings used to connect to the Juju
state-server's API. You can see the settings for all the fields (except for
password) like so:

```bash
juju api-info
```

If you want to see the password being used, you need to either use the
"--password" option:

```bash
juju api-info --password
```

or specify the password field as the only field to show:

```bash
juju api-info password
```

You can learn the value of any field by including it in the command line. For
example, to discover the name of user created during the bootstrap stage, type:

```bash
juju api-info user
```

Recall that you can specify the environment:

```bash
juju api-info user -e local-env
```
