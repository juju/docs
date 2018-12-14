Title: Machine authentication
TODO:  Stuff on user-created models (ssh key and credentials)

# Machine authentication

Juju machines are contacted via the SSH protocol and is managed on a per-model
basis. That is, if a public key is added to a model then that key is placed on
all machines (present and future) in that model.

Each Juju machine provides a user account named 'ubuntu' and it is to this
account that public keys are added when using the Juju SSH commands
(`add-ssh-key` and `import-ssh-key`). Because this user is effectively the
'root' user (passwordless sudo privileges), the granting of SSH access must be
done with due consideration.

It is possible to connect to a Juju machine in one of two ways:

- Via Juju, using `juju ssh`
- Direct access, using a standard SSH client (e.g `PuTTY` on Windows or `ssh`
  [OpenSSH] on Linux)

Connecting via Juju involves a second degree of security, as explained below.

Regardless of the method used to connect, a public SSH key must be added to the
model. In the case of direct access, it remains possible for a key to be added
to an individual machine using standard methods (manually copying a key to the
`authorized_keys` file or by way of a command such as `ssh-import-id` in the
case of Ubuntu).

## Juju ssh
 
When using the Juju `ssh` command, Juju's own user rights system imposes an
extra degree of security by permitting access solely from a Juju user. This
user must also have either 'superuser' controller access or 'admin' model
access. See [Managing models in a multi-user context][multiuser-models] for
more information.

For example, to connect to a machine with an id of '0':

```bash
juju ssh 0
```

An interactive pseudo-terminal (pty) is enabled by default. For the OpenSSH
client, this corresponds to the `-t` option ("force pseudo-terminal
allocation").

### Admin user

When a controller is created a passphraseless SSH keypair will be generated and
placed under `~/.local/share/juju/ssh`. The public key (`juju_id_rsa.pub`) will
be installed in the 'ubuntu' account on every machine created within every
model belonging to this controller. During creation, if there is an existing
public key named `~/.ssh/id_rsa.pub` then it will also be placed on every
machine.

As long as the controller administrator has access to either of the above keys
he/she can connect to any machine with `juju ssh`.

### Regular user

In order for a regular Juju user to connect with `juju ssh` the user must:

 - be created (`add-user`)
 - have registered a controller (`register`)
 - be logged in (`login`)
 - have 'admin' rights to the model (`grant`)
 - have their public SSH key added to the model by an admin (`add-ssh-key` or
   `import-ssh-key`)
 - be in possession of the corresponding private SSH key

See [Model access][multiuser-models-access] for information on managing user
permissions.

In terms of the private key, the easiest way to ensure it is used is to have it
stored as `~/.ssh/id_rsa`. Otherwise, you can do one of two things:

 1. Use `ssh-agent`
 1. Specify the key manually

The second option above, applied to the previous example, will look like this:

```bash
juju ssh 0 -i ~/.ssh/my-private-key
```

## Direct SSH access

When using a standard SSH client if one's public key has been installed into a
model, then, as expected, a connection to the 'ubuntu' user account can be
made. All that is needed is the corresponding keypair and adequate network
connectivity. 

For example, to connect to a machine with an IP address of 10.149.29.143 with
the OpenSSH client:

```bash
ssh ubuntu@10.149.29.143
```


<!-- LINKS -->

[users]: ./users.md
[multiuser-model-access]: ./multiuser.md#model-access
[multiuser-models]: ./multiuser.md#managing-models-in-a-multi-user-context
