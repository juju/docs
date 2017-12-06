Title: Deploying Charms Offline

# Deploying charms offline

*This page is concerned with using Juju charms offline. See the
[Working offline][charms-offline] page for background information.*

Clouds that do not enjoy a connection to the internet can nonetheless make use
of Juju charms provided that local copies of the charms are prepared in
advance.

These instructions are concerned strictly with how to obtain local copies of
Juju charms. In particular, they do not take into account:

 - how individual charms may be adversely affected when deployed in an offline
   context. For instance, some charms download files from internet-based
   sources (e.g. GitHub). In such cases, the charm must be appropriately
   modified prior to usage.

 - other required cloud ingredients such as operating system (or container)
   images.

There are also scenarios where the charms are **only** available locally, such
as:

 - The charms are newly-written and have not been published online.
 - The charms exist online but they have been customized locally.

## Maintaining charms locally with Charm Tools

For the situation when the charms are not already available locally, the steps
described here involve both the installation of the Charm Tools software and
the download of charms from the [Charm Store][charm-store]. These tasks are to
be performed on an internet-connected system prior to being migrated to the
internet-deprived network.

### Installation and overview

Charm Tools is add-on software that is useful for interacting with local
charms. It is primarily meant for charm authors but it is also useful for
just downloading charms from the Charm Store.

Local charms originating from the Store require some degree of maintenance
(updating). Merely downloading a charm once will allow the charm to get stale.
To update a charm, simply overwrite the existing charm directory by downloading
it to the same location.

See [Charm Tools][charm-tools] for information on installation as well as
for command syntax and general usage.

### Storing a charm locally

Storing a charm locally involves downloading the charm to the local filesystem.
This is done by means of the Charm Tools `pull` command.

For example, to download the mysql charm and put its files under the
`~/charms/mysql` directory:

```bash
charm pull mysql ~/charms/mysql
```

Now that the Charm Tools and the desired charms are available the
administrative system can be placed in the offline environment.

### Deploying from a local charm

After having created a [Juju controller][controllers], deploy from a local
charm by supplying the path to the charm's directory when invoking the
`juju deploy` command.

To deploy the previously downloaded mysql charm:

```bash
juju deploy ~/charms/mysql
```

To deploy vsftpd while specifying the series (you do not have to specify the
series if the local charm contains a series declaration):

```bash
juju deploy ~/charms/vsftpd --series trusty
```

A default series can be configured at the model level: 

```bash
juju model-config -m mymodel default-series=trusty
```

!!! Note:
    Charms hosted on the Charm Store always have an implied series. 

See the [Deploying applications][charms-deploying] page for a comprehensive
treatment of the `juju deploy` command and [Configuring models][models-config]
for more details on model level configuration.

The `juju status` command shows how a charm was installed. Below, MySQL was
installed from a local charm and PostgreSQL came from the Charm Store:

```no-highlight
App         Version  Status  Scale  Charm       Store       Rev  OS      Notes
mysql       5.7.20   active      1  mysql       local       326  ubuntu  
postgresql  9.5.10   active      1  postgresql  jujucharms  164  ubuntu  
```


<!-- LINKS -->

[charms-offline]: ./charms-offline.html
[charm-store]: https://jujucharms.com
[charm-tools]: ./tools-charm-tools.html
[charms-deploying]: ./charms-deploying.html
[models-config]: ./models-config.html
[controllers]: ./controllers.html
