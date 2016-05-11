Title: Deploying charms offline  
TODO: See whether it is still possible to download all charms (marco ignored me
        on irc)
      Downloading charms is shabby. See https://git.io/vwNLI . I therefore
        ommitted the "feature" of specifying a download dir
      Review specifying 'default-series' key at model level in conjunction with
        deploying local and non-local charms. I detected flakiness.
      Review whether Juju should go to the store when pointing to a local dir
        with non-existant charm. It did not for me but the old version of this
        doc said it should.


# Deploying charms offline

There are times when it may not be possible to use the charms located in the
official Charm Store. Such cases include:

- The backing cloud may be private and not have internet access.
- The charms may not exist online. They are newly-written charms.
- The charms may exist online but they have been customized locally.

This page will explain how to manage local Juju charms.

!!! Note: Although this method will ensure that the charms themselves are
available on systems without outside internet access, there is no guarantee
that a charm will work in a disconnected state. Some charms pull code from the
internet, such as GitHub. We recommend modifying these charms to pull code from
an internal server instead.


## Using Charm Tools

Charm Tools is a set of tools necessary when using Juju with locally stored charms.

See [Charm Tools](https://jujucharms.com/docs/devel/tools-charm-tools) for more
information.

### Installation

Users of Ubuntu 14.04 (Trusty) will need to first add a PPA:

```bash
sudo add-apt-repository ppa:juju/stable
sudo apt update
```

Install the software:

```bash
sudo apt install charm-tools
```

### Usage

Charm commands are called with `charm <subcommand>`.

The command `charm-help` is used to view the available subcommands. Each
subcommand has its own help page, which is accessible by adding either the `-h`
or `--help` option:

```bash
charm add --help
```

When downloading charms, they end up in a directory with the same name as the
charm. It is therefore a good idea to work from a central directory. For
example, to download the MySQL and the WordPress charms:

```bash
mkdir ~/charms
cd ~/charms
charm pull nfs
charm pull vsftpd
```

### Deploying from a local charm

To deploy services using local charms, specify the path to the charm directory.
For example, to deploy vsftpd from above (on Trusty):

```bash
juju deploy ~/charms/vsftpd --series trusty
```

The series does not require stating if the model configuration specifies a
value for key `default-series`. For example:

```bash
juju set-model-config -m mymodel default-series=trusty
```

See [Configuring models](./models-config.md) for details on model level
configuration.
