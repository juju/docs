Title: Using MAAS with Juju


# Using a MAAS cloud

Juju works closely with [MAAS](https://maas.io) to deliver the same experience 
on bare metal that you would get using any other cloud.


## Defining MAAS clouds

For each MAAS you may have, you will need to define it so it may become a
member of Juju's known clouds. This is done with the help of a YAML file. All
that varies is the endpoint and the name, since they use the same
authentication method. For example, below is the file maas-clouds.yaml:
 
```yaml
clouds:
   devmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://devmaas/MAAS
   testmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://172.18.42.10/MAAS
   prodmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://prodmaas/MAAS
```

This defines three MAAS (region) controllers. To add a MAAS cloud from this
definition to Juju run the command in the form:
 
```bash
juju add-cloud <cloudname> <YAML file>
```

To add two MAAS clouds from the above example we would run:

```bash
juju add-cloud devmaas maas-clouds.yaml
juju add-cloud prodmaas maas-clouds.yaml
```

Where the supplied cloud names refer to those in the YAML file.

This will add both the 'prodmaas' and 'devmaas' clouds, which you can confirm
by running:
 
```bash
juju clouds
```

This will list the newly added clouds, preceded with the prefix 'local:' which
denotes that these are local clouds added by the user:

<!-- JUJUVERSION: 2.0.0-xenial-amd64 -->
<!-- JUJUCOMMAND: juju clouds -->
```no-highlight
Cloud        Regions  Default        Type        Description
aws               11  us-east-1      ec2         Amazon Web Services
...
devmaas            0                 maas        Metal As A Service
prodmaas           0                 maas        Metal As A Service
testmaas           0                 maas        Metal As A Service
```

Next, add your MAAS credentials:

```bash
juju add-credential prodmaas
```

When prompted for "maas-oauth", you should paste your MAAS API key. Your API
key can be found in the Account/User Preferences page in the MAAS web
interface, or by using the MAAS CLI:

```bash
sudo maas-region apikey --username=<user>
```

Note: Juju does not echo this key back to the screen.

Now you can create a Juju controller with the bootstrap command:
 
```bash
juju bootstrap prodmaas prodmaas-controller
```

Above, the Juju controller was called 'prodmaas-controller'.
