This page covers various operations that can be applied to the Juju client, the software that is used to manage Juju, whether as an admin user or as a regular user.

The following topics are covered:

-   Client directory
-   Client backups
-   Client upgrades

See the [Concepts](/t/concepts-and-terms/1144#heading--client) page for a full definition of the client.

<h2 id="heading--client-directory">Client directory</h2>

The Juju client directory is located, on Ubuntu, at `~/.local/share/juju`.

Aside from things like a credentials YAML file, which you are presumably able to recreate, this directory contains unique files such as Juju's SSH keys, which are necessary to be able to connect to a Juju machine. This location may also be home to resources needed by charms or models.

[note]
On Microsoft Windows, the directory is in a different place (usually `C:\Users\{username}\AppData\Roaming\Juju`).
[/note]

<h2 id="heading--client-backups">Client backups</h2>

A backup of the client enables one to regain management control of one's controllers and associated cloud environments.

This section will cover the following topics:

-   Creating a backup
-   Restoring from a backup

[note]
Data backups can also be made of the Juju controller. See the [Controller backups](/t/controller-backups/1106) page for guidance.
[/note]

<h3 id="heading--creating-a-backup">Creating a backup</h3>

Making a copy of the client directory is sufficient for backing up the client. This is normally done with backup software that compresses the data into a single file (archive). On a Linux/Ubuntu system, the `tar` program is a common choice:

``` text
cd ~
tar -cpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz .local/share/juju 
```

[note]
For Microsoft Windows any native Windows backup tool will do.
[/note]

The above invocation embeds a timestamp in the generated archive's filename, which is useful for knowing **when** a backup was made. You may, of course, call it what you wish.

The archive should normally be transferred to another system (or at the very least to a different physical drive) for safe-keeping.

[note type="caution"]
Whoever has access to a client backup will have access to its associated environments. Appropriate steps should be taken to protect it (e.g. encryption).
[/note]

<h3 id="heading--restoring-from-a-backup">Restoring from a backup</h3>

Restoring your client settings is a simple matter of extracting the backup created earlier. For Ubuntu:

``` text
cd ~
tar -xzf juju-yymmdd-hhmmss.tar.gz 
```

[note type="caution"]
This command will extract the contents of the archive and overwrite any existing files in the Juju directory. Make sure that this is what you want.
[/note]

<h2 id="heading--client-upgrades">Client upgrades</h2>

The client software is managed by the operating system's package management system. On Ubuntu this is traditionally APT:

``` text
sudo apt update
sudo apt install juju
```

If Juju was installed via snaps then no action is required since a snap, by default, will update automatically. However, this is how to update manually:

``` text
sudo snap refresh juju
```

The current Juju snap version can be queried like so:

``` text
snap info juju
```

For more installation information and what versions are available, see [Reference: Installing Juju](/t/installing-juju/1164).

[note]
Models can also be upgraded. See the [Upgrading models](/t/upgrading-models/1154) page for guidance.
[/note]

<!-- LINKS -->
