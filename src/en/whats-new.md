Title: What's new in 2.3

# What's new in 2.3

The major new features in this release are summarised below. If you're new to
Juju, begin by going through our [Getting started][getting-started] guide
first.

For details on these features, and other improvements not listed here, see
the [2.3 release notes][release-notes-2.3.0].

## Persistent storage

Persistent storage enables operators to manage the life-cycle of storage
independently of Juju machines. See [Using Juju storage][charms-storage] for a
complete breakdown of how persistent storage, also called *dynamic storage*,
fits in with legacy Juju storage.

## Cross model relations

Cross model relations make centralised management of multiple models a reality
by allowing applications in separate models to form relations between one
another. This feature also works across multiple controllers. See 
[Cross model relations][models-cmr] for more information and examples.

## Fan networking support

Fan networking leads to the reconfiguration of an IPv4 address space such that
network connectivity among containers running on separate hosts becomes
possible. Applied to Juju, this allows for the seamless interaction between
deployed applications running within LXD containers on separate Juju machines.
Read [Juju and Fan networking][charms-fan] for more on this exciting topic.

## Improvements to bundles

You can now recycle existing machines instead of having new ones created. It is
also possible to map specific machines to machines configured in the bundle.

A bundle declaration can be placed on top of a base bundle to override elements
of the latter. These are bonafide bundle files, called "overlay bundles", that
can do anything a normal bundle can do. They can also remove applications from
the base bundle. See [Overlay bundles][overlay-bundles].


<!-- LINKS -->

[getting-started]: https://jujucharms.com/docs/devel/getting-started
[charms-storage]: https://jujucharms.com/docs/stable/charms-storage
[models-cmr]: https://jujucharms.com/docs/stable/models-cmr
[charms-fan]: https://jujucharms.com/docs/stable/charms-fan
[release-notes-2.3.0]: ./reference-release-notes.html#juju_2.3.0
[overlay-bundles]: ./charms-bundles.html#overlay-bundles
