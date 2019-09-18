This is a bug fix release and includes the fixes below:

-   [LP #1803484](https://bugs.launchpad.net/juju/2.4/+bug/1803484) - httpserver worker restart with controller-api-port gets stuck
-   [LP #1778033](https://bugs.launchpad.net/juju/2.4/+bug/1778033) - juju stuck attaching storage to OSD

For the full list of fixes and additions, see the [2.4.7 milestone](https://launchpad.net/juju/+milestone/2.4.7).

<h2 id="heading--enhancements">Enhancements</h2>

**Disabling juju state metrics**
It was found that for some large controllers where the metrics were being scraped into Prometheus, the collection of some metrics related to information stored in the database was slow and causing timeouts. To deal with this issue we have added a controller configuration feature to disable the gathering of those metrics.

This can be enabled using

    juju controller-config features=[disable-state-metrics]

This can be set before upgrading to 2.4.7. The controller will need to be restarted if it's done after upgrading.

<h2 id="heading--get-juju">Get Juju</h2>

The easiest way to install Juju is by using the `snap` package:

    sudo snap install juju --classic

Those already using the 'stable' snap channel (the default as per the above command) should be upgraded automatically. Other packages are available for a variety of platforms (see the [install documentation](/t/installing-juju/1164)).

<h2 id="heading--feedback-appreciated">Feedback appreciated</h2>

Let us know how you're using Juju or of any questions you may have. You can join us on [Discourse](https://discourse.jujucharms.com/), send us a message on Twitter (hashtag `#jujucharms`), or talk to us in the `#juju` IRC channel on freenode.

<h2 id="heading--more-information">More information</h2>

To learn more about Juju visit our home page at <https://jujucharms.com>.

<!-- LINKS -->
