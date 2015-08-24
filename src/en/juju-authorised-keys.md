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

```bash
juju authorised-keys import lp:wallyworld
```

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
