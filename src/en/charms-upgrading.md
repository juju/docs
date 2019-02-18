Title: Upgrading applications

# Upgrading applications

An application's charm is upgraded with the `upgrade-charm` command, where the
upgrade candidate is known as the *revision*. The default channel is the
channel of the currently deployed charm.

!!! Note:
    It is possible, though unlikely, that the revision is **older** than that
    of the deployed application. In this case, the application will actually be
    **downgraded** (to the revision).

The notion of a *channel* is related to revision numbers. See
[Deploying applications][deploy-charm_channels] for an overview of channels.

The [Charm developer guide][dev-upgrade-charm] provides low-level details on
the mechanics of charm upgrades.

You can query for charm information, such as channels and revisions, with the
`charm` utility, which is available via the Charm Tools software. See the
[Charm Tools][charm-tools] page for guidance.

## Upgrade mechanics

Here is a summary of how charm upgrades work.

The agent (running on each unit of the application being upgraded) unpacks the
new version of the charm to a staging directory next to the original charm. It
then points itself to the newly unpacked charm and deletes the old one, after
which the expected hooks are fired using the newly unpacked charm code.

The original charm continues to run until the new charm is successfully
downloaded and unpacked. Only then does the original one stop running and the
new one begin to run (by executing the `install` and `upgrade-charm` hooks).

To be clear, the logic of the upgrade itself is contained within the charm.
Juju simply unpacks the new charm and fires the hooks. 

## Crossgrading an application

Crossgrading an application refers to upgrading an application by switching out
the current charm and replacing it with a new local charm. This is accomplished
by way of the `--switch` option. This differs from upgrading an existing charm
locally (with the `--path` option) due to the charm being considered entirely
new.

This is considered a dangerous operation since Juju has only limited
information with which to determine compatibility. The operation will succeed
so long as the following conditions are met:

 - The new charm must support all relations that the application is currently
   participating in.
 - Each configuration setting shared by the original and new charm must be of
   the same type.

The new charm may add new relations and configuration settings.

## Forced upgrades

A charm upgrade may require the use of the `--force-series` option.

Consider the case where an application is initially deployed using a charm that
supports Precise and Trusty. If a new version of the charm is released that
only supports Trusty and Xenial then applications already deployed on Precise
can only be force-upgraded.

## Examples

To upgrade WordPress based on the current channel:

```bash
juju upgrade-charm wordpress
```

To upgrade MySQL based on the 'edge' channel:

```bash
juju upgrade-charm mysql --channel edge
```

To upgrade Git to a specific revision number:

```bash
juju upgrade-charm git --revision 2
```

To upgrade Apache using a local updated charm:

```bash
juju upgrade-charm apache2 --path ~/charms/apache2
```

!!! Note:
    The above implies the application was originally deployed locally.
    The path must be the same in both cases (deployed and upgraded).

To crossgrade MySQL with a local charm:

```bash
juju upgrade-charm --switch ~/charms/new-mysql mysql
```

To force an upgrade of PostgreSQL that would otherwise fail:

```bash
juju upgrade-charm postgresql --force-series
```


<!-- LINKS -->

[charm-tools]: ./tools-charm-tools.md
[dev-upgrade-charm]: ./developer-upgrade-charm.md
[deploy-charm_channels]: ./charms-deploying.md#channels
