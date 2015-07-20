Title: Managing users in Juju

# Managing users in Juju

Juju considers users to be of one of two types:

  1. **local users**, those stored in the database along side the environments and
entities in those environments
  1. **remote users**, those whose authenticiation
is managed by an external service and reserved for future use.

When a Juju System is bootstrapped, an initial user is created with the 
environment. This user is considered to be the administrator for the Juju
System. Only this user can create other users until such a time as Juju has
full fine grained role-based permissions.

All user managment functionality is managed though the 'juju user' collection
of commands.

# Adding a new user

The primary user commands are used by the admin users to create users and
disable or reenable login access.

```bash
$ juju user add bob "Bob Brown"
user "Bob Brown (bob)" added
server file written to /current/working/directory/bob.server
```

The server file contains everything that Juju needs to connect to the API
server of the Juju system. It has the network address, server certificate,
username and a randomly generated password.

This server file is then sent to Bob.

# Changing a password

The `juju user change-password` command can be used by any user to change
their own password, or, for admins, the command can change another user's
password and generate a new credentials file for them.

```bash
# You will be prompted to enter a password.
$ juju user change-password

# Change the password to a random strong password.
$ juju user change-password --generate

# Change the password for bob, this always uses a random password
$ juju user change-password bob
```

# Copying a local identity to use on another machine

The `juju user credentials` command gives any user the ability to export the
credentails they are using to access an environment to a file that they can
use elsewhere to login to the same Juju System.

```bash
$ juju user credentials --output staging.creds
# copy the staging.creds file to another machine
$ juju system login staging --server staging.creds --keep-password
```

Note that when logging in to the system on the new machine the `--keep-
password` option should be used, otherwise Juju will generate a new random
strong password for the user, thus invalidating the password stored on the
first machine.

# Other user administration commands

Other commands that are useful for system administrators are:

  - `juju user list`
  - `juju user disable <username>`
  - `juju user enable <username>`

