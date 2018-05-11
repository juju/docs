Title: Hello World example charm development.

# What you will learn:

This guide will go through the first basic concepts of charm development:

* Preparing & setup of a basic workbench.
* Creating the example charm with "charm tools".
* Understanding the anatomy of a charm (files and directories).
* Validating & building the charm.
* Adding functionality via a secondary layer (layer:apt).
* Deploying the example charm with juju.

## Setup up a basic workbench

This is how a typical workbench looks like:

  - **A Juju controller**: To deploy developed charms to. You can [start here][getting-started] to get one up and running.
  - **Python 3.x**: We use python 3 in this tutorial to develop our charm.
  - **Charm Tools**: To create skeleton charms, build, fetch and test charms. [See the Charm Tools page][charm-tools]
  for installation instructions.

  - Three directories for our build environment needs to be created.
```bash
    mkdir -p ~/charms
    mkdir -p ~/charms/layers
    mkdir -p ~/charms/interfaces
```
  - Put these environment variables in your **~/.bashrc**
```bash
    export JUJU_REPOSITORY=$HOME/charms
    export LAYER_PATH=$JUJU_REPOSITORY/layers
    export INTERFACE_PATH=$JUJU_REPOSITORY/interface
```
  - Finally source your ~/.bashrc to get the environment properly setup.
```bash
    source ~/.bashrc
```

## Creating the example charm with "charm tools"

To simplify creation of new charms, charmtools exist for us. Lets start a new charm that we name: "layer-example".

```bash
cd ~/charms/layers
charm create layer-example
```
Great work, lets move on to understand what a charm consists of.

## The anatomy of a charm

A bare minimum charm consists of a directory with the charm name and two files: 'layers.yaml' and 'metadata.yaml'. Thats all that is strictly required for a charm to be valid. We do however normally create a directory called 'reactive' where we put a python module named with our charm. This is what happened when we ran 'charm create layer-example' above.

Lets examine what was created.

```
layer-example
├── config.yaml             <-- Configuration options for our charm/layer.
├── icon.svg                <-- A nice icon for our charm.
├── layer.yaml              <-- The layers and interfaces we include.
├── metadata.yaml           <-- Information about our charm
├── reactive                <-- Needed for all reactive charms
│   └── layer_example.py    <-- The charm code
├── README.ex               <-- README
└── tests                   <-- Tests goes in here
    ├── 00-setup            <-- A skeleton setup test
    └── 10-deploy           <-- A skeleton deploy test
```

Note! Prefixing the charm directory name with 'layer-' is a naming convention. It tells us that this charm is a 'reactive' charm.

## Validating the charm

If we were to build our charm now, it would fail because its created with defaults. We can see this, by running "charm proof" to validate our charm structure:
```bash
cd ~/charms/layers
charm proof layer-example

I: Includes template icon.svg file.
I: no hooks directory
W: no copyright file
W: Includes template README.ex file
W: README.ex includes boilerplate: Step by step instructions on using the charm:
W: README.ex includes boilerplate: You can then browse to http://ip-address to configure the service.
W: README.ex includes boilerplate: - Upstream mailing list or contact information
W: README.ex includes boilerplate: - Feel free to add things if it's useful for users
E: template interface names should be changed: interface-name
I: relation provides-relation has no hooks
E: template interface names should be changed: interface-name
I: relation requires-relation has no hooks
E: template interface names should be changed: interface-name
I: relation peer-relation has no hooks
I: missing recommended hook install
I: missing recommended hook start
I: missing recommended hook stop
I: missing recommended hook config-changed
```

Let's get rid of these `E: errors` by making the following files look like this:

**layer-example/layer.yaml**
<pre>
includes:
  - 'layer:basic'
</pre>
**layer-example/metadata.yaml**
<pre>
name: example
summary: A very basic example charm
maintainer: Your Name <your.name@mail.com>
description: |
  This is a charm I built as part of my beginner charming tutorial.
tags:
  - misc
  - tutorials
</pre>

**layer-example/reactive/layer_example.py**
```python
from charms.reactive import when, when_not, set_state

@when_not('example.installed')
def install_example():
    set_state('example.installed')
```

### Building the example charm

We are ready to build our charm now with charm tools.

```bash
cd ~/charms/layers
charm build layer-example

build: Composing into /home/erik/charms
build: Destination charm directory: /home/erik/charms/trusty/example
build: Please add a `repo` key to your layer.yaml, with a url from which your layer can be cloned.
build: Processing layer: layer:basic
build: Processing layer: example (from layer-example)
proof: I: Includes template icon.svg file.
proof: W: Includes template README.ex file
proof: W: README.ex includes boilerplate: Step by step instructions on using the charm:
proof: W: README.ex includes boilerplate: You can then browse to http://ip-address to configure the service.
proof: W: README.ex includes boilerplate: - Upstream mailing list or contact information
proof: W: README.ex includes boilerplate: - Feel free to add things if it's useful for users
proof: I: all charms should provide at least one thing
```

Great work! Your charm is assembled and placed in the '$JUJU_REPOSITORY/trusty/example' directory. Go ahead and look in to it before we move on.

### Adding functionality via a layer

Our example charm isn't really doing anything fun yet. Let's make it install the 'hello' package and set a "Hello World" message for juju once its done.

For this very common scenario of installing packages as part of a charm, we can use the *layer:apt*. 

The *layer:apt* has all the functionality we need for installing packages from apt repositories.

Modify the '~/charms/layers/layer-example/layer.yaml' to look like this:

<pre>
includes: 
  - 'layer:basic'
  - 'layer:apt'
options:
  apt:
    packages:
     - hello
</pre>

Modify '~/charms/layers/layer-example/reactive/layer_example.py' to look like this:

```python
from charms.reactive import set_flag, when, when_not
from charmhelpers.core.hookenv import application_version_set, status_set
from charmhelpers.fetch import get_upstream_version
import subprocess as sp

@when_not('example.installed')
def install_example():
    set_flag('example.installed')

@when('apt.installed.hello')
def set_message_hello():
    # Set the upstream version of hello for juju status.
    application_version_set(get_upstream_version('hello'))

    # Run hello and get the message
    message = sp.check_output('hello', stderr=sp.STDOUT)

    # Set the active status with the message
    status_set('active', message )

    # Signal that we know the version of hello
    set_flag('hello.version.set')
```

Lets build again with our changes.

```bash
cd ~/charms/layers/
charm build layer-example
```

The charm will now be built and the final charm assemble ends up in 
'~/charms/layers/trusty/example'

Deploy it with juju:

```bash
juju deploy example
```

After some time, `juju status` will show the "Hello World" message.

Congratulations, you have completed the first basic excersise in charm development!

## Next lesson: Interfaces

Building on your new knowledge, you should try out the Vanilla example which introduces 'interfaces' to charms.

## More to learn from this tutorial:

### Layers vs Charms

One way of thinking about layers in relation to charms, is in terms of libraries or modules. A compilation of layers results in a charm that can be deployed by the juju engine.

*Tip!
There are a lot of pre exising layers included in charm tools, you can find them here [interfaces.juju.solutions][interfaces])*

### Reactive programming

Most programmers expects their applications to be executing from a clear "main()" start and move on step by step towards an exit. Reactive programming is 'somewhat' different in how you plan the execution.

In reactive programming, a good way of thinking about your program, is that it has many "main()" entry points. Which one is execute, depends on how you chose to act on the different states/flags communicated to you by the juju engine. 

The principle is that juju engine signals your application, and you write code/functions to act on this information. Your code then raises new flags/states to communicate with the rest of the system.

This is what the `@when(some.flag.raised)` decorators are all about.
