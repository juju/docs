(hello-world)=
# Hello, World

<div data-theme-toc="true"> </div>

This section will guide you through the process of initialising an empty Charm template (which defaults to creating a Kubernetes charm), and explain the purpose of each file.

<h2 id="heading--initialisation">Initialisation</h2>

The Charmcraft tool is used throughout the Charm development process, from initialising early directory structure to publishing your finished Charm to [Charmhub](https://charmhub.io).

To get started, first ensure that you have an appropriate [Development Environment](https://discourse.charmhub.io/t/development-setup/4450) for a Charmed Operator, then create a new Charm named `hello-operator`, generating the template in its own directory:

```bash
# Create the Charm directory
$ mkdir hello-operator; cd hello-operator
# Initialise the Charm directory
$ charmcraft init
```

This will create a skeleton directory structure, described below:

```bash
# Documentation
├── README.md            # The front page documentation for your charm
├── LICENSE              # Your Charm's license (we recommend Apache 2)
# Charm specification and requirements
├── metadata.yaml        # Charmed Operator package description and metadata
├── requirements.txt     # PyPI requirements for the charm runtime environment
# Runtime features
├── config.yaml          # Configuration schema for your operator
├── actions.yaml         # Day 2 action declarations, e.g. backup, restore
# Development files
├── requirements-dev.txt # PyPI requirements for development environment
├── run_tests            # Bash script to run Charm tests
# Charm code and tests
├── src                  # Top-level source code directory for Charm
│ └── charm.py           # Minimal operator using Charmed Operator Framework
└── tests # Top-level directory for Charm tests
├── __init__.py
└── test_charm.py        # Skeleton unit tests for generated charm
```

The `metadata.yaml` file is critical, and has a [detailed spec](https://juju.is/docs/sdk/metadata-reference) that enables you to specify where your Charm should run, how it communicates with other Charms using relations, and any Resources it depends on. We’ll cover these concepts in greater detail later in the docs.

In most Charms, the majority of the operator code is likely to live in `src/charm.py`, and it is the default entrypoint for the Charm.

<h2 id="heading--deploy">Deploy the charm</h2>

Before completing this section, ensure you've bootstrapped a Juju controller as described in the [Development Setup](https://juju.is/docs/sdk/dev-setup) section.

We can now build and deploy our (very minimal!) Charm. Before we do that, let’s configure the Juju model to display `DEBUG` level log messages and watch the output. Open another terminal and run the following:

```bash
# Set the default log level to DEBUG
$ juju model-config logging-config="<root>=WARNING;unit=DEBUG"
# Tail the Juju log
$ juju debug-log
```

Now, back to our original terminal:

```bash
# Build the Charm package (outputs ./hello-operator.charm)
$ charmcraft pack
# Deploy the packaged Charm
$ juju deploy ./hello-operator.charm --resource httpbin-image=kennethreitz/httpbin
# Watch the Juju status to see the Charm's progress
$ watch -c juju status --color
```

```{note}

We have to specify the `httpbin-image` resource to tell Juju which OCI image to deploy for the default container in the template. When your charms are published, this is no longer necessary because the OCI image resource is attached to the charm when you release it. Read more in [Publishing](https://juju.is/docs/sdk/publishing) and [Resources](https://juju.is/docs/sdk/resources).

```

The deployment will take about 30 seconds, and you should see the various operator events being triggered in the `juju debug-log` output. If all goes well, you should see output similar to the following from `watch -c juju status --color`:

```bash
Model        Controller  Cloud/Region        Version  SLA          Timestamp
development  micro       microk8s/localhost  2.9.0    unsupported  10:25:35+01:00

App             Version  Status  Scale  Charm           Store  Channel  Rev  OS          Address  Message
hello-operator           active      1  hello-operator  local             0  kubernetes           

Unit               Workload  Agent  Address       Ports  Message
hello-operator/0*  active    idle   10.1.215.218                
```

Note that you can inspect the content of your Charm easily - the bundle is just a zip file! Go ahead and open up `hello-operator.charm` in your native archive viewer to see how the Charm gets packaged up.

Now the charm is deployed, you should be able to browse to the Pod IP (if you're using MicroK8s) and see the [httpbin](https://httpbin.org) user interface. You can confirm it's working with:

```bash
# curl the pod ip (using the example above)
$ curl 10.1.215.218
```

<h2 id="heading--cleanup">Cleaning Up</h2>

Now you’ve deployed your charm, you might want to clear up your cluster and remove what we’ve done. You have a few options:

```bash
# ⚠ Destroy the model, removing the application and machines with it
$ juju destroy-model --force --no-wait development
# ⚠ Destroy the controller, and also any associated models and deployed applications
# ⚠ Note that you will need to bootstrap again before using Juju on the cluster
$ juju kill-controller -y -t0 micro
```