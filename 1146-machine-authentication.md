<!--
Todo:
- Stuff on user-created models (ssh key and credentials)
-->

Juju machines are contacted via the SSH protocol and is managed on a per-model basis. That is, if a public key is added to a model then that key is placed on all machines (present and future) in that model.

Each Juju machine provides a user account named 'ubuntu' and it is to this account that public keys are added when using the Juju SSH commands (`add-ssh-key` and `import-ssh-key`). Because this user is effectively the 'root' user (passwordless sudo privileges), the granting of SSH access must be done with due consideration.

It is possible to connect to a Juju machine in one of two ways:

- Via Juju, using `juju ssh`
- Direct access, using a standard SSH client (e.g `PuTTY` on Windows or `ssh` [OpenSSH] on Linux)

Connecting via Juju involves a second degree of security, as explained below.

Regardless of the method used to connect, a public SSH key must be added to the model. In the case of direct access, it remains possible for a key to be added to an individual machine using standard methods (manually copying a key to the `authorized_keys` file or by way of a command such as `ssh-import-id` in the case of Ubuntu).

<h2 id="heading--juju-ssh">Juju ssh</h2>

When using Juju's `ssh` (or `scp`) command, Juju's internal user rights system imposes an extra degree of security by permitting access solely from a Juju user. This user must also have 'admin' model access. See [Managing models in a multi-user context](/t/working-with-multiple-users/1156#heading--managing-models-in-a-multi-user-context) for help on assigning user permissions.

For example, to connect to a machine with an id of '0':

```text
juju ssh 0
```

Machines can also be expressed in unit notation:

```text
juju ssh mysql/3
```

An interactive pseudo-terminal (pty) is enabled by default. For the OpenSSH client, this corresponds to the `-t` option ("force pseudo-terminal allocation").

Remote commands can be run as expected. For example: `juju ssh 1 lsb_release -c`. For complex commands the recommended method is by way of the `run` command (see tutorial [Basic client usage](/t/basic-client-usage-tutorial/1191#heading--running-commands-on-a-machine)).

The `scp` command copies files securely to and from units.

[note]
Options specific to scp must be preceded by double dashes: `--`.
[/note]

Examples:

Copy 2 files from two MySQL units to the local backup/ directory, passing `-v` to scp as an extra argument:

```text
juju scp -- -v mysql/0:/path/file1 mysql/1:/path/file2 backup/
```

Recursively copy the directory `/var/log/mongodb/` on the first MongoDB server to the local directory remote-logs:

```text
juju scp -- -r mongodb/0:/var/log/mongodb/ remote-logs/
```

Copy a local file to the second apache2 unit in the model "testing". Note that the `-m` here is a Juju argument so the characters `--` are not used:

```text
juju scp -m testing foo.txt apache2/1:
```

[note]
Juju cannot transfer files between two remote units because it uses public key authentication exclusively and the native (OpenSSH) `scp` command disables agent forwarding by default. Either the destination or the source must be local (to the Juju client).
[/note]

<h3 id="heading--ssh-keys-and-models">SSH keys and models</h3>

When a controller is either created or registered a passphraseless SSH keypair will be generated and placed under `~/.local/share/juju/ssh` The public key `juju_id_rsa.pub`, as well as a possibly existing `~/.ssh/id_rsa.pub`, will be placed within any newly-created model.

This means that a model creator will always be able to connect to any machine within that model (with `juju ssh`) without having to add keys since the creator is also granted 'admin' model access by default (see [Adding a model](/t/adding-a-model/1147) for more information).

Recall that the creation of a controller effectively produces two models: 'controller' and 'default'. This provides the initial controller administrator access to keys and models out of the box.

<h3 id="heading--providing-access-to-non-initial-controller-admin-juju-users">Providing access to non-initial controller admin Juju users</h3>

In order for a non-initial controller admin user to connect with `juju ssh` that user must:

- be created (`add-user`)
- have registered the controller (`register`)
- be logged in (`login`)
- have 'admin' access to the model
- have their public SSH key reside within the model
- be in possession of the corresponding private SSH key

As previously explained, 'admin' model access and installed model keys can be obtained by creating the model. Otherwise access needs to be granted (`grant`) by a controller admin and keys need to be added (`add-ssh-key` or `import-ssh-key`) by a controller admin or the model admin.

See [Model access](/t/working-with-multiple-users/1156#heading--model-access) for how to grant rights to a model.

In terms of the private key, the easiest way to ensure it is used is to have it stored as `~/.ssh/id_rsa`. Otherwise, you can do one of two things:

1. Use `ssh-agent`
1. Specify the key manually

The second option above, applied to the previous example, will look like this:

```text
juju ssh 0 -i ~/.ssh/my-private-key
```

Use the `ssh-keys` command to list SSH keys currently permitting access to all machines, present and future, in a model.

<h2 id="heading--direct-ssh-access">Direct SSH access</h2>

When using a standard SSH client if one's public key has been installed into a model, then, as expected, a connection to the 'ubuntu' user account can be made. All that is needed is the corresponding keypair and adequate network connectivity.

For example, to connect to a machine with an IP address of 10.149.29.143 with the OpenSSH client:

```text
ssh ubuntu@10.149.29.143
```
