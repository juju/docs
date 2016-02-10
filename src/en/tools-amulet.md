Title: Amulet  

# Amulet, a testing harness

Amulet is a set of tools designed to simplify the testing process for charm
authors. Amulet aims to be:

- a testing harness for writing and running tests.
- a way to validate charm relation data (not just what a charm expects/receives).
- a method to exercise and test charm relations outside of a deployment.

While these tools are designed to help make test writing easier, much like [Charm
Helpers](./tools-charm-helpers.html) are designed to make hook writing easier, they are not required to write
tests for charms. These libraries are offered as a completely optional set of tools
for you to use.

## Installation

Amulet is available as both a package and via pip. For source packages, see [
GitHub](https://github.com/juju/amulet/releases).

### Ubuntu

Amulet is available in the Juju Stable PPA for Ubuntu

```bash
sudo add-apt-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install amulet
```

### Mac OSX

Amulet is available via Pip:

```bash
sudo pip install amulet
```

### Windows
Amulet is available via Pip:

```bash
pip install amulet
```

### Source
Amulet is built with Python3, so please make sure it's installed prior to
following these steps. While you can run Amulet from source, it's not
recommended as it requires several changes to environment variables in order for
Amulet to operate as it does in the packaged version.

To install Amulet from source, first get the source:

```bash
git clone https://github.com/marcoceppi/amulet.git
```

Move in to the `amulet` directory and run:

```bash
sudo python3 setup.py install
```

You can also access the Python libraries; however, your `PYTHONPATH` will need
to be amended in order for it to find the amulet directory.

## Usage

Amulet is made available to Python via the `amulet` module which you can import:

```python
import amulet
```

The amulet module seeds each module/command directly, so Deployment is made
available in amulet/deployer.py and is accessible directly from amulet using:

```python
from amulet import Deployment
```

Though `deployer` is also available in the event you wish to execute any of the
helper functions:

```python
from amulet import deployer
d = deployer.Deployment()
```

## Core functionality

This section is deigned to outline the core functions of Amulet. Again, please
refer to the developer documentation for an exhaustive list of functions and
methods.

### amulet.deployer

The Deployer module houses several classes for interacting and setting up an
environment. These classes and methods are outlined below
amulet.deployer.Deployment()

Deployment (amulet deployment, from amulet import Deployment) is an abstraction
layer to the juju-deployer Juju plugin and a service life cycle management tool.
It's designed to allow an author to describe their deployment in simple terms:

```python
import amulet
d = amulet.Deployment()
d.add('mysql')
d.add('mediawiki')
d.relate('mysql:db', 'mediawiki:db')
d.expose('mediawiki')
d.configure('mediawiki', {'title': 'My Wiki', 'skin': 'Nostolgia'})
d.setup()
```

That information is then translated to a Juju Deployer deployment file then,
finally, juju-deployer executes the described setup. Amulet strives to ensure it
implements the correct version and syntax of Juju Deployer, to avoid charm
authors having to potentially intervene each time an update to `juju-deployer`
is made.

Once an environment has been set up, deployer can still drive the environment
outside of of juju-deployer. So the same commands (add, relate, configure,
expose) will instead interact directly with the environment by using either the
Juju API or the juju commands.

#### Deployer Class:

    Deployment(juju_env=None, series='precise', sentries=True, juju_deployer='juju-deployer', sentry_template=None)

#### Deployer Methods:

##### Deployment.add(service, charm=None, units=1)

Add a new service to the deployment schema.

  - `service` Name of the service to deploy.
  - `charm` If provided, will be the charm used. Otherwise service is used as the charm.
  - `units` Number of units to deploy.

Example:

```python
import amulet
d = amulet.Deployment()
d.add('wordpress')
d.add('second-wp', charm='wordpress')
d.add('personal-wp', charm='~marcoceppi/wordpress', units=2)
```

##### Deployment.add_unit(service, units=1)

Add more units of an existing service after deployment.

  - `service` Name of the service to add, must already be added.
  - `units` Number of units to add, default is one.

Example:

```python
import amulet
d = amulet.Deployment()
d.add('wordpress')
try:
    d.setup(timeout=900)
except amulet.helpers.TimeoutError:
    # Setup didn't complete before timeout
    pass
d.add_unit('wordpress')
d.add_unit('wordpresss', units=2)
```

##### Deployment.build_relations()

Private method invoked during deployer_map. Creates relation mapping.

##### Deployment.build_sentries()

Private method invoked during deployer_map. Creates sentries for services.

##### Deployment.configure(service, **options)

Change configuration options for a service.

  - `service` The service to configure.
  - `options` Dict of configuration options.

Example:

```python
import amulet
d = amulet.Deployment()
d.add('postgresql')
d.configure('postgresql', {'autovacuum': True, 'cluster_name': 'cname'})
```

##### Deployment.deployer_map(services, relations)

Create deployer file from provided services and relations.

  - `services` Object of service and service data.
  - `relations` List of relations to map.

##### Deployment.expose(service)

Indicate if a service should be exposed after deployment.

  - `service` - Name of service to expose

```python
import amulet
d = amulet.Deployment()
d.add('varnish')
d.expose('varnish')
```

##### Deployment.load(deploy_cfg)

Import an existing deployer object.

  - `deploy_cfg` Already parsed deployer yaml/json file.

##### Deployment.relate(*args)

Relate services together.

  - `*args` - `service:relation` to be related.

If more than two arguments are given, it's assumed they're to be added to the
first argument as a relation.

```python
import amulet
d = amulet.Deployment()
d.add('postgresql')
d.add('mysql')
d.add('wordpress')
d.add('mediawiki')
d.add('discourse')
d.relate('postgresql:db-admin', 'discourse:db')
d.relate('mysql:db', 'wordpress:db', 'mediawiki:database')
# previous command is equivalent too:
d.relate('mysql:db', 'wordpress:db')
d.relate('mysql:db', 'mediawiki:database')
```

##### Deployment.setup(timeout=600)

This will create the deployer mapping, create any sentries that are required,
and execute juju-deployer with the generated mapping.

  - `timeout` in seconds, how long to wait for setup

Example:

```python
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
```

##### Deployment.unrelate(*args)

Remove a relation between two services.

  - `*args` - `service:relation` to be unrelated.

Exactly two arguments must be given.

```python
import amulet
d = amulet.Deployment()
d.add('postgresql')
d.add('mysql')
d.add('wordpress')
d.add('mediawiki')
d.add('discourse')
d.relate('postgresql:db-admin', 'discourse:db')
d.relate('mysql:db', 'wordpress:db', 'mediawiki:database')
# unrelate all the services we just related
d.unrelate('postgresql:db-admin', 'discourse:db')
d.unrelate('mysql:db', 'wordpress:db')
d.unrelate('mysql:db', 'mediawiki:database')
```

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

```python
import amulet
d = amulet.Deployment()
d.add('mediawiki')
d.add('mysql')
d.setup()
d.sentry.wait()
# get UnitSentry for a specific service/unit
d.sentry['mysql'][0]
d.sentry['mediawiki'][0]
# get list of all UnitSentry objects for a service, one per unit
d.sentry['mysql']
assert d.sentry['mysql'][0] in d.sentry['mysql']
```

Sentries provide several methods for which you can use to gather information
about an environment. The following are a few examples.

#### Methods

##### wait(timeout=300)

Wait for all hooks to finish execution on deployment

  - `timeout` Duration in seconds to wait before raising exception, default 300 seconds

If timeout is met prior to ready state, `TimeoutError` is raised.

### amulet.sentry.unit

Each unit is assigned a UnitSentry

#### UnitSentry Class:

##### UnitSentry.from_unitdata(unit, unit_data, port=9001, sentry=None)

  - `unit` - `service/#` formatted string of unit name
  - `unit_data` - Object of unit status output
  - `port` - Sentry port
  - `sentry` - RelationSentry

#### UnitSentry Methods:

##### UnitSentry.directory(dir)

See UnitSentry.directory_stat()

##### UnitSentry.directory_contents(dir)

Return files and directories of directory

  - `dir` Directory on remote machine

Example of output

```no-highlight
{'files': []
 'directories': []}
```

##### UnitSentry.directory_stat(dir)

Return stat of directory

  - `dir` Directory on remote machine

Example of output

```no-highlight
{'mtime': fs_stat.st_mtime,
 'size': fs_stat.st_size,
 'uid': fs_stat.st_uid,
 'gid': fs_stat.st_gid,
 'mode': fs_stat.st_mode}
```

##### UnitSentry.file(filename)

See UnitSentry.file_stat()

##### UnitSentry.file_contents(filename)

Return contents of filename

  - `filename` File on remote machine


##### UnitSentry.file_stat(filename)

Return stat of path

  - `filename` File on remote machine

Example of output

```no-highlight
{'mtime': fs_stat.st_mtime,
 'size': fs_stat.st_size,
 'uid': fs_stat.st_uid,
 'gid': fs_stat.st_gid,
 'mode': fs_stat.st_mode}
```

##### UnitSentry.relation(from_rel, to_rel)

Return stat of path

  - `from_rel` The relation of the unit eg `rel`
  - `to_rel` Service and relation connection, eg: `service:rel`

Output is an object of key, val relation data

##### UnitSentry.run(command)

Execute specified command as root on remote machine

  - `command` Shell command to execute

Returns a tuple of output string and exit code

```no-highlight
>>> d.sentry['ubuntu/0'].run('whoami')
('root', 0)
```

## Examples

Here are a few examples of Amulet tests

### WordPress

#### tests/00-setup

```bash
#!/bin/bash
sudo apt-get install amulet python-requests
```

#### tests/01-simple

```python
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
wp_unit = d.sentry['wordpress'][0]
mysql_unit = d.sentry['mysql'][0]
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
```

#### tests/lib/helper.py

```python
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
```
