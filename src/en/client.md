Title: Juju client
TODO:  

# Juju client

It is easy to forget that your client environment needs to be backed up. Aside 
from things like the 'credentials.yaml' file, which you may be able to 
recreate, it contains unique files such as Juju's SSH keys, which are vital to 
be able to connect to a running instance. In order to also save any additional
configuration files (such as the files used by running models) it is usually 
best to simply back up the entire Juju directory (`~/.local/share/juju`).

!!! Note: 
    On Windows systems, the Juju directory is in a different place
    (usually `C:\Users\{username}\AppData\Roaming\Juju`. Also, although `tar` is 
    available for Windows, you may prefer to use a more Windows-centric backup 
    application.

### A simple backup of the Juju client directory

As the Juju directory is simply just another directory on your filesystem, you 
may wish to include it in any regular backup procedure you already have. For a 
simple backup on an Ubuntu system, you can just use `tar` to create an archive 
of the directory:

```bash
cd ~
tar -cpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz .local/share/juju 
```

This command datestamps the created file for easy identification. You may, of
course, call it what you wish. 

!!! Note: 
    As mentioned previously, the files in this backup include the keys 
    Juju uses to connect to running environments. Anybody who has access to this 
    backup will be able to connect to and use your controllers/models, so a 
    further step of encrypting this backup file may be advisable.
 
### Restoring ~/.local/share/juju

For Ubuntu, restoring your Juju client settings is a simple matter of
extracting the archive you created above.

```bash
cd ~
tar xzf juju-yymmdd-hhmmss.tar.gz 
```

!!! Note: 
    This command will extract the contents of the archive and overwrite 
    any existing files in the Juju directory. Please be sure that this is what you 
    want!


