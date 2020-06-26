<!--
Todo:
- Give an example of setting up a subordinate
-->

Bundles are collections of charms. They represent an entire model, rather than a single application. They're an example of the declarative devops approach.

From a technical point of view, a bundle is a YAML file. 

## Creating a bundle

The [Bundle reference](/t/bundle-reference/1158) page provides the structure of a bundle file and defines all available properties. It's a handy reference if you need to create one from scratch or extend a bundle that you currently have.

There are a few short cuts available to you.

### Ask Juju to create one from an existing model

When you have an existing model that you wish to replicate elsewhere, you can ask Juju to create a bundle for you:

To start, make sure that the client is accssing the correct model with `juju switch`:

```plain
juju switch <model>
```

The `juju-export` bundle command creates the YAML file 

```plain
juju export-bundle --filename <model>-<date>.yaml
```

### From an example bundle

The [charm store contains hundreds of bundles](https://jaas.ai/search?type=bundle). Consider downloading the contents of a bundle that is similiar to your own via each bundle's `bundle.yaml` file within the "Files" widget. Once it has been downloaded, you are free to add your own custom functionality.

<!--
## Deploying a bundle

Users treat bundles the same way they treat charms. `juju deploy` will happily accept a bundle rather than a charm:

```plain
juju deploy <bundle>
```
-->

<h2 id="heading--inside-a-bundle">Inside a bundle</h2>

The [`kubernetes-core`](https://jaas.ai/kubernetes-core/) provides a good overview of a bundle file.

```yaml
description: A minimal two-machine Kubernetes cluster, appropriate for development.
series: bionic
machines:
  '0':
    constraints: cores=2 mem=4G root-disk=16G
    series: bionic
  '1':
    constraints: cores=4 mem=4G root-disk=16G
    series: bionic
applications:
  containerd:
    annotations:
      gui-x: '475'
      gui-y: '800'
    charm: cs:~containers/containerd-53
    resources: {}
  easyrsa:
    annotations:
      gui-x: '90'
      gui-y: '420'
    charm: cs:~containers/easyrsa-295
    num_units: 1
    resources:
      easyrsa: 5
    to:
    - lxd:0
  etcd:
    annotations:
      gui-x: '800'
      gui-y: '420'
    charm: cs:~containers/etcd-485
    num_units: 1
    options:
      channel: 3.3/stable
    resources:
      core: 0
      etcd: 3
      snapshot: 0
    to:
    - '0'
  flannel:
    annotations:
      gui-x: '475'
      gui-y: '605'
    charm: cs:~containers/flannel-466
    resources:
      flannel-amd64: 537
      flannel-arm64: 534
      flannel-s390x: 521
  kubernetes-master:
    annotations:
      gui-x: '800'
      gui-y: '850'
    charm: cs:~containers/kubernetes-master-788
    constraints: cores=2 mem=4G root-disk=16G
    expose: true
    num_units: 1
    options:
      channel: 1.17/stable
    resources:
      cdk-addons: 0
      core: 0
      kube-apiserver: 0
      kube-controller-manager: 0
      kube-proxy: 0
      kube-scheduler: 0
      kubectl: 0
    to:
    - '0'
  kubernetes-worker:
    annotations:
      gui-x: '90'
      gui-y: '850'
    charm: cs:~containers/kubernetes-worker-623
    constraints: cores=4 mem=4G root-disk=16G
    expose: true
    num_units: 1
    options:
      channel: 1.17/stable
    resources:
      cni-amd64: 538
      cni-arm64: 529
      cni-s390x: 541
      core: 0
      kube-proxy: 0
      kubectl: 0
      kubelet: 0
    to:
    - '1'
relations:
- - kubernetes-master:kube-api-endpoint
  - kubernetes-worker:kube-api-endpoint
- - kubernetes-master:kube-control
  - kubernetes-worker:kube-control
- - kubernetes-master:certificates
  - easyrsa:client
- - kubernetes-master:etcd
  - etcd:db
- - kubernetes-worker:certificates
  - easyrsa:client
- - etcd:certificates
  - easyrsa:client
- - flannel:etcd
  - etcd:db
- - flannel:cni
  - kubernetes-master:cni
- - flannel:cni
  - kubernetes-worker:cni
- - containerd:containerd
  - kubernetes-worker:container-runtime
- - containerd:containerd
  - kubernetes-master:container-runtime

```

<h3 id="heading--kubernetes-bundles">Kubernetes bundles</h3>

A Kubernetes bundle differs from a standard bundle in the following ways:

- key 'bundle' is given the value of 'kubernetes'
- key 'num_units' is replaced by key 'scale'
- key 'to' is replaced by key 'placement'

The value of 'placement' is a key=value pair and is used as a Kubernetes node selector.

For example:

```text
bundle: kubernetes
applications:
  mariadb:
    charm: cs:~juju/mariadb-k8s
    scale: 2
    constraints: mem=1G
    options:
        dataset-size: 70%
    storage:
      database: mariadb-pv,20M
  gitlab:
    charm: cs:~juju/gitlab-k8s
    placement: foo=bar
    scale: 1
relations:
  - - gitlab:mysql
    - mariadb:server
```

<h2 id="heading--deploying-bundles">Deploying bundles</h2>

A bundle is deployed just like a regular charm is:

``` text
juju deploy wiki-simple
```

See the [Deploying applications](/t/deploying-applications/1062) page for details on the `deploy` command.

To get a summary of the deployment steps (without actually deploying) a dry run can be performed:

``` text
juju deploy --dry-run wiki-simple
```

[note]
The `--dry-run` option works only with bundles, not with regular charms.
[/note]

You can get the name of a bundle from the [Juju Charm Store](https://jujucharms.com/q/?type=bundle), just as you would a charm. There, you can see icons representing each separate application alongside the bundle's name. This gives you a quick overview of a bundle's complexity and potential resource requirements.

![Bundle resources in the Charm Store](https://assets.ubuntu.com/v1/053466a1-juju2_gui_bundles_store.png)

To get a bundle's name, select a bundle on the store and find the 'command prompt' icon at the top of the pane. A field will contain the Charm Store URL for the bundle, which you can also use to deploy:

``` text
juju deploy cs:bundle/wiki-simple-4
```

The `cs` signifies "charm store".

Bundles can also be deployed by referring to a local bundle file (if it exists). We'll see this in the [Creating bundles](#heading--creating-bundles) section.

<h2 id="heading--configuring-bundles">Configuring bundles</h2>

Below we present two ways in which existing bundles can be customised for your environment:

- Setting application constraints
- Setting application configuration options

<h3 id="heading--setting-application-constraints">Setting application constraints</h3>

To make a bundle as reusable as possible, it's common to set minimum constraints for its associated charms, much like you would when deploying charms from the command line. This is done by including a `constraints` field to a charm's definition.

For example, to add memory and CPU constraints to MySQL:

``` yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  constraints: mem=2G cores=4
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

Here we show how to co-locate applications along with constrained LXD containers on a single machine:

``` yaml
applications:
  wordpress:
    charm: "cs:wordpress-5"
    num_units: 1
    constraints: mem=1G cores=1
    annotations:
      "gui-x": "339.5"
      "gui-y": "-171"
    to: lxd:0
  mysql:
    charm: "cs:mysql-57"
    num_units: 1
    constraints: mem=2G cores=2
    annotations:
      "gui-x": "79.5"
      "gui-y": "-142"
    to: lxd:0
relations:
  - - "wordpress:db"
    - "mysql:db"
machines:
  "0":
    series: xenial
    constraints: "arch=amd64 mem=4G cores=4"
```

Refer to the [Using constraints](/t/using-constraints/1060) page for in-depth coverage of constraints.

<h3 id="heading--setting-application-configuration-options">Setting application configuration options</h3>

When deploying an application, the charm you use will often support or even require specific configuration options to be set. This is done by including an `options` field to the application.

For example, to set the "flavor" of MySQL to 'percona':

``` yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  options:
    flavor : percona
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

Values for options and annotations can also be read from a file. For binary files, such as binary certificates, there is an option to base64-encode the contents. A file location can be expressed with an absolute or relative (to the bundle file) path. For example:

``` yaml
applications:
  my-app:
    charm: some-charm
    options:
      config: include-file://my-config.yaml
      cert: include-base64://my-cert.crt
```

See section [Discovering application configuration options](/t/configuring-applications/1059#heading--discovering-application-configuration-options) to learn about a charm's options.

<h3 id="heading--using-YAML-anchors-and-aliases">Using YAML anchors and aliases</h3>

YAML *anchors* and *aliases* can be used to stipulate values for certain kinds of objects (usually charm options)  in a central place in a bundle file where they can then be referred to elsewhere in the file.

An anchor is a string prefixed with an ampersand (&) and an alias is the same string but prefixed with an asterisk (*). The object's value is set with the anchor and that value is manifested with the alias. For this to work, anchors must be set before the alias is parsed. For simplicity, just put all the anchors at the very top of the file under an element called `variables`. Here is an example:

```yaml
variables:
  openstack-origin:    &openstack-origin     cloud:bionic-stein
  osd-devices:         &osd-devices          /dev/sdb /dev/vdb
.
.
.
applications:
  ceph-osd:
    charm: cs:ceph-osd
    num_units: 3
    options:
      osd-devices: *osd-devices
      source: *openstack-origin
    to:
    - '1'
    - '2'
    - '3'
.
.
.
```

So in the above excerpt, the `options` section would effectively be treated as:

```yaml
    options:
      osd-devices: /dev/sdb /dev/vdb
      source: cloud:bionic-stein
```

<h2 id="heading--creating-bundles">Creating bundles</h2>

Bundles can continue to be modified to the point that you are effectively creating a new bundle. This section presents the following topics:

- Using local charms
- Overlay bundles
- Bundle placement directives
- Machine specifications in a bundle
- Recycling machines
- Binding endpoints within a bundle
- Bundles and charm resources
- Setting up subordinate charms

<h3 id="heading--using-local-charms">Using local charms</h3>

To integrate a local charm into a bundle a local bundle file, say `bundle.yaml`, will be needed and where the `charm` field points to the directory of the charm in question. Here is an example:

``` yaml
series: xenial
applications:
  mysql:
    charm: "/home/ubuntu/charms/mysql"
    num_units: 1
    constraints: mem=2G cores=4
```

The bundle can then be deployed by using the file as the argument instead of a bundle name:

``` text
juju deploy bundle.yaml
```

<h3 id="heading--overlay-bundles">
Overlay bundles
</h3>

Overlay bundles provide you with the ability to customise settings in an upstream bundle for your own needs. For example, you may wish to add extra applications, set custom machine constraints or modify the number of units being deployed. They are especially useful for keeping configuration local, while being able to make use of public bundles.

To add an overlay bundle to a deployment, use the `--overlay` option with the `juju deploy` command:

``` text
juju deploy wiki-simple \
  --overlay ~/custom-wiki.yaml
``` 

An overlay bundle is just a bundle. That is, it has the same YAML syntax as base bundles.

#### Relative paths

Relative paths are resolved relative to the path of the entity that describes them. That is, relative to the overlay bundle file itself. 

[note type=important status="Change in behaviour"]
Before Juju 2.7, relative paths within overlay bundles were resolved relative to the base bundle.
[/note]


#### Removing an application from a bundle

An application is removed from the base bundle by defining the application name in the application section, but omitting any values. Removing an application also removes all the relations for that application.

#### Replacing machines

If a machines section is specified in an overlay bundle it replaces the corresponding section of the base bundle. No merging of machine information is attempted. Multiple overlay bundles can be specified and they are processed in the order they appear on the command line.

#### Further reading

Tutorial [Using the aws-integrator charm](/t/using-the-aws-integrator-charm-tutorial/1192) provides an example of how an "overlay" is used.

<h3 id="heading--bundle-placement-directives">Bundle placement directives</h3>

You can co-locate applications by using the `to` key. When LXD is supported by the backing cloud it is also possible to isolate charms by including the container format in the placement directive.

For example:

``` yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  to: ["lxd:wordpress/0"]
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

This will install the MySQL application into a LXD container on the same machine as the 'wordpress/0' unit.

Alternatively, to install MySQL into a LXD container on machine '1', use the following syntax:

``` yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  to: ["lxd:1"]
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

<h3 id="heading--machine-specifications-in-a-bundle">Machine specifications in a bundle</h3>

Bundles may optionally include a machine specification, which allows you to set up specific machines and then to place application units on those machines however you wish. This is done by including a `machines` field at the root of the bundle file and then defining machines based on an integer. These machines are objects with three possible fields: `series`, `constraints`, and `annotations`. Finally, these machines are referred to in a charm's definition by using the placement key `to`. For example:

``` yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  to: 0
  annotations:
    "gui-x": "139"
    "gui-y": "168"
machines:
  "0":
    series: trusty
    constraints: arch=amd64 cores=1 mem=1740 root-disk=8192
```

This will install the MySQL application on machine '0', which has been assigned a specific series and a collection of constraints.

You may also specify multiple machines for placing multiple units of an application. For example:

``` yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 2
  to: 0, 1
  annotations:
    "gui-x": "139"
    "gui-y": "168"
machines:
  "0":
    series: trusty
    constraints: arch=amd64 cores=1 mem=1740 root-disk=8192
  "1":
    series: trusty
    constraints: arch=amd64 cores=4 mem=4096 root-disk=8192
```

This will install one unit of the MySQL application on machine '0' and the other on machine '1'.

<h3 id="heading--recycling-machines">Recycling machines</h3>

To have a bundle use a model's existing machines, as opposed to creating new machines, the `--map-machines=existing` option is used. In addition, to specify particular machines for the mapping, comma-separated values of the form 'bundle-id=existing-id' can be passed where the bundle-id and the existing-id refer to top level machine IDs.

For example, consider a bundle whose YAML file is configured with machines 1, 2, 3, and 4, and a model containing machines 1, 2, 3, 4, and 5. The following deployment would use existing machines 1 and 2 for bundle machines 1 and 2 but use existing machine 4 for bundle machine 3 and existing machine 5 for bundle machine 4:

``` text
juju deploy some-bundle --map-machines=existing,3=4,4=5
```

<h3 id="heading--binding-endpoints-within-a-bundle">Binding endpoints within a bundle</h3>

Generally, you can configure more complex networks using [Network spaces](/t/network-spaces/1157) and deploy charms with a binding, as described in [Deploying to spaces](/t/deploying-applications-advanced/1061#heading--deploying-to-network-spaces). However, the same can also be achieved with a bundle and is done by including a `bindings` field to a charm's definition. For example:

``` yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  bindings:
    shared-db: database
    cluster: internal
```

This is equivalent to:

``` text
juju deploy cs:mysql-57 --bind "shared-db=database cluster=internal"
```

The following connects application endpoints to specific spaces and includes a default space, `default-space`, for any interfaces not specified:

``` text
juju deploy --bind "default-space db=db-space db-admin=admin-space" mysql
```

Using a bundle file, the above deploy command can be mirrored with the following:

``` yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  bindings:
    "": default-space
    db: db-space
    db-admin: admin-space
```

It is not currently possible to declare a default space in the bundle for all endpoints. The workaround is to list all endpoints explicitly.

<h3 id="heading--bundles-and-charm-resources">Bundles and charm resources</h3>

Bundles support charm resources (see [Using resources](/t/using-resources-developer-guide/1127)) through the use of the `resources` key. Consider the following charm `metadata.yaml` file that includes a resource called `pictures`:

``` yaml
name: example-charm
summary: "example charm."
description: This is an example charm.
resources:
  pictures:
    type: file
    filename: pictures.zip
    description: "This charm needs pictures.zip to operate"
```

It might be desirable to use a specific resource revision in a bundle:

``` yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     pictures: 1
```

So here we specify a revision of '1' from the Charm Store.

The `resources` key can also specify a local path to a resource instead:

``` yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     pictures: "./pictures.zip"
```

Local resources can be useful in network restricted environments where the controller is unable to contact the Charm Store.

<h3 id="heading--bundles-and-charm-resources">Bundles and storage</h3>

A bundle can specify the storage directives used to satisfy a charm storage declaration. Exactly the same argument as used with `juju deploy` with `--storage` are supported.

For a charm with storage declaration in its `metadata.yaml` file:

```yaml
storage:
  database:
    type: filesystem
    location:/var/lib/mysql
  logs:
    type: filesystem
    location:/var/log/mysql
  cache:
    type: filesystem
```

A bundle might look like:

``` yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   storage:
     database: ebs,10G
     logs: rootfs,1G
     cache: tmpfs
```


<h3 id="heading--setting-up-subordinate-charms">Setting up subordinate charms</h3>

To set up a subordinate charm simply do not use the placement key `to` and do not specify any units with the `num_units` key. The vital part with a subordinate is to create the relation between it and the principle charm under the `relations` element.

<h2 id="heading--comparing-a-bundle-to-a-model">Comparing a bundle to a model</h2>

To compare a model's configuration to that of a bundle the `diff-bundle` command is used.

Consider, for example, a model that has the below output to the `status` command:

``` text
Model  Controller  Cloud/Region         Version  SLA          Timestamp
docs   lxd         localhost/localhost  2.5.0    unsupported  05:22:22Z

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
haproxy             unknown      1  haproxy    jujucharms   46  ubuntu  
mariadb    10.1.37  active       1  mariadb    jujucharms    7  ubuntu  
mediawiki  1.19.14  active       1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports   Message
haproxy/0*    unknown   idle   2        10.86.33.28     80/tcp  
mariadb/0*    active    idle   1        10.86.33.192            ready
mediawiki/0*  active    idle   0        10.86.33.19     80/tcp  Ready

Machine  State    DNS           Inst id        Series  AZ  Message
0        started  10.86.33.19   juju-dbf96b-0  trusty      Running
1        started  10.86.33.192  juju-dbf96b-1  trusty      Running
2        started  10.86.33.28   juju-dbf96b-2  bionic      Running

Relation provider  Requirer              Interface     Type     Message
haproxy:peer       haproxy:peer          haproxy-peer  peer     
mariadb:cluster    mariadb:cluster       mysql-ha      peer     
mariadb:db         mediawiki:db          mysql         regular  
mediawiki:website  haproxy:reverseproxy  http          regular
```

Now say we have a bundle file `bundle.yaml` with these contents:

``` yaml
applications:
  mediawiki:
    charm: "cs:mediawiki-5"
    num_units: 1
    options:
      name: Central library
  mysql:
    charm: "cs:mysql-55"
    num_units: 1
    options:
      "binlog-format": MIXED
      "block-size": 5
      "dataset-size": "512M"
      flavor: distro
      "ha-bindiface": eth0
      "ha-mcastport": 5411
      "max-connections": -1
      "preferred-storage-engine": InnoDB
      "query-cache-size": -1
      "query-cache-type": "OFF"
      "rbd-name": mysql1
      "tuning-level": safest
      vip_cidr: 24
      vip_iface: eth0
relations:
  - - "mediawiki:db"
    - "mysql:db"
```

Comparison of the currently active model with the bundle can be achieved in this way:

``` text
juju diff-bundle bundle.yaml
```

This produces an output of:

``` yaml
applications:
  haproxy:
    missing: bundle
  mariadb:
    missing: bundle
  mediawiki:
    charm:
      bundle: cs:mediawiki-5
      model: cs:mediawiki-19
    series:
      bundle: ""
      model: trusty
    options:
      name:
        bundle: Central library
        model: null
  mysql:
    missing: model
machines:
  "0":
    missing: bundle
  "1":
    missing: bundle
  "2":
    missing: bundle
relations:
  bundle-additions:
  - - mediawiki:db
    - mysql:db
  model-additions:
  - - haproxy:reverseproxy
    - mediawiki:website
  - - mariadb:db
    - mediawiki:db
```

This informs us of the differences in terms of applications, machines, and relations. For instance, compared to the model, the bundle is missing applications 'haproxy' and 'mariadb', whereas the model is missing 'mysql'. Both model and bundle utilise the 'mediawiki' application but they differ in terms of configuration. There are also differences being reported in the 'machines' and 'relations' sections. We'll now focus on the 'machines' section in order to demonstrate other features of the `diff-bundle` command.

We can extend the bundle by including a bundle overlay. Consider an overlay bundle file `changes.yaml` with these machine related contents:

``` yaml
applications:
  mediawiki:
    to: 2
  mysql:
    to: 3
machines:
  "2":
    series: trusty
    constraints: arch=amd64 cores=1
  "3":
    series: trusty
    constraints: arch=amd64 cores=1
```

Here, by means of the `--overlay` option, we can add this extra information to the comparison, effectively inflating the configuration of the bundle:

``` text
juju diff-bundle bundle.yaml --overlay changes.yaml
```

This changes the 'machines' section of the output to:

``` yaml
machines:
  "0":
    missing: bundle
  "1":
    missing: bundle
  "2":
    series:
      bundle: trusty
      model: bionic
  "3":
    missing: model
```

The initial comparison displayed a lack of all three machines in the bundle. By adding machines '2' and '3' in the overlay the output now shows machines '0' and '1' as missing in the bundle, machine '2' differs in configuration, and machine '3' is missing in the model.

As with the `deploy` command, there is the ability to map machines in the bundle to those in the model. Below, the addition of `--map-machines=2=0,3=1` makes, for the sake of the comparison, bundle machines 2 and 3 become model machines 0 and 1, respectively:

``` text
juju diff-bundle bundle.yaml --overlay changes.yaml --map-machines=2=0,3=1
```

The 'machines' section now becomes:

``` yaml
machines:
  "2":
    missing: bundle
```

The bundle shows as only missing machine 2 now, which makes sense.

The target bundle can also reside within the online Charm Store. In that case you would simply reference the bundle name, such as 'wiki-simple':

``` text
juju diff-bundle wiki-simple
```

<h2 id="heading--saving-a-bundle">Saving a bundle</h2>

If you have created your own bundle you will probably want to save it. This is done with the `export-bundle` command, which exports a single model configuration.

For example, to export the currently active model into file `mymodel.yaml`:

``` text
juju export-bundle --filename mymodel.yaml
```

You can also use the Juju GUI to save a bundle. See [Adding bundles with the GUI](/t/using-bundles-with-the-gui/1057#exporting-and-importing-bundles-with-the-GUI) for instructions.

Once the bundle is saved you can consider these [Next steps](/t/getting-started-with-charm-development/1118#heading--next-steps).

<!-- LINKS -->
