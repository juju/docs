(write-your-first-kubernetes-charm-for-a-flask-app)=
# Write your first Kubernetes charm for a Flask app

Imagine you have a Flask application backed up by a database such as PostgreSQL and need to deploy it. In a traditional setup, this can be quite a challenge, but with Juju you’ll find yourself deploying, configuring, scaling, integrating, monitoring, etc., your Flask application in no time. Let’s get started!

In this tutorial we will build a rock and Kubernetes charm for a Flask application using the charm SDK, so we can have a Flask application up and running with Juju in about 90 minutes.

```{note}


:open_book: **rock** <br>An Ubuntu LTS-based OCI compatible container image designed to meet security, stability, and reliability requirements for cloud-native software.

:open_book: **charm** <br>

A package consisting of YAML files + Python code that will automate every aspect of an application's lifecycle so it can be easily orchestrated with Juju.

:open_book: **Juju** <br>An orchestration engine for software operators that enables the deployment, integration and lifecycle management of applications using charms.

```

**What you’ll need:**

- A workstation, e.g., a laptop, with amd64 or arm64 architecture which has sufficient resources to launch a virtual machine with 4 CPUs, 4 GB RAM, and a 50 GB disk
- Familiarity with Linux

**What you’ll do:**

- [Set things up](#heading--set-things-up)
- [Create the Flask application](#heading--create-the-flask-application)
- [Run the Flask application locally](#heading--run-the-flask-application-locally)
- [Pack the Flask application into a rock](#heading--pack-the-flask-application-into-a-rock)
- [Create the charm](#heading--create-the-charm)
- [Deploy the Flask application](#heading--deploy-the-flask-application)
- [Enable `juju config flask-hello-world greeting=<greeting>`](#heading--enable-juju-config-flask-hello-world-greetinggreeting)
- [Integrate with a database](#heading--integrate-with-a-database)
- [Expose the app using ingress](#heading--expose-the-app-using-ingress)
- [Clean up environment](#heading--clean-up-environment)

```{note}

Don't hesitate to get in touch on [Matrix](https://matrix.to/#/#12-factor-charms:ubuntu.com) or [Discourse](https://discourse.charmhub.io/) (or follow the "Help improve this document in the forum" on the bottom of this doc to comment directly on the doc).

```


<a href="#heading--set-things-up"><h2 id="heading--set-things-up">Set things up</h2></a>

Install Multipass.

> See more: [Multipass | How to install Multipass](https://multipass.run/docs/install-multipass)

Use Multipass to launch an Ubuntu VM with the name `charm-dev` from the 24.04 blueprint:

```bash
multipass launch --cpus 4 --disk 50G --memory 4G --name charm-dev 24.04
```

Once the VM is up, open a shell into it:

```bash
multipass shell charm-dev
```

In order to create the rock, you'll need to install Rockcraft:

```bash
sudo snap install rockcraft --classic
```

`LXD` will be required for building the rock. Make sure it is installed and initialised:

```bash
sudo snap install lxd
lxd init --auto
```

In order to create the charm, you'll need to install Charmcraft:

```bash
sudo snap install charmcraft --channel latest/edge --classic
```

```{note}

This tutorial requires version `3.0.0` or later of Charmcraft. Check the version of Charmcraft using `charmcraft --version` If you have an older version of Charmcraft installed, use `sudo snap refresh charmcraft --channel latest/edge` to get the latest edge version of Charmcraft.

```

MicroK8s is required to deploy the Flask application on Kubernetes. Install MicroK8s:

```bash
sudo snap install microk8s --channel 1.31-strict/stable
sudo adduser $USER snap_microk8s
newgrp snap_microk8s
```

Wait for MicroK8s to be ready using `sudo microk8s status --wait-ready`. Several MicroK8s add-ons are required for deployment:

```bash
sudo microk8s enable hostpath-storage
# Required to host the OCI image of the Flask application
sudo microk8s enable registry
# Required to expose the Flask application
sudo microk8s enable ingress
```

Juju is required to deploy the Flask application. Install Juju and bootstrap a development controller:

```bash
sudo snap install juju --channel 3.5/stable
mkdir -p ~/.local/share
juju bootstrap microk8s dev-controller
```

Finally, create a new directory for this tutorial and go inside it:

```bash
mkdir flask-hello-world
cd flask-hello-world
```

<a href="#heading--create-the-flask-application"><h2 id="heading--create-the-flask-application">Create the Flask application</h2></a>

Start by creating the "Hello, world" Flask application that will be used for this tutorial.

Create a `requirements.txt` file, copy the following text into it and then save it:

```
Flask
```

In the same directory, copy and save the following into a text file called `app.py`:

```python
import flask

app = flask.Flask(__name__)

@app.route("/")
def index():
    return "Hello, world!\n"

if __name__ == "__main__":
    app.run()
```

<a href="#heading--run-the-flask-application-locally"><h2 id="heading--run-the-flask-application-locally">Run the Flask application locally</h2></a>

Install `python3-venv` and create a virtual environment:

```bash
sudo apt-get update && sudo apt-get install python3-venv -y
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Now that we have a virtual environment with all the dependencies, let's run the Flask application to verify that it works:

```bash
flask run -p 8000 
```

Test the Flask application by using `curl` to send a request to the root endpoint. You may need a new terminal for this; if you are using Multipass use `multipass shell charm-dev` to get another terminal:

```bash
curl localhost:8000
```

The Flask application should respond with `Hello, world!`. The Flask application looks good, so we can stop for now using  <kbd>Ctrl</kbd> + <kbd>c</kbd>.

<a href="#heading--pack-the-flask-application-into-a-rock"><h2 id="heading--pack-the-flask-application-into-a-rock">Pack the Flask application into a rock</h2></a>

First, we'll need a `rockcraft.yaml` file. Rockcraft will automate its creation and tailoring for a Flask application by using the `flask-framework` profile:

```bash
rockcraft init --profile flask-framework
```

The `rockcraft.yaml` file will automatically be created and set the name based on your working directory. Open the file in a text editor and check that the `name` is `flask-hello-world`. Ensure that `platforms` includes the architecture of your host. For example, if your host uses the ARM architecture, include `arm64` in `platforms`.

```{note}

For this tutorial, we'll use the `name` "flask-hello-world" and assume you are on the `amd64` platform. Check the architecture of your system using `dpkg --print-architecture`. Choosing a different name or running on a different platform will influence the names of the files generated by Rockcraft.

```

Pack the rock:

```bash
rockcraft pack
```

```{note}

Depending on your system and network, this step can take a couple of minutes to finish.

```

Once Rockcraft has finished packing the Flask rock, you'll find a new file in your working directory with the `.rock` extension:

```bash
ls *.rock -l
```

```{note}

If you changed the `name` or `version` in `rockcraft.yaml` or are not on an `amd64` platform, the name of the `.rock` file will be different for you.

```

The rock needs to be copied to the Microk8s registry so that it can be deployed in the Kubernetes cluster:

```bash
rockcraft.skopeo --insecure-policy copy --dest-tls-verify=false \
   oci-archive:flask-hello-world_0.1_amd64.rock \
   docker://localhost:32000/flask-hello-world:0.1
```

> See more: [skopeo^](https://manpages.ubuntu.com/manpages/jammy/man1/skopeo.1.html)

<a href="#heading--create-the-charm"><h2 id="heading--create-the-charm">Create the charm</h2></a>

Create a new directory for the charm and go inside it:

```bash
mkdir charm
cd charm
```

We'll need a `charmcraft.yaml`, `requirements.txt` and source code for the charm. The source code contains the logic required to operate the Flask application. Charmcraft will automate the creation of these files by using the `flask-framework` profile:

```bash
charmcraft init --profile flask-framework --name flask-hello-world
```

The files will automatically be created in your working directory. Pack the charm:

```bash
charmcraft pack
```

```{note}

Depending on your system and network, this step can take a couple of minutes to finish.

```

Once Charmcraft has finished packing the charm, you'll find a new file in your working directory with the `.charm` extension:

```bash
ls *.charm -l
```

```{note}

If you changed the name in charmcraft.yaml or are not on the amd64 platform, the name of the `.charm` file will be different for you.

```

<a href="#heading--deploy-the-flask-application"><h2 id="heading--deploy-the-flask-application">Deploy the Flask application</h2></a>

A Juju model is needed to deploy the application. Let's create a new model:

```bash
juju add-model flask-hello-world
```

```{note}

If you are not on a host with the amd64 architecture, you will need to include a constraint to the Juju model to specify your architecture. For example, for the arm64 architecture, use `juju set-model-constraints -m flask-hello-world arch=arm64`. Check the architecture of your system using `dpkg --print-architecture`.

```

Now the Flask application can be deployed using {ref}`Juju <juju-documentation>`:

```bash
juju deploy ./flask-hello-world_ubuntu-22.04-amd64.charm \
   flask-hello-world --resource \
   flask-app-image=localhost:32000/flask-hello-world:0.1
```

```{note}

It will take a few minutes to deploy the Flask application. You can monitor the progress using `juju status --watch 5s`. Once the status of the App has gone to `active`, you can stop watching using <kbd>ctrl</kbd> + <kbd>c</kbd>.

> See more: {ref}`Command 'juju status' <command-juju-status>`

```

The Flask application should now be running. We can monitor the status of the deployment using `juju status` which should be similar to the following output:

```
Model              Controller      Cloud/Region        Version  SLA          Timestamp
flask-hello-world  dev-controller  microk8s/localhost  3.1.8    unsupported  17:04:11+10:00

App           Version  Status  Scale  Charm              Channel  Rev  Address         Exposed  Message
flask-hello-world      active      1  flask-hello-world             0  10.152.183.166  no       

Unit             Workload  Agent  Address      Ports  Message
flask-hello-world/0*  active    idle   10.1.87.213
```

The deployment is finished when the status shows `active`. Let's expose the application using ingress. Deploy the `nginx-ingress-integrator` charm and integrate it with the Flask app:

```bash
juju deploy nginx-ingress-integrator --channel=latest/edge
juju integrate nginx-ingress-integrator flask-hello-world
```

The hostname of the app needs to be defined so that it is accessible via the ingress. We will also set the default route to be the root endpoint:

```bash
juju config nginx-ingress-integrator \
   service-hostname=flask-hello-world path-routes=/
```

Monitor `juju status` until everything has a status of `active`. Test the deployment using `curl http://flask-hello-world --resolve flask-hello-world:80:127.0.0.1` to send a request via the ingress to the root endpoint. It should still be returning the `Hello, world!` greeting.

```{note}

The `--resolve flask-hello-world:80:127.0.0.1` option to the `curl` command is a way of resolving the hostname of the request without setting a DNS record.

```

<a href="#heading--enable-juju-config-flask-hello-world-greetinggreeting"><h2 id="heading--enable-juju-config-flask-hello-world-greetinggreeting">Configure the Flask application</h2></a>

Now let's customise the greeting using a configuration option. We will expect this configuration option to be available in the Flask app configuration under the keyword `GREETING`. Go back out to the root directory of the project using `cd ..` and copy the following code into `app.py`:

```python
import flask

app = flask.Flask(__name__)
app.config.from_prefixed_env()


@app.route("/")
def index():
    greeting = app.config.get("GREETING", "Hello, world!")
    return f"{greeting}\n"


if __name__ == "__main__":
    app.run()
```

Open `rockcraft.yaml` and update the version to `0.2`. Run `rockcraft pack` again, then upload the new OCI image to the MicroK8s registry:

```bash
rockcraft.skopeo --insecure-policy copy --dest-tls-verify=false \
   oci-archive:flask-hello-world_0.2_amd64.rock \
   docker://localhost:32000/flask-hello-world:0.2
```

Change back into the charm directory using `cd charm`. The `flask-framework` Charmcraft extension supports adding configurations to `charmcraft.yaml` which will be passed as environment variables to the Flask application. Add the following to the end of the `charmcraft.yaml` file:

```yaml
config:
  options:
    greeting:
      description: |
        The greeting to be returned by the Flask application.
      default: "Hello, world!"
      type: string
```

```{note}

Configuration options are automatically capitalised and `-` are replaced by `_`. A `FLASK_` prefix will also be added which will let Flask identify which environment variables to include when running `app.config.from_prefixed_env()` in `app.py`.

```

Run `charmcraft pack` again. The deployment can now be refreshed to make use of the new code:

```bash
juju refresh flask-hello-world \
   --path=./flask-hello-world_ubuntu-22.04-amd64.charm \
   --resource flask-app-image=localhost:32000/flask-hello-world:0.2
```

```{note}

For the refresh command, the `--constraints` option is not required if you are not running on an `amd64` host as Juju will remember the constraint for the life of the application deployment.

```

Wait for `juju status` to show that the App is `active` again. Verify that the new configuration has been added using `juju config flask-hello-world | grep -A 6 greeting:` which should show the configuration option.

```{note}

The `grep` command extracts a portion of the configuration to make it easier to check whether the configuration option has been added.

```

Using `curl http://flask-hello-world --resolve flask-hello-world:80:127.0.0.1` shows that the response is still `Hello, world!` as expected. The greeting can be changed using Juju:

```bash
juju config flask-hello-world greeting='Hi!'
```

`curl http://flask-hello-world --resolve flask-hello-world:80:127.0.0.1` now returns the updated `Hi!` greeting.

```{note}

It might take a short time for the configuration to take effect.

```

<a href="#heading--integrate-with-a-database"><h2 id="heading--integrate-with-a-database">Integrate with a database</h2></a>

Now let's keep track of how many visitors your application has received. This will require integration with a database to keep the visitor count. This will require a few changes:

* We will need to create a database migration that creates the `visitors` table
* We will need to keep track how many times the root endpoint has been called in the database
* We will need to add a new endpoint to retrieve the number of visitors from the database

The charm created by the `flask-framework` extension will execute the `migrate.py` script if it exists. This script should ensure that the database is initialised and ready to be used by the application. We will create a `migrate.py` file containing this logic.

Go back out to the tutorial root directory using `cd ..`. Open the `migrate.py` file using a text editor and paste the following code into it:

```python
import os

import psycopg2


DATABASE_URI = os.environ{ref}`"POSTGRESQL_DB_CONNECT_STRING"]


def migrate():
    with psycopg2.connect(DATABASE_URI) as conn, conn.cursor() as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS visitors (
                timestamp TIMESTAMP NOT NULL,
                user_agent TEXT NOT NULL
            );
        """)
        conn.commit()


if __name__ == "__main__":
    migrate()
```

```{note}

The charm will pass the Database connection string in the `POSTGRESQL_DB_CONNECT_STRING` environment variable once postgres has been integrated with the charm.

```

Open the `rockcraft.yaml` file in a text editor and update the version to `0.3`.

To be able to connect to postgresql from the Flask app the `psycopg2-binary` dependency needs to be added in `requirements.txt`. The app code also needs to be updated to keep track of the number of visitors and to include a new endpoint to retrieve the number of visitors to the app. Open `app.py` in a text editor and replace its contents with the following code:

```python
import datetime
import os

import flask
import psycopg2

app = flask.Flask(__name__)
app.config.from_prefixed_env()

DATABASE_URI = os.environ["POSTGRESQL_DB_CONNECT_STRING"]


@app.route("/")
def index():
    with psycopg2.connect(DATABASE_URI) as conn, conn.cursor() as cur:
        user_agent = flask.request.headers.get('User-Agent')
        timestamp = datetime.datetime.now()
        
        cur.execute(
            "INSERT INTO visitors (timestamp, user_agent) VALUES (%s, %s)",
            (timestamp, user_agent)
        )
        conn.commit()


    greeting = app.config.get("GREETING", "Hello, world!")
    return f"{greeting}\n"


@app.route("/visitors")
def visitors():
    with psycopg2.connect(DATABASE_URI) as conn, conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM visitors")
        total_visitors = cur.fetchone()[0]

    return f"{total_visitors}\n"


if __name__ == "__main__":
    app.run()
```

Run `rockcraft pack` and upload the newly created rock to the MicroK8s registry:

```bash
rockcraft.skopeo --insecure-policy copy --dest-tls-verify=false \
   oci-archive:flask-hello-world_0.3_amd64.rock \
   docker://localhost:32000/flask-hello-world:0.3
```

Go back into the charm directory using `cd charm`. The Flask app now requires a database which needs to be declared in the `charmcraft.yaml` file. Open `charmcraft.yaml` in a text editor and add the following section to the end:

```yaml
requires:
  postgresql:
    interface: postgresql_client
    optional: false
```

Pack the charm using `charmcraft pack` and refresh the deployment using Juju:

```bash
juju refresh flask-hello-world \
   --path=./flask-hello-world_ubuntu-22.04-amd64.charm \
   --resource flask-app-image=localhost:32000/flask-hello-world:0.3
```

Deploy `postgresql-k8s` using Juju and integrate it with `flask-hello-world`:

```bash
juju deploy postgresql-k8s --trust
juju integrate flask-hello-world postgresql-k8s
```

Wait for `juju status` to show that the App is `active` again. Running `curl http://flask-hello-world --resolve flask-hello-world:80:127.0.0.1` should still return the `Hi!` greeting. To check the total visitors, use `curl http://flask-hello-world/visitors --resolve flask-hello-world:80:127.0.0.1` which should return `1` after the previous request to the root endpoint and should be incremented each time the root endpoint is requested. If we perform another request to `curl http://flask-hello-world --resolve flask-hello-world:80:127.0.0.1`, `curl http://flask-hello-world/visitors --resolve flask-hello-world:80:127.0.0.1` will return `2`.

<a href="#heading--clean-up-environment"><h2 id="heading--clean-up-environment">Clean up environment</h2></a>

We've reached the end of this tutorial. We have created a Flask application, deployed it locally, exposed it via ingress and integrated it with a database!

If you'd like to reset your working environment, you can run the following in the root directory for the tutorial:

```bash
# exit and delete the virtual environment
deactivate
rm -rf charm .venv __pycache__
# delete all the files created during the tutorial
rm flask-hello-world_0.1_amd64.rock flask-hello-world_0.2_amd64.rock \
   flask-hello-world_0.3_amd64.rock rockcraft.yaml app.py \
   requirements.txt migrate.py
# Remove the juju model
juju destroy-model flask-hello-world --destroy-storage
```

If you created an instance using Multipass, you can also clean it up. Start by exiting it:

```bash
exit
```

And then you can proceed with its deletion:

```bash
multipass delete charm-dev
multipass purge
```


<a href="#heading--next-steps"><h2 id="heading--next-steps">Next steps</h2></a>

| If you are wondering...| visit...|
|---------------------------------|----------------------------------------------------|
| "How do I...?"                | [SDK How-to docs <sdk-how-to-guides>`            |
| "How do I debug?"     | {ref}`Charm debugging tools <jhack>` |
| "What is...?"                  | {ref}`SDK Reference docs <sdk-reference>`       |
| "Why...?", "So what?" |  {ref}`SDK Explanation docs <sdk-explanation>`   |

<br>

<small>**Contributors:** @econley, @jdkandersson , @tmihoc, @weii-wang  </small>