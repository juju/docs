# Getting Started Developing Charms

The developer guide is for anyone wanting to write bits of code that we call
charms. This guide introduces some new concepts that once you learn can help
you make some very powerful and reusable code components in the Juju ecosystem.

## Install Juju
To develop charms you will need the Juju client installed. The Juju client is
available for Linux, Windows and Mac OS.  

## Configure Juju
Juju needs to be configured before it can orchestrate an environment. Juju
defaults to an Amazon EC2 environment, but for testing and development you may
wish to configure the local provider such as LXC or KVM.

## Test your Juju setup
You will want to make sure everything is running properly before writing code.
Bootstrapping an environment is a good way to tell if the environment is
configured correctly.  

For more information on these steps, read these pages and be sure to come back
to continue the development journey.
* [Installing Juju](./getting-started.html#installation).
* [Configure the local environment](./config-local.html)
* [Test your Juju setup](./getting-started.html#testing-your-setup)

This guide also uses the [Vanilla PHP Forum software](http://vanillaforums.org)
as our example application for getting started charming, as it's a great example
of a typical three factor application consisting of a Database, a PHP web
application served over HTTP.

## Install libraries and tools

### Charm Tools
We have created tools to make writing charms easier. Developers should [install
Charm Tools](./tools-charm-tools.html) software. Charm Tools are command line
utilities that make it easy to create, build, fetch and find common charm errors.

```bash
sudo apt-get install charm-tools
charm help
```

### Charm Helpers
[Charm Helpers](./tools-charm-helpers.html) is a Python library that provides
an extensive collection of functions for developers to reuse. Spending time
reading the [Charm Helpers documentation](http://pythonhosted.org/charmhelpers/)
would be well spent because several common charm patterns are encapsulated in
functions in this library.

```python
from charmhelpers.core import hookenv
config = hookenv.config()
value = config.get('key')
```

## Designing your charm

In order to begin writing a charm, you should have a good plan of how it’s
going to be implemented, what configuration options you wish to expose to anyone
deploying the charm, and what dependent charms (if any) it will be related to.
It’s encouraged to diagram this out, using any of the freely available mockup
tools available on the web. Google Draw, DIA, Gliffy, Draw.io - just to name a
few.

The visual representation of your charm deployment will help to solidify the
configuration, deployment, and management of your service. Take the following
example:

![Charm Design Diagram](./media/vanilla-planning.png)

Looking at this diagram we see the Vanilla charm with two units.  The Vanilla
service requires a relationship to a database using the “mysql” interface. The
MariaDB charm implements the mysql interface, which fulfills the db relation and
is already in [the charm store](https://jujucharms.com/mariadb).  

## Writing your Charm

The fastest way to write a new charm is to build off of layers that have already
been done.  This allows you to create code that is very focused for the service
you are trying to implement.  

Layers let you build on the work of other charmers, whether that work is in the
form of other charms that you can extend and modify, interfaces that are already
built for you and know how to communicate with a remote service and let you know
when that service is ready and what it provides for you, or partial base layers
that make managing dependencies much easier. And it does this in a consistent,
repeatable, and incremental way.  

The available layers and interfaces can be found at
[interfaces.juju.solutions](http://interfaces.juju.solutions/).  The `basic`
layer provides charm helpers python library and the reactive framework that
makes layers possible.  

### Creating a new layer

First off, you require a [local charm repository](./charms-deploying.html) in
which to work. This involves creating some directories and setting some
environment variables.  For example:

```bash
export JUJU_REPOSITORY=$HOME/charms
export LAYER_PATH=$JUJU_REPOSITORY/layers
export INTERFACE_PATH=$JUJU_REPOSITORY/interfaces
mkdir -p $JUJU_REPOSITORY/layers
cd $JUJU_REPOSITORY/layers
```

Once in the layers directory clone the example charm layer - layer-vanilla:

```bash
git clone http://github.com/juju-solutions/layer-vanilla.git
cd layer-vanilla
```

> If you would like to jump right into how the layers are implemented, you can
read the [vanilla layer walk through](./developer-layer-example.html)

### Assemble the layers

Now that the layer is complete, let's build it and deploy the final charm. From
within the layer directory, this is as simple as:  

```bash
charm build
```

Build will take all of the layers and create a new charm into
$JUJU_REPOSITORY/trusty/vanilla:

    build: Composing into /home/user/charms
    build: Processing layer: layer:basic
    build: Processing layer: layer:apache-php
    build: Processing layer: .

![Charm layer diagram](./media/vanilla-layers.png)

To inspect how the charm was assembled, there is a command `charm layers` that
shows what file belongs to which layer.  Change to the charm directory and view
the layer map:  

```bash
cd $JUJU_REPOSITORY/trusty/vanilla
charm layers
```

Then we can deploy mariadb and the new charm:

```bash
juju deploy mariadb
juju deploy local:trusty/vanilla
juju add-relation mariadb vanilla
juju expose vanilla
```

## Testing your Charm

Because Juju is a large complex system, not unlike a Linux software
distribution, there is a need to test the charms themselves and how they
interact with one another. All new charms require tests that verify the service
installs, configures, scales and relates as intended. The tests should be self
contained, installing all the required packages so the tests can be run
automatically with a tool called
[`bundletester`](https://github.com/juju-solutions/bundletester). Similar to
hooks the tests should be executable files in a `tests/` directory of the charm.
While you can write tests in Bash or other languages, the [Amulet
library](./tools-amulet.html) is highly suggested and makes it easy to write
tests in Python.

For more information about writing tests please refer to the
[charm testing guide](./developer-testing.html).

## Submitting your charm for review

Once the charm is complete you can  [submit the charm for
review](./charm-review-process.html), where if accepted  would be included in
the recommended section of the Juju Charm Store.  Charms in the recommended
section follow Charm Store policy and best pratctices for charms. The
recommended charms have a shorter namespace on the Charm Store website, and are
listed higher in search results on <http://jujucharms.com>
