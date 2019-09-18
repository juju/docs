This guide is for anyone wanting to creating the code that we call a *charm*; the part that does the work of installing and managing applications in a Juju model. Many charms exist in the [Charm Store](https://jujucharms.com/store) already, but if your favourite application isn't covered or you would like to make your own spin on an existing charm, you will discover all the tools and information you need here.

For an example of a community-driven charm development project see the [OpenStack Charm Guide](https://docs.openstack.org/charm-guide/).

<h2 id="heading--requirements">Requirements</h2>

- **A Juju controller**: If you have not used Juju before, it's a good idea to [start here](/t/getting-started-with-juju/1134).
- **Python 3.x**: it is possible to develop charms using other languages, but this guide focuses on Python-based development.
- **Charm Tools**: Command line utilities to make it easy to create, build, fetch and test charms. See the [Charm Tools](/t/charm-tools/1180) page for more information.
- **Charm Helpers**: A Python library that provides an extensive collection of functions for developers to reuse. Many common charm patterns are encapsulated in functions of this library. See [Charm Helpers](/t/tools/1181#heading--charm-helpers) for details.
- This guide also uses the [Vanilla PHP Forum software](http://vanillaforums.org) as an example.

<h2 id="heading--designing-your-charm">Designing your charm</h2>

In order to begin writing a charm, you should have a good plan of how it’s going to be implemented, what configuration options you wish to expose to anyone deploying the charm, and what dependent charms (if any) it will be related to. It’s a good idea to start with a diagram.

This visual representation of your charm deployment will help to solidify the configuration, deployment, and management of your application. Take the following example:

![Charm Design Diagram](https://assets.ubuntu.com/v1/4fdbb3ff-vanilla-planning.png)

Looking at this diagram we see the Vanilla charm with two units. The Vanilla application requires a relationship to a database using the “mysql” interface. The MariaDB charm implements the mysql interface, which fulfills the db relation and is already in the Store: [https://jujucharms.com/mariadb](https://jujucharms.com/mariadb).

<h2 id="heading--writing-your-charm">Writing your charm</h2>

The fastest way to write a new charm is to build off of existing layers. This allows you to create code that is very focused for the application you are trying to implement.

Layers let you build on the work of other charmers, whether that work is in the form of other charms that you can extend and modify, interfaces that communicate with remote applications, or partial base layers that make managing dependencies much easier. And it does this in a consistent, repeatable, and incremental way.

The available layers and interfaces can be found at [Juju Charm Layers Index](https://github.com/juju/layer-index). The `basic` layer provides charm helpers Python library and the reactive framework that makes layers possible.

<h3 id="heading--reactive-and-layered-charms">Reactive and layered charms</h3>

<h4 id="heading--reactive">Reactive</h4>

Another software paradigm is [reactive programming](https://en.wikipedia.org/wiki/Reactive_programming). Do something when the state or conditions indicate. Juju offers the [charms.reactive](https://charmsreactive.readthedocs.io/) package to allow charms to be written in the reactive paradigm. In charms.reactive code execution is controlled by boolean logic. You can define when the conditions are right, run this code, or when something is not set, run different code or do nothing at all.

<h4 id="heading--layers">Layers</h4>

The idea of charm layers is to combine objects or data into more complex objects or data. When applied to Charms, layers allow you to extend or build off other charms to make more complex or useful charms. The `layer.yaml` file in the root directory of the charm controls what layer(s) will be imported.

<h3 id="heading--creating-a-new-layer">Creating a new layer</h3>

First off, you require a [local charm repository](/t/deploying-applications/1062#heading--deploying-from-a-local-charm) in which to work. This involves creating three directories -- `layers`, `interfaces`, and `charms` -- and setting some environment variables.

The `layers` directory contains the source code of the layered charm covered in our examples. The `interfaces` directory is where you'd place any [interface layers](/t/interface-layers/1121) you may wish to write, and the `charms` directory holds the assembled, ready to deploy charm.

```text
export CHARM_DIR=$HOME/charms
export LAYER_PATH=$CHARM_DIR/layers
export INTERFACE_PATH=$CHARM_DIR/interfaces

mkdir -p $LAYER_PATH $INTERFACE_PATH

cd $CHARM_DIR/layers
```

[note]
Exporting the environment variables in this way only sets the variables for the current terminal. If you wish to make these changes persist, add the same export statements to a resource file that are evaluated when you create a new console such as ~/.bashrc depending on your shell.
[/note]

Once in the layers directory clone the example charm layer - layer-vanilla:

``` text
git clone http://github.com/juju-solutions/layer-vanilla.git
cd layer-vanilla
```

If you'd like to write your own layer, or simply learn more about how layers are implemented, see [How to Write a Layer](/t/writing-a-layer-by-example/1120).

<h3 id="heading--assemble-the-layers">Assemble the layers</h3>

Now that the layer is complete, let's build it and deploy the final charm. From within the layer directory, this is as simple as:

``` text
charm build
```

Build will take all of the layers and interfaces included by your charm, either from your local `LAYER_PATH` and `INTERFACE_PATH` directories or automatically downloaded from the [Juju Charm Layers Index](https://github.com/juju/layer-index) and create a new charm in `$CHARM_DIR/trusty/vanilla`:

    build: Composing into /home/user/charms
    build: Processing layer: layer:basic
    build: Processing layer: layer:apache-php
    build: Processing layer: .

![Charm layer diagram](https://assets.ubuntu.com/v1/5d0e913d-vanilla-layers.png)

To inspect how the charm was assembled, there is a `charm layers` command that shows what file belongs to which layer. Change to the charm directory and view the layer map:

``` text
cd $CHARM_DIR/trusty/vanilla
charm layers
```

Then we can deploy mariadb and the new charm:

``` text
juju deploy mariadb
juju deploy $CHARM_DIR/trusty/vanilla --series trusty
juju add-relation mariadb vanilla
juju expose vanilla
```

<h2 id="heading--add-gui-user-notes">Add GUI user notes</h2>

Optionally leave some notes for those users who will deploy the charm from the Juju GUI. This consists of including a Markdown-formatted file called `getstarted.md` at the root of the charm's directory. Once the charm (or bundle) is deployed, the file will be rendered and displayed to the user.

The file should include the user's next steps. Here is a guideline for what to include:

-   State prerequisites for various application features.
-   Include instructions for achieving a working application at a rudimentary level.
-   Provide links for further reading.

As for style, here are some pointers:

-   Keep in mind that the user is reading this information from the GUI, so write accordingly.
-   Do not over-complicate. This is a small beginners' guide.
-   Use available Markdown formatting features such as section headers, lists, and code blocks. See this [Markdown help](https://askubuntu.com/editing-help).

Finally, here is an example of a `getstarted.md` file:

<https://api.jujucharms.com/charmstore/v5/~rharding/grafana-4/archive/getstarted.md>

<h2 id="heading--testing-your-charm">Testing your charm</h2>

Because Juju is a large complex system, not unlike a Linux software distribution, there is a need to test the charms themselves and how they interact with one another. All new charms require tests that verify the application installs, configures, scales and relates as intended. The tests should be self-contained, installing all the required packages so the tests can be run automatically with a tool called [`bundletester`](https://github.com/juju-solutions/bundletester). Similar to hooks the tests should be executable files in a `tests/` directory of the charm. While you can write tests in Bash or other languages, it is recommended to use the [Amulet](/t/tools/1181#heading--amulet) library, which makes it easy to write charm tests in Python.

For more information about writing tests please refer to the [charm testing guide documentation](/t/writing-charm-tests/1130).

<h2 id="heading--next-steps">Next steps</h2>

Once you have finished testing your charm or bundle visit the [Charm Store](/t/the-juju-charm-store/1045#heading--pushing-to-the-store) page and consider the following topics:

-   Pushing to the store
-   Releasing to channels
-   Publishing your charm
-   Sharing charms and bundles

<!-- LINKS -->
