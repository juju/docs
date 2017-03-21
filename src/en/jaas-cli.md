Title: Using JAAS from the command line

# Using JAAS from the command line

To use JAAS from the CLI requires that you install Juju on a local machine and
connect that Juju install with your JAAS account.

## Install Juju

Follow [these instructions][installjuju] to install Juju on your local machine.

## Register or login to JAAS from Juju

If you are using Juju 2.1, use:

```bash
juju register jimm.jujucharms.com
```

If you are using Juju 2.2, use:
	
```bash
juju login JAAS
```

## View your models

If you added a model using the GUI, you can see it in the CLI, like this:

```bash
juju models
```

## Create a new model

If you have not yet entered credentials for the public cloud of your choice
into JAAS, enter one now with the `add-credential` command, which will walk
you through entering the pertinent credential data for the cloud you specify,
as in this example which uses the GCE cloud.

```bash
juju add-credential google
```

See [Cloud credentials][credentials] for more information.

To add a new model from the CLI, use:

```bash
juju add-model mygce google
```

To deploy kubernetes-core, use:

```bash
juju deploy kubernetes-core
```

View the new model in the JAAS web UI by logging in to [https://jujucharms.com][https://jujucharms.com].

[credentials]: ./credentials.html
[installjuju]: ./getting-started-general.html
