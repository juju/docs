Title: Building a Juju charm


# Building is easier than writing

When creating a charm, you always have the option of doing it by
[hand][writing].  That is, you can create each hook, implement the side of the
interface you need for each relation your charm requires or provides, manage
the dependencies, such as [charm-helpers][], that your charm uses, et cetera.
However, what you really want to do is focus on *your* charm.  So, why not
leverage the work of others and keep your charm code as minimal and tightly
focused as possible?

Enter the concept of building charms from layers.  Layers let you build on
the work of other charmers, whether that work is in the form of other charms
that you can extend and modify, interfaces that are already built for you and
know how to communicate with a remote service and let you know when that service
is ready and what it provides for you, or partial base layers that make managing
dependencies much easier.  And it does this in a consistent, repeatable, and
auditable way.

For this example, we will create a charm for the same [Vanilla forum software][]
as [before][writing], but using layers.


## Preparation

First off, building charms requires [Charm Tools][], as well as a
[local charm repository][deploying] in which to work. So, if you haven't set
those up yet, use the previous links to do so.

Then create a directory for your layer:

```bash
mkdir vanilla
cd vanilla
```


## Determine a base layer and additional relations

To best leverage existing work, it is important to choose the right base layer
for your charm.  The available layers and interfaces can be found at
[interfaces.juju.solutions][].

In our case, Vanilla is a PHP5 application, so the layer we will use is the
[apache-php5][] layer.  This is a "runtime" layer that provides a common basis
for specific applications to built on top of.  Out of the box, this will give
us Apache2 running on a configurable port, mod-php5, and support for the
[http interface][] for running behind a proxy for high availability and scaling.

On top of that, we'll want to use the [mysql interface][].

We will put these in a `layers.yaml` file, which tells the builder what layers
and interfaces to combine with yours to create the finished charm:

```yaml
includes: ['layer:apache-php', 'interface:mysql']
```


## Fill in your charm layer

With that decided, we're ready to start creating our charm layer.  The README,
icon, and copyright file will be the same.  The `metadata.yaml` will be the
same except that the `website` relation will be managed for us, so we can
leave out the `provides` section:

```yaml
name: vanilla
summary: Vanilla is an open-source, pluggable, themeable, multi-lingual forum.
maintainer: Your Name <your@email.tld>
description: |
  Vanilla is designed to deploy and grow small communities to scale.
  This charm deploys Vanilla Forums as outlined by the Vanilla Forums installation guide.
tags:
  - social
requires:
  database:
    interface: mysql
```

The `apache-php` layer requires some additional configuration to tell it how
to install and configure your application.  This goes in an `apache.yaml` file:

```yaml
packages:
  - 'php5-mysql'
  - 'php5-gd'
sites:
  vanilla:
    options: 'Indexes FollowSymLinks MultiViews'
    install_from:
      source: https://github.com/vanillaforums/Garden/archive/Vanilla_2.0.18.8.tar.gz#sha256=acf61a7ffca9359c1e1d721777182e51637be59744925935291801ccc8e8fd55
```

This tells the `apache-php` layer to install some additional packages for PHP,
where to fetch your application from (as well as its cryptographic hash to
verify the payload), and a few options for the vhost entry.  The application
will be installed under `/var/www/{site_name}` where `{site_name}` is the name
of the block under `sites` (in this case `vanilla`).

Finally, we're ready to work on the charm implementation.


## Implementing your layer

The `apache-php` layer and `mysql` interface use [charms.reactive][] to
coordinate with your layer.  This makes it easy to coordinate the state
of multiple layers, relations, configuration options, etc.  Code for
reactive handlers should live under a `reactive/` folder in your charm layer.
In our case, we'll use `reactive/vanilla.py`.  (We're using Python in this
example, but a Bash version would look [substantially similar][reactive-bash]).

The `apache-php` layer sets an `apache.available` state when your application
is done being installed, and the `mysql` interface sets a similar
`{relation_name}.available` state (where `{relation_name}` depends on what you
called the relation in your `metadata.yaml`) to indicate that MySQL has
provided you with a complete set of database credentials.

Thus, by watching for both of those states, you can easily tell when the right
time to set up your application is:

