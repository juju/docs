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

# Backup and Restore of the Juju State-Server

Juju provides `backup` and `restore` commands to recover the juju state-server
(bootstrap node) in case or failure. The juju backup command creates a archive
of the state-server’s configuration, keys, and environment data. If the state-
server or its host machine failes, a new state-server can be created from the
backup file.

The `backup` command creates an dated archive of the current environment's
state-server. An archive like "juju-backup-20140403-1408.tgz" is created by this
command.

    juju switch my-env
    juju backup

Unline most juju commands, `backup` does not accept the -e option to specific
the environment. You must `switch` to the environment or specify the envronment
name in the `JUJU_ENV` shell env variable.

    JUJU_ENV=my-env juju backup

The juju `restore` command creates a new juju state-server instance using the
data from the backup file. It updates the existing instances in the environment
to recognise the new state-server. The command ensures the environment's state-
server is not running before it creates the replacement.

    juju restore -e my-env juju-backup-20140403-1408.tgz

As with the normal bootstrap command, you can pass --constraints to setup the
new state-server.

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

