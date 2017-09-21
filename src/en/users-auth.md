Title: Users and authentication
TODO:  Stuff on user-created models (ssh key and credentials)
       bug tracking: https://pad.lv/1718775


# Users and authentication

This section deals with topics related to user authentication and general user
security.


## Users and passwords

There are two ways users are introduced into Juju: the initial administrator of
a controller via the controller creation step and a non-administrator via the
user registration step. The latter sets up the user's Juju password but the
former is left without an actual password.  This is why if such a user tries to
log out (`juju logout`) before creating a password the command will fail and a
warning will be displayed. An administrator should, therefore, create a
password once the controller is created. They must do so if multiple Juju users
will be using the same system user account:

```bash
juju bootstrap aws mycontroller
juju change-user-password
```

See [Creating a controller][controllers-creating] for details on controller
creation.

## Credentials

Credentials managed in Juju are related to the accessing of the chosen
cloud-backed resource. They are not related to Juju users themselves in any
way. Credentials added to Juju remain local to the system user (on Ubuntu:
`~/.local/share/juju/credentials.yaml`).

See [Cloud credentials][credentials] for more on this topic.

## SSH access

SSH access is managed on a per-model basis. That is, if a public key is added
to a model by an admin then that key is placed on all machines in that model,
as well as on any subsequently-created machines. This is done with commands
`juju add-ssh-key`, `juju import-ssh-key`, and `juju remove-ssh-key`, which
refer to keys owned by ordinary people (non-Juju users). However, Juju's own
user rights system imposes a second degree of security that only allows
access from a Juju user with the correct model permissions. Additionally,
connections can only be made via the `juju ssh` command.

### Controller admins

The controller admin is the system (e.g. Ubuntu) user that performed the
initial controller-creation step.

By default, a controller admin will be able to connect to any machine. When a
controller is created a passphraseless SSH keypair will be created and placed
under `~/.local/share/juju/ssh`:

```no-highlight
-rw------- 1 ubuntu ubuntu 1675 Sep 21 21:58 juju_id_rsa
-rw------- 1 ubuntu ubuntu  397 Sep 21 21:58 juju_id_rsa.pub 
```

The public key (`juju_id_rsa.pub`) will be placed on every machine created
within every model belonging to this controller. If there is an existing
private key named `~/.ssh/id_rsa` then it will also be placed on every machine.

### Non-admin users

For SSH connections to work for a non-admin Juju user, the user must:

- be registered (`juju register`)
- be logged in (`juju login`)
- have 'admin' rights to the model (`juju grant`)
- ensure their private key is named `id_rsa` (or use the `ssh-agent` utility)

See [Users and models][models-users] for more information on managing
user permissions.


<!-- LINKS -->

[controllers-creating]: ./controllers-creating.html
[credentials]: ./credentials.html
[models]: ./models.html
[models-users]: ./users-models.html
