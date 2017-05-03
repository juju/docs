Title: Installing Juju

# Getting the latest Juju

Juju is available as a client on many platforms and distributions. Find your
platform below and get started with Juju!


## Ubuntu

For Ubuntu 16.04 LTS (Xenial) and other OSes which have snaps enabled
([see the snapcraft.io site][snapcraft]) you can install the latest
stable release of Juju with the command:

     sudo snap install juju --classic

You can check which version of Juju you have installed with

     sudo snap list juju

And update it if necessary with:

     sudo snap refresh juju



## macOS

The easiest way to install Juju on macOS is with the [brew package
manager][brew]. With brew installed, simply enter the following into a
terminal:

   brew install juju

If you previously installed Juju with brew, the package can be
updated with the following:

   brew upgrade juju

For alternative installation methods, see the [releases page][releases].


## Windows

A Windows installer is available for Juju.

[juju-setup-2.1.2.exe](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe/+md5))

Please see the [releases page][releases] for other
versions.


## Centos and other Linuxes


Spans enable installing the the Juju client on an array of Linux
distributions. Note that the `--classic` flag is not supported on many of them
and so you'll need to use `--devmode` instead.

See the [span install documentation][snap-install] to get snapd onto your linux and then you
can install Juju with:

```
 sudo snap install juju --classic
```


# Getting development releases

The Juju team regularly puts out alpha, beta, and RC releases during a
development cycle. We encourage users to please test these versions out with
their workloads and use cases and [file bugs][bugs] if you hit any issues.
Remember that while in development feedback on usability and missing
functionality is very important so don't just file bugs for things that go
wrong, but also for things that have an opportunity to be "more right".


## Ubuntu

It is possible to install other versions, including beta releases of
Juju via a snap package. See the [releases page][releases] for more information.


## macOS

The easiest way to install Juju on macOS is with the [brew package
manager][brew]. The development releases are put under the `--devel` flag in
brew.

   brew install --devel juju

For alternative installation methods, see the [releases page][releases].


## Windows

The latest windows .exe can be downloaded from the Juju download page.

https://launchpad.net/juju/+download



# Building from source

Check out the [Contributing][contributing] documentation in the codebase to walk through
building Juju from source.


[brew]: https://brew.sh/
[bugs]: https://bugs.launchpad.net/juju/
[contributing]: https://github.com/juju/juju/blob/develop/CONTRIBUTING.md
[releases]: ./reference-releases.html
[snapcraft]: https://snapcraft.io
[snap-install]: https://snapcraft.io/docs/core/install
