Title: Interface layers

# Interface layers

Interface layers are responsible for the communication that transpires over a
relation between two applications. This type of layer encapsulates a single
"interface protocol" and is generally written and maintained by the author of
the primary charm that provides that interface. However, it does cover both
sides (provides and requires) of the relation and turns the two-way key-value
store that are Juju relations under-the-hood into a full-fledged API for
interacting with charms supporting that interface.

It is important to note that interface layers **do not** actually implement
either side of the relation. Instead, they are solely responsible for the
**communication** that goes on over the relation, relying on charms on either
end to decide what to do with the results of that communication.

Interface layers currently must be written in Python and extend the [Endpoint]
class, though they can then be *used* by any language using the built-in CLI
API.

[Endpoint]: https://charmsreactive.readthedocs.io/en/latest/charms.reactive.relations.html#charms.reactive.altrelations.Endpoint

## Terminology

Historically, the term "relation" has been used ambiguously when discussing
Juju, charms, and applications deployed with Juju using charms.  To make things
more clear and consistent, we use the following terms:

  * "charm" This is the set of code that encapsulates the operational knowledge
    that manages the life-cycle of an application when deployed.

  * "application" This is a deployed instance of a charm.  It is hosted on a
    machine, VM, or container, it has a copy of the charm code, and it is
    managed by a Juju controller.

  * "interface" This is the protocol used by the charm(s) running on two
    applications to communicate over a relation established between them.
    This protocol is what interface layers codify.

  * "endpoint" This is the name that a charm uses as a connection point at which
    a relation can be made between two deployed applications.  An endpoint is
    defined in a charm's `metadata.yaml` and specify a name, a type (one of
    `requires`, `provides`, or `peers`), and an interface that relations
    established at the endpoint will use.

  * "relation" This is an established connection between endpoints of two
    applications.  Relations have a relation ID that is tracked by the Juju
    controller and relation data associated with each unit of each application
    involved in the relation.  Relations can only be established between
    endpoints that specify the same interface, and a given endpoint can only
    have one relation to a specific application. However, a given application
    can be related to an application any number of times on different
    endpoints, as long as they specify the same interface, and even to itself
    if it has two endpoints of the same interface (or if the endpoint is of the
    type `peers`).

## Design considerations

When writing an interface, there is a small amount of pre-planning into what
that interface should look like in terms of the communication between
applications/unit(s) participating in the relationship.

Common questions to answer:

- What units need to participate in the conversation?

- What data is being sent on the wire?

- Are we sending data that is essentially static to any application connecting
over this interface?

- How should this data be made available to the requirer?

- What flags should this interface set on the provider?

- What flags should this interface set on the requirer?

For the last couple of considerations, it's important to note that the
`Endpoint` base class will automatically manage a few flags that are common to
all interfaces:

  * `endpoint.{relation_name}.joined` Set whenever any remote unit joins
  * `endpoint.{relation_name}.changed` Set whenever any relation data changes
  * `endpoint.{relation_name}.changed.{field}` Set for each field that changes
  * `endpoint.{relation_name}.departed` Set whenever any remote unit leaves

These are mainly intended to be used by the interface layer itself, but can be
documented as part of the official API that the interface layer exposes.
Additionally, the `joined` flag will be automatically cleared when there are no
remote units remaining on any relation, but neither of the other flags will be
automatically cleared.

## Creating an interface layer

First off, you require a [local charm repository](./charms-deploying.html) in
which to work. This involves creating three directories -- `layers`,
`interfaces`, and `charms` -- and setting some environment variables.

The `layers` directory contains the source code of the layered charm covered in
our examples. The `interfaces` directory is where you'd place any
interface-layers you may wish to write, and the
`charms` directory holds the assembled, ready to deploy charm.

```bash
export JUJU_REPOSITORY=$HOME/charms
export LAYER_PATH=$JUJU_REPOSITORY/layers
export INTERFACE_PATH=$JUJU_REPOSITORY/interfaces

mkdir -p $LAYER_PATH $INTERFACE_PATH
```

!!! Note:
    Exporting the environment variables in this way only sets the
    variables for the current terminal. If you wish to make these changes persist,
    add the same export statements to a resource file that are evaluated when you
    create a new console such as `~/.bashrc` depending on your shell.

