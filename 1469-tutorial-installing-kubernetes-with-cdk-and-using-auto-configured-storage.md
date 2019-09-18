*This is in connection to the topic of [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090). See that page for background information.*

This tutorial will demonstrate how to install the Charmed Distribution of Kubernetes (CDK) and take advantage of the auto-configuration of Kubernetes **dynamic** persistent volumes (PVs) for use with Kubernetes-specific charms. This is normally done when your backing cloud has a storage type that is supported natively by Kubernetes. Here, we'll build our cluster with Juju via the CDK bundle using AWS as a backing cloud. The cluster will then be added, as a cloud, to the Juju client's local cache, after which a controller will be created to manage it.

<h2 id="heading--prerequisites">Prerequisites</h2>

The following prerequisites are assumed as a starting point for this tutorial:

- You're using Ubuntu 18.04 LTS.
- Juju `v.2.6.1` is installed. See the [Installing Juju](/t/installing-juju/1164) page.
- A credential for the 'aws' cloud has been added to Juju. See the [Using Amazon AWS with Juju](/t/using-amazon-aws-with-juju/1084) page.
- Sufficient permissions are assigned to the above credential in order for 'aws-integrator' to perform operations (see [Permissions Requirements](https://github.com/juju-solutions/charm-aws-integrator#permissions-requirements); this tutorial assigns the IAM security policy of 'AdministratorAccess').

<h2 id="heading--installing-kubernetes">Installing Kubernetes</h2>

Begin by creating a controller. We’ll call it ‘aws’:

```text
juju bootstrap aws aws
```

We'll deploy Kubernetes using the '[canonical-kubernetes](https://jujucharms.com/canonical-kubernetes/)' bundle (CDK), which will give us a decently sized cluster. We'll add an integrator charm by means of an overlay bundle that we'll store in file `k8s-aws-overlay.yaml`:

```yaml
applications:
  aws-integrator:
    charm: cs:~containers/aws-integrator
    num_units: 1
relations:
  - ['aws-integrator', 'kubernetes-master']
  - ['aws-integrator', 'kubernetes-worker']
```

See [Overlay bundles](/t/charm-bundles/1058#heading--overlay-bundles) for details on overlays.

We can now deploy the cluster:

```text
juju deploy canonical-kubernetes --overlay k8s-aws-overlay.yaml
juju trust aws-integrator
```

The `trust` command grants 'aws-integrator' access to the credential used in the `bootstrap` command. This charm acts as a proxy for the Juju machines, acting as Kubernetes nodes, to create and attach dynamic storage volumes in the AWS backing cloud.

[note type=caution]
When a cluster is not built, but merely added, such as one originating from a public Kubernetes service like Azure's AKS or Google's GKE, then an integrator charm is not required. Ready-made clusters have storage built in.
[/note]

It will take about 20 minutes to arrive at a stable `status` command output:

```text
Model    Controller  Cloud/Region   Version  SLA          Timestamp
default  aws         aws/us-east-1  2.6-rc2  unsupported  20:07:50Z

App                    Version   Status  Scale  Charm                  Store       Rev  OS      Notes
aws-integrator         1.16.148  active      1  aws-integrator         jujucharms   10  ubuntu  
easyrsa                3.0.1     active      1  easyrsa                jujucharms  235  ubuntu  
etcd                   3.2.10    active      3  etcd                   jujucharms  415  ubuntu  
flannel                0.10.0    active      5  flannel                jujucharms  404  ubuntu  
kubeapi-load-balancer  1.14.0    active      1  kubeapi-load-balancer  jujucharms  628  ubuntu  exposed
kubernetes-master      1.14.1    active      2  kubernetes-master      jujucharms  654  ubuntu  
kubernetes-worker      1.14.1    active      3  kubernetes-worker      jujucharms  519  ubuntu  exposed

Unit                      Workload  Agent  Machine  Public address  Ports           Message
aws-integrator/0*         active    idle   0        52.91.184.172                   Ready
easyrsa/0*                active    idle   1        34.201.167.3                    Certificate Authority connected.
etcd/0                    active    idle   2        52.91.39.43     2379/tcp        Healthy with 3 known peers
etcd/1*                   active    idle   3        54.166.185.173  2379/tcp        Healthy with 3 known peers
etcd/2                    active    idle   4        3.94.148.234    2379/tcp        Healthy with 3 known peers
kubeapi-load-balancer/0*  active    idle   5        34.200.233.4    443/tcp         Loadbalancer ready.
kubernetes-master/0       active    idle   6        107.22.102.161  6443/tcp        Kubernetes master running.
  flannel/4               active    idle            107.22.102.161                  Flannel subnet 10.1.64.1/24
kubernetes-master/1*      active    idle   7        54.197.30.23    6443/tcp        Kubernetes master running.
  flannel/3               active    idle            54.197.30.23                    Flannel subnet 10.1.40.1/24
kubernetes-worker/0*      active    idle   8        3.84.152.194    80/tcp,443/tcp  Kubernetes worker running.
  flannel/0*              active    idle            3.84.152.194                    Flannel subnet 10.1.51.1/24
kubernetes-worker/1       active    idle   9        18.234.242.121  80/tcp,443/tcp  Kubernetes worker running.
  flannel/1               active    idle            18.234.242.121                  Flannel subnet 10.1.10.1/24
kubernetes-worker/2       active    idle   10       34.229.148.230  80/tcp,443/tcp  Kubernetes worker running.
  flannel/2               active    idle            34.229.148.230                  Flannel subnet 10.1.83.1/24

Machine  State    DNS             Inst id              Series  AZ          Message
0        started  52.91.184.172   i-06d8c42a33dd53f4c  bionic  us-east-1a  running
1        started  34.201.167.3    i-0ef15a160a8d6aea9  bionic  us-east-1b  running
2        started  52.91.39.43     i-0e97785dce4afad2e  bionic  us-east-1a  running
3        started  54.166.185.173  i-090c7af5f0b0235b7  bionic  us-east-1b  running
4        started  3.94.148.234    i-01a65ce6300b5bda7  bionic  us-east-1c  running
5        started  34.200.233.4    i-099bf4c44cab8200c  bionic  us-east-1c  running
6        started  107.22.102.161  i-0d2a5fbf55a93f94a  bionic  us-east-1b  running
7        started  54.197.30.23    i-05c97ea2ce5a50858  bionic  us-east-1a  running
8        started  3.84.152.194    i-0e6d4f997e0174e3b  bionic  us-east-1b  running
9        started  18.234.242.121  i-044654e51075296c8  bionic  us-east-1c  running
10       started  34.229.148.230  i-0144700b2ef3ebf43  bionic  us-east-1a  running
```

<h2 id="heading--adding-the-cluster-to-juju">Adding the cluster to Juju</h2>

We'll now copy over the cluster's main configuration file and then use the `add-k8s` command to add the cluster to the Juju client's list of known clouds. Here, we call the new cloud 'aws-cluster':

```text
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
juju add-k8s --local --region=ec2/us-east-1 aws-cluster
```

The first component of the value of the `--region` option is "cloud type" ('ec2') and its second component is the actual region ('us-east-1'). The latter was obtained from the output to `juju controllers`:

```text
Controller  Model       User   Access     Cloud/Region               Models  Nodes    HA  Version
aws         default     admin  superuser  aws/us-east-1                   2     12  none  2.6-rc2
```

The fact that the cluster was added without error indicates that the auto-configuration of storage was successful for both operator storage and workload storage. It would have failed if the `--region` option was omitted, as the inclusion of a cloud type and a region permits the AWS backing cloud to be queried.

The success of this operation can be confirmed by running `juju clouds --local`.

<h2 id="heading--creating-a-controller">Creating a controller</h2>

Since the cluster is now known to Juju as a cloud, a controller can be created to manage it. We'll call it 'k8s':

```text
juju bootstrap aws-cluster k8s
```

Now run the `clouds` command (within the context of the newly-created controller):

```text
juju clouds
```

Sample output:

```text
Clouds on controller "k8s":

Cloud         Regions  Default    Type  Description
aws-cluster         1  us-east-1  k8s
```

So the 'k8s' controller now manages the cluster that was built with the aid of the 'aws' controller. The name 'aws-cluster' was chosen (during the first invocation of `add-k8s`) in order to reflect this in the above output.

<h2 id="heading--adding-a-model">Adding a model</h2>

In contrast to non-Kubernetes controllers, there is no workload model automatically set up for us as part of the controller-creation process (i.e. model 'default'). Here, we create one called 'exciter':

```text
juju add-model exciter
```

The output to `juju models` should look like this:

```text
Controller: k8s

Model       Cloud/Region               Type        Status     Access  Last connection
controller  aws-cluster/us-east-1      kubernetes  available  admin   just now
exciter*    aws-cluster                kubernetes  available  admin   never connected
```

<h2 id="heading--deploying-kubernetes-charms">Deploying Kubernetes charms</h2>

We can now deploy a Kubernetes charm. We'll choose one that has storage requirements:

```text
juju deploy cs:~juju/mariadb-k8s --storage database=10M
```

Because dynamic storage was set up automatically when the cluster was added there is no need to specify a  storage pool. If we did, the value for the `--storage` option would have looked like `database=<pool-name>,10M`.

The output to `juju status` should soon look like the following:

```text
Model    Controller  Cloud/Region     Version  SLA          Timestamp
exciter  k8s         aws-cluster      2.6-rc2  unsupported  03:23:20Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address        Notes
mariadb-k8s           active      1  mariadb-k8s  jujucharms    1  kubernetes  10.152.183.58  

Unit            Workload  Agent  Address    Ports     Message
mariadb-k8s/0*  active    idle   10.1.83.7  3306/TCP
```

We can inspect the workload storage volume in use with the `storage` command:

```text
juju storage
```

Output:

```text
Unit           Storage id  Type        Pool        Size   Status    Message
mariadb-k8s/0  database/0  filesystem  kubernetes  35MiB  attached  Successfully provisioned volume pvc-4ac4...c590 using kubernetes.io/aws-ebs
```

We can see that storage class 'aws-ebs' was chosen during the storage auto-configuration process.

The model configuration options that are used to track storage class values corroborate this:

```text
juju model-config | grep -e Attribute -e storage
```

Output:

```text
Attribute                     From        Value
operator-storage              controller  aws-ebs
workload-storage              controller  aws-ebs
```


<h2 id="heading--next-steps">Next steps</h2>

Consider the following tutorials:

- [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193)
- [Using Juju with MicroK8s](/t/using-juju-with-microk8s-tutorial/1194)
- [Using the aws-integrator charm](/t/using-the-aws-integrator-charm-tutorial/1192)
- [Multi-cloud controller with GKE and auto-configured storage](/t/tutorial-multi-cloud-controller-with-gke-and-auto-configured-storage/1465)
