Title: Juju user management
TODO: 


# User management

This section covers topics related to managing users at the administrative
level.


## Disabling and re-enabling users

An administrator can sever user communication from a user to the controller
they manage by disabling them. The effect is immediate. To get a list of
potential users to disable the `juju list-users` command can first be used.

Examples:

To disable the user 'mike':

```bash
juju disable mike
```

To re-enable the user 'mike':

```bash
juju enable mike
```

Disabled users do not show up in the output to `juju list-users` unless the
'--all' option is used.


## Changing user passwords

An administrator can change the password of any user associated with the
controller they manage. For example:

```bash
juju change-user-password john
```
