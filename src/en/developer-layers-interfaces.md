Title: Interface layers  

# Interface layers

Interface layers are perhaps the most misunderstood type of layer, and are
responsible for the communication that transpires over a relation between two
applications. This type of layer encapsulates a single “interface protocol”
and is generally written and maintained by the author of the primary charm
that provides that interface. However, it does cover both sides (provides and
requires) of the relation and turns the two-way key-value store that
are Juju relations under-the-hood into a full-fledged API for interacting with
charms supporting that interface.

It is important to note that interface layers **do not** actually implement
either side of the relation. Instead, they are solely responsible for the
**communication** that goes on over the relation, relying on charms on either
end to decide what to do with the results of that communication.

Interface layers currently must be written in Python and extend the ReactiveBase
class, though they can then be __used__ by any language using the built-in CLI
API.

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

- What states should this interface raise on the provider?

- What states (if any) should this interface raise on the requirer?


## Communication scopes

When writing an interface, there is also the concept of a communication scope.
There are three distinct flavors of scoping for a conversation. At times there
will be fairly static information being transmitted between applications - and this
is a prime candidate for a [GLOBAL](#global) scope. If the information varies
from app to app but remains the same for each unit of the application, you
will want to investigate [SERVICE](#service) level conversations. The
final, and default communication scope is [UNIT](#unit) level conversations,
where each unit in a application group gets its own conversation with the
provider.

#### GLOBAL

All connected applications and units for this relation will share a single
conversation. The same data will be broadcast to every remote unit, and
retrieved data will be aggregated across all remote units and is expected to
either eventually agree or be set by a single leader.

```python
class MyRelationClient(RelationBase):
  scope = Scopes.GLOBAL
```

#### Application

Each connected application for this relation will have its own conversation. The
same data will be broadcast to every unit of each application’s conversation, and
data from all units of each application will be aggregated and is expected to
either eventually agree or be set by a single leader.

```python
class MyRelationClient(RelationBase):
  scope = Scopes.SERVICE
```

#### Unit

Each connected unit for this relation will have its own conversation. This is
the default scope. Each unit’s data will be retrieved individually, but note
that due to how Juju works, the same data is still broadcast to all units of a
single application.

```python
class MyRelationClient(RelationBase):
  scope = scopes.UNIT
```

## Writing an interface-layer

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

!!! Note: Exporting the environment variables in this way only sets the
variables for the current terminal. If you wish to make these changes persist,
add the same export statements to a resource file that are evaluated when you
create a new console such as `~/.bashrc` depending on your shell.

The export of `INTERFACE_PATH` is an environment variable which tells the
`charm build` process where to scan for local interfaces not found in the
[layer registry](http://interfaces.juju.solutions).

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
from charms.reactive import hook
from charms.reactive import RelationBase
from charms.reactive import scopes


class HttpProvides(RelationBase):
    # Every unit connecting will get the same information
    scope = scopes.GLOBAL

    # Use some template magic to declare our relation(s)
    @hook('{provides:http}-relation-{joined,changed}')
    def changed(self):
        # Signify that the relationship is now available to our principal layer(s)
        self.set_state('{relation_name}.available')

    @hook('{provides:http}-relation-{departed}')
    def departed(self):
        # Remove the state that our relationship is now available to our principal layer(s)
        self.remove_state('{relation_name}.available')

    # call this method when passed into methods decorated with
    # @when('{relation}.available')
    # to configure the relation data
    def configure(self, port):
        relation_info = {
            'hostname': hookenv.unit_get('private-address'),
            'port': port,
        }
        self.set_remote(**relation_info)
```

!!! Note: You may notice we do not decorate for the -broken hook event. This
is intentional.  It will only actually cause problems if you use set_state
in the context of a relationship being broken, but it doesn't work like you'd
expect so it's better to avoid it entirely

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
@when('website.available')
def configure_website(website):
  website.configure(80)
```


#### Writing the requires side

We're now ready to implement the requirer interface in `requires.py`

```python
from charms.reactive import hook
from charms.reactive import RelationBase
from charms.reactive import scopes


class HttpRequires(RelationBase):
    scope = scopes.UNIT

    @hook('{requires:http}-relation-{joined,changed}')
    def changed(self):
        conv = self.conversation()
        if conv.get_remote('port'):
            # this unit's conversation has a port, so
            # it is part of the set of available units
            conv.set_state('{relation_name}.available')

    @hook('{requires:http}-relation-{departed}')
    def departed(self):
        conv = self.conversation()
        conv.remove_state('{relation_name}.available')

    def services(self):
        """
        Returns a list of available HTTP services and their associated hosts
        and ports.
        The return value is a list of dicts of the following form::
            [
                {
                    'service_name': name_of_service,
                    'hosts': [
                        {
                            'hostname': address_of_host,
                            'port': port_for_host,
                        },
                        # ...
                    ],
                },
                # ...
            ]
        """
        services = {}
        for conv in self.conversations():
            service_name = conv.scope.split('/')[0]
            service = services.setdefault(service_name, {
                'service_name': service_name,
                'hosts': [],
            })
            host = conv.get_remote('hostname') or conv.get_remote('private-address')
            port = conv.get_remote('port')
            if host and port:
                service['hosts'].append({
                    'hostname': host,
                    'port': port,
                })
        return [s for s in services.values() if s['hosts']]
```

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
from charms.reactive.helpers import data_changed

@when('reverseproxy.available')
def update_reverse_proxy_config(reverseproxy):
    services = reverseproxy.services()
    if not data_changed('reverseproxy.services', services):
        return
    for service in services:
        for host in service['hosts']:
            hookenv.log('{} has a unit {}:{}'.format(
                service['service_name'],
                host['hostname'],
                host['port']))
```
