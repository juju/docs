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
to a model then that key is placed on all machines (present and future) in that
model.

Each Juju machine provides a user account named 'ubuntu' and it is to this
account that public keys are added when using the Juju SSH commands (
`juju add-ssh-key` and `juju import-ssh-key`). Because this user is effectively
the 'root' user (passwordless sudo privileges), the granting of SSH access must
be done with due consideration.

It is possible to connect to a Juju machine in one of two ways:

- Via Juju, using the `juju ssh` command
- Direct access, using a standard SSH client (e.g `PuTTY` on Windows or `ssh`
  [OpenSSH] on Linux)

Connecting via Juju involves a second degree of security, as explained below.

Regardless of the method used to connect, a public SSH key must be added to the
model. In the case of direct access, it remains possible for a key to be added
to an individual machine using standard methods (manually copying a key to the
`authorized_keys` file or by way of a command such as `ssh-import-id` for
Debian-based Linux distributions such as Ubuntu).

### Juju ssh
 
When using the `juju ssh` command, Juju's own user rights system imposes an
extra degree of security by permitting access solely from a Juju user, and only
one with sufficient permissions. How this works depends on whether the user is
an admin or a non-admin. See [Juju users][users] for a breakdown of the
different user types.

For example, to connect to a machine with an id of '0':

```bash
juju ssh 0
```

#### Admin user

When a controller is created (see
[Creating a controller][controllers-creating]) a passphraseless SSH keypair
will be generated and placed under `~/.local/share/juju/ssh`. The public key
(`juju_id_rsa.pub`) will be installed in the 'ubuntu' account on every machine
created within every model belonging to this controller. During creation, if
there is an existing public key named `~/.ssh/id_rsa.pub` then it will also be
placed on every machine.

As long as the controller administrator has access to either of the above keys
he/she can connect to any machine with the `juju ssh` command.

#### Regular user

In order for a regular Juju user to connect with `juju ssh` the user must:

- be created (`juju add-user`)
- be registered (`juju register`)
- be logged in (`juju login`)
- have 'admin' rights to the model (`juju grant`)
- have their public key added to the model by an admin (`juju add-ssh-key` or
  `juju import-ssh-key`)
- must be in possession of their private key and ensure it is named `id_rsa`
  (or use `ssh-agent`)

See [Users and models][models-users] for information on managing user
permissions.

### Direct SSH access

When using a standard SSH client  if one's public key has been installed into a model, then, as
expected, a connection to the 'ubuntu' user account can be made. All that is
needed is the corresponding keypair and adequate network connectivity. 

For example, to connect to a machine with an IP address of 10.149.29.143 with
the OpenSSH client:

```bash
ssh ubuntu@10.149.29.143
```


<!-- LINKS -->

[controllers-creating]: ./controllers-creating.html
[credentials]: ./credentials.html
[users]: ./users.html
[models]: ./models.html
[models-users]: ./users-models.html
