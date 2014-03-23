[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# Amulet, a testing harness

Amulet is a set of tools designed to simplify the testing process for charm
authors. Amulet aims to be:

  - a testing harness for writing and running tests.
  - a way to validate charm relation data (not just what a charm expects/receives).
  - a method to exercise and test charm relations outside of a deployment.

While these tools are designed to help make test writing easier, much like charm
helpers are designed to make hook writing easier, they are not required to write
tests for charms. This library is offered as a completely optional set of tools
for you to use.

# Installation

Amulet is available as both a package and via pip. For source packages, see [
GitHub](https://github.com/marcoceppi/amulet/releases).

[Ubuntu](.) [Mac OSX](.) [Windows](.) [Source](.)

Amulet is available in the Juju Stable PPA for Ubuntu

    
    
    sudo add-apt-repository ppa:juju/stable
    sudo apt-get update
    sudo apt-get install amulet
    

Amulet is available via Pip:

    
    
    sudo pip install amulet

Amulet is available via Pip:

    
    
    pip install amulet

Amulet is built with Python3, make sure it's installed prior to following these
steps. While you can run Amulet from source, it's not recommended as it requires
several changes to environment variables in order for Amulet to operate as it
does in the packaged version.

To install Amulet from source, first get the source:

    
    
    git clone https://github.com/marcoceppi/amulet.git

Move in to the `amulet` directory and run

    
    
    sudo python3 setup.py install

You can also access the Python libraries; however, your `PYTHONPATH` will need
to be amended in order for it to find the amulet directory.

## Usage

Amulet comes packaged with several tools. In order to provide the most
flexibility, Amulet offers both direct Python library access and generic access
via a programmable API for other languages (for example, `bash`).

### Python

Amulet is made available to Python via the `amulet` module which you can import:

    
    
    import amulet

The amulet module seeds each module/command directly, so Deployment is made
available in amulet/deployer.py and is accessible directly from amulet using:

    
    
    from amulet import Deployment

Though `deployer` is also available in the event you wish to execute any of the
helper functions:

    
    
    from amulet import deployer
    d = deployer.Deployment()
    

### Programmable API

A limited number of functions are made available through a generic forking API.
The following examples assume you're using a BOURNE Shell, though this syntax
could be used from within other languauges with the same expected results.

Unlike the Python modules, only some of the functions of Amulet are available
through this API, though efforts are being made to make the majority of the core
functionality available.

This API follows the subcommand workflow, much like Git or Bazaar. Amulet makes
an amulet command available and each function is tied to a sub-command. To mimic
the Python example you can create a a new Deployment by issuing the following
command:

    
    
    amulet deployment

Depending on the syntax and worflow for each function you can expect to provide
either additional sub-commands, command-line flags, or a combination of the two.

## Core functionality

This section is deigned to outline the core functions of Amulet. Again, please
refer to the developer documentation for an exhaustive list of functions and
methods.

### amulet.deployer

The Deployer module houses several classes for interacting and setting up an
environment. These classes and methods are outlined below
amulet.deployer.Deployment()

Deployment (amulet deployment, from amulet import Deployment) is an abstraction
layer to the juju-deployer Juju plugin and a service lifecycle management tool.
It's designed to allow an author to describe their deployment in simple terms:

    
    
    import amulet
    
    d = amulet.Deployment()
    d.add('mysql')
    d.add('mediawiki')
    d.relate('mysql:db', 'mediawiki:db')
    d.expose('mediawiki')
    d.configure('mediawiki', title="My Wiki", skin="Nostolgia")
    d.setup()
    

That information is then translated to a Juju Deployer deployment file then,
finally, juju-deployer executes the described setup. Amulet strives to ensure it
implements the correct version and syntax of Juju Deployer, to avoid charm
authors having to potentially intervene each time an update to `juju-deployer`
is made.

Once an environment has been set up, deployer can still drive the environment
outside of of juju-deployer. So the same commands (add, relate, configure,
expose) will instead interact directly with the environment by using either the
Juju API or the juju commands.

#### Class:

`Deployment(juju_env=None, series='precise', sentries=True, juju_deployer='juju-
deployer', sentry_template=None)`

#### Methods:

`Deployment.add(service, charm=None, units=1)`

Add a new service to the deployment schema.

  - `service` Name of the service to deploy.
  - `charm` If provided, will be the charm used. Otherwise service is used as the charm.
  - `units` Number of units to deploy.
    
    
    import amulet
    
    d = amulet.Deployment()
    d.add('wordpress')
    d.add('second-wp', charm='wordpress')
    d.add('personal-wp', charm='~marcoceppi/wordpress', units=2)
    

`Deployment.build_relations()`

Private method invoked during deployer_map. Creates relation mapping.

`Deployment.build_sentries()`

Private method invoked during deployer_map. Creates sentries for services.

`Deployment.configure(service, **options)`

Change configuration options for a service.

  - `service` The service to configure.
  - `options` Dict of configuration options.
    
    
        
    import amulet
    
    d = amulet.Deployment()
    d.add('postgresql')
    d.configure('postgresql', {'autovacuum': True, 'cluster_name': 'cname'})
    

`Deployment.deployer_map(services, relations)`

Create deployer file from provided services and relations.

  - `services` Object of service and service data.
  - `relations` List of relations to map.
`Deployment.expose(service)`

Indicate if a service should be exposed after deployment.

  - `service` \- Name of service to expose
    
    
        
    import amulet
    
    d = amulet.Deployment()
    d.add('varnish')
    d.expose('varnish')
    

`Deployment.load(deploy_cfg)`

Import an existing deployer object.

  - `deploy_cfg` Already parsed deployer yaml/json file.
`Deployment.relate(*args)`

Relate two services together.

  - `*args` \- `service:relation` to be related.

If more than two arguments are given, it's assumed they're to be added to the
first argument as a relation.

    
    
    import amulet
    
    d = amulet.Deployment()
    d.add('postgresql')
    d.add('mysql')
    d.add('wordpress')
    d.add('mediawiki')
    d.add('discourse')
    
    d.relate('postgresql:db-admin', 'discourse:db')
    d.relate('mysql:db', 'wordpress:db', 'mediawiki:database')
    

`Deployment.setup(timeout=600)`

This will create the deployer mapping, create any sentries that are required,
and execute juju-deployer with the generated mapping.

  - `timeout` in seconds, how long to wait for setup
    
    
    import amulet
    
    d = amulet.Deployment()
    d.add('wordpress')
    d.add('mysql')
    d.configure('wordpress', debug=True)
    d.relate('wordpress:db', 'mysql:db')
    try:
        d.setup(timeout=900)
    except amulet.helpers.TimeoutError:
        # Setup didn't complete before timeout
        pass
    
    

### amulet.sentry

Sentries are an additional service built in to the Deployment tool which allow
an author the ability to dig deeper in to a deployment environment. This is done
by adding a set of tools to each service/unit deployed via a subordinate charm
and a final "relation sentry" charm is deployed which all relations are proxied
through. In doing so you can inspect on each service/unit deployed as well as
receive detailed information about what data is being sent by which
units/service during a relation.

Sentries can be accessed from within your deployment using the sentry object.
Using the above example from ## Deployer, each service and unit can be accessed
using the following:

    
    
    import amulet
    
    d = amulet.Deployment()
    d.add('mediawiki')
    d.add('mysql')
    d.setup()
    
    d.sentry.wait()
    
    d.sentry.unit['mysql/0']
    d.sentry.unit['mediawiki/0']
    

Sentries provide several methods for which you can use to gather information
about an environment. The following are a few examples.

#### Methods

`wait(timeout=300)`

Wait for all hooks to finish execution on deployment

  - `timeout` Duration in seconds to wait before raising exception, default 300 seconds

If timeout is met prior to ready state, `TimeoutError` is raised.

### amulet.sentry.unit

Each unit is assigned a UnitSentry

#### Class:

`UnitSentry.from_unitdata(unit, unit_data, port=9001, sentry=None)`

  - `unit` \- `service/#` formatted string of unit name
  - `unit_data` \- Object of unit status output
  - `port` \- Sentry port
  - `sentry` \- RelationSentry

#### Methods:

`UnitSentry.directory(dir)`

See UnitSentry.directory_stat()

`UnitSentry.directory_contents(dir)`

Return files and directories of directory

  - `dir` Directory on remote machine

Example of output

    
    
    {'files': []
     'directories': []}

`UnitSentry.directory_stat(dir)`

Return stat of directory

  - `dir` Directory on remote machine

Example of output

    
    
    {'mtime': fs_stat.st_mtime,
     'size': fs_stat.st_size,
     'uid': fs_stat.st_uid,
     'gid': fs_stat.st_gid,
     'mode': fs_stat.st_mode}

`UnitSentry.file(filename)`

See UnitSentry.file_stat()

`UnitSentry.file_contents(filename)`

Return contents of filename

  - `filename` File on remote machine
`UnitSentry.file_stat(filename)`

Return stat of path

  - `filename` File on remote machine

Example of output

    
    
    {'mtime': fs_stat.st_mtime,
     'size': fs_stat.st_size,
     'uid': fs_stat.st_uid,
     'gid': fs_stat.st_gid,
     'mode': fs_stat.st_mode}

`UnitSentry.relation(from_rel, to_rel)`

Return stat of path

  - `from_rel` The relation of the unit eg `rel`
  - `to_rel` Service and relation connection, eg: `service:rel`

Output is an object of key, val relation data

`UnitSentry.run(command)`

Execute specified command as root on remote machine

  - `command` Shell command to execute

Returns a tuple of output string and exit code

    
    
    >>> d.sentry.unit['ubuntu/0'].run('whoami')
    ('root', 0)

## Examples

Here are a few examples of Amulet tests

### WordPress

#### tests/00-setup

    
    
    #!/bin/bash
    
    sudo apt-get install amulet python-requests
    

#### tests/01-simple

    
    
    import os
    import amulet
    import requests
    
    from .lib import helper
    
    d = amulet.Deployment()
    d.add('mysql')
    d.add('wordpress')
    d.relate('mysql:db', 'wordpress:db')
    d.expose('wordpress')
    
    try:
        # Create the deployment described above, give us 900 seconds to do it
        d.setup(timeout=900)
        # Setup will only make sure the services are deployed, related, and in a
        # "started" state. We can employ the sentries to actually make sure there
        # are no more hooks being executed on any of the nodes.
        d.sentry.wait()
    except amulet.helpers.TimeoutError:
        amulet.raise_status(amulet.SKIP, msg="Environment wasn't stood up in time")
    except:
        # Something else has gone wrong, raise the error so we can see it and this
        # will automatically "FAIL" the test.
        raise
    
    # Shorten the names a little to make working with unit data easier
    wp_unit = d.sentry.unit['wordpress/0']
    mysql_unit = d.sentry.unit['mysql/0']
    
    # WordPress requires user input to "finish" a setup. This code is contained in
    # the helper.py file found in the lib directory. If it's not able to complete
    # the WordPress setup we need to quit the test, not as failed per se, but as a
    # SKIPed test since we can't accurately setup the environment
    try:
        helper.finish_setup(wp_unit.info['public-address'], password='amulet-test')
    except:
        amulet.raise_status(amulet.SKIP, msg="Unable to finish WordPress setup")
    
    home_page = requests.get('http://%s/' % wp_unit.info['public-address'])
    home_page.raise_for_status() # Make sure it's not 5XX error
    

#### tests/lib/helper.py

    
    
    import requests
    
    def finish_setup(unit, user='admin', password=None):
        h = {'User-Agent': 'Mozilla/5.0 Gecko/20100101 Firefox/12.0',
             'Content-Type': 'application/x-www-form-urlencoded',
             'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*',
             'Accept-Encoding': 'gzip, deflate'}
    
        r = requests.post('http://%s/wp-admin/install.php?step=2' % unit,
                          headers=h, data={'weblog_title': 'Amulet Test %s' % unit,
                          'user_name': user, 'admin_password': password,
                          'admin_email': 'test@example.tld',
                          'admin_password2': password,
                          'Submit': 'Install WordPress'})
    

  - ## [Juju](/)

    - [Charms](/charms)
    - [Features](/features)
    - [Deployment](/deployment)
  - ## [Resources](/resources)

    - [Overview](/resources/juju-overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/the-juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://canonical.com).

