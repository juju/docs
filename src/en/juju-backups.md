Title: Back up and restore Juju

# Backing up And Restoring Juju

It is always a good idea to keep backups, and it is possible to backup both the 
Juju client environment and the Juju state server (bootstrap node) to be able to 
reconnect to running cloud environments. Both the backup and restore procedures
for each are detailed below.

## The Juju client

It is easy to forget that your client environment needs to be backed up. Aside 
from things like the 'environments.yaml' file, which you may be able to 
recreate, it contains unique files such as Juju's SSH keys, which are vital to 
be able to connect to a running instance. In order to also save any additional
configuration files (such as '.jenv' files for running environments, or
credentials) it is usually best to simply back up the entire Juju directory
(```~/.juju```)

### Backup ~/.juju

As the Juju directory is simply just another directory on your filesystem, you 
may wish to include it in any regular backup procedure you already have. For a 
simple backup, you can just use ```tar``` to create an archive of the directory:

```bash
cd ~
tar -cpzf juju-$(date "+%Y-%b-%d_%H-%M-%S").tar.gz .juju 
```

This command datestamps the created file for easy identification, you may of
course, call it what you wish.

If you have used the local provider, you will need to run the command as a 
superuser:

```bash
cd ~
sudo tar -cpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz .juju 
```

This is because the local provider makes use of superuser priveleges, and
consequently some of the files belong to 'root' and cannot be read by a normal
user. You will also find that the backup archives are substantially bigger. 
As the local provider stores everything in '~/.juju', you are effectively 
backing up the entire local environment also. If you aren't concerned about the 
local user, you can omit the local provider files by supplying the 
```--exclude-path=``` switch as many times as necessary and specifying the name 
of your local environment(s):

```bash
sudo tar -cvpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz --exclude=.juju/local --exclude=.juju/local2 .juju 
```

!!! Note: As mentioned previously, the files in this backup include the keys 
Juju uses to connect to running environments. Anybody who has access to this 
backup will be able to connect to and control your environments, so a further 
step of encrypting this backup file may be advisable.
 
### Restoring ~/.juju

Restoring your Juju client settings and environments is a simple matter of 
extracting the archive you created above.

```
tar xzf juju-yymmdd-hhmmss.tar.gz 
```

In the case of any local environment, this will also be restored providing the 
actual service itself (LXC) has remained running.

## The Juju state server (bootstrap node)

### Backup

### Managing Backups

### Restore