```python
@when('apache.available', 'database.available')
def setup_vanilla(mysql):
    pass
```

You'll notice that the MySQL relation is passed in so that you can easily access
the database connection information.

Since the Apache installation and MySQL relation negotiation are all handled for
us, the only thing left to do is create the `conf/config.php` file for Vanilla.
To make things easy, we will render a template to populate the values.  We'll
also handle a few more state changes to provide better status reporting and
react to our database going away in an intelligent manner:

```python
import pwd
import os
from charmhelpers.core.hookenv import status_set
from charmhelpers.core.templating import render
from charms.reactive import when, when_not
from charms.reactive import set_state, remove_state


@when('apache.available', 'database.available')
def setup_vanilla(mysql):
    render(source='vanilla_config.php',
           target='/var/www/vanilla/conf/config.php',
           owner='www-data',
           perms=0o775,
           context={
               'db': mysql,
           })
    uid = pwd.getpwnam('www-data').pw_uid
    os.chown('/var/www/vanilla/cache', uid, -1)
    os.chown('/var/www/vanilla/uploads', uid, -1)
    set_state('apache.start')
    status_set('maintenance', 'Starting Apache')


@when('apache.available')
@when_not('database.connected')
def missing_mysql():
    remove_state('apache.start')
    status_set('blocked', 'Please add relation to MySQL')


@when('database.connected')
@when_not('database.available')
def waiting_mysql(mysql):
    remove_state('apache.start')
    status_set('waiting', 'Waiting for MySQL')


@when('apache.started')
def started():
    status_set('active', 'Ready')
```

By setting the `apache.start` state, we are letting the `apache-php` layer know
that we have finished configuring the application and it is ready to start.

The `templates/vanilla_config.php` file is straightforward:

```php
<?php if (!defined('APPLICATION')) exit();
$Configuration['Database']['Host'] = '{{ db.host() }}';
$Configuration['Database']['Name'] = '{{ db.database() }}';
$Configuration['Database']['User'] = '{{ db.user() }}';
$Configuration['Database']['Password'] = '{{ db.password() }}';
?>
```

And that's all you need to get Vanilla up and running using layers!
The final directory structure looks like this:

![directory tree](./media/author-charm-composing-01.png)

Check out the [repo][] for the complete charm layer.

It is important to note that we didn't have to create any hooks.  Those were
all handled by the other layers and interfaces.  This is common when using
layers.

It's also worth noting that there is a file for each layer in the `reactive`
directory.  This allows the handlers for each layer to remain separate and
not conflict.  All handlers from each of those files will be discovered and
dispatched according to the [discovery and dispatch rules][].


## Building your charm

Now that the layer is done, let's build it together and deploy the final
charm.  From within the layer directory, this is as simple as:

```bash
charm build
```

Build will take all of the layers and create a new charm into
`$JUJU_REPOSITORY/trusty/vanilla`:

```
build: Composing into /home/user/charms
build: Processing layer: layer:basic
build: Processing layer: layer:apache-php
build: Processing layer: .
```

Then we can deploy mysql and our new charm as usual:

```bash
juju deploy mysql
juju deploy local:trusty/vanilla
juju add-relation mysql vanilla
juju expose vanilla
```


[writing]: ./authors-charm-writing.html
[charm-helpers]: https://pypi.python.org/pypi/charmhelpers/
[Vanilla forum software]: http://vanillaforums.org/
[Charm Tools]: ./tools-charm-tools.html
[deploying]: ./charms-deploying.html
[apache-php5]: https://github.com/johnsca/apache-php
[http interface]: https://code.launchpad.net/~bcsaller/charms/+source/http/+git/http
[mysql interface]: https://github.com/johnsca/juju-relation-mysql
[charms.reactive]: http://pythonhosted.org/charms.reactive/
[reactive-bash]: http://pythonhosted.org/charms.reactive/#non-python-reactive-handlers
[repo]: https://github.com/johnsca/layered-vanilla
[interfaces.juju.solutions]: http://interfaces.juju.solutions/
[discovery and dispatch rules]: http://pythonhosted.org/charms.reactive/#discovery-and-dispatch-of-reactive-handlers
