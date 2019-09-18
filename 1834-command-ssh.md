**Usage:** `juju ssh [options] <[user@]target> [openssh options] [command]`

**Summary:**

Initiates an SSH session or executes a command on a Juju machine.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--no-host-key-checks (= false)`

Skip host key checking (INSECURE)

`--proxy (= false)`

Proxy through the API server

`--pty (= <auto>)`

Enable pseudo-tty allocation

**Details:**

The machine is identified by the argument which is either a 'unit name' or a 'machine id'. Both are obtained in the output to `juju status`. If 'user' is specified then the connection is made to that user account; otherwise, the default 'ubuntu' account, created by Juju, is used.

The optional command is executed on the remote machine, and any output is sent back to the user. If no command is specified, then an interactive shell session will be initiated.

When `juju ssh` is executed without a terminal attached, e.g. when piping the output of another command into it, then the default behavior is to not allocate a pseudo-terminal (pty) for the ssh session; otherwise a pty is allocated. This behavior can be overridden by explicitly specifying the behavior with `--pty=true` or `--pty=false`.

The SSH host keys of the target are verified. The `--no-host-key-checks` option can be used to disable these checks. Use of this option is not recommended as it opens up the possibility of a man-in-the-middle attack.

The default identity known to Juju and used by this command is ~/.ssh/id_rsa Options can be passed to the local OpenSSH client (ssh) on platforms where it is available. This is done by inserting them between the target and a possible remote command. Refer to the ssh man page for an explanation of those options.

**Examples:**

Connect to machine 0:

`   juju ssh 0`

Connect to machine 1 and run command 'uname -a':

`   juju ssh 1 uname -a`

Connect to a mysql unit:

`   juju ssh mysql/0`

Connect to a jenkins unit as user jenkins:

`   juju ssh jenkins@jenkins/0`

Connect to a mysql unit with an identity not known to juju (ssh option -i):

`   juju ssh mysql/0 -i ~/.ssh/my_private_key echo hello`

**See also:**

[scp](https://discourse.jujucharms.com/t/command-scp/1806)
