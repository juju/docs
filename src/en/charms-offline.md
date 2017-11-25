Title: Deploying Charms Offline

# Deploying Charms Offline

Clouds that do not enjoy a connection to the internet can nonetheless make use
of Juju charms provided that local copies of the charms are prepared in
advance. Examples of common offline clouds are LXD, MAAS, and OpenStack.

These instructions are concerned strictly with how to obtain local copies of
Juju charms. In particular, they do not take into account:

 - how individual charms may be adversely affected when deployed in an offline
   context. For instance, some charms download files from internet-based
   sources (e.g. GitHub). In such cases, the charm must be appropriately
   modified prior to usage.

 - other required cloud ingredients such as operating system (or container)
   images.

## Maintaining charms locally with Charm Tools

The steps described here involve both the installation and download of
software. These tasks are to be performed on an internet-connected system (e.g.
an admin laptop) prior to being migrated to the internet-deprived network.

### Installation and overview

Charm Tools is add-on software that is useful for interacting with local
charms. It is primarily meant for charm authors but it is also useful for
just downloading charms from the Charm Store.

Local charms require some degree of maintenance (updating). Merely downloading
a charm once will allow the charm to get stale. To update a charm, simply
overwrite the existing charm directory by downloading it to the same location.

See [Charm Tools][charm-tools] for information on installation as well as
for command syntax and usage.

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

For example, to deploy the previously downloaded mysql charm:

```bash
juju deploy ~/charms/mysql
```

See the [Deploying applications][charms-deploying] page for a comprehensive
treatment of the `juju deploy` command. In particular, see the section on
[Deploying from a local charm][anchor__charms-deploying_deploying-locally].

The `juju status` command shows how a charm was installed. Below, MySQL was
installed from a local charm and PostgreSQL came from the Charm Store:

```no-highlight
App         Version  Status  Scale  Charm       Store       Rev  OS      Notes
mysql       5.7.20   active      1  mysql       local       326  ubuntu  
postgresql  9.5.10   active      1  postgresql  jujucharms  164  ubuntu  
```


<!-- LINKS -->

[charm-tools]: ./tools-charm-tools.html
[charms-deploying]: ./charms-deploying.html
[controllers]: ./controllers.html
[anchor__charms-deploying_deploying-locally]: ./charms-deploying.html#deploying-from-a-local-charm
