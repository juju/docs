Title: What's new in Juju 2.1
TODO: add changes in output to model and show-machine


# What's new in Juju 2.1

Juju 2.1 makes creating and managing cloud deployments even easier. This is
thanks to two new and significant features:

- add other clouds interactively: Juju already has baked-in support for many
  public clouds, including [Amazon AWS][aws], [Google GCE][gce] and Microsoft
  [Azure][azure]. But with Juju 2.1, additional clouds such as [MAAS][maas],
  [OpenStack][openstack] and [vSphere][vsphere], can be added by simply typing
  `juju add-cloud` and answering a few questions.
- model migration: it's now possible to move live models from one controller to
  another, allowing for load balancing and maintenance without losing access to
  your applications. 

We're going to step through these new features in more detail below. If you're
new to Juju, we recommend taking a look at our [Getting started][first] guide
first.

## Interactive add-cloud

With previous versions of Juju, the 'add-cloud' command would need to be fed a
specifically formatted yaml file if your cloud of choice wasn't directly
supported by Juju. You can still do this, but from version 2.1, you can also
step through a simple interactive process that will create a working
configuration for you. 

In the following example, we're going to configure Juju to add a locally
accessible MAAS installation by answering 3 simple questions.

Typing `juju add-cloud` starts the process and produces the following output:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  vsphere

Select cloud type:
```

For this example, typing 'maas' will select our chosen cloud type. 

!!! Note: for a cloud that supports multiple regions, 'add-cloud' will walk you
entering the endpoints for each region.

The next question will ask for a name to give to this new cloud:

```no-highlight
Enter a name for your maas cloud: newmaas
```

We're now asked for the API endpoint URL. For our MAAS system, this is
`https://192.168.122.143:5240/MAAS`. Juju will check the validity of the API
url by making sure it's visible to the client. After verifying the url, the
configuration will be created as shown here:

```no-hightlight
Enter the API endpoint url: https://192.168.122.143:5240/MAAS

Cloud "newmaas" successfully added
You may bootstrap with 'juju bootstrap newmaas'
```

### Add credentials

Juju now has all the connection details it needs. The next step
is to add user access credentials, a process that's similarly interactive:

```bash
juju add-credential newmaas
```

Juju will ask two further details:

```no-highlight
Enter credential name: newmaascreds
Using auth-type "oauth1".
Enter maas-oauth:  ****************
Credentials added for cloud add-cloud-maas.
```

### Bootstrap the cloud

Juju can bow bootstrap our new cloud, a process that can
be initiated by typing the following:

```bash
juju bootstrap
```

The above command will list available clouds, including the freshly added
'newmaas'. This is typed to launch the new cloud:

```no-highlight
Select a cloud [localhost]: newmaas

Enter a name for the Controller [newmaasc]: 

Creating Juju controller "newmaasc" on newmaas
Looking for packaged Juju agent version 2.1-beta4 for amd64
Launching controller instance(s) on add-cloud-maas...
 - kh4k4a (arch=amd64 mem=4G cores=1)  
Fetching Juju GUI 2.2.7
```
## Deploy an application

We can now easily deploy any application from the [Juju charm
store][charmstore]. For this example, we're going to deploy an [Elasticsearch
cluster][esstore], which combines both Elasticsearch and Kibana in a single
scaleable bundle:

```bash
juju deploy cs:bundle/elasticsearch-cluster-17
```

After a few moments, `juju status` will report both applications are active,
giving us a fully operational Elasticsearch deployment. 

## Migrate an application

The new migration feature in Juju 2.1 allows you to painlessly move any model
from one controller to another. This may be necessary if a controller reaches
capacity, or to move a model while backing up the data on the original
controller.

!!! Note: for details on where models can be migrated to, see the [migrate][migrate]
documentation.

To continue the previous example, we need to create a secondary controller to
act as the destination.  As we're going to move the 'default' model that was
created automatically when we bootstrapped the original controller, we'll need
to bootstrap the new controller with a different name for the default model:

```bash
juju bootstrap lxd newcontroller --default-model newmodel
```

Starting the migration is now as easy as switching back to the original
controller and specifying both the model and the destination controller with
the `migrate` command:

```
juju switch newmaasc
juju migrate default newcontroller
```

The 'Notes' column in the output from `juju status` can be used to follow
progress. However, small migrations like this will complete in seconds. And
that's all there is to it. 

## Next Steps

For further details, see the [add-cloud][addcloud] and [migrate][migrate]
documentation and the Juju 2.1 [release notes][rnotes].

[first]: ./getting-started.html
[aws]: ./help-aws.html
[gce]: ./help-google.html
[azure]: ./help-azure.html
[maas]: ./clouds-maas.html
[openstack]: ./help-openstack.html
[vsphere]: ./help-vmware.html
[charmstore]: https://jujucharms.com/store
[esstore]: https://jujucharms.com/elasticsearch-cluster
[addcloud]: ./commands.html#add-cloud
[migrate]: ./models-migrate.html
[rnotes]: ./reference-release-notes.html#juju_2.1.0
