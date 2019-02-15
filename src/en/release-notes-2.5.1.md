Title: 2.5.1 Release Notes 

# 2.5.1 Release Notes

The Juju team is proud to release Juju 2.5.1! 

This is a release primarily to address various performance issues found when
running at scale. The major issues encountered related to start up of
controllers and abnormal behaviour of leadership, both when the controllers
are under heavy load.

There's also a couple of cross model relations fixes, including a fix for
allowing multiple offers of a single application.

Important fixes:

- [LP #1815179](https://bugs.launchpad.net/bugs/1815179) - It is not possible to actively use two offers of the same application at the same time
- [LP #1813151](https://bugs.launchpad.net/bugs/1813151) - cmr: remote SAAS status incorrectly reported in consuming model
- [LP #1807735](https://bugs.launchpad.net/bugs/1807735) - Juju controller cannot connect to itself
- [LP #1810331](https://bugs.launchpad.net/bugs/1810331) - Mid-hook lost leadership issues
- [LP #1813104](https://bugs.launchpad.net/bugs/1813104) - Massive goroutine leak (logsink 2.5.0)
- [LP #1813261](https://bugs.launchpad.net/bugs/1813261) - api-server and http-server get stuck in "state: stopping"
- [LP #1813867](https://bugs.launchpad.net/bugs/1813867) - Hubwatcher caches last modified revno for all docs (memory consumption)
- [LP #1814556](https://bugs.launchpad.net/bugs/1814556) - lease Manager should not evaluate all Leases and all Blocks on every loop()
- [LP #1811700](https://bugs.launchpad.net/bugs/1811700) - GetMeterStatus called too frequently
- [LP #1815719](https://bugs.launchpad.net/bugs/1815719) - repeated ErrInvalid can cause lease.Manager to be stopped

For the full list of fixes and additions, see the
[2.5.1 milestone](https://launchpad.net/juju/+milestone/2.5.1).

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
