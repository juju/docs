Title: Hello World example charm development, part 2/2.

# What you will learn:

We will build on the previous tutorial: Hello World example charm development, part 1/2 to:

* Learn how to add a 'mysql' database interface to charms.
* Write a charm that writes a text-file using a template.
* Deploy the example charm and relate to a mysql charm.
* Use 'juju ssh' to login to the juju unit and display the contents of the text-file.

## Add the interface
To add the mysql interface, we have to modify 'layer.yaml', 'metadata.yaml' and create a template inside a templates directory. Lets do that.

Modify the **~/charms/layers/layer-example/layer.yaml** to look like this:

<pre>
includes: 
  - 'layer:basic'
  - 'layer:apt'
  - 'interface:mysql'
options:
  apt:
    packages:
     - hello 
</pre>

Modify the **~/charms/layers/layer-example/metadata.yaml** to look like this:

<pre>
name: example
summary: A very basic example charm
maintainer: Your Name <your.name@mail.com>
description: |
  This is a charm I built as part of my beginner charming tutorial.
tags:
  - misc
  - tutorials
requires:
  database:
    interface: mysql
</pre>

## Create the templates directory:
The 'templates' directory is where templates go for charms. Lets create it.

```bash
cd ~/charms/layers/layer-example/
mkdir templates 
```

Modify the **~/charms/layers/layer-example/templates/text-file.tmpl** to look like this:

<pre>
DB_HOST = '{{ my_database.host() }}'
DB_NAME = '{{ my_database.database() }}'
DB_USER = '{{ my_database.user() }}'
DB_PASSWORD = '{{ my_database.password() }}'
</pre>

The file above is in a "Jinja2" template format. Jinja2 templates allows us to perform very advanced template rendering with little effort.


## Rewrite the layer_example.py

**~/charms/layers/layer-example/reactive/layer_example.py
**
```python
from charms.reactive import set_flag, when, when_not
from charmhelpers.core.hookenv import application_version_set, status_set
from charmhelpers.fetch import get_upstream_version
import subprocess as sp
from charmhelpers.core.templating import render


@when_not('example.installed')
def install_example():
    set_flag('example.installed')


@when('apt.installed.hello')
def set_message_hello():
    # Set the upstream version of hello for juju status.
    application_version_set(get_upstream_version('hello'))

    # Run hello and get the message
    message = sp.check_output('hello', stderr=sp.STDOUT)

    # Set the maintenance status with a message
    status_set('maintenance', message )

    # Signal that we know the version of hello
    set_flag('hello.version.set')


@when('database.available')
def write_text_file(mysql):
    render(source='text-file.tmpl',
           target='/root/text-file.txt',
           owner='root',
           perms=0o775,
           context={
               'my_database': mysql,
           })
        status_set('active', 'Ready: File rendered.')


@when_not('database.connected')
def missing_mysql():
    status_set('blocked', 'Please add relation to MySQL')


@when('database.connected')
@when_not('database.available')
def waiting_mysql(mysql):
    status_set('waiting', 'Waiting for MySQL')
```

What happens here is that:

* The mysql interface raises a flag 'database.available' when the relation is joined and mysql has created a database and username, password for us. 
* The database mysql object is passed to us from juju.
* We pass on the mysql object to Jinja2 render() that renders the template.
* We finish our work by setting the 'active' status.

Note: Look how we change the code in the function *set_message_hello()*. In the previous part of this tutorial, we set the 'active' status when the hello package was installed. This time, we set it to 'maintenance'. The logic is that we intend to do more work before we are done this time. Status 'active' is set in the function *write_text_file(mysql)* when the template is rendered.

## Proof, Build, Deploy, Relate
We are done and can run through the deployment and relate our charm to the mysql charm.

```bash
cd ~/charms/layers
charm proof layer-example
charm build layer-example
juju deploy ../trusty/example
juju deploy cs:mysql
juju relate example mysql

```

Note: We deploy our local charm by referencing with a path (../trusty/example). mysql is on the other hand is deployed from the Charm Store (cs:mysql). "cs:mysql" tells juju to download the charm from over the network instead of uploadning it from our local directory repository.

## Look at the file with 'juju ssh'
Lets look at the file we created inside the example/0 unit. We will do that using "juju ssh".

```bash
juju ssh mysql/0 sudo cat /root/text-file.txt

```
juju ssh executes a command on the remote machine and if everything goes well, you should see the contents of the rendered file, something like below:

<pre>
DB_HOST = '10.170.55.25'
DB_NAME = 'example'
DB_USER = 'Dae7EGh9Zei0nee'
DB_PASSWORD = 'aiRei1siePhewah'
</pre>

Congratulations, you have completed the tutorial!

## Next lesson: 
In the next tutorial, we will learn how to publish our charms to the charmstore so you can use it from anywhere around the world, in any cloud!

## More to learn from this tutorial:

### More
