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

## Examples

To upgrade WordPress based on the current channel:

```bash
juju upgrade-charm wordpress
```

To upgrade MySQL based on the 'edge' channel:

```bash
juju upgrade-charm mysql --channel edge
```

To upgrade Apache using a local updated charm:

```bash
juju upgrade-charm apache2 --path ~/charms/new-git
```

To upgrade Git to a specific revision number:

```bash
juju upgrade-charm git --revision 2
```


<!-- LINKS -->

[charm-tools]: ./tools-charm-tools.html
[dev-upgrade-charm]: ./developer-upgrade-charm.html
[deploy-charm_channels]: ./charms-deploying.html#channels
