Title: Charm promulgation

# Charm promulgation

Charm promulagation is the process of making your charm available on the charm store and visible in searches. This is a manual process and requires a review from a member of the [~charmers][launchpad-group-charmers] Launchpad group.

## Before you request promulgation

You should spend some time verifying your charm is in good shape before you request promulgation. If you are requesting promulgation over an existing charm, ensure your charm uses the same configuration variables and has the same or greater feature set or be able to explain why your charm should replace the existing one. Use the following checklist to ensure you are ready for promulgation

- [ ] Verify charm proof doesn't have any errors.
- [ ] Ensure the charm source is available and in a public repository
- [ ] Make sure the charm has bugs-url and homepage set via `charm set bug-url="https://example.com/issues" && charm set homepage="https://example.com"`

## Request promulgation

The current method of requesting promulgation is to go to [the Juju discourse page][juju-discourse] and make a new topic with the Charming tag requesting promulgation. Once you submit your request simply wait for someone to respond to the topic with either questions or status.

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
[juju-discourse]: https://discourse.juju.com
