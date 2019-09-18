<!--
Todo:
- Update when upgrade path from 1.25 to 2.x is available
-->
You may wish to use the 2.x series of Juju for new projects, tests, or development work, but still require to support legacy deployments, which use the 1.x series. It is possible to install both series on the same host but how it's done depends on your OS.

The data directory for 1.x is `~/.juju` and for 2.x it is `~/.local/share/juju/`. Keep these as-is; do not attempt to co-locate files in a central directory.

The instructions given in this guide must be followed by a user logout, login, and a verification of what series is associated with the called binary. For example, if the called binary is `juju-1` then a verification consists of:

``` text
juju-1 version
```

[note]
On Ubuntu 18.04 LTS (Bionic) the 1.x series is not available.
[/note]

<h2 id="heading--ubuntu-and-2x">Ubuntu and 2.x</h2>

On Ubuntu, install 2.x using [these](/t/installing-juju/1164#heading--ubuntu) standard instructions.

<h2 id="heading--ubuntu-1604-lts-xenial-and-1x">Ubuntu 16.04 LTS (Xenial) and 1.x</h2>

On Xenial, how to install 1.x depends on which series you want to be the default binary.

<h3 id="heading--to-make-2x-be-the-default">To make 2.x be the default</h3>

To let 2.x be the default install 1.x with the following deb:

``` text
sudo apt install juju-1.25
```

Here, `juju` will call 2.x and `juju-1` will call 1.x.

<h3 id="heading--to-make-1x-be-the-default">To make 1.x be the default</h3>

To let 1.x be the default install 1.x with this deb:

``` text
sudo apt install juju-1-default
```

Now, `juju` will call 1.x and `/snap/bin/juju` will call 2.x.

<h2 id="heading--ubuntu-1404-lts-trusty-and-1x">Ubuntu 14.04 LTS (Trusty) and 1.x</h2>

On Trusty, there is only one way to install 1.x:

``` text
sudo apt install juju
```

<h3 id="heading--to-make-2x-be-the-default">To make 2.x be the default</h3>

There's no fancy way to make 2.x be called by `juju` by default.

Edit your PATH environment variable so that `/snap/bin` appears before `/usr/bin`. For the Bash shell, one way is to add a line at the bottom of `~/.profile`. For example:

``` text
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/snap/bin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
```

To fully reflect the corresponding Xenial scenario, you can create a symbolic link for the 1.x series:

``` text
sudo ln -s /usr/bin/juju /usr/bin/juju-1
```

After these changes, `juju` will call 2.x and `juju-1` will call 1.x.

<h3 id="heading--to-make-1x-be-the-default">To make 1.x be the default</h3>

In this scenario, by default, `juju` will call 1.x and `/snap/bin/juju` will call 2.x.

<h2 id="heading--other-linux">Other Linux</h2>

The CentOS download, available [here](/t/installing-juju/1164#heading--centos-and-other-linuxes), includes the binaries for Juju which should also work on other flavours of Linux. As these tarballs simply contain an executable binary, you can place them wherever you wish, renaming them if required.

It is recommended to install them in `/usr/lib/juju-1.25/bin` and `/usr/lib/juju-2.0/bin`. After which you can use `ùpdate-alternatives` to configure which one to use:

``` text
update-alternatives --install /usr/bin/juju juju /usr/lib/juju-2.0/bin/juju 1
update-alternatives --install /usr/bin/juju juju /usr/lib/juju-1.25/bin/juju 0
update-alternatives --config juju
```

The same data directories as noted above for Ubuntu are created on first use of the Juju binary.

<h2 id="heading--windows">Windows</h2>

The latest Windows version of Juju can be downloaded from [here](/t/installing-juju/1164#heading--windows).

Unlike Linux and OS X binary releases, the Microsoft Windows version of Juju is bundled within an executable installer. Running this will walk you through a GPL licence agreement, a request for an install location and the opportunity to add this install location to your environment path.

By default, a new installation will upgrade any previous installation. If you wish to install two versions alongside one another, such as versions 1.25 and 2.0, you will need to install the first package without specifying an environment path. This will stop the second installation automatically overwriting the first. You can then specify a different install location for the second installation and either manually rename and add the binaries to your Windows environment path, or run each executable directly from their respective directories.

Juju can be uninstalled from the Windows 'Add or remove programs' system pane, just like any other Windows application.

<h2 id="heading--macos">macOS</h2>

The Apple OS X download, available [here](/t/installing-juju/1164#heading--macos), includes the binaries for Juju. These will work work with any recent version of Mac OS X, including 10.9 (Mavericks), 10.10 (Yosemite), 10.11 (El Capitan) and 10.12 (Sierra).

As the download tarball contains executable binaries, you can place them wherever you wish within your user's shell path (such as `/usr/bin`), renaming them or their parent folders if required. Renaming is particularly useful if you want to install two versions of Juju alongside one another, such as versions 1.25 and 2.5, as the binary files within each archive have identical names.

Unfortunately, OS X doesn't currently support a system similar to `update-alternatives` (see above), which means you'll need to manually update and name the files differently when installing and using multiple versions.

<!-- LINKS -->
