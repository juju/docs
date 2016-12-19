Title: OpenStack clouds

# OpenStack Clouds

Although Juju doesn't have baked-in knowledge of *your* OpenStack cloud, it 
does know how such clouds work in general. We just need to provide some 
information to add it to the list of known clouds.

## Adding an OpenStack Cloud

There are cases where the cloud you want to use is not on Juju's list of known 
clouds. In this case it is possible to create a [YAML][yaml] formatted file 
with the information Juju requires and import this new definition. The file 
should follow this general format:
  
```yaml
clouds:
  <cloud_name>:
    type: <type_of_cloud>
    auth-types: <[access-key, oauth, userpass]>
    regions:
      <region-name>:
        endpoint: <https://xxx.yyy.zzz:35574/v3.0/>
```
with the relevant values substituted in for the parts indicated
(within '<' '>').

For example, a typical OpenStack cloud on the local network you want to call 
'mystack' would appear something like this:

  
```yaml
clouds:
    mystack:
      type: openstack
      auth-types: [access-key, userpass]
      regions:
        dev1:
          endpoint: https://openstack.example.com:35574/v3.0/
```

In this case the authentication url is at 
https://openstack.example.com:35574/v3.0/, it has a region called 'dev1' and 
the cloud accepts either access-key or username/password authentication 
methods.

With the configuration file saved, you can add this cloud to Juju with the 
`add-cloud` command:

```bash
juju add-cloud <cloud-name> <config-file.yaml>
```

The cloud name you supply here **must** match the name given in the YAML file, 
so for example:

```bash
juju add-cloud mystack mystack-config.yaml
```

Once the cloud has been added, it will appear on the list of known clouds 
output by the `juju clouds` command. Note that the cloud name will be 
highlighted to indicate that it is a locally added cloud.

!["juju cloud with locally added cloud"](./media/list-clouds-local.png)

## Adding credentials

If you source a novarc file for OpenStack, or use the default environmental 
variables for accessing this cloud, you can simply get Juju to scan for the 
credentials and add them.

Run the command...

```bash
juju autoload-credentials
```

Juju will search known locations, including environment variables, for
credential information and present you with a set of choices for storing them. 
Simply follow the prompts.

For other methods of adding credentials, please see the specific 
[credentials documentation][credentials].



## Images and private clouds

The above steps are all you need to use most OpenStack clouds which are 
configured for general use. If this is your own cloud, you will also need to 
additionally provide stream information so that the cloud can fetch the 
relevant images for Juju to use. This is covered in the section on 
[private clouds][simplestreams].

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[simplestreams]: ./howto-privatecloud.html
[credentials]: ./credentials.html
