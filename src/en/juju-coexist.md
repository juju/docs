Title: Running multiple versions of Juju
TODO: Update when upgrade path is available
      Add information for MacOS
      Add information for Windows
      
# Running multiple versions of Juju

You may wish to use the new 2.x series of Juju releases for new projects, 
tests and development work, but still require to support legacy deployments
which were built on and use the 1.x version of Juju.

Juju 2.x has been designed to be able to co-exist with earlier versions, so
you can install both. The details vary depending on your OS, as detailed
below:

## Ubuntu 16.04LTS (Xenial) and later releases

Running 

```bash
apt install juju
```

...will install the latest Juju 2.x. If you also want to run the legacy
1.x series, you may install that separately:

```bash
àpt install juju-1.25
```
**OR**, if you wish to run Juju 1.x as the 'primary' Juju (i.e. the version
the `juju` command points to by default), you can install this package:

```bash
apt install juju-1-default
```

(Juju 2.x will be available by running the `juju-2.0` command).



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

```bash
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

The CentOS download [here][centos] includes the binaries for Juju which 
should also work on other flavours of Linux. As these tarballs simply 
contain an executable binary, you can place them wherever you wish, renaming
them if required.

It is recommended to install them in `/usr/lib/juju-1.25/bin/` and 
`/usr/lib/juju-2.0/bin`. After which you can also use `ùpdate-alternatives`
to configure which one to use:

```
update-alternatives --install /usr/bin/juju juju /usr/lib/juju-2.0/bin/juju 1
update-alternatives --install /usr/bin/juju juju /usr/lib/juju-1.25/bin/juju 0
update-alternatives --config juju
```

The same data directories as noted above for Ubuntu are created on first
use of the Juju binary.

## Windows

Information to follow

## MacOS

Information to follow

[centos]: ./reference-releases.html#stable
