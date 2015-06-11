#  Using Juju to Deploy your Node.js Application

One of Juju's main use cases is to deploy your application directly out of
version control and into a cloud. Since Juju supports local and remote clouds,
this makes for a nice workflow that enables you to rev your app quickly on your
local machine and then deploy to the cloud.

In this tutorial we will deploy a Node.js/MongoDB application directly from
github. The application will be behind an HAProxy service so that we can
horizontally scale when needed.

We will then set up a local-to-cloud workflow with our application so we can do
continuous deployment. Since we deploy locally in the exact same way as we
deploy to a cloud, this is a powerful method for developing your application in
an environment that more closely resembles production.

Before moving on you should have gone through the [Getting
Started](https://jujucharms.com/docs/getting-started.html) section and
installed and configured Juju.

##  Basic Usage of the Node.js Charm

First, create a configuration file `myapp.yaml` to add info about your app
pointing to your github repo:

```yaml
node-app:
  app_url: https://github.com/yourapplication
```

If you have not already bootstrapped an environment, do so:

```bash
juju bootstrap
```

Then wait a few minutes while your cloud spins up. Then deploy some basic
services:

```bash
juju deploy --config myapp.yaml node-app myapp
juju deploy mongodb
juju deploy haproxy
```

relate them

```bash
juju add-relation mongodb myapp
juju add-relation myapp haproxy
```

open it up to the outside world

```bash
juju expose haproxy
```

Find the haproxy instance's public URL from

```bash
juju status
```

(or attach it to an elastic IP via the AWS console) and open it up in a browser.

scale up your app (to 10 nodes for example)

```bash
juju add-unit -n 10 myapp
```

and scale it back down

```bash
juju remove-unit myapp/9 myapp/8 myapp/7 myapp/6 myapp/5 myapp/4 myapp/3 myapp/2 myapp/1
```


##  Local to Cloud Workflow

The previous example deploys your application quickly to the cloud, in this
example we will show how to hack and test on an application locally on your
laptop and then push out to the public cloud.

We need to configure 2 environments, a local one and a public cloud one.

1. Configure the [local provider](config-local.html) on your machine.
1. Configure a public or private cloud on your machine.
  - [AWS](config-aws.html)
  - [HP Cloud](config-hpcloud.html)
  - [OpenStack](config-openstack.html)

In this example the local environment is named `local` and we'll deploy to an
AWS environment called `amazon`. First let's `switch` to the local environment
and bootstrap.

```bash
juju switch local
juju bootstrap
```

Create a configuration file `myapp.yaml` to add info about your app pointing to
your github repo:

```no-highlight
sample-node:
  app_url: https://github.com/yourapplication
```

Then deploy some basic services:

```bash
juju deploy --config ~/myapp.yaml node-app myapp
juju deploy mongodb
```

relate them

```bash
juju add-relation mongodb myapp
```

Now open up your browser and go to `http://localhost` to get your application
loaded in your browser.


###  Continuous Deployment

Continue to write your code, push to git as you land features and fixes. When
you're ready to test it you can tell Juju to check the git repository again:

```bash
juju set myapp app_branch=https://github.com/yourapplication
```

The charm will then fetch the latest code and you can refresh your browser at
`http://localhost`.

Repeat pushing to git and using the juju set command to keep a live instance of
your application running in your local environment.

###  Push to your Public/Private Cloud

After you've repeatedly upgraded your application locally it's time to push it
out to a place where your coworkers can see your app in all it's glory, let's
push this to AWS. Same exact commands as before, just to a different
environment:

```bash
juju switch amazon
juju bootstrap
juju deploy --config ~/myapp.yaml node-app myapp
juju deploy mongodb
juju add-relation mongodb myapp
```

Since we're on a public cloud and not on a local provider we need to explicitly
expose the service and get its public IP:

```bash
juju expose myapp
juju status myapp
```

And put the ec2 URL in your browser. If you want to enable some horizontal
scalability to your application you can do so, even after you've deployed!

```bash
juju deploy haproxy
juju add-relation haproxy myapp
juju expose haproxy
juju unexpose myapp
```

And then get the public IP from the haproxy instead (notice how we've unexposed
your application so that only haproxy is serving the public internet):

```bash
juju status haproxy
```

Now you can `juju add-unit myapp` and `juju remove-unit myapp` based on load.


###  Tearing it all down

The local containers survive reboots and do not go away until you explicitly
tear the environment down. Now that your coworkers have seen your great
application let's also stop spending money:

```bash
juju destroy-environment -e amazon
juju destroy-environment -e local
```

##  Charm Details

This section is to explain how the charm works and is provided here as a
reference.


###  What the charm does

During the `install` hook,

- installs `node`/`npm`
- clones your node app from the repo specified in `app_repo`
- runs `npm` if your app contains `package.json`
- configures networking if your app contains `config/config.js`
- waits to be joined to a `mongodb` service

when related to a `mongodb` service, the formula

  - configures db access if your app contains `config/config.js`
  - starts your node app as a service


###  Charm configuration

Configurable aspects of the charm are listed in `config.yaml` and can be set by
either editing the default values directly in the yaml file or passing a
`myapp.yaml` configuration file during deployment

```bash
juju deploy --config ~/myapp.yaml node-app myapp
```

Some of these parameters are used directly by the charm, and some are passed
through to the node app using `config/config.js`.


###  Application configuration

The formula looks for `config/config.js` in your app which starts off looking
something like this

```javascript
module.exports = config = {
  "name" : "mynodeapp"
  ,"listen_port" : 8000
  ,"mongo_host" : "localhost"
  ,"mongo_port" : 27017
}
```

and gets modified with contextually correct configuration information during
either deployment (via the `install` hook) or relation to another service
(`relation-changed` hook).

This config can be used from within your application using snippets like

```javascript
...
var config = require('./config/config')
...
new mongo.Server(config.mongo_host, config.mongo_port, {}),
...
server.listen(config.listen_port);
...
```

Alternatively you could use a `Procfile` in root directory like this:

```no-highlight
web: node app.js
```

and then get the environment variables from the running environment like this:

```no-highlight
app.set('port', process.env.PORT);
```

The defined environment variables are:

```no-highlight
NAME
PORT
NODE_ENV
MONGO_HOST
MONGO_PORT
MONGO_REPLSET
```


###  Network access

This charm does not open any public ports itself. The intention is to relate it
to a proxy service like `haproxy`, which will in turn open port 80 to the
outside world. This allows for instant horizontal scalability.

If your node app is itself a proxy and you want it directly exposed, this can
easily be done by adding

```javascript
open-port $app_port
```

to the bottom of the `install` hook, and then once your stack is started, you
expose

```bash
juju expose myapp
```

it to the outside world.

By default, juju services within the same environment can talk to each other on
any port over internal network interfaces.


###  Making this work with your node.js app

This charm makes some strong assumptions about the structure of the node
application (`config/config.js`) that might not apply to your app. Please treat
this formula as a template that you can fork and modify to suit your needs.

The biggest difference between how the charm behaves for different kind of apps
is application startup. A simple application will want to start upon install
(startup code goes in the `install` hook), whereas some applications will not
want to start up until a database has be associated (startup code goes in the
`db-relation-joined` hooks).
