Title: Juju and multi-user environments


# Managing multi-user environments

Juju supports multi-user environments by allowing multiple users to connect to
an environment with unique credentials.

When an environment is bootstrapped the name of the initial Juju user is
hardcoded to "admin".

Support for fine grain permissions is in development. The only permission
checked at this stage is that only the initial administrative user can create
or disable other users. Any user is now able to change their own password.

The user commands are grouped under the `juju user` command. For syntax use
`juju user --help` or `juju user <sub-command> --help` or see the
[command reference page](./commands.html#user).

To add a user:

```bash
juju user add fred -o /tmp/fred-local.jenv "Test User"
```

Assuming the current user is 'ubuntu', this will result in:

```no-highlight
To generate a random strong password, use the --generate flag.
password:
type password again:
user "Test User (fred)" added
environment file written to /tmp/fred-local.jenv
```

Then create the system user (also called 'fred' for simplicity) and set
everything up:

```bash
sudo adduser fred
su - fred
mkdir -p .juju/environments
cp /tmp/fred-local.jenv .juju/environments
juju status -e fred-local
```

You can see which users have been created using the `juju user list`
command:

```bash
juju user list
```

The output will be similar to:

```no-highlight
NAME   DISPLAY NAME  DATE CREATED    LAST CONNECTION
admin  admin         2015-08-12      just now
test   Test User     5 minutes ago   never connected
fred   Test User     26 minutes ago  never connected
```

The output of this command can also be in YAML or JSON using the usual
"--format" options.

To disable a user:

```bash
juju user disable test
```

Disabled users are not shown with the list sub-command unless the '--all'
option is given:

```bash
juju user list --all
```

Query an environment for the current user 'fred' (with the
[api-info command](./juju-misc.html#inspect-api-connection-settings)):

```bash
juju api-info user -e fred-local
```

If a disabled user issues the above command his name will be shown. However, if
such a user, such as 'test', tries to request information:

```bash
juju user info -e test-local
```

He will be confronted with an error:

```no-highlight
WARNING discarding API open error: invalid entity name or password
ERROR environment "test-local" not found
```

An enabled user, such as 'fred', should get output similar to:

```no-highlight
user-name: fred
display-name: Test User
date-created: 35 minutes ago
last-connection: just now
```

A disabled user can be re-enabled easily:

```bash
juju user enable test
```
