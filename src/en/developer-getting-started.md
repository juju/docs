Title: Getting started developing charms  

# Getting Started with charm development

This guide is for anyone wanting to creating the code that we call
 a _charm_; the part that does the work of installing and managing
applications in a Juju model. Many charms exist in the
[Juju store][store] already, but if your favourite application
isn't covered or you would like to make your own spin on an existing
charm, you will discover all the tools and information you need here.

For an example of a community-driven charm development project see the
[OpenStack Charm Guide][upstream-openstack-charms].

## Requirements

  - **A Juju controller**: If you have not used Juju before, it's
  a good idea to [start here][getting-started].
  - **Python 3.x**: it is possible to develop charms using other languages,
  but this guide focuses on Python-based development.
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


The developer guide is for anyone wanting to write bits of code that we call
charms. This guide introduces some new concepts that, once learned, can help
you make some very powerful and reusable code components in the Juju ecosystem.

## Install Juju
To develop charms you will need the Juju client installed. The Juju client is
available for Linux, Windows and Mac OS.

## Configure Juju
Juju needs to be configured before it can model, configure or manage
applications. Juju defaults to an Amazon EC2 provider, but for testing and
development you may wish to configure the local provider such as LXD.

## Test your Juju setup
You will want to make sure everything is running properly before writing code.
Bootstrapping a controller is a good way to tell if Juju is
configured correctly. Please follow the steps at the
['Getting Started' page in the user guide](./getting-started.html)
to make sure you have a working local model before proceeding.

This guide also uses the [Vanilla PHP Forum software](http://vanillaforums.org)
as our example application for getting started charming, as it's a great example
of a typical three factor application consisting of a Database, a PHP web
application served over HTTP.

## Install libraries and tools

### Charm Tools
We have created tools to make writing charms easier. Developers should [install
the Charm Tools](./tools-charm-tools.html) software. Charm Tools are command line
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
tools available on the web. Google Draw, DIA, Gliffy, or Draw.io, just to name a
few.

The visual representation of your charm deployment will help to solidify the
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
[interfaces.juju.solutions](http://interfaces.juju.solutions/). The `basic`
layer provides charm helpers python library and the reactive framework that
makes layers possible.

### Python 3

The reactive framework used with layered charms runs under Python 3, so you'll
want to be aware of [compatibility](http://python-future.org/compatible_idioms.html)
issues between Python 2 and 3.

### Creating a new layer

First off, you require a [local charm repository](./charms-deploying.html) in
which to work. This involves creating three directories -- `layers`,
`interfaces`, and `charms` -- and setting some environment variables.

The `layers` directory contains the source code of the layered charm covered in
our examples. The `interfaces` directory is where you'd place any
[interface-layers](./charms-layers-interfaces.md) you may wish to write, and the
`charms` directory holds the assembled, ready to deploy charm.

```bash
export JUJU_REPOSITORY=$HOME/charms
export LAYER_PATH=$JUJU_REPOSITORY/layers
export INTERFACE_PATH=$JUJU_REPOSITORY/interfaces

mkdir -p $LAYER_PATH $INTERFACE_PATH

cd $JUJU_REPOSITORY/layers
```


!!! Note:
    Exporting the environment variables in this way only sets the
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


Build will take all of the layers and interfaces included by your charm,
either from your local `LAYER_PATH` and `INTERFACE_PATH` directories or
automatically downloaded from the
[interfaces.juju.solutions][interfaces] website and create a new charm
in `$JUJU_REPOSITORY/trusty/vanilla`:


    build: Composing into /home/user/charms
    build: Processing layer: layer:basic
    build: Processing layer: layer:apache-php
    build: Processing layer: .

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

## Add GUI user notes

Optionally leave some notes for those users who will deploy the charm from the
Juju GUI. This consists of including a Markdown-formatted file called
`getstarted.md` at the root of the charm's directory. Once the charm (or
bundle) is deployed, the file will be rendered and displayed to the user.

The file should include the user's next steps. Here is a guideline for what to
include:

 - State prerequisites for various application features.
 - Include instructions for achieving a working application at a rudimentary
   level.
 - Provide links for further reading.

As for style, here are some pointers:

 - Keep in mind that the user is reading this information from the GUI, so
   write accordingly.
 - Do not over-complicate. This is a small beginners' guide.
 - Use available Markdown formatting features such as section headers, lists,
   and code blocks. See this [Markdown help][askubuntu-markdown].
   
Finally, here is an example of a `getstarted.md` file:

[https://api.jujucharms.com/charmstore/v5/~rharding/grafana-4/archive/getstarted.md][getstartedmd-link]

## Testing your Charm

Because Juju is a large complex system, not unlike a Linux software
distribution, there is a need to test the charms themselves and how they
interact with one another. All new charms require tests that verify the
application installs, configures, scales and relates as intended. The tests
should be self-contained, installing all the required packages so the tests
can be run automatically with a tool called
[`bundletester`][bundletester]. Similar to hooks the tests should be
executable files in a `tests/` directory of the charm.
While you can write tests in Bash or other languages, it is recommended to
use the [Amulet library][amulet], which makes it easy to write charm
tests in Python.

For more information about writing tests please refer to the
[charm testing guide documentation][charm testing].

## Publishing your charm

When you are done writing your charm and you want to make it available to
others you will need to make a *promulgation request*. This is informally done
via the [Juju users mailing list][mailing-list-juju].

The '#juju' IRC channel on Freenode and the above mailing list remain excellent
resources for questions and comments regarding charm development and charm
promulgation.

### Promulgation notes

- The [Charm promulgation][charm-promulgation] page contains information on what
  happens once the request is made.

- It is the responsibility of the charm author (and maintainer) to test
  their charm to ensure it is of good quality and is secure.

- Promulgation to the top level namespace of the Charm Store does not imply
  an endorsement by Canonical.

- Charm authors are encouraged to use their personal or group namespace.


<!-- LINKS -->


[store]:              https://jujucharms.com/
[getting-started]:    ./getting-started.html
[charm-tools]:        ./tools-charm-tools.html
[charm-helpers]:      ./tools-charm-helpers.html
[charm-helper-docs]:  http://pythonhosted.org/charmhelpers/
[interface-layers]:   ./developer-layers-interfaces.html
[vanilla]:            http://vanillaforums.org
[charms-local]:       ./charms-deploying.html#deploying-from-a-local-charm
[amulet]:             ./tools-amulet.html
[bundletester]:       https://github.com/juju-solutions/bundletester
[charm testing]:      ./developer-testing.html
[interfaces]:         http://interfaces.juju.solutions/
[charm-promulgation]: ./charm-promulgation.html
[reactive]: https://en.wikipedia.org/wiki/Reactive_programming
[mailing-list-juju]: https://lists.ubuntu.com/mailman/listinfo/juju
[charmsreactive]: https://charmsreactive.readthedocs.io/
[upstream-openstack-charms]: https://docs.openstack.org/charm-guide/
[askubuntu-markdown]: https://askubuntu.com/editing-help
[getstartedmd-link]: https://api.jujucharms.com/charmstore/v5/~rharding/grafana-4/archive/getstarted.md