The export of `INTERFACE_PATH` is an environment variable which tells the
`charm build` process where to scan for local interfaces not found in the
[layer registry](https://github.com/juju/layer-index/).

With our interface repository created, we can now create our new interface.

Next, create the directory to warehouse your interface.

```Bash
mkdir -p $INTERFACE_PATH/http
```

And declare the interface's metadata in `interface.yaml`.

```yaml
name: http
summary: Basic HTTP interface
version: 1
repo: https://git.launchpad.net/~bcsaller/charms/+source/http
```

#### Writing the provides side

We're now ready to implement the provider interface in `provides.py`.

```python
from charmhelpers.core import hookenv
from charms.reactive import set_flag, clear_flag
from charms.reactive import Endpoint


class HttpProvides(Endpoint):
    def configure(self, port, hostname=None):
        """
        Configure the HTTP relation by providing a port and optional hostname.

        If no hostname is provided, the unit's private-address is used.
        """
        for relation in self.relations:
            relation.send['hostname'] = hostname or hookenv.unit_get('private_address')
            relation.send['port'] = port
```

!!! Note: You can only "send" data at the relation level. Remember, a relation
has data associated with each unit in the relation; "sending" data is really
just setting the local unit's data on the relation. If you need to provide data
specific to each remote unit, you can use [`send_json`][] to send structured
data using a dict keyed by the remote unit names.

#### Implementing the provides side

With our provider interface written, lets take a look at how we might implement
this in a charm.

In our metadata we define a website relation implementing the interface:
```yaml
provides:
  website:
    interface: http
```

And in the reactive class, we will receive the RelationBase object, and invoke
the configure method:

```python
from charms.reactive import context

@when('endpoint.website.joined')
def configure_website():
    context.endpoints.website.configure(80)
```


#### Writing the requires side

We're now ready to implement the requirer interface in `requires.py`

```python
from charms.reactive import when_any, when_not
from charms.reactive import set_flag, clear_flag
from charms.reactive import Endpoint


class HttpRequires(Endpoint):
    @when_any('endpoint.{relation_name}.changed.hostname',
              'endpoint.{relation_name}.changed.port')
    def new_website(self):
        # Detect changes to the hostname or port field on any remote unit
        # and translate that into the new-website flag. Then, clear the
        # changed field flags so that we can detect further changes.
        set_flag(self.flag('endpoint.{relation_name}.new-website'))
        clear_flag(self.flag('endpoint.{relation_name}.changed.hostname'))
        clear_flag(self.flag('endpoint.{relation_name}.changed.port'))

    @when_not('endpoint.{relation_name}.joined')
    def broken(self):
        clear_flag(self.flag('endpoint.{relation_name}.new-website'))

    def websites(self):
        """
        Get the list of websites that were provided.

        Returns a list of dicts, where each dict contains the hostname (address)
        and the port (as a string) that the website is listening on, as well as
        the relation ID and remote unit name that provided the site.

        For example::
            [
                {
                    'hostname': '10.1.1.1',
                    'port': '80',
                    'relation_id': 'reverseproxy:1',
                    'unit_name': 'myblog/0',
                },
            ]
        """
        websites = []
        for relation in self.relations:
            for unit in relation.units:
                hostname = unit.received['hostname']
                port = unit.received['port']
                if not (hostname and port):
                    continue
                website.append({
                    'hostname': hostname,
                    'port': port,
                    'relation_id': relation.relation_id,
                    'unit_name': unit.unit_name,
                })
        return websites
```

!!! Note: Although this is obviously a very simple example, it is important for
your interface layer to provide an API like this and not give the charms direct
access to the `Relation` and `RelatedUnit` objects in those collections. This
ensures proper encapsulation of the underlying interface data protocol; it
means that you can update your interface layer to handle changes in things like
the encoding or key names in a backwards compatible way without requiring all
charms that use the interface to know about or implement that logic.

#### Implementing the requires side

With our requirer interface written, lets take a look at how we might implement
this in a charm.

In our metadata we define a reverseproxy relation implementing the interface:

```yaml
requires:
  reverseproxy:
    interface: http
```

And in our reactive file, we implement it as so:

```python
from charms.reactive import when
from charms.reactive import clear_flag
from charms.reactive import context


@when('endpoint.reverseproxy.new-website')
def update_reverse_proxy_config():
    for website in context.endpoints.reverseproxy.websites():
        hookenv.log('New website: {}:{}'.format(
            website['hostname'],
            website['port']))
    clear_flag('endpoint.reverseproxy.new-website')
```
