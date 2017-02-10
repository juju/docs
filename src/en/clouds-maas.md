Title: Using MAAS with Juju


# Using a MAAS cloud

Juju works closely with [MAAS][maas-site] to deliver the same experience
on bare metal that you would get using any other cloud.

## Registering a MAAS cloud with Juju

Using the Juju `add-cloud` command, it is easy to add your MAAS clouds to
Juju's list of known clouds. The command is interactive, and will ask for
a name and the endpoint to use. A sample session is shown below.

Running...

```bash
juju add-cloud
```
...will enter the interactive mode. Enter the desired values to continue.

```
Cloud Types
 maas
 manual
 openstack
 vsphere

Select cloud type: maas


Enter a name for your maas cloud: mainmaas

Enter the API endpoint url: http://maas.example.org:5240/MAAS

Cloud "mainmaas" successfully added
You may bootstrap with 'juju bootstrap mainmaas'
```

This will add both the 'mainmaas' cloud, which you can confirm
by running:

```bash
juju clouds
```

This will list the newly added clouds, preceded with the prefix 'local:' which
denotes that these are local clouds added by the user:

```no-highlight
Cloud        Regions  Default        Type        Description
aws               11  us-east-1      ec2         Amazon Web Services
...
mainmaas            0                 maas        Metal As A Service
```

Before you bootstrap this cloud, it is necessary to add the relevant
credentials, as explained below.

## Adding your MAAS credentials

```bash
juju add-credential mainmaas
```

When prompted for "maas-oauth", you should paste your MAAS API key. Your API
key can be found in the Account/User Preferences page in the MAAS web
interface, or by using the MAAS CLI:

```bash
sudo maas-region apikey --username=<user>
```

**Note:** Juju does not echo this key back to the screen.

Now you can create a Juju controller with the bootstrap command:

```bash
juju bootstrap mainmaas mainmaas-controller
```

Above, the Juju controller was called 'mainmaas-controller'.

## Manually defining MAAS clouds

If for any reason you would rather define all your MAAS clouds in a
single YAML configuration file, Juju can also import cloud definitions.
For more details on this, see the
[documentation on manually adding MAAS clouds][maas-manual]

[maas-site]: https://maas.io
[maas-manual]: ./clouds-maas-manual.html
