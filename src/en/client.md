Title: Juju client

# Juju client

This page covers various operations that can be applied to the Juju client, the
software that is used to manage Juju, whether as an administrator or as a
regular user.

The following topics are covered:

 - Client directory
 - Client backups
 - Client upgrades

See the [Concepts][concepts-client] page for a full definition of the client.

## Client directory

The Juju client directory is located, on Ubuntu, at `~/.local/share/juju`.

Aside from things like a credentials YAML file, which you are presumably able
to recreate, this directory contains unique files such as Juju's SSH keys,
which are necessary to be able to connect to a Juju machine. This location may
also be home to resources needed by charms or models.

!!! Note: 
    On Microsoft Windows, the directory is in a different place (usually
    `C:\Users\{username}\AppData\Roaming\Juju`).

## Client backups

A backup of the client enables one to regain management control of one's
controllers and associated cloud environments.

This section will cover the following topics:

 - Creating a backup
 - Restoring from a backup

!!! Note:
    Data backups can also be made of the Juju controller. See the
    [Controller backups][controllers-backups] page for guidance.

### Creating a backup

Making a copy of the client directory is sufficient for backing up the client.
This is normally done with backup software that compresses the data into a
single file (archive). On a Linux/Ubuntu system, the `tar` program is a common
choice:

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

## Client upgrades

The client software is managed by the operating system's package management
system. On Ubuntu this is traditionally APT:

```bash
sudo apt update
sudo apt install juju
```

If Juju was installed via snaps then no action is required as a snap, by
default, will update automatically. However, this is how to update manually:

```bash
sudo snap refresh juju
```

The current Juju snap version can be queried like so:

```bash
snap info juju
```

For more installation information and what versions are available, see
[Reference: Installing Juju][reference-install].

!!! Note:
    Models can also be upgraded. See the [Model upgrades][models-upgrade]
    page for guidance.


<!-- LINKS -->

[concepts-client]: juju-concepts.html#client
[controllers-backups]: controllers-backup.html
[reference-install]: reference-install.html
[models-upgrade]: models-upgrade.md
