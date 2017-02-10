Title: Getting started developing charms  

# Getting Started with charm development

This guide is for anyone wanting to creating the code that we call
 a _charm_; the part that does the work of installing and managing 
applications in a Juju model. Many charms exist in the 
[Juju store][store] already, but if your favourite application
isn't covered or you would like to make your own spin on an existing
charm, you will discover all the tools and information you need here.

## Requirements

  - **A Juju controller**: If you have not used Juju before, it's 
  a good idea to [start here][getting-started].
  - **Python 3.x**: it is possible to develop charms using other languages, 
  but this guide focusses on Python-based development.
  - **Charm Tools**: Command line utilities to make it easy to create,
  build, fetch and test charms. [See the Charm Tools page][charm-tools]
  for installation instructions.
  - **Charm Helpers**: [Charm Helpers][charm-helpers] is a Python library
  that provides an extensive collection of functions for developers to
  reuse. Many common charm patterns are encapsulated in functions of this
  library, so it is also worth reading the 
  [Charm Helpers documentation][charm-helper-docs].
  - This guide also uses the [Vanilla PHP Forum software][vanilla] as an 
  example.


## Designing your charm

In order to begin writing a charm, you should have a good plan of how it’s
going to be implemented, what configuration options you wish to expose to anyone
deploying the charm, and what dependent charms (if any) it will be related to.
It’s a good idea to start with a diagram.

This visual representation of your charm deployment will help to solidify the
configuration, deployment, and management of your application. Take the
following example:

![Charm Design Diagram](./media/vanilla-planning.png)

Looking at this diagram we see the Vanilla charm with two units. The Vanilla
application requires a relationship to a database using the “mysql” interface.
The MariaDB charm implements the mysql interface, which fulfills the db relation
and is already in [the charm store](https://jujucharms.com/mariadb).

## Writing your Charm

The fastest way to write a new charm is to build off of existing layers. This
allows you to create code that is very focused for the application you are
trying to implement.

Layers let you build on the work of other charmers, whether that work is in the
form of other charms that you can extend and modify, interfaces that communicate
with remote applications, or partial base layers that make managing dependencies
much easier. And it does this in a consistent, repeatable, and incremental way.

The available layers and interfaces can be found at
[interfaces.juju.solutions][interfaces]. The `basic`
layer provides charm helpers Python library and the reactive framework that
makes layers possible.


### Creating a new layer

First off, you require a [local charm repository][charms-local] in
which to work. This involves creating three directories -- `layers`,
`interfaces`, and `charms` -- and setting some environment variables.

The `layers` directory contains the source code of the layered charm covered in
our examples. The `interfaces` directory is where you'd place any
[interface layers][interface-layers]
you may wish to write, and the `charms` directory holds the assembled,
ready to deploy charm.

```bash
export JUJU_REPOSITORY=$HOME/charms
export LAYER_PATH=$JUJU_REPOSITORY/layers
export INTERFACE_PATH=$JUJU_REPOSITORY/interfaces

mkdir -p $LAYER_PATH $INTERFACE_PATH

cd $JUJU_REPOSITORY/layers
```

!!! Note: Exporting the environment variables in this way only sets the
variables for the current terminal. If you wish to make these changes persist,
add the same export statements to a resource file that are evaluated when you
create a new console such as ~/.bashrc depending on your shell.

Once in the layers directory clone the example charm layer - layer-vanilla:

```bash
git clone http://github.com/juju-solutions/layer-vanilla.git
cd layer-vanilla
```

If you'd like to write your own layer, or simply learn more about how
layers are implemented, see [How to Write a
Layer](./developer-layer-example.html).

### Assemble the layers

Now that the layer is complete, let's build it and deploy the final charm. From
within the layer directory, this is as simple as:  

```bash
charm build
```

Build will take all of the layers and interfaces included by your charm, either
from your local `LAYER_PATH` and `INTERFACE_PATH` directories or automatically
downloaded from the [interfaces.juju.solutions][interfaces]
and create a new charm in `$JUJU_REPOSITORY/trusty/vanilla`:

```
build: Composing into /home/user/charms
build: Processing layer: layer:basic
build: Processing layer: layer:apache-php
build: Processing layer: .
```

![Charm layer diagram](./media/vanilla-layers.png)

To inspect how the charm was assembled, there is a `charm layers` command that
shows what file belongs to which layer. Change to the charm directory and view
the layer map:  

```bash
cd $JUJU_REPOSITORY/trusty/vanilla
charm layers
```

Then we can deploy mariadb and the new charm:

```bash
juju deploy mariadb
juju deploy $JUJU_REPOSITORY/trusty/vanilla --series trusty
juju add-relation mariadb vanilla
juju expose vanilla
```

## Testing your Charm

Because Juju is a large complex system, not unlike a Linux software
distribution, there is a need to test the charms themselves and how they
interact with one another. All new charms require tests that verify the
application installs, configures, scales and relates as intended. The tests
should be self-contained, installing all the required packages so the tests can
be run automatically with a tool called
[`bundletester`][bundletester]. Similar to
hooks the tests should be executable files in a `tests/` directory of the charm.
While you can write tests in Bash or other languages, it is reccommended to
use the [Amulet library][amulet], which makes it easy to write charm
tests in Python.

For more information about writing tests please refer to the
[charm testing guide documentation][charm testing].

## Submitting your charm for review

Once the charm is complete you can [submit the charm for
review](./charm-review-process.html) where, if accepted, would be included in
the recommended section of the Juju Charm Store. Charms in the recommended
section must follow Charm Store policy and best practices for charms. These
recommended charms have a shorter namespace on the Charm Store website, and are
listed higher in search results on [https://jujucharms.com][store]

[store]:              https://jujucharms.com/
[charm-helpers]:      ./tools-charm-helpers.html
[charm-helper-docs]:  http://pythonhosted.org/charmhelpers/
[interface-layers]:   ./developer-layers-interfaces.html) 
[vanilla]:            http://vanillaforums.org
[charms-local]:       ./charms-deploying.html#deploying-from-a-local-charm
[amulet]:             ./tools-amulet.html
[bundletester]:       https://github.com/juju-solutions/bundletester
[charm testing]:      ./developer-testing.html
[interfaces]:         http://interfaces.juju.solutions/
[python-compatibility]: http://python-future.org/compatible_idioms.html