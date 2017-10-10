Title: Charm promulgation

# Charm promulgation

To promulgate a Juju charm a member of the
[~charmers][launchpad-group-charmers] Launchpad group will:

1. Download the proposed charm (`charm pull`).
1. Perform static analysis on the charm (`charm proof`).
1. Ensure the charm has a bugs-url and homepage (`charm set`).
1. If steps 2 or 3 fails, the charm author will be asked to make changes.
1. Promulgate the charm (`charm promulgate`).
1. Grant write access to the promulgated charm (`charm grant`).


<!-- LINKS -->

[launchpad-group-charmers]: https://launchpad.net/~charmers
