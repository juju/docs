Title: Using MAAS with Juju

# Using MAAS with Juju

Juju works closely with [MAAS][maas-site] to deliver the same experience
on bare metal that you would get by using any other cloud. Note that the 
Juju 2.x series is compatible with both the 1.x and 2.x series of MAAS.

## Adding a MAAS cloud

Use the interactive `add-cloud` command to add your MAAS to Juju's list of
clouds:

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  oracle
  vsphere

Select cloud type: maas

Enter a name for your maas cloud: maas-cloud

Enter the API endpoint url: http://10.55.60.29:5240/MAAS

Cloud "maas-cloud" successfully added
You may bootstrap with 'juju bootstrap maas-cloud'
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

You will need to add credentials for this cloud before bootstrapping it
(creating a controller).

### Manually adding a MAAS cloud

Alternatively, it is possible to manually define a single or multiple MAAS
clouds with a file and add a cloud by referring to such a file (still with
`juju add-cloud`). See [Manually adding MAAS clouds][maas-manual] for details.

## Adding credentials

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

For detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[maas-site]: https://maas.io
[maas-cli]: https://docs.ubuntu.com/maas/en/manage-cli
[maas-api]: https://docs.ubuntu.com/maas/en/manage-account#api-key
[maas-manual]: ./clouds-maas-manual.md
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
