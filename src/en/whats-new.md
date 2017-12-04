Title: What's new in 2.3

# What's new in 2.3

The major new features in this release are explained briefly below. If you're
new to Juju, begin by reading our [Getting started][getting-started] guide
first.

For further details, see the [2.3 release notes][anchor__release-notes-2.3].

## Persistent storage

Persistent Storage enables operators to manage the lifecycle of storage
independently of Juju machines. See [Using Juju storage][charms-storage] for a
complete breakdown of how persistent storage, also called *dynamic storage*,
fits in with legacy Juju storage.

## Cross model relations

Cross model relations make centralised management of multiple models a reality
by allowing applications in separate models to form relations between one
another. This feature also works across multiple controllers. See 
[Cross model relations][models-cmr] for more information and examples.

## Fan networking

application density by providing
routable containers on all providers via the FAN.
[Fan networking][charms-fan]


<!-- LINKS -->

[getting-started]: https://jujucharms.com/docs/devel/getting-started
[charms-storage]: https://jujucharms.com/docs/stable/charms-storage
[models-cmr]: https://jujucharms.com/docs/stable/models-cmr
[charms-fan]: https://jujucharms.com/docs/stable/charms-fan
[anchor__release-notes-2.3]: ./reference-release-notes.html#juju_2.3.0
