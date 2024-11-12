(charmed-ingress-on-k8s-with-traefik-and-traefik-route)=
# Charmed ingress on k8s with Traefik and Traefik-Route

The [traefik charm](https://charmhub.io/traefik-k8s) is a charm to provide ingress to another charmed application 'the juju way'. The idea is that if a charm integrates with `traefik-k8s` then you can relate the two applications and your application will receive the url at which ingress is made available.

The traefik charm supports two standardized interfaces:
- [ingress](https://github.com/canonical/charm-relation-interfaces/tree/main/interfaces/ingress/v2#readme) 

  Using this interface, each charmed application can request a single, cluster-unique url for ingress. You can choose between a domain-name-based url (`your.parameters.domain.com`) and a path-based url (`domain.com\your\parameters`).
- [ingress-per-unit](https://github.com/canonical/charm-relation-interfaces/blob/main/interfaces/ingress_per_unit/v0/README.md)

  Using this interface, each charmed application can request a cluster-unique url for each existing unit. This is for applications such as prometheus, where each remote-write endpoint needs to be routed to separately, and database applications who wish to do client-side load-balancing.

## Traefik-route
The [traefik route charm](https://charmhub.io/traefik-route-k8s) is a proxy charm that sits between traefik and a charm in need of ingress, and is used to provide low-level access to traefik configuration, as well as to allow per-relation configuration. 


Want to have full access to all the expressive power of [traefik's routing configuration](https://doc.traefik.io/traefik/routing/overview/)? Want to have one traefik instance, and provide domain-name-based url routing to some charms, but path-based url routing to some others? This is how you do it.

## How to add ingress to your charm

Traefik owns two charm libraries to facilitate integrating with it over `ingress` and `ingress_per_unit`.
At the time of writing, the most recent `ingress` version is v2. You can verify what the latest version for the libraries is by visiting the documentation pages on charmhub:

- [`ingress`](https://charmhub.io/traefik-k8s/libraries/ingress)
- [`ingress_per_unit`](https://charmhub.io/traefik-k8s/libraries/ingress_per_unit)

The following steps assume we want to use `ingress`. The process for `ingress_per_unit` is very similar.

### Fetch the latest `ingress` library

`charmcraft fetch-lib charms.traefik_k8s.v2.ingress`

This will download `lib/charms/traefik_k8s/v2/ingress.py`
The simplest way to use the library is to instantiate the `IngressPerAppRequirer` object from your charm's constructor.
You can immediately pass to it the host and port of the server you want to be ingressed (useful if they are static), or you can defer that decision to a later moment by using the `IngressPerAppRequirer.provide_ingress_requirements` API.

```python
# src/charm.py
from charms.traefik_k8s.v2.ingress import IngressPerAppRequirer, IngressReadyEvent

... # your charm's __init__(self, ...):
        self.ingress = IngressPerAppRequirer(self, host="foo.bar", port=80)
        self.framework.observe(self.ingress.ready, self._on_ingress_ready)
        self.framework.observe(self.ingress.revoked, self._on_ingress_revoked)

    def _on_ingress_ready(self, event: IngressPerAppReadyEvent):
        self.unit.status = ops.ActiveStatus(f"I have ingress at {event.url}!")

    def _on_ingress_revoked(self, _):
        self.unit.status = ops.WaitingStatus(f"I have lost my ingress URL!")

    def _foo(self):
        self.ingress.provide_ingress_requirements(host="foo.com", port=42)


```

`IngressPerAppRequirer` will take care of communicating over the `ingress` relation with `traefik-k8s` and notifying the charm whenever traefik replies with an ingress URL or that URL is revoked for some reason (e.g. the cloud admin removed the relation). 


## How to get the proxied endpoint exposed by `traefik`

You have added an ingress integration to your charm and you have deployed it alongside `traefik-k8s` and related them.
Run the following command to get a list of the endpoints currently exposed by `traefik`, one for each application integrated over `ingress` and one for each *unit* related over `ingress_per_unit`.

```bash
juju run traefik/0 show-proxied-endpoints
```

These are the URLs at which your workloads are externally accessible.