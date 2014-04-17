[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# Manage Access with Authorised Keys

Juju's ssh key management allows people other than the person who bootstrapped
an environment to ssh into Juju machines. The `authorised-keys` command accepts
four subcommands:

  - add -- add ssh keys for a Juju user
  - delete -- delete ssh keys for a Juju user
  - list -- list ssh keys for a Juju user
  - import -- import Launchpad or Github ssh keys

`import` can be used in clouds with open networks to pull ssh keys from
Launchpad or Github. For example:

    juju authorised-keys import lp:wallyworld

`add` can be used to import the provided key, which is necessary for clouds that
do not have internet access.

Use the key fingerprint or comment to specify which key to `delete`. You can
find the fingerprint for a key using ssh-keygen.

Juju will prefix the comments all keys that it adds to a machine with "Juju:".
These are the only keys it can `list` or `delete`. Juju cannot not manage
existing keys on manually provisioned machines.

Keys are global and grant access to all machines. When a key is added, it is
propagated to all machines in the environment. When a key is deleted, it is
removed from all machines.

  - ## [Juju](/)

    - [Charms](/charms/)
    - [Features](/features/)
    - [Deployment](/deployment/)
  - ## [Resources](/resources/)

    - [Overview](/resources/overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/communiy/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013-2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://www.canonical.com).

