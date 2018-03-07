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
Juju, charms, and applications deployed with Juju using charms. To make things
more clear and consistent, we use the following terms:

  * A **charm** is the set of code that encapsulates the operational knowledge
    that manages the life-cycle of an application when deployed.

  * An **application** is a deployed instance of a charm. It is hosted on a
    machine, VM, or container, it has a copy of the charm code, and it is
    managed by a Juju controller.

  * The **interface** is the protocol used by two charms to communicate over a
    relation between them.
    This protocol is what interface layers codify.

  * An **endpoint** is one charm's connection point at which a relation can be
    made. An endpoint is defined in a charm's `metadata.yaml` and specify a
    name, a **role** (one of `requires`, `provides`, or `peers`), and an
    interface that relations established at the endpoint will use.

  * A **relation** is an established connection between endpoints of two
    applications. Relations have a relation ID that is tracked by the Juju
    controller and relation data associated with each unit of each application
    involved in the relation. Relations can only be established between
    endpoints that specify the same interface, and a given endpoint can only
    have one relation to a specific application. However, a given application
    can be related to an application any number of times on different
    endpoints, as long as they specify the same interface, and even to itself
    if it has two endpoints of the same interface (or if the endpoint is of the
    type `peers`).

Here's how these terms map to a charm's `metadata.yaml` and `layer.yaml` file.

```yaml
# metadata.yaml
name: mattermost  # Charm name
# ...
requires:  # Endpoint role
    postgres:  # Endpoint name
        interface: pgsql  # Interface name
provides:  # Endpoint role
    website:  # Endpoint name
        interface: http  # Interface name
# ...
```

```yaml
# layer.yaml
includes:
 - 'layer:basic'
   # ...
 - 'interface:pgsql'  # This interface layer codifies the `pgsql` protocol. The
                      # `requires` role of this interface layer will by used by
                      # the `postgres` endpoint.

 - 'interface:http'  # This interface layer codifies the `http` protocol. The
                     # `website` endpoint will use the `provides` role of this
                     # interface.
repo: https://github.com/tengu-team/layer-mattermost.git
# ...
```

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

  * `endpoint.{endpoint_name}.joined` Set whenever any remote unit joins
  * `endpoint.{endpoint_name}.changed` Set whenever any relation data changes
  * `endpoint.{endpoint_name}.changed.{field}` Set for each field that changes
  * `endpoint.{endpoint_name}.departed` Set whenever any remote unit leaves

These are mainly intended to be used by the interface layer itself, but can be
documented as part of the official API that the interface layer exposes.
Additionally, the `joined` flag will be automatically cleared when there are no
remote units remaining on any relation, but neither of the other flags will be
automatically cleared.

## Creating an interface layer

First off, you require a [local charm repository](../charms-deploying.html) in
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

The HTTP interface has two roles: the `provides` side is for an http-accessible
webservice and the `requires` is for an application that uses the webservice.
In this example, the `provides` side is a website and the `requires` side is a
reverseproxy.

#### Creating the `provides` role

We're now ready to implement the `provides` interface in `provides.py`.

```python
from charmhelpers.core import hookenv
from charms.reactive import set_flag, clear_flag
from charms.reactive import Endpoint


class HttpProvides(Endpoint):
    def publish_info(self, port, hostname=None):
        """
        Publish the port and hostname of the website over the relationship so
        it is accessible to the remote units at the other side of the
        relationship.

        If no hostname is provided, the unit's private-address is used.
        """
        for relation in self.relations:
            relation.to_publish['hostname'] = hostname or hookenv.unit_get('private_address')
            # Publishing data with `to_publish` is the only way to communicate
            # with remote units. Flags are local-only, they are not shared with
            # remote units!
            relation.to_publish['port'] = port
```

!!! Note: Data is send after the hook successfully exits. If any handler
    crashes, all the flags and the `to_send` dict will be reset to their
    original position at hook start.

!!! Note: You can only publish data at the relation level. All units of the
    application at the other end of the relation will see the same data. If you
    need to provide data specific to each remote unit, you can use a workaround
    such as publishing a dictionary with the remote unit names as keys and
    their specific data as values.

