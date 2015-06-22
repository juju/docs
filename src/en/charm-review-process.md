Title: Charm Review Process
# Charm Review Process

Reviewing a Juju Charm is a process that can easily be broken down into
the following parts:

1. Identifying what to review
1. Setting up a branch of the charm
1. Charm Information Review
1. Charm Deployment, Configuration and Testing
1. Gathering / Submitting Your Results


## Identifying what to review

When determining what charm (or merge request for a charm) you should
review, prioritize whichever you think best achieves the goal of helping people
enjoy getting things done in Juju. That might be the newest ones, neglected
patches, easy patches, or those from new contributors. Take a look at the
[Review Queue](http://review.juju.solutions) to best determine what needs to
be done!


## Setting up a branch of the charm

Let's get started with setting up a branch of the charm. The process below
highlights how you would branch a charm that is for Ubuntu 12.04 (Precise),
but the branching process is essentially the same for other series such as
Ubuntu 14.04 (Trusty).

```bash
mkdir /tmp/precise
cd /tmp/precise
```

Above we created a temporary directory for Precise. If you are reviewing a
charm for Ubuntu 14.04, you'd replace `precise` with `trusty`.

If the charm is already available in the Juju Charm Store, do the following
command to get the charm:

```bash
charm get charm-name
```

If you are reviewing a merge request for an existing charm, in order to get
the merge proposal applied to the current charm store version, do:

```bash
bzr merge lp:~the-username/charms/precise/charm-name/trunk
```

If the charm is not already available in the Juju Charm Store, do the
following command to get the charm:

```bash
bzr branch lp:~the-username/charms/precise/charm-name/trunk charm-name
```

Like when creating the temporary directory, the `precise` part can be
replaced with the series relating to the charm that is being reviewed.

```bash
cd charm-name
```


## Charm Information Review

### Charm Proofing

Now that we have set up / branched the charm and are in the charm's directory,
we need to run the following command:

```bash
charm proof
```

The [proof](tools-charm-tools.html#proof) command validates that charm conforms
with the [Charm Store Policy](authors-charm-policy.html). It programmatically
ensures that the charm structure, layout and files conform to policy.  The tool
will output particular information with a level of severity.

If you come across errors or warnings (starting with `E` and `W` respectively),
these are typically major issues and will result in a broken charm as well as
breaking [Charm Store Policy](authors-charm-policy.html). We also recommend you
check for the presence of copyright information as well as the charm's icon and
ensure it [follows icon specification](authors-charm-icon.html).

If the charm proof results in errors or warnings and you still feel that this
charm is likely to be deployable, continue on with the review. Just be sure to
note that the charm, as it stands, breaks Charm Store Policy and will not be
accepted in its current form.

### Reading The README

Understanding the purpose of the charm is crucial for both those that are
reviewing as well as for those that may want to deploy the charm. We recommend
the charm's README have the following information:

1. What is the service?
1. What configuration options does it provide as well as suggested
usage noting defaults.
1. What files does it retrieve from the Internet
1. Instructions on how to deploy the service and scale it out.
1. How the charm should be used in relation to configuration options
and relations.
1. Caveats
1. Support including contact and upstream project information.

Make note of sections of the README that need improvement or are missing.

### Charm Configuration

Take a look at the charm's config.yaml file, using the
[Charm Configuration](authors-charm-config.html) document for reference. We
also recommend you cross-reference it with the README to make sure the options
in the README are defined in the config.yaml and vise-versa.

### Charm metadata

Inspect the charm's metadata.yaml file and use the
[Charm metadata](authors-charm-metadata.html) document as reference.


## Charm Code Review

Reviewing a charm's code is an **optional** step for community reviewers.
If you feel comfortable reviewing the charm's code, here are some things to
watch out for in the charms code:

1. Not allowing users to set any applicable passwords with config-set.
1. When downloading files from the Internet, not cross-referencing with
   hashes (ex: md5). Note this isn't necessary if the charm is using a version
   control system like *git*, since they typically have built-in file verification.
1. Not using `set -e` or `set -eux` in Bash scripts, which helps detect
   failed execution, thereby allowing Juju to more accurately detect a failed hook.


## Charm Deployment, Configuration, and Testing

If a charm has tests (you can determine if it does by checking for a "tests"
folder), run the command below and verify the charm that way:

```bash
juju test -v --set-e
```

If a charm does not have tests, you will need to manually deploy it.

### Deployment

We are going to cover some basic elements to deploying the charm you are
reviewing.  For a more in-depth look at deploying charms, go to the
[Charms Deploying](charms-deploying.html) page.

While using the README as a reference, deploy the charm using the command
below on your local environment.

```bash
juju deploy --repository=../../ local:precise/charm-name
```

Alternatively, you can set JUJU_REPOSITORY and deploy like the following:

```bash
export JUJU_REPOSITORY=/tmp
juju deploy local:precise/charm-name
```

!!! Note: Remember to swap out `precise` for the series the charm is being
tested for, like `trusty`.

If the local deployment is successful, continue to the configuration section.

!!! Note: If you have access to other cloud environments (like EC2), we
appreciate testing the deployment on those environments as well.

### Configuration and Relations

Reference the config.yaml as well as the README to determine what configuration
options are available for the charm. Test out changing the charm configuration
by doing something like the following:

```bash
juju set charm-name key=value
```

If the configuration of the charm successfully changes and the charm's README
makes note of possible relations with other charms, test adding and removing
the relations __multiple__ times. Doing so will test for idempotency, ensuring a
hook can be called repeatedly and making sure the departed and broken
hooks are fired correctly.

```bash
juju add-relation charm-name other-charm-name
juju remove-relation charm-name other-charm-name
```

### Verifying

Let's quickly verify that the charm is correctly running by using SSH to
jump into the machine the charm is running on.

```bash
juju ssh charm-name/0
```

Use `top` or `ps` to show if the charm's process is running. Some
services status would also be available with `sudo service name status`
(example: `sudo service apache2 status`).

!!! Note: If the charm itself is not a process, but relies on another
process/application (eg. nginx or apache2), be sure to check those services are
running. A good example of this would be Wordpress needing apache2 or nginx).

If the charm's configuration options are written to the service's configuration
files, check that file for the values you set earlier. Check the hooks to see
which ones are written to configuration files (if applicable at all).


## Gathering / Submitting Your Results

Gather the information that you have obtained from the charm review, such as
whether the charm proof passes or has issues, if the README is understandable
and thorough, if it successfully deploys, configuration and relations work, etc.

Post that information to the bug report or merge request, starting off with a "Thanks"
no matter the outcome of the review. If you are a community member and/or contributor,
you can leave your general approval or disapproval based on your findings. Normally
people use "+1 LGTM" to indicate approval. Of course, in moments of disapproval, we
suggest posting information as to why you disapprove.

### Part of the ~charmers group, hold up!

If you are a ~charmer or wishing to become a ~charmer, make sure you are
applying the [Reviewers Guidelines](reference-reviewers.html).

### Not part of the ~charmers group?

First off, thank you for your review of the charm. Your review helps improve the Juju
community as a whole and we appreciate your time and effort. If you've found that you
are ready to be part of the ~charmers group and want the responsibilities of a member
of the ~charmers team, we recommend you seek out how to
[apply for membership](https://jujucharms.com/community/charmers/) to the
team via #juju on IRC (Freenode) and on the Juju
[mailing list](https://lists.ubuntu.com/mailman/listinfo/juju).
