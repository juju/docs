Title:Manually adding an OpenStack cloud


# Manually adding an Openstack cloud

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
output by the `juju list-clouds` command. Note that the cloud name will be
highlighted to indicate that it is a locally added cloud.

!["juju list-cloud with locally added cloud"](./media/list-clouds-local.png)

It is necessary to add credentials for this cloud before Juju can bootstrap it.
Please see the [Documentation on adding OpenStack credentials][openstack-credentials]

[openstack-credentials]: ./help-openstack.html#adding-credentials