Now we can use this `provides` endpoint interface in our charm. The first step
is to define the relation using this interface in `metadata.yaml`.

```yaml
provides:  # This side of the relationship implements the `provides` role
  website:  # We call our endpoint `website`. All flags of this endpoint will
            # be prefixed with `endpoint.website.`.
    interface: http  # The `website` endpoint uses the `provides`
                     # side of the `http` interface
```

Now we can create handlers that react to the flags set by the endpoint. These
handlers are part of a charm that deploys a webservice. The following handler
publishes the information about the webservice after the webservice started and
a relation is established with a charm that wants to use the webservice.

```python
from charms.reactive import context

# `website` is the endpoint name as defined in `metadata.yaml`
@when('endpoint.website.joined')
@when('my-webservice.started')
def publish_website_info():
    # Retrieve the Endpoint object. This object will be an instance of the
    # HttpProvides class defined above.
    website = endpoint_from_flag('endpoint.website.joined')
    website.publish_info(80)
```


#### Creating the `requires` role

We're now ready to implement the `requires` role of this interface in
`requires.py`.

```python
from charms.reactive import when_any, when_not
from charms.reactive import set_flag, clear_flag
from charms.reactive import Endpoint


class HttpRequires(Endpoint):
    # {endpoint_name} will be filled in by the reactive framework. This is the
    # name of the endpoint as defined in `metadata.yaml`
    @when_any('endpoint.{endpoint_name}.changed.hostname',
              'endpoint.{endpoint_name}.changed.port')
    def new_website(self):
        # Detect changes to the hostname or port field on any remote unit
        # and translate that into the new-website flag. Then, clear the
        # changed field flags so that we can detect further changes.
        set_flag(self.expand_name('endpoint.{endpoint_name}.new-website'))
        clear_flag(self.expand_name('endpoint.{endpoint_name}.changed.hostname'))
        clear_flag(self.expand_name('endpoint.{endpoint_name}.changed.port'))

    @when_not('endpoint.{endpoint_name}.joined')
    def broken(self):
        clear_flag(self.expand_name('endpoint.{endpoint_name}.new-website'))

    def websites(self):
        """
        Get the list of websites that remote units have published over all the
        relationships connected to this endpoint.

        Returns a list of dicts, where each dict contains the hostname (address)
        and the port (as a string) that the website is listening on, as well as
        the relation ID and remote unit name that provided the site.

        For example::
            [
                {
                    'hostname': '10.1.1.1',
                    'port': '80',
                    'relation_id': 'reverseproxy:1',
                    'remote_unit_name': 'myblog/0',
                },
            ]
        """
        websites = []
        #
        # Multiple relations can connect to the same endpoint. All relations
        # of the same endpoint will be handled by the same Endpoint
        # class.
        #
        # Loop over all units of all relations connected to this enpoint,
        # read the port and hostname they published, add them to a dict and
        # return that information.
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
                    'remote_unit_name': unit.unit_name,
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

Now we can use this `requires` endpoint interface in our charm. The first step
is to define the relation using this interface in `metadata.yaml`.

```yaml
requires:
  reverseproxy:
    interface: http
```

Now we can create handlers that react to the flags set by the endpoint. This
handler is part of a charm that deploys a reverseproxy. The handler logs the
published information of all the connected webservices.

```python
from charms.reactive import when
from charms.reactive import clear_flag
from charms.reactive import context

# `reverseproxy` is the endpoint name as defined in `metadata.yaml`
@when('endpoint.reverseproxy.new-website')
def update_reverse_proxy_config():
    # Retrieve the Endpoint object. This object will be an instance of the
    # HttpRequires class defined above.
    reverseproxy = endpoint_from_flag('endpoint.reverseproxy.new-website')
    # Note that `reverseproxy.websites()` returns _all_ websites, not just
    # the website that triggered the `endpoint.reverseproxy.new-website` flag.
    for website in reverseproxy.websites():
        hookenv.log('Website: {}:{}'.format(
            website['hostname'],
            website['port']))
        # ...
    clear_flag('endpoint.reverseproxy.new-website')
```
