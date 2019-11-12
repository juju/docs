The goals of this tutorial are to expose the innards of Kubernetes charms, explain how they work and how to build them. Further reading suggestions are included at the end.

<h2 id="heading--prerequisites">Prerequisites</h2>

The following prerequisites are assumed as a starting point for this tutorial:

-   You have an [Ubuntu SSO account](https://login.ubuntu.com/).
-   You're using Ubuntu 18.04 LTS (Bionic).
-   Juju (`v.2.5.1` or later) is installed. See the [Installing Juju](/t/installing-juju/1164) page.
-   The Charm Tools (`v.2.5.2` or later) package is installed. See the [Charm Tools](/t/charm-tools/1180) page.
-   The system user is 'ubuntu'.

The SSO account is needed to interact with the [Charm Store](https://jujucharms.com). The example username used in this guide is 'jlarin'.

<h2 id="heading--install-supporting-software">Install supporting software</h2>

Besides Juju and Charm Tools, some supporting software will be necessary. There are `kubectl` and `Docker`. Install them in this way:

``` text
sudo snap install kubectl --classic
sudo snap install docker
```

Create system group 'docker' and add your user to it. We assume a user of 'ubuntu' here:

``` text
sudo addgroup --system docker
sudo adduser ubuntu docker
newgrp docker
```

Verify that Docker is working:

``` text
docker run hello-world
```

<h2 id="heading--charm-contents">Charm contents</h2>

The contents of the charm we'll build are based on an existing [MariaDB Kubernetes charm](https://github.com/wallyworld/caas/tree/master/charms/mariadb).

Begin by creating a work directory; initialising your new charm (named 'mariadb-k8s-test' here); and entering the resulting charm directory:

``` text
mkdir ~/work
cd ~/work
charm create mariadb-k8s-test
cd mariadb-k8s-test
```

This provides us with the needed files and directories for building the charm:

``` text
|
|── README.ex
├── config.yaml
├── icon.svg
├── layer.yaml
├── metadata.yaml
├── reactive
│   ├── mariadb_k8s_test.py
│   └── spec_template.yaml
└── tests
    ├── 00-setup
    └── 10-deploy
```

Replace the sample contents of the following files with the contents from the [MariaDB Kubernetes charm](https://github.com/wallyworld/caas/tree/master/charms/mariadb) charm:

-   `layer.yaml`
-   `config.yaml`
-   `metadata.yaml`
-   `reactive/spec_template.yaml`
-   `reactive/mariadb-k8s-test.py`

File `mariadb-k8s-test.py` corresponds to the original `mysql.py`, which is the file that contains the charm's logic.

Edit some fields in `metadata.yaml`. We have:

``` yaml
name: mariadb-k8s-test
summary: A learning k8s charm.
maintainer: Javier Larin <javierlarin72@gmail.com>
description: |
  This is a test k8s charm.
display-name: mariadb-k8s-test
tags:
  - database
  - kubernetes
subordinate: false
provides:
    server:
      interface: mysql
series:
   - kubernetes
resources:
  mysql_image:
    type: oci-image
    description: "Image used for mariadb pod."
storage:
  database:
    type: filesystem
    location: /var/lib/mysql 
```

File `layer.yaml` is where we import functionality via *layers*. Our file looks like this:

``` yaml
"includes":
- "layer:caas-base"
- "layer:docker-resource"
- "interface:juju-relation-mysql"
```

All layers are listed and described in the [Juju Charm Layers Index](https://github.com/juju/layer-index). For Kubernetes charms, the fundamental layers are 'caas-base' and 'docker-resource'.

File `config.yaml` is where application configuration settings are placed.

File `spec_template.yaml` is vital for getting pods created for Juju units. This is explained in detail later on.

Edit information file `README.ex` to provide guidance to users of the charm.

File `icon.svg` will be displayed in the Charm Store once the charm is put there.

Notes:

-   A Kubernetes charm can implement the same hooks that traditional charms can, and each hook, in turn, has at its disposal all traditional hook tools.
-   Charms, whether Kubernetes or traditional, are written using the [Reactive Framework](https://charmsreactive.readthedocs.io/en/latest/index.html).

<h3 id="heading--deployment-and-service-types">Deployment and service types</h3>

With `v.2.6.0` charms can specify a deployment type and a service type.

deployment type | default | Kubernetes documentation
---------------------------|------------|------------------------
stateless                  | X           | [DeploymentController][kubernetes-stateless]
stateful                    |               | [StatefulSet][kubernetes-stateful]

[kubernetes-stateless]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment
[kubernetes-stateful]: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset

A charm with storage requirements needs a deployment type of 'stateful'. However, a charm can be 'stateful' without requiring storage.

service type | default | Kubernetes documentation
---------------------------|------------|------------------------
cluster                     | X            | [ClusterIP][kubernetes-cluster]
loadbalancer         |                | [LoadBalancer][kubernetes-loadbalancer]
external                  |                | [ExternalName][kubernetes-external]

[kubernetes-cluster]: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
[kubernetes-loadbalancer]: https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer
[kubernetes-external]: https://kubernetes.io/docs/concepts/services-networking/service/#externalname

The service type can be overridden at deploy time with the `kubernetes-service-type` option.

Charm metadata syntax looks like this:

```yaml
deployment:
  type: stateless | stateful
  service: cluster | loadbalancer | external
```

<h3 id="heading--container-images">Container images</h3>

A Kubernetes charm requires a Docker container image. It states this requirement by including a resource of type 'oci-image' in `mariadb-k8s-test/metadata.yaml`:

``` yaml
resources:
  mysql_image:
    type: oci-image
    description: Image used for mariadb pod.
```


The resource name of 'mysql_image' is referenced in file `mariadb-k8s-test/reactive/mariadb-k8s-test.py`.

The charm is published as a tuple of charm revision and resource version. This allows a charm and an image to be published with a known-working configuration.

[note]
OCI is an abbreviation for Open Container Initiative. It is not to be confused with Oracle's public cloud (Oracle Cloud Infrastructure).
[/note]

Get a Docker container image for mariadb. We're going to use it as the OCI resource:

``` text
docker pull mariadb
```

View your list of Docker images:

``` text
docker image list
```

Sample output:

``` text
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE                                                          
mariadb             latest              230ef4d856a3        6 days ago          368MB
Hello-world         latest              fce289e99eb9        8 weeks ago         1.84kB
```

<h2 id="heading--build-the-charm">Build the charm</h2>

Set up a build directory, ensure you're in the work directory, and then build the charm using the Charm Tools `build` sub-command:

``` text
export CHARM_BUILD_DIR=$HOME/build
mkdir $CHARM_BUILD_DIR
cd ~/work/mariadb-k8s-test
charm build .
```

Sample output:

``` text
build: Destination charm directory: /home/ubuntu/build/mariadb-k8s-test
build: Processing layer: layer:options                                     
build: Processing layer: layer:caas-base            
build: Processing layer: layer:status   
build: Processing layer: layer:docker-resource                          
build: Processing layer: mariadb-k8s-test (from .)                       
build: Processing interface: mysql                                                                                    
proof: W: Includes template README.ex file
proof: W: README.ex includes boilerplate: Step by step instructions on using the charm:
proof: W: README.ex includes boilerplate: You can then browse to http://ip-address to configure the service.
proof: W: README.ex includes boilerplate: - Upstream mailing list or contact information
proof: W: README.ex includes boilerplate: - Feel free to add things if it's useful for users
```

[note]
Set variable CHARM_BUILD_DIR permanently by editing your shell's initialisation file (e.g. `~/.bashrc` for Bash).
[/note]

You can perform static analysis on the built charm by entering the charm's build directory and using the Charm Tools `proof` sub-command:

``` text
cd $CHARM_BUILD_DIR/mariadb-k8s-test
charm proof .
```

Sample output:

``` text
I: Includes template README.ex file                                                                                                           
W: README.ex includes boilerplate: Step by step instructions on using the charm:
W: README.ex includes boilerplate: You can then browse to http://ip-address to configure the service.
W: README.ex includes boilerplate: - Upstream mailing list or contact information
W: README.ex includes boilerplate: - Feel free to add things if it's useful for users
```

<h3 id="heading--how-pod-configuration-works">How pod configuration works</h3>

Juju sets up a single Kubernetes (operator) pod for the application as a whole and a pod per application unit.

For the operator pod, Juju uses a static [Docker image](https://hub.docker.com/r/jujusolutions/caas-jujud-operator) that includes all the necessary reactive and charm helper libraries.

For the unit pods, Juju must determine what configuration to send to the cluster. This configuration varies; it depends on the charm being deployed. Here is a summary of how this works:

1.  The charm retrieves the application's configuration settings from Juju.

2.  The charm ships with a pod configuration template and populates it with the above settings.

3.  The charm sends to Juju the finalised pod configuration.

4.  Juju sends the final configuration to the cluster.

5.  The cluster creates the required number of pods.

This is explained in more detail in the next section.

<h4 id="heading--unit-pod-configuration-details">Unit pod configuration details</h4>

The filenames mentioned in this section are for demonstrative purposes only. They are based on the 'mariadb-k8s-test' test charm built earlier.

The `config-get` hook tool retrieve the application's configuration settings from Juju. This is found within `mariadb-k8s-test/lib/charmhelpers/core/hookenv.py`:

``` python
def config(scope=None):
    global _cache_config
    config_cmd_line = ['config-get', '--all', '--format=json']
...
```

These local settings get put into a pod configuration template found at `mariadb-k8s-test/reactive/spec_template.yaml`:

``` yaml
containers:
  - name: %(name)s
    imageDetails:
      imagePath: %(docker_image_path)s
      username: %(docker_image_username)s
      password: %(docker_image_password)s
    ports:
    - containerPort: %(port)s
      protocol: TCP
    config:
      MYSQL_ROOT_PASSWORD: %(root_password)s
      MYSQL_USER: %(user)s
      MYSQL_PASSWORD: %(password)s
      MYSQL_DATABASE: %(database)s
    files:
      - name: configurations
        mountPath: /etc/mysql/conf.d
        files:
          custom_mysql.cnf: |
            [mysqld]
            skip-host-cache
            skip-name-resolve          

            query_cache_limit = 1M
            query_cache_size = %(query-cache-size)s
            query_cache_type = %(query-cache-type)s
```

The `pod_spec_set()` function sends the pod configuration to Juju. This is located within `mariadb-k8s-test/reactive/mariadb-k8s-test.py`:

``` python
def config_mariadb():
    status_set('maintenance', 'Configuring mysql container')

    spec = make_pod_spec()
    log('set pod spec:\n{}'.format(spec))
    layer.caas_base.pod_spec_set(spec)

    set_flag('mysql.configured')
...
```

Using this final configuration, Juju creates a Kubernetes pod for each application unit.

[details=Unit pod configuration settings]

Charms can specify many pod attributes. The following example (updated to Juju `v.2.6.0`) of a charm pod spec is representative but not complete (e.g. not all security context attributes are shown).

```yaml
activeDeadlineSeconds: 10
serviceAccountName: serviceAccount
restartPolicy: OnFailure
terminationGracePeriodSeconds: 20
automountServiceAccountToken: true
securityContext:
  runAsNonRoot: true
  supplementalGroups: [1,2]
hostname: host
subdomain: sub
priorityClassName: top
priority: 30
dnsPolicy: ClusterFirstWithHostNet
dnsConfig: 
  nameservers: [ns1, ns2]
readinessGates:
  - conditionType: PodScheduled
containers:
  - name: gitlab
    image: gitlab/latest
    imagePullPolicy: Always
    command: ["sh", "-c"]
    args: ["doIt", "--debug"]
    workingDir: "/path/to/here"
    ports:
    - containerPort: 80
      name: fred
      protocol: TCP
    - containerPort: 443
      name: mary
    securityContext:
      runAsNonRoot: true
      privileged: true
    livenessProbe:
      initialDelaySeconds: 10
      httpGet:
        path: /ping
        port: 8080
    readinessProbe:
      initialDelaySeconds: 10
      httpGet:
        path: /pingReady
        port: www
    config:
      attr: foo=bar; name['fred']='blogs';
      foo: bar
      restricted: 'yes'
      switch: on
    files:
      - name: configuration
        mountPath: /var/lib/foo
        files:
          file1: |
            [config]
            foo: bar
  - name: gitlab-helper
    image: gitlab-helper/latest
    ports:
    - containerPort: 8080
      protocol: TCP
  - name: secret-image-user
    imageDetails:
        imagePath: staging.registry.org/testing/testing-image@sha256:deed-beef
        username: docker-registry
        password: hunter2
  - name: just-image-details
    imageDetails:
        imagePath: testing/no-secrets-needed@sha256:deed-beef
initContainers:
  - name: gitlab-init
    image: gitlab-init/latest
    imagePullPolicy: Always
    command: ["sh", "-c"]
    args: ["doIt", "--debug"]
    workingDir: "/path/to/here"
    ports:
    - containerPort: 80
      name: fred
      protocol: TCP
    - containerPort: 443
      name: mary
    config:
      foo: bar
      restricted: 'yes'
      switch: on
service:
  annotations:
    foo: bar
customResourceDefinitions:
  tfjobs.kubeflow.org:
    group: kubeflow.org
    version: v1alpha2
    scope: Namespaced
    names:
      plural: "tfjobs"
      singular: "tfjob"
      kind: TFJob
    validation:
      openAPIV3Schema:
        properties:
          tfReplicaSpecs:
            properties:
              Worker:
                properties:
                  replicas:
                    type: integer
                    minimum: 1
              PS:
                properties:
                  replicas:
                    type: integer
                    minimum: 1
              Chief:
                properties:
                  replicas:
                    type: integer
                    minimum: 1
                    maximum: 1
```

[/details]

<h4 id="heading--unit-pod-configmaps">Unit pod ConfigMaps</h4>

A Kubernetes [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) "allows you to decouple configuration artifacts from image content to keep containerized applications portable".

A ConfigMap is set up within the final pod configuration file by specifying a file set that is mounted within the Docker image. Juju internally creates a "config-map" volume source to do that. Its name is based on the charm name, the fileset name, and the string '-config': `<appname>-<filesetname>-config`

For instance, the 'myapp' charm may produce a pod configuration file containing:

``` yaml
    files:
      - name: foocfg
        mountPath: /var/lib/foo
        files:
          file1: |
            [config]
            foo: bar
```

This would yield a config map called `myapp-foocfg-config` created to back the volume mounted into the pod.

<h2 id="heading--charm-store">Charm Store</h2>

Push the built charm to the Charm Store:

``` text
cd $CHARM_BUILD_DIR/mariadb-k8s-test
charm push .
```

You will be prompted to authenticate with the store by following a URL.

Relevant output:

``` text
url: cs:~jlarin/mariadb-k8s-test-1
channel: unpublished
```

Now attach the previously downloaded Docker image 'mariadb' to the charm by referring to the resource name 'mysql_image', as specified in `metadata.yaml`:

``` text
charm attach cs:~jlarin/mariadb-k8s-test-1 mysql_image=mariadb
```

The push and attach steps can also be done in a single step:

``` text
charm push . --resource mysql_image=mariadb
```

Sample output:

``` text
url: cs:~jlarin/mariadb-k8s-test-1
channel: unpublished
The push refers to repository [registry.jujucharms.com/jlarin/mariadb-k8s-test/mysql_image]
f7a047af7156: Pushed 
c695619416f6: Pushed 
40d3e1b3d6b8: Pushed 
b9241d7750f0: Pushed 
485b98d9f143: Pushed 
c4ffbd4d9738: Pushed 
1daa8b28cc39: Pushed 
3e11ee88dc26: Pushed 
da56250be694: Pushed 
c891a91d9209: Pushed 
4b7d93055d87: Pushed 
663e8522d78b: Pushed 
283fb404ea94: Pushed 
bebe7ce6215a: Pushed 
latest: digest: sha256:91a8dadf82129b2f3f7ff63bc40554b91ac44981afea66ea6669c5dd1c658862 size: 3240
Uploaded "mariadb" as mysql_image-0
```

Publish the new charm:image configuration:

``` text
charm release cs:~jlarin/mariadb-k8s-test-1 --resource mysql_image-0                      
```

Sample output:

``` text
url: cs:~jlarin/mariadb-k8s-test-1
channel: stable
warning: bugs-url and homepage are not set.  See set command.
```

Above, the resource received a numbered version by appending '0' to the resource name of 'mysql_image'.

The syntax for deploying this particular charm is:

``` text
juju deploy cs:~jlarin/mariadb-k8s-test-1 --storage database=k8s-pool,10M
```

This assumes that operator storage and workload storage are available and that the Juju storage pool is called 'k8s-pool'.

<h3 id="heading--local-charms">Local charms</h3>

To deploy a local charm with a public image use a Docker repository path URL as resource value:

```text
juju deploy /path/to/mariadb-k8s-local --resource mysql_image=mariadb:latest
```

For private images, a definition YAML file will first need to be set up:

```yaml
registrypath: image-path
username: me
password: secret
```

The resource value then becomes the path to that file:

```text
juju deploy /path/to/mariadb-k8s-local --resource mysql_image=/path/to/imagedef.yaml
```

<h2 id="heading--next-steps">Next steps</h2>

Based on the material covered in this tutorial, we suggest the following for further reading:

-   [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090)

Also consider the following tutorials:

-   [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193)
-   [Using the aws-integrator charm](/t/using-the-aws-integrator-charm-tutorial/1192)
-   [Using Juju with MicroK8s](/t/using-juju-with-microk8s-tutorial/1194)
