Title: Upgrading applications

# Upgrading applications

An application is upgraded with the `upgrade-charm` command, where the upgrade
candidate is known as the *revision*. The default channel is naturally the
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

## Crossgrading an application

Crossgrading an application refers to upgrading an application by switching out
the current charm and replacing it with a new local charm. This is accomplished
by way of the `--switch` option. This differs from upgrading an existing charm
locally (with the `--path` option) due to the charm being considered entirely
new.

This is considered a dangerous operation since Juju has only limited
information with which to determine compatibility. The operation will succeed
so long as the following conditions are met:

- The new charm must declare all relations that the application is currently
  participating in.
- Each configuration setting shared by the original and new charm must be of
  the same type.

The new charm may add new relations and configuration settings.

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


<!-- LINKS -->

[charm-tools]: ./tools-charm-tools.html
[dev-upgrade-charm]: ./developer-upgrade-charm.html
[deploy-charm_channels]: ./charms-deploying.html#channels
