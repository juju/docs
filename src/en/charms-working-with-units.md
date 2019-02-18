Title: Working with units  
TODO:  Convert into a tutorial

# Working with units

Each node that Juju manages is referred to as a "unit". Generally speaking,
when using Juju you interact with the applications at the application level. 
There are times when working directly with units is useful though, particularly
for debugging purposes. Juju provides a few different commands to make this
easier.


## The juju ssh command

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


## The juju scp command

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

Copy a local file to the second apache2 unit in the model "testing":

```bash
juju scp -m testing foo.txt apache2/1:
```

!!! Note:
    Juju cannot transfer files between two remote units because it uses public
    key authentication exclusively and the native (OpenSSH) `scp` command
    disables agent forwarding by default. Either the destination or the source
    must be local (Juju client).

For more information, run the `juju help scp` command.


## ???

The `run` command can be used to inspect or perform work on machines by
targeting applications, units, or actual machines. The command operates on a
per-model basis.

!!! Note:
    Only users with 'admin' model access can use the `run` command.

For example, consider the Linux `uname` command in the below scenarios.

 - To target all machines in a model the `--all` option is used:

```bash
juju run 'uname' --all
```

 - To target all units of specific applications the `--application` option is
   used:

```bash
juju run 'uname' --application=mysql
```

 - To target a single unit of a specific application the `--unit` option is
   used:

```bash
juju run 'uname' --unit=mysql/0,mysql/1
```

 - To target specific machines the `--machines` option is used (command is run
   as the 'root' user on the target machines).

```bash
juju run 'uname' --machine=0,2
```
 
!!! Positive "Pro tip":
    Commands for applications or units are executed in a hook context. Charm
    authors can therefore use the `run` command to develop and debug scripts
    that run in hooks.
