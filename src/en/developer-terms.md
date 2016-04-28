Title: Writing charms using terms

# Writing charms that use terms

Many commercial applications require the acceptance of Terms in order to be
installed. Starting with Juju 2, charms can require a user accept its terms in
order for it to be deployed.

Because of the nature of terms, the user must have a Launchpad account, and will
be prompted to login when attempting to deploy a term-enabled charm.

# How it works

When a user tries to deploy a term-enabled charm from the charm store, Juju will
check if the terms have been agreed to. If they have, the charm will deploy as
usual. If not, the user will be prompted to run the `juju agree` command in
order to deploy.

You can view which charm terms you've accepted by installing
[charm-tools](./tools-charm-tools.html) and running `charm terms`.

# Managing terms

## Creating terms

At the moment, terms can only be created by charm store administrators.
Charm developers should send an email to juju@lists.ubuntu.com with:
- the id of the term in the format of "vendor-app", such as "lorem-ipsum".
- the full text of the terms to display to the user, appended to the body
of the email.

In order to make a charm require terms, the `terms` key has been introduced to
the charm's `metadata.yaml`. For example:

```yaml
name: terms1
summary: "That's a dummy charm with terms."
description: |
    This is a longer description which
    potentially contains multiple lines.
terms: ["lorem-ipsum"]
```

The `terms` key can include multiple terms to be required. It can also require
specific versions of a term, i.e., `lorem-ipsum/2` would reference the second
version of the `lorem-ipsum` term. Omitting the version will require the latest
version.

## Upgrading terms

Deployed charms will run under the terms they were installed with. If the terms
have been revised, running `juju upgrade-charm <service>` will require the user
to accept the new terms before the upgrade will run.


# Caveats
Terms are only checked when the charm is deployed from the charm store, so
deploying a local charm will bypass the term check and install.
