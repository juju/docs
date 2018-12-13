Title: Juju user management


# User management

This section covers topics related to managing users at the administrative
level.


## Viewing user model access

```bash
juju models --user mat
```

```no-highlight
Controller: lxd-bionic-1

Model            Cloud/Region         Status     Access  Last connection
admin/euphoric*  localhost/localhost  available  read    never connected
```

## Disabling and re-enabling users

To immediately sever a user's communication with their controller the
`disable-user` command is employed. To re-establish communication the
`enable-user` command is used. To get a list of potential users to disable the
`users` command can first be used.

Examples:

To disable the user 'mike':

```bash
juju disable-user mike
```

To re-enable the user 'mike':

```bash
juju enable-user mike
```

Disabled users are suppressed in the output to the `users` command unless the
`--all` option is used, whereby the output will show "disabled":

```no-highlight
Controller: cstack

Name    Display name  Access     Date created    Last connection
admin*  admin         superuser  2018-12-12      just now
mike                  login      17 minutes ago  never connected (disabled)
```

## Changing user passwords

The local user is prompted to set a password when registering the controller.
This password can subsequently be changed either by the user or by the admin
user of the controller. For the user, it is simply a matter of running:

```bash
juju change-user-password
```

The admin user must also supply the name of the user account whose password
is to be changed:

```bash
juju change-user-password mike
```

Then simply follow the prompts to enter and confirm a new password.
