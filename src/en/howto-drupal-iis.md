Title: Deploying Drupal Windows with Juju charms  

#  Using Juju to deploy Drupal Windows charm

Juju is able to deploy workloads on top of Windows. For the moment, only MAAS
and OpenStack can be used as providers, but shortly in the future,
Juju will be able to deploy Windows workloads using any provider, starting
from private clouds to public clouds.

This tutorial explains how to deploy Drupal Windows charm on top of
IIS (Internet Information Services) with HAProxy used as reverse proxy.

Before anything else, make sure you have a MAAS or an OpenStack environment
with Windows images uploaded to it (Windows Server 2012 R2 is used in this
tutorial). [Cloudbase](http://www.cloudbase.it/) has a wiki
[page](http://wiki.cloudbase.it/maas) with a step-by-step tutorial on
how to create a MAAS environment with Windows images. Also, ensure that Juju is
properly installed and configured. You can visit [Getting
Started](https://jujucharms.com/docs/getting-started.html) section to get
instructions on that.

##  Basic usage of the Drupal IIS charm

First, make sure you bootstrapped an environment. If you have not already,
do so:

```bash
juju bootstrap
```

Create a basic configuration file `drupal-iis.yaml` to add info about your
Drupal site:

```yaml
drupal-iis:
  site-name: "Drupal IIS Web Site"
  site-mail: "admin@admin.com"
  admin-password: "Passw0rd"
  admin-mail: "admin@admin.com"
```

Drupal content management system uses a relational database to store its data.
The Drupal Windows charm supports the relation with the following database
charms: [mysql](https://jujucharms.com/mysql/trusty/25),
[postgresql](https://jujucharms.com/postgresql/trusty/21) and
[mssql-express](https://jujucharms.com/u/cloudbaseit/mssql-express/win2012r2).

The charm is agnostic of which database you choose. For this tutorial
we will use the `mssql-express` database charm, but you are free to choose any
of the supported ones and it will behave the same.

Deploy the Drupal Windows charm with the custom yaml config file you prepared
and the `mssql-express` database charm:

```bash
juju deploy cs:~cloudbaseit/win2012r2/drupal-iis --config drupal-iis.yaml
juju deploy cs:~cloudbaseit/win2012r2/mssql-express
```

Wait until the deployment of charms finishes, then add a relation between
them:

```bash
juju add-relation drupal-iis mssql-express
```

At this point, you have a basic deployment of Drupal content management system
that uses two Microsoft technologies: IIS web server and MSSQL Express
relational database.

![juju-gui-services](media/howto-drupal-iis-juju-gui-services.png)

Next, find the `public address` of the Drupal unit you just deployed by issuing
the following command:

```bash
juju status drupal-iis
```

Open a web browser and visit `http://<public_address>/` and you should be able
to see the home page of your Drupal website.

![Drupal Home Page](media/howto-drupal-iis-home-page.png)

Now you can scale out horizontally with:

```bash
juju add-unit drupal-iis
```

and scale down with:

```bash
juju remove-unit drupal-iis/<unit_number>
```

To add a reverse proxy you can use the HAProxy charm and distribute
connections from one front-end port to your charm units.

```bash
juju deploy haproxy
juju add-relation haproxy drupal-iis
juju expose haproxy
```
![juju-gui-haproxy](media/howto-drupal-iis-juju-gui-haproxy.png)

And then get the `public address` from the haproxy instead:

```bash
juju status haproxy
```

and when you visit `http://<public_address>/` you should see the
same home page of your Drupal website.

##  Charm configuration

Configurable aspects of the charm are listed in `config.yaml` with detailed
description about each one. You either edit the default values directly in the
yaml file or pass a `drupal-iis.yaml` configuration file at the deployment
as previously described.

If there is a Drupal service already deployed, you can define the new configs
for your website in custom `drupal-iis.yaml` file and after executing:

```bash
juju set drupal-iis --config drupal-iis.yaml
```

the charm will respond accordingly and it will reconfigure.
