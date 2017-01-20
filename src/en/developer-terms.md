Title: Writing charms using terms

# Writing charms that use terms

Many applications require the acceptance of terms in order to be installed.
Starting with Juju 2, charms can require a user accept its terms in order for
it to be deployed.

Because of the nature of terms, the user must have a Launchpad account, and will
be prompted to login when attempting to deploy a term-enabled charm.

# How it works

When a user tries to deploy a term-enabled charm from the charm store, Juju will
check if the terms have been agreed to. If they have, the charm will deploy as
usual. If not, the user will be prompted to run the `juju agree` command in
order to deploy.

# Managing terms

## Creating terms

As a charm developer, you may push and release terms owned by a group of which
you are a member. Groups are mapped onto Launchpad teams.

### Install latest charm-tools

To use terms you will need at least v2.2 of [charm tools](./tools-charm-tools.html).

### Pushing terms

To push an initial or updated revision of a term, use `charm push-term`.

```bash
charm push-term terms.txt my-group/my-terms
```

This displays the assigned ID for the created term revision.

```no-highlight
my-group/my-terms/1
```

This pushes, or uploads, the contents in the local file `terms.txt` to the term
`my-group/my-terms`. Because this is a new term, revision 1 is created.

### Testing unreleased terms

As a member of `my-group`, you can `juju agree` to your own
unreleased term:

```bash
juju agree my-group/my-terms/1
```

However, until this revision is released, the term cannot be agreed to by
non-owners.

The term contents and metadata may also be viewed with `charm show-term`.

```bash
charm show-term my-group/my-terms/1
```

Which returns output like this:

```yaml
id: my-group/my-terms/1
owner: my-group
name: my-terms
revision: 1
createdon: 2016-04-20T13:28:54Z
published: false
content: |
  Your terms here...
```

### Releasing terms

Use `charm release-term` to release a term revision for general availability.
Note that until a term revision is released, non-owners will be unable to agree
to it. If your charm requires agreement to an unreleased revision, or any
revision of a new, never-before-released term, users will not be able to agree
to it, and will be unable to deploy the charm.

When releasing, the revision to be released must be given:

```bash
charm release-term my-group/my-terms/1
```

## Requiring agreement to terms in your charm

In order to make a charm require terms, the `terms` key has been introduced to
the charm's `metadata.yaml`. For example:

```yaml
name: terms1
summary: "That's a dummy charm with terms."
description: |
    This is a longer description which
    potentially contains multiple lines.
terms: ["my-group/my-terms"]
```

The `terms` key can include multiple terms to be required. It can also require
specific versions of a term, i.e., `my-group/my-terms/2` would reference the
second version of the `my-group/my-terms` term. Omitting the version will
require the latest version.

## Listing terms

There two distinctions when considering terms. There are the terms that are
linked to a charm, and terms that have been accepted by the user.
Developer-facing subcommands are run against the `charm` command, which is
installed via [charm-tools](./tools-charm-tools.html), while users interact
with `juju`.

`charm terms` shows the terms that you have created, and which charms they
are associated with.

```bash
charm terms
```

This produces a listing of your terms.

```no-highlight
TERM         		CHARM
my-group/my-terms/1	cs:trusty/terms-example-0
```

You can also view the terms associated with a specific charm.

```bash
charm show cs:trusty/terms-example-0 terms
```

This displays a subset of charm metadata; the terms required by the charm:

```yaml
terms:
- my-group/my-terms/1
```

A user can view the list of terms they've agreed to with
`juju agreements`.

```bash
juju agreements
```

The output displays each term revision the user has agreed to:

```json
[
    {
        "user": "aisrael",
        "owner": "my-group",
        "term": "my-terms",
        "revision": 1,
        "created-on": "2016-04-20T21:01:24.84Z"
    }
]
```

## Upgrading terms

Deployed charms will run under the terms they were installed with. If the terms
have been revised, running `juju upgrade-charm <service>` will require the user
to accept the new terms before the upgrade will run.


# Caveats
Terms are only checked when the charm is deployed from the charm store, so
deploying a local charm will bypass the term check and install.
