Title: Running multiple versions of Juju
TODO: Update when upgrade path is available
      Add information for MacOS
      Add information for Windows
      Add information for Other Linux OSes

# Running multiple versions of Juju

You may wish to use the new 2.x series of Juju releases for new projects, 
tests and development work, but still require to support legacy deployments
which were built on and use the 1.x version of Juju.

Juju 2.x has been designed to be able to co-exist with earlier versions, so
you can install both. The details vary depending on your OS, as detailed
below:

## Ubuntu 16.04LTS (Xenial) and later releases

It is possible to install 


### Data directories

The 1.x series keeps data in `~/.juju`
The 2.x series keeps data in `~/.local/share/juju/`

You can alter these by setting the environment variables `JUJU_HOME` and
`JUJU_DATA` respectively. **DO NOT** co-locate the files in these
directories or unfortunate things will happen.


## Ubuntu 14.04LTS (Trusty)

Both series 1.x and 2.x can co-exist in Trusty. If you have already 
installed and used 1.x and subsequently install 2.0, the binary for
2.0 will be installed at `/usr/lib/juju-2.0/bin/juju`

You can replicate the experience for Ubuntu 16.04 by using the 
`ùpdate-alternatives` command to add 2.x as an alternative for
the binary to call when issuing the `juju` command, and to add a
`juju-1` command for the 1.x series:

```
update-alternatives --install /usr/bin/juju juju /usr/lib/juju-2.0/bin/juju 1
update-alternatives --install /usr/bin/juju-1 juju-1 /usr/lib/juju-1.25.6/bin/juju 0
update-alternatives --config juju
```

This last command will present a choice for which version to use for 
the `juju` command.

### Data directories

The 1.x series keeps data in `~/.juju`
The 2.x series keeps data in `~/.local/share/juju/`

You can alter these by setting the environment variables `JUJU_HOME` and
`JUJU_DATA` respectively. **DO NOT** co-locate the files in these 
directories or unfortunate things will happen.


## Other Linux 

Information to follow

## Windows

Information to follow

## MacOS

Information to follow
