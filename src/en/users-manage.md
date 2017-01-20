Title: Juju user management


# User management

This section covers topics related to managing users at the administrative
level.


## Disabling and re-enabling users

An administrator can sever user communication from a user to the controller
they manage by disabling them. The effect is immediate. To get a list of
potential users to disable the `juju users` command can first be used.

Examples:

To disable the user 'mike':

```bash
juju disable-user mike
```

To re-enable the user 'mike':

```bash
juju enable-user mike
```

Disabled users do not show up in the output to `juju users` unless the
'--all' option is used:

<!-- JUJUVERSION: 2.0.1-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju users --all -->

```no-highlight
Controller: cstack

Name    Display name  Access     Date created    Last connection
admin*  admin         superuser  2016-10-12      just now
mike                  login      17 minutes ago  never connected (disabled)
```
## Changing user passwords

An administrator can change the password of any user associated with the
controller they manage. For example:

```bash
juju change-user-password john
```
