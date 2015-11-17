# Interface layers

Interface layers are perhaps the most misunderstood type of layer, and are
responsible for the communication that transpires over a relation between two
services. This type of layer encapsulates a single “interface protocol” and is
generally written and maintained by the author of the primary charm that
provides that interface. However, it does cover both sides (provides and
requires) of the relation and turns the two-way key-value store that are Juju
relations under-the-hood into a full-fledged API for interacting with charms
supporting that interface.

It is important to note that interface layers **do not** actually implement
either side of the relation. Instead, they are solely responsible for the
**communication** that goes on over the relation, relying on charms on either
end to decide what to do with the results of that communication.

Interface layers currently must be written in Python and extend the ReactiveBase
class, though they can then be used by any language using the built-in CLI API.

## Design considerations

 When writing an interface, there is a small amount of pre-planning into what
that interface should look like in terms of the communication between
services/unit(s) participating in the relationship.

Common questions to answer:

- What units need to participate in the conversation?

- What data is being sent on the wire?

- Are we sending data that is essentially static to any service connecting over
this interface?

- How should this data be made available to the requirer?

- What states should this interface raise on the provider?

- What states (if any) should this interface raise on the requirer?


## What communication scopes are, and how to use them

When writing an interface, there is also the concept of a communication scope.
There are three distinct flavors of scoping for a conversation. At times there
will be fairly static information being transmitted between services - and this
is a prime candidate for a [GLOBAL](#global) scope. If the information varies
from service to service but remains the same for each unit of the service, you
will want to investigate [SERVICE](#service) level conversations. The final, and
default communication scope is [UNIT](#unit) level conversations, where each
unit in a service group gets its own conversation with the provider.

#### GLOBAL

All connected services and units for this relation will share a single
conversation. The same data will be broadcast to every remote unit, and
retrieved data will be aggregated across all remote units and is expected to
either eventually agree or be set by a single leader.

```python
class MyRelationClient(RelationBase):
  scope = Scopes.GLOBAL
```

#### Service

Each connected service for this relation will have its own conversation. The
same data will be broadcast to every unit of each service’s conversation, and
data from all units of each service will be aggregated and is expected to either
eventually agree or be set by a single leader.

```python
class MyRelationClient(RelationBase):
  scope = Scopes.SERVICE
```

#### Unit

Each connected unit for this relation will have its own conversation. This is
the default scope. Each unit’s data will be retrieved individually, but note
that due to how Juju works, the same data is still broadcast to all units of a
single service.

```python
class MyRelationClient(RelationBase):
  scope = scopes.UNIT
```

## Writing an interface-layer

Begin by making an interface repository if you don't currently have one.

```bash
mkdir -p $JUJU_REPOSITORY/interfaces
export INTERFACE_PATH=$JUJU_REPOSITORY/interfaces
```

The export of `INTERFACE_PATH` is an environment variable which tells the
`charm build` process where to scan for local interfaces not found in the
[layer registry](http://interfaces.juju.solutions).

With our interface repository created, we can now create our new interface.

Start by creating the directory to warehouse your interface

```Bash
mkdir -p $INTERFACE_PATH/http
```

And declare the interface's metadata in `interface.yaml`

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

    @hook('{provides:http}-relation-{broken,departed}')
    def broken(self):
        # Remove the state that our relationship is now available to our principal layer(s)
        self.remove_state('{relation_name}.available')

    # Anonymous method passed into methods decorated with
    # @when('{relation}.available')
    def configure(self, port):
        relation_info = {
            'hostname': hookenv.unit_get('private-address'),
            'port': port,
        }
        self.set_remote(**relation_info)
```

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
