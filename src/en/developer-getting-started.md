# Getting Started Developing Charms

The developer guide is for anyone wanting to write bits of code that we call
charms. This guide introduces some new concepts that once you learn can help
you make some very powerful and reusable code components in the Juju ecosystem.

This guide assumes you have already  [installed
Juju](./getting-started#installation), [tested your
setup](./getting-started#testing-your-setup), and are able to deploy a charm to
an environment. Since Juju provides the same user experience on all
environments, many developers use the [local provider](./config-local) to
develop  because it is easier, faster, and cheaper than a traditional cloud
environment.

## Prerequisites and Tools

We have created tools to make writing charms easier. Developers should [install
Charm Tools](./tools-charm-tools) which makes it easy to create,  build, fetch
and find common charm errors.

```bash
sudo apt-get install charm-tools
```

While a charm can be written in any language that will run on a cloud image, we
recommend Python. [Charm Helpers](./tools-charm-helpers) is a Python  library
that provides an extensive collection of functions for developers to  reuse.
Spending time reading the [Charm Helpers
documentation](http://pythonhosted.org/charmhelpers/) would be well spent
because several common charm patterns are encapsulated in functions in this
library.

Once the charm is complete you can submit it for review, where if accepted would
be included in the recommended section of the Juju Charm Store.  Charms in this
section have a flat namespace and are listed higher in search results on
<http://jujucharms.com>

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

First off, you require a [local charm repository](./charms-deploying) in which
to work. For example:

```bash
export JUJU_REPOSITORY=$HOME/charms
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

All new charms require tests so we can ensure that the service installs,
configures, scales and relates as intended. These tests are required to ensure
quality and compatibility with other charms. The tests should be self contained,
installing all the required packages, so the tests can be run automatically with
a tool called [bundletester](https://github.com/juju-solutions/bundletester).
Similar to hooks tests should be executable files in a `tests` directory of the
charm.  While you can write tests in Bash or other languages, the [Amulet
library](./tools-amulet) is highly suggested and makes it easy to write tests in
Python.

The automated test tool will run the tests in an alphanumeric ordering based on
the file name.  A common pattern is to use a filename that sorts first (00-setup
for example) which installs Juju if not already installed and any other packages
required for testing.

The other files in the test directory can now be written in Python and use the
Amulet library.  The tests should deploy the charm, change configuration, relate
to other charms where appropriate.  The test should ensure the service is
running, operational, received the configuration from the test and was
successfully related to the other charms.
