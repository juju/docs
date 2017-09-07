Title: Upgrading applications

# Upgrading applications

An application is upgraded by upgrading its corresponding charm. Since a charm
is always associated with a *channel* and a charm's version can fluctuate
within that channel the following rules apply:

- If the channel has a version **newer** than the deployed version then the latter
  is **upgraded** to the former.
- If the channel has a version **older** than the deployed version then the latter
  is **downgraded** to the former.

Channels can be specified with the `upgrade-charm` command. For example:

```bash
juju upgrade-charm mysql --channel edge
```

See [Deploying applications][deploy-charm_channels] for an overview of channels
and the [Charm developer guide][dev-upgrade-charm] for even more details on the
mechanics of charm upgrades.


<!-- LINKS -->

[dev-upgrade-charm]: ./developer-upgrade-charm.html
[deploy-charm_channels]: ./charms-deploying.html#channels
