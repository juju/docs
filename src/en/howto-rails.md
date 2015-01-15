#  Using Juju to Deploy your Rails Application

One of Juju's main use cases is to deploy your application directly out of
version control and into a cloud. Since Juju supports local and remote clouds,
this makes for a nice workflow that enables you to rev your app quickly on your
local machine and then deploy out the cloud.

In this HowTo we will deploy a Rails/PostgreSQL application directly from
github. The application will be behind an HAProxy service so that we can
horizontally scale when needed.

We will then set up a local-to-cloud workflow with our application so we can do
continuous deployment. Since we deploy locally in the exact same way as we
deploy to a cloud, this is a powerful method for developing your application in
an environment that more closely resembles production.

Before moving on you should have gone through the [Getting
Started](https://jujucharms.com/docs/getting-started.html) section and
installed and configured Juju.

##  Basic Usage of the Ruby on Rails Charm

Create a YAML config file with your application's name and its git location

`sample-app.yaml`

    sample-app:
      repo: https://github.com/pavelpachkovskij/sample-rails

Deploy the application and a proxy:

    juju deploy --config sample-app.yaml rails myapp
    juju deploy haproxy
    juju add-relation haproxy myapp

Deploy and relate database:

    juju deploy postgresql
    juju add-relation postgresql:db myapp

Now you can run migrations:

    juju ssh myapp/0 run rake db:migrate

Seed database

    juju ssh myapp/0 run rake db:seed

And finally expose the proxy:

    juju expose haproxy

Find the instance's public URL from

    juju status haproxy

Scale horizontally by adding and removing units:

    juju add-unit myapp
    juju remove-unit myapp

Or go even larger with `juju add-unit -n10 myapp` for 10 nodes.

##  Local to Cloud Workflow

The previous example deploys your application quickly to the cloud, in this
example we will show how to hack and test on an application locally on your
laptop and then push out to the public cloud.

We need to configure 2 environments, a local one and a public cloud one.

1. Configure the [local provider](./config-local.html) on your machine.
1. Configure a public or private cloud on your machine.
  - [AWS](./config-aws.html)
  - [HP Cloud](./config-hpcloud.html)
  - [OpenStack](./config-openstack.html)

In this example the local environment is named "local" and we'll deploy to an
AWS environment called `amazon`. First let's `switch` to the local environment
and bootstrap.

    juju switch local
    juju bootstrap

Create a YAML config file with your application's name and its git location

`sample-app.yaml`

    sample-app:
      repo: https://github.com/pavelpachkovskij/sample-rails

Deploy the application and database:

    juju deploy --config ~/sample-app.yaml rails myapp
    juju deploy postgresql

and relate them:

    juju add-relation myapp postgresql

Now open up your browser and go to `http://localhost` to get your application
loaded in your browser.

###  Continuous Deployment

Continue to write your code, push to git as you land features and fixes. When
you're ready to test it you can tell Juju to check the git repository again:

    juju set myapp repo=https://github.com/yourapplication

The charm will then fetch the latest code and you can refresh your browser at
`http://localhost`.

Repeat pushing to git and using the juju set command to keep a live instance of
your application running in your local environment.

###  Push to your Public/Private Cloud

After you've repeatedly upgraded your application locally it's time to push it
out to a place where your coworkers can see your app in all its glory, let's
push this to AWS. Same exact commands as before, just to a different
environment:

    juju switch amazon
    juju bootstrap
    juju deploy --config ~/myapp.yaml rails myapp
    juju deploy postgresql
    juju add-relation postgresql myapp

Since we're on a public cloud and not on a local provider we need to explicitly
expose the service and get its public IP:

    juju expose myapp
    juju status myapp

And put the ec2 URL in your browser. If you want to enable some horizontal
scalability to your application you can do so, even after you've deployed!

    juju deploy haproxy
    juju add-relation haproxy myapp
    juju expose haproxy
    juju unexpose myapp

And then get the public IP from the haproxy instead (notice how we've unexposed
your application so that only haproxy is serving the public internet):

    juju status haproxy

Now you can `juju add-unit myapp` and `juju remove-unit myapp` based on load.

###  Tearing it all down

The local containers survive reboots and do not go away until you explicitly
tear the environment down. Now that your coworkers have seen your great
application let's also stop spending money:

    $ juju destroy-environment -e amazon
    $ juju destroy-environment -e local

##  Charm Details

This document just scratches the surface of what is possible with the Rails
charm, for more deployment options, including support for more databases,
integrated logging with Logstash/Kibana, and Nagios integration, make sure you
check out the [Charm README](https://jujucharms.com/precise/rails-HEAD/) for
more information.
