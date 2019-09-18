Many applications require the acceptance of terms in order to be installed. Starting with Juju 2, charms can require a user accept its terms in order for it to be deployed.

Because of the nature of terms, the user must have a Launchpad account, and will be prompted to login when attempting to deploy a term-enabled charm.

# How it works

When a user tries to deploy a term-enabled charm from the charm store, Juju will check if the terms have been agreed to. If they have, the charm will deploy as usual. If not, the user will be prompted to run the `juju agree` command in order to deploy.

# Managing terms

<h2 id="heading--creating-terms">Creating terms</h2>

As a charm developer, you may push and release terms owned by a group of which you are a member. Groups are mapped onto Launchpad teams, so you will need to [join](https://help.launchpad.net/Teams/Joining) or [create a team](https://help.launchpad.net/Teams/CreatingAndRunning) in Launchpad.

<h3 id="heading--install-latest-charm-tools">Install latest charm-tools</h3>

To use terms you will need at least v2.2 of [charm tools](/t/charm-tools/1180).

<h3 id="heading--pushing-terms">Pushing terms</h3>

To push an initial or updated revision of a term, use `charm push-term`.

``` text
charm push-term term.txt my-group/my-term
```

This displays the assigned ID for the created term revision.

``` text
my-group/my-term/1
```

This pushes, or uploads, the contents in the local file `terms.txt` to the term `my-group/my-term`. Because this is a new term, revision 1 is created.

<h3 id="heading--testing-unreleased-terms">Testing unreleased terms</h3>

As a member of `my-group`, you can `juju agree` to your own unreleased term:

``` text
juju agree my-group/my-term/1
```

However, until this revision is released, the term cannot be agreed to by non-owners.

The term contents and metadata may also be viewed with `charm show-term`.

``` text
charm show-term my-group/my-term/1
```

Which returns output like this:

``` yaml
id: my-group/my-term/1
owner: my-group
name: my-term
revision: 1
createdon: 2016-04-20T13:28:54Z
published: false
content: |
  Your terms here...
```

<h3 id="heading--releasing-terms">Releasing terms</h3>

Use `charm release-term` to release a term revision for general availability. Note that until a term revision is released, non-owners will be unable to agree to it. If your charm requires agreement to an unreleased revision, or any revision of a new, never-before-released term, users will not be able to agree to it, and will be unable to deploy the charm.

When releasing, the revision to be released must be given:

``` text
charm release-term my-group/my-term/1
```

<h2 id="heading--requiring-agreement-to-terms-in-your-charm">Requiring agreement to terms in your charm</h2>

In order to make a charm require terms, the `terms` key has been introduced to the charm's `metadata.yaml`. For example:

``` yaml
name: terms1
summary: "That's a dummy charm with terms."
description: |
    This is a longer description which
    potentially contains multiple lines.
terms: ["my-group/my-term"]
```

The `terms` key can include multiple terms to be required. It can also require specific versions of a term, i.e., `my-group/my-term/2` would reference the second version of the `my-group/my-term` term. Omitting the version will require the latest version.

<h2 id="heading--listing-terms">Listing terms</h2>

There two distinctions when considering terms. There are the terms that are linked to a charm, and terms that have been accepted by the user. Developer-facing subcommands are run against the `charm` command, which is installed via [charm-tools](/t/charm-tools/1180), while users interact with `juju`.

`charm terms` shows the terms that you have created, and which charms they are associated with.

``` text
charm terms
```

This produces a listing of your terms.

``` text
TERM                CHARM
my-group/my-term/1  cs:trusty/terms-example-0
```

You can also view the terms associated with a specific charm.

``` text
charm show cs:trusty/terms-example-0 terms
```

This displays a subset of charm metadata; the terms required by the charm:

``` yaml
terms:
- my-group/my-term/1
```

A user can view the list of terms they've agreed to with `juju agreements`.

``` text
juju agreements
```

The output displays each term revision the user has agreed to:

``` json
[
    {
        "user": "aisrael",
        "owner": "my-group",
        "term": "my-term",
        "revision": 1,
        "created-on": "2016-04-20T21:01:24.84Z"
    }
]
```

<h2 id="heading--upgrading-terms">Upgrading terms</h2>

Deployed charms will run under the terms they were installed with. If the terms have been revised, running `juju upgrade-charm <application>` will require the user to accept the new terms before the upgrade will run.

# Caveats

Terms are only checked when the charm is deployed from the charm store, so deploying a local charm will bypass the term check and install.
