Title: Using MAAS with Juju

# Using a MAAS cloud

Juju works closely with [MAAS](https://maas.io) to deliver the same experience 
on bare metal that you would get using any other cloud.

In the simplest case, there is no need to do any additional configuration, just
supply your credentials:
  
```bash
juju add-credential maas
```
This command will then ask for the name to assign to this credential, and the 
MAAS key to use.

You can then proceed to bootstrap the cloud by specifying the IP address of the 
MAAS controller:
  
```bash
juju bootstrap mass-controller maas/192.168.0.1
```

## Defining MAAS clouds

For convenience, especially if you have more than one MAAS, you can add a 
definition of a MAAS to Juju's known clouds.

To do this you should create a YAML format file of the type shown below. For 
MAAS clouds the only thing that varies is the endpoint and the name, since they
use the same authentication method. 
For example, we could create the file maas-clouds.yaml:
  
```yaml

clouds:
   devmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://devmaas/MAAS
   testmass:
      type: maas
      auth-types: [oauth1]
      endpoint: http://172.18.42.10/MAAS
   prodmass:
      type: maas
      auth-types: [oauth1]
      endpoint: http://prodmaas/MAAS
```

This defines three available MAAS controllers. To add a MAAS cloud 
from this definition to Juju's list of known clouds you run the command in the 
form:
  
```bash
juju add-cloud <cloudname> <YAML file>
```
So, for the above example we would run:
  
```bash
juju add-cloud devmaas maas-clouds.yaml
juju add-cloud prodmaas maas-clouds.yaml
```

Note that the name for the cloud supplied here *must* match the name in the
YAMl file.

This will add both the 'prodmaas' and 'devmaas' clouds, which you can confirm
by running:
  
```bash
juju list-clouds
```

which will list the newly added clouds at the bottom, preceded with a 'local:' 
prefix which denotes that these are local clouds added by the user:

```no-higlight
CLOUD           TYPE        REGIONS
aws             ec2         us-east1, us-west1, us-west2
...
local:devmaas   maas
local:prodmaas  maas
```

After adding credentials for a MAAS:

```bash
juju add-credential prodmaas
```

...you can then create a Juju controller 
with the bootstrap command:
  
```
juju bootstrap prodmaas
```


