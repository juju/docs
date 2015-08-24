# Deploying Charms Offline

Many private clouds have no direct access to the internet due to security
reasons.

In these cases it's useful to maintain a copy of the internet-accessible
Charm Store for your local deployments.

!!! Note: Though this method will ensure that the charms themselves are
available on systems without outside internet access, there is no
guarantee that a charm will work in a disconnected state. Some charms
pull code from the outside world, such as github. We recommend modifying
these charms to pull code from an internal server when appropriate.

## Retrieving charms using the Charm Tools

### Installation

In addition to [Juju](getting-started#installation) we need
to install charm-tools:

```bash
sudo apt-get update && sudo apt-get install charm-tools
```

### Usage

The Charm Tools comes packaged as both a stand alone tool and a juju plugin.
So you simply can call it with `charm` or as usual for Juju commands with
`juju charm`.

There are several tools available within the Charm Tools itself. At any time
you can run `juju charm` to view the available subcommands and all subcommands
have independent help pages, accessible using either the `-h` or `--help` flags.

If you want to retrieve and branch one of the charm store charms, use the `get`
command specifying the `CHARM_NAME` you want to copy and provide an optional
`CHARMS_DIRECTORY`. Otherwise the current directory will be used.

```bash
juju charm get [-h|--help] CHARM_NAME [CHARMS_DIRECTORY]
```

### Example

The command

```bash
juju charm get mysql
```

will download the MySQL charm to a `mysql` directory within your current path.
By running

```bash
juju charm get wordpress ~/charms/precise/
```

You will download the WordPress charm to `~/charms/precise/wordpress`. It is
also possible to fetch all official charm store charms. The command for this
task is:

```bash
juju charm getall [-h|--help] [CHARMS_DIRECTORY]
```

The retrieved charms will be placed in the `CHARMS_DIRECTORY`, or your current
directory if no `CHARMS_DIRECTORY` is provided. This command can take quite a
while to complete - there are a lot of charms!

### Deploying from a local repository

There are many cases when you may wish to deploy charms from a local filesystem
source rather than the charm store:

  - When testing charms you have written.
  - When you have modified store charms for some reason.
  - When you don't have direct internet access.

... and probably a lot more times which you can imagine yourselves.

Juju can be pointed at a local directory to source charms from using the
`--repository=<path/to/files>` switch like this:

```bash
juju deploy --repository=/usr/share/charms/ local:trusty/vsftpd
```

The `--repository` switch can be omitted when shell environment
defines `JUJU_REPOSITORY` like so:

```bash
export JUJU_REPOSITORY=/usr/share/charms/
juju deploy local:trusty/vsftpd
```

You can also make use of standard filesystem shortcuts, if the environment
specifies the `default-series`. The following examples will deploy the trusty
charms in the local repository when `default-series` is set to trusty:

```bash
juju deploy --repository=. local:haproxy
juju deploy --repository ~/charms/ local:wordpress
```

The `default-series` can be specified in `environments.yaml` thusly:

```no-highlight
default-series: precise
```

The default-series can also be added to any bootstrapped environment with
the `set-env` command:

```bash
juju set-env "default-series=trusty"
```

!!! Note: Specifying a local repository makes Juju look there *first*, but if
the relevant charm is not found in that repository, it will fall back to
fetching it from the charm store. If you wish to check where a charm was
installed from, it is listed in the `juju status` output.
