Title: Using MAAS with Juju
table_of_contents: True

# Using MAAS with Juju

[MAAS][upstream-maas] treats physical servers (or KVM guests) as a public cloud
treats cloud instances.

!!! Note:
    The Juju 2.x series is compatible with both the 1.x and 2.x series of MAAS.

## Adding a MAAS cloud

Use the interactive `add-cloud` command to add your MAAS cloud to Juju's list
of clouds. You will need to supply a name you wish to call your cloud and the
unique MAAS API endpoint.

For the manual method of adding a MAAS cloud, see below section
[Manually adding MAAS clouds][#clouds-maas-manual].

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: maas

Enter a name for your maas cloud: maas-cloud

Enter the API endpoint url: http://10.55.60.29:5240/MAAS

Cloud "maas-cloud" successfully added

You will need to add credentials for this cloud (`juju add-credential maas-cloud`)
before creating a controller (`juju bootstrap maas-cloud`).
```

We've called the new cloud 'maas-cloud' and used an endpoint of
'http://10.55.60.29:5240/MAAS'.

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

Here is a partial output:

```no-highlight
Cloud        Regions  Default          Type        Description
.
.
.
maas-cloud         0                   maas        Metal As A Service
```

### Manually adding MAAS clouds

This example covers manually adding a MAAS cloud to Juju (see
[Adding clouds manually][clouds-adding-manually] for background information).
It also demonstrates how multiple clouds of the same type can be defined and
added.

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. Here is an example:

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

This defines three MAAS clouds and refers to them by their respective region
controllers.

To add clouds 'devmaas' and 'prodmaas', assuming the configuration file is
`maas-clouds.yaml` in the current directory, we would run:

```bash
juju add-cloud devmaas maas-clouds.yaml
juju add-cloud prodmaas maas-clouds.yaml
```

## Adding credentials

The [Credentials][credentials] page offers a full treatment of credential
management.

Use the interactive `add-credential` command to add your credentials to the new
cloud:

```bash
juju add-credential maas-cloud
```

Example user session:

```no-highlight
Enter credential name: maas-cloud-creds

Using auth-type "oauth1".

Enter maas-oauth:

Credentials added for cloud maas-cloud.
```

We've called the new credential 'maas-cloud-creds'. When prompted for
'maas-oauth', you should paste your MAAS API key.

!!! Note:
    The API key will not be echoed back to the screen.

Typically you will have a MAAS user of your own. The [MAAS API key][maas-api]
can be found on your user preferences page in the MAAS web UI, or by using the
[MAAS CLI][maas-cli], providing you have sudo access:

```bash
sudo maas-region apikey --username=$PROFILE
```

Where $PROFILE is to be replaced by the MAAS username.

## Creating a controller

You are now ready to create a Juju controller for cloud 'maas-cloud':

```bash
juju bootstrap maas-cloud maas-cloud-controller
```

Above, the name given to the new controller is 'maas-cloud-controller'. MAAS
will allocate a node from its pool to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[upstream-maas]: https://maas.io
[maas-cli]: https://docs.ubuntu.com/maas/en/manage-cli
[maas-api]: https://docs.ubuntu.com/maas/en/manage-account#api-key
[create-a-controller-with-constraints]: ./controllers-creating.md#create-a-controller-with-constraints
[models]: ./models.md
[charms]: ./charms.md
[#clouds-maas-manual]: #manually-adding-maas-clouds
[controllers-creating]: ./controllers-creating.md
[clouds-adding-manually]: ./clouds.md#adding-clouds-manually
[credentials]: ./credentials.md
