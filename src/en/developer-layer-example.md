Title: Writing layer example  

## Writing a layer by example

In this document, we will be writing a charm layer for Vanilla. Vanilla is an
open source, themeable, pluggable, and multi-lingual forum software, which
enables communities to host a forum for discussion topics at scale. Powered by
PHP and MySQL, Vanilla is a fine example of a three-tiered application:

- Database (MySQL)
- Middleware (PHP App)
- Load Balancing via HTTP interface

### Prepare your workspace

Building off of [`$JUJU_REPOSITORY`](reference-environment-variables.html#juju_repository),
we want to add two more environment variables to your session. We recommend
adding these into your shell configuration file so that they are always
available.

#### LAYER_PATH

Defines the location on disk to search for local layers. First, create the base
directory, if it doesn't exist:

```bash
mkdir $HOME/charms
export JUJU_REPOSITORY=$HOME/charms
```

Next, create the directory where layered charms will reside:

```bash
mkdir $JUJU_REPOSITORY/layers
export LAYER_PATH=$JUJU_REPOSITORY/layers
```

And finally, create our charm layer for Vanilla:

```bash
mkdir -p $LAYER_PATH/vanilla
cd $LAYER_PATH/vanilla
```

### Determine a base layer and additional relations

To best leverage existing work, it is important to choose the right base layer
for your charm. The available layers and interfaces can be found at
[interfaces.juju.solutions](http://interfaces.juju.solutions/).

For our example, Vanilla is a PHP5 application, so the layer we will use is the
[apache-php5](https://github.com/johnsca/apache-php) layer. This is a "runtime"
layer that provides a common basis for specific applications to be built on top
of. Out of the box, this will give us Apache2 running on a configurable port,
mod-php5, and support for the [http
interface](https://code.launchpad.net/~bcsaller/charms/+source/http/+git/http)
for running behind a proxy for high availability and scaling. On top of that,
we'll use the [mysql
interface](https://github.com/johnsca/juju-relation-mysql) to facilitate our
database interface. We will put these in a `layer.yaml` file, which tells the
builder what layers and interfaces to combine with yours to create the finished
charm:

```yaml
includes: ['layer:apache-php', 'interface:mysql']
```

### Fill in your charm layer

With that decided, we're ready to start creating our charm layer. The README,
icon, and copyright file will be the same. The `metadata.yaml` will be the same
except that the website relation will be managed for us, so we can leave out
the provides section:

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

The apache-php layer requires some additional configuration to tell it how to
install and configure your application. This goes in an `apache.yaml` file:

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

This tells the apache-php layer to install some additional packages for PHP,
where to fetch your application from (as well as its cryptographic hash to
verify the payload), and a few options for the vhost entry. The application will
be installed under `/var/www/{site_name}` where {site_name} is the name of the
block under sites (in this case vanilla).
### Implementing your layer

The apache-php layer and mysql interface use
[charms.reactive](http://pythonhosted.org/charms.reactive/) to coordinate with
your layer. This makes it easy to coordinate the state of multiple layers,
relations, configuration options, etc. Code for reactive handlers should live
under a `reactive/` directory in your charm layer. In our case, we'll use
`reactive/vanilla.py`. The apache-php layer sets an apache.available state when
your application is done being installed, and the mysql interface sets a similar
{relation_name}.available state (where {relation_name} depends on what you
called the relation in your metadata.yaml) to indicate that MySQL has provided
you with a complete set of database credentials. Thus, by watching for both of
those states, you can easily tell when the right time to set up your application
is:

```python
    @when('apache.available', 'database.available')
    	def setup_vanilla(mysql):
    	    pass
```

You'll notice that the MySQL relation is passed in so that you can easily access
the database connection information. Since the Apache installation and MySQL
relation negotiation are all handled for us, the only thing left to do is create
the `conf/config.php` file for Vanilla. To make things easy, we will render a
template to populate the values. We'll also handle a few more state changes to
provide better status reporting and react to our database going away in an
intelligent manner:

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

By setting the apache.start state, we are letting the apache-php layer know that
we have finished configuring the application and it is ready to start.

The `templates/vanilla_config.php` file is straightforward:

```php
<?php if (!defined('APPLICATION')) exit();
$Configuration['Database']['Host'] = '{{ db.host() }}';
$Configuration['Database']['Name'] = '{{ db.database() }}';
$Configuration['Database']['User'] = '{{ db.user() }}';
$Configuration['Database']['Password'] = '{{ db.password() }}';
?>
```
