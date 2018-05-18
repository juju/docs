Title: Juju client

# Juju client

This page covers various operations that can be applied to the Juju client, the
software that is used to manage Juju, whether as an administrator or as a
regular user.

The following topics are covered:

 - Client backups

<!--
 - Client upgrades
-->

See the [Concepts][concepts-client] page for a full definition of the client.

## Client backups

Data backups can be made of the Juju client and the Juju controller. This
section concerns itself with the client aspect only. For information on
controller backups see the [Controller backups][controllers-backups] page.

This section will cover the following topics:

 - Client directory
 - Creating a backup
 - Restoring from a backup

### Client directory

The Juju client directory is located, on Ubuntu, at `~/.local/share/juju`.

Aside from things like a credentials YAML file, which you are presumably able
to recreate, this directory contains unique files such as Juju's SSH keys,
which are necessary to be able to connect to a Juju machine. In order to also
save any additional configuration files (such as the files used by running
models) it is recommended to back up the entire Juju directory.

!!! Note: 
    On Microsoft Windows, the directory is in a different place (usually
    `C:\Users\{username}\AppData\Roaming\Juju`).

### Creating a backup

Making a copy of the client directory is normally done with backup software
that compresses the data into a single file (archive). On a Linux/Ubuntu
system, the `tar` program is a common choice:

```bash
cd ~
tar -cpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz .local/share/juju 
```

!!! Note:
    For Microsoft Windows any native Windows backup tool will do.

The above invocation embeds a timestamp in the generated archive's filename,
which is useful for knowing **when** a backup was made. You may, of course,
call it what you wish. 

The archive should normally be transferred to another system (or at the very
least to a different physical drive) for safe-keeping.

!!! Warning: 
    Whoever has access to a client backup will have access to its associated
    environments. Appropriate steps should be taken to protect it (e.g.
    encryption).
 
### Restoring from a backup

Restoring your client settings is a simple matter of extracting the backup
created earlier. For Ubuntu:

```bash
cd ~
tar -xzf juju-yymmdd-hhmmss.tar.gz 
```

!!! Warning: 
    This command will extract the contents of the archive and overwrite any
    existing files in the Juju directory. Make sure that this is what you want.


<!-- LINKS -->

[concepts-client]: juju-concepts.html#client
[controllers-backups]: controllers-backup.html
