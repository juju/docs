
 Title: Layers for Charm Authoring

# Why build from layers

When creating a charm, you always have the option of doing it traditional way by
creating each hook, implementing each side of the interface you need for each
relation your charm requires or provides, manage the dependencies, such as
[charm-helpers](https://pythonhosted.org/charmhelpers/), that your charm uses,
et cetera. However, what you really want to do is focus on *your* charm.  So,
why not leverage the reusable work of others and keep your charm code as minimal and
tightly focused as possible?

Enter the concept of building charms from layers.  Layers let you build on the
work of other charmers, whether that work is in the form of other charms that
you can extend and modify, interfaces that are already built for you and know
how to communicate with a remote service and let you know when that service is
ready and what it provides for you, or partial base layers that make managing
dependencies much easier.  And it does this in a consistent, repeatable, and
audit-able way.

# What are layers?

Layers are encapsulated charm code which lend themselves to being re-used across
charms. They come in distinct flavors:

- Base/runtime, Interface, or Charm layers

Each of these has a distinct role, and it’s important to understand how a charm
should be broken up into these types of layers. Generally, a charm will contain
one base layer, one charm layer, and one or more interface layers, but it is
possible that a charm might include more than one base layer, as well.

## Base, or Runtime, Layers

Base layers are layers that other charms can be built on. They contain things
that are common to many different charms, and allow charms to reuse that
commonality without having to reimplement it each time. Base layers typically
are not sufficient on their own to be considered a charm; they likely can’t be
built into a deployable charm, and if they can, they’re unlikely to do anything
useful.

The most basic example is just that,
[layer-basic](http://github.com/juju-solutions/layer-basic). It provides nothing
more than the minimum needed to effectively use layered charms:
[charms.reactive](https://pythonhosted.org/charms.reactive/),
[charmhelpers](https://pythonhosted.org/charmhelpers/), and the skeleton hook
implementations that call into the reactive framework. However, the most useful
base layers are actually a type of runtime layer. For example,
[layer-apache-php](https://github.com/johnsca/apache-php) provides Apache2 and
mod-php, as well as mechanisms for fetching and installing a PHP project within
that runtime.

Base layers can be written in any language, but must at a minimum provide the
reactive framework that glues layers together, which is written in Python. This
can be done trivially by building the base layer off of layer-basic.

## Interface Layers

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

There's more on programming interface layers in the [Developing Interface
Layers](developers-interface-layers.html) guide.

## Charm Layers

Building on base and interface layers, charm layers are what actually get turned
into charms. This is where the core logic of the charm should go, the logic
specific to that individual charm. This layer brings together all the pieces
needed to create the charm. It is where most of the charm’s config options will
be defined, and where the reactive handlers that do the specific work of the
charm will go. It will need to contain the charm’s README, copyright, icon, and
so on.

Charm layers should be the most common type of layer, and is what most charm
authors will be dealing with. However, the goal is to keep them hyper-focused on
just that specific charm’s logic and needs, and to push any commonality into an
appropriate base layer. Charm layers should contain as little boilerplate as
possible.

Charm layers can be written in any language, and there are helpers for writing
them in Bash.

## Layer Encapsulation

## States

States are synthetic events that are defined by the layers author. States allow
for the layer, or related layers to subscribe to these states and take action
only when appropriate. Consider the example illustrated in the [Getting
Started]() guide. `apache.available` is set from the apache-php layer. Any
layers built on top of the apache-php layer can subscribe to this state with a
`@when` decorator to take action only after the Apache service has been started.
subsequently the `@when_not` decorator has also been made to assist guarding
against running code when a state has been set, which lends itself nicely to
idempotent behavior.

When charming a runtime layer, it's important to think through the states you
will be setting, and to expose a good level of states so that complimentary
layers may join the state machine.

Another example is the docker-layer, where the docker daemon is installed and
sets a `docker.ready` state, which is an intermediate state intended for
docker-plugins to install and configure themselves before it becomes available
for being loaded with workloads. This allows a charm author to plug right into
the charm, extend the capabilities of a vanilla docker daemon, and modify it
without any interruption to the workloads targeted at that unit. Top layer
charms need only subscribe to the `docker.available` state to ensure their
workload is being run after the pre-dependency configuration has been performed.

Charmers can set synthetic states:

```python
from charms.reactive import set_state

set_state('apache.available')
```

 ```bash
 charms.reactive set_state 'apache.available'
```

And subsequently subscribe to them:

```python
@when('apache.available')
@when_not('website.available')
def deploy_middleware():
  # doing something to deploy middleware
```

```bash
@when('apache.available')
@when_not('website.available')
function deploy_middleware(){
   # doing something to deploy middleware
 }
```

## Writing a layer

The Getting Started guide example illustrates charming the layer-vanilla, which
is an excellent example for how to write your own layer.

[Layer Example](developer-layer-example.html)
