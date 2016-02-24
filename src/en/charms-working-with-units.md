Title: Working with units  

# Using units

Each node that Juju manages is referred to as a "unit". Generally speaking,
when using Juju you interact with the services at the service level. There are
times when working directly with units is useful though, particularly for
debugging purposes. Juju provides a few different commands to make this
easier.


## The Juju ssh command

The `juju ssh` command will connect you, via SSH, into a target unit. For
example:

```bash
juju ssh mysql/3
```

This will start an SSH session on the 3rd mysql unit. This is useful for
investigating things that happen on a unit, checking resources or viewing
system logs.

It is possible to run commands via `juju ssh`, for example, `juju ssh 1 uname
-a` will run the uname command on node one. This works for simple commands,
however for more complex commands we recommend using `juju run` instead.

See also the `juju help ssh` command for more information.


## The Juju scp command

Copying files to and from units can be a common task depending on your
workload, so Juju provides a `juju scp` command for copying files securely to
and from units.

Examples:

Copy a single file from machine 2 to the local machine:

```bash
juju scp 2:/var/log/syslog .
```

Copy 2 files from two MySQL units to the local backup/ directory, passing -v to
scp as an extra argument:

```bash
juju scp -v mysql/0:/path/file1 mysql/1:/path/file2 backup/
```

Recursively copy the directory `/var/log/mongodb/` on the first MongoDB server
to the local directory remote-logs:

```bash
juju scp -r mongodb/0:/var/log/mongodb/ remote-logs/
```

Copy a local file to the second apache2 unit of the environment "testing":

```bash
juju scp -e testing foo.txt apache2/1:
```

For more information, run the `juju help scp` command.


## The Juju run command

The `juju run` command can be used by devops or scripts to inspect or do work
on services, units, or machines. Commands for services or units are executed in
a hook context. Charm authors can use the run command to develop and debug
scripts that run in hooks.

For example, to run uname on every instance:

```bash
juju run "uname -a" --all
```

Or to run uptime on some instances:

```bash
juju run "uptime" --machine=2
juju run "uptime" --service=mysql
```

!!! Note: When using `juju run` with the `--service` option, keep in mind that
whichever command you pass will run on *every unit* of that service.

When used in combination with certain services you can script certain tasks.
For instance, in the 'hadoop' charm you can use `juju run` to initiate a
terasort:

```bash
juju run --unit hadoop-master/0 "sudo -u hdfs /usr/lib/hadoop/terasort.sh"
```

For more information see the `juju help run` command.
