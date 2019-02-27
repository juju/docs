Title: 2.5.2 Release Notes 

# 2.5.2 Release Notes

The Juju team is proud to release Juju 2.5.2! 

This is a bugfix release of the current stable 2.5 version of Juju. 

Important fixes:

- [LP #1813044](https://bugs.launchpad.net/juju/+bug/1813044) - 2.5.0: race condition when upgrading multiple charms in the same machine
- [LP #1803247](https://bugs.launchpad.net/juju/+bug/1803247) - unable to determine if a model is a controller model
- [LP #1814962](https://bugs.launchpad.net/juju/+bug/1814962) - juju run should allow specification of leader units like juju run-action
- [LP #1815636](https://bugs.launchpad.net/juju/+bug/1815636) - container-inherit-properties=apt-primary,apt-security,apt-sources doesn't work on MAAS provider
- [LP #1815154](https://bugs.launchpad.net/juju/+bug/1815154) - juju status as admin with non-default format fails on other users' models

For the full list of fixes and additions, see the
[2.5.2 milestone](https://launchpad.net/juju/+milestone/2.5.2).

## Get Juju

The easiest way to install Juju is by using the `snap` package:

    sudo snap install juju --classic

Those already using the 'stable' snap channel (the default as per the above
command) should be upgraded automatically. Other packages are available for a
variety of platforms (see the [install documentation][reference-install]).

## Feedback appreciated

Let us know how you're using Juju or of any questions you may have. You can
join us on [Discourse][juju-discourse-forum], send us a message on Twitter
(hashtag `#jujucharms`), or talk to us in the `#juju` IRC channel on
freenode.

## More information

To learn more about Juju visit our home page at 
[https://jujucharms.com][upstream-juju].


<!-- LINKS -->

[reference-install]: ./reference-install.md
[juju-discourse-forum]: https://discourse.jujucharms.com/
[upstream-juju]: https://jujucharms.com
