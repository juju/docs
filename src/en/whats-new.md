Title: What's new in 2.3

# What's new in 2.3

The major new features in this release are summarised below. If you're new to
Juju, begin by going through our [Getting started][getting-started] guide
first.

For more details on the new features in Juju 2.3 see the
[2.3 release notes][anchor__release-notes-2.3.0].

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


<!-- LINKS -->

[getting-started]: https://jujucharms.com/docs/devel/getting-started
[charms-storage]: https://jujucharms.com/docs/stable/charms-storage
[models-cmr]: https://jujucharms.com/docs/stable/models-cmr
[charms-fan]: https://jujucharms.com/docs/stable/charms-fan
[anchor__release-notes-2.3.0]: ./reference-release-notes.html#juju_2.3.0
