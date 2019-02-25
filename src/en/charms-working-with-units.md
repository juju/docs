Title: Working with units  

# Working with units



## Connecting to units via SSH


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
juju run --all uname
```

 - To target all units of specific applications the `--application` option is
   used:

```bash
juju run --application=mysql uname
```

 - To target a single unit of a specific application the `--unit` option is
   used:

```bash
juju run --unit=mysql/0,mysql/1 uname 
```

 - To target specific machines the `--machines` option is used (command is run
   as the 'root' user on the target machines).

```bash
juju run --machine=0,2 uname 
```

To pass options or arguments with the command precede it with '--'. For
example:
 
 ```bash
juju run --all -- hostname -f
 ```
 
!!! Positive "Pro tip":
    Commands for applications or units are executed in a hook context. Charm
    authors can therefore use the `run` command to develop and debug scripts
    that run in hooks.


<!-- LINKS -->


