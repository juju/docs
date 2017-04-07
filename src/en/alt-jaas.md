
# Juju as a Service 一 Getting Started

JAAS is the best way to quickly get started modeling and deploying your cloud-based applications. When you use JAAS, Canonical manages the Juju infrastructure freeing you to concentrate on your software and solutions. Deploy, configure, and operate your applications on  AWS, GCE, and Azure.

## Advantages

 - One view for all of your modelled applications across multiple clouds. Easily see what you’re running, regardless of the provider.
 - Collaborate with other JAAS users.
 - Juju infrastructure professionally managed by Canonical, the company behind Ubuntu. 
    - Infrastructure is highly available and multi-region.
    - 24/7 monitoring and alerting.
    - Juju upgrades managed for you.

## First step: create an Ubuntu single sign on identity

JAAS uses Ubuntu SSO for identity management. So if you don’t already have an Ubuntu SSO account you’ll need to create one at https://login.ubuntu.com/.  You must provide a username when registering. It is the name that will be used by JAAS.

## Obtaining cloud credentials

In order for JAAS to deploy your workload on the cloud of your choice, it needs to have a set of credentials for the clouds you would like to use.

We recommend that users generate a new set of credentials exclusively for use with JAAS via the public cloud’s IAM tools. For instructions on getting your credentials see our credentials documentation page. 

## Get started via the web

It is easiest to do the initial steps using the web. First, go to:

	https://jujucharms.com/login

There you will login to JAAS using the SSO account from the previous step. You can then press the “Start Building” button to design your model and deploy it. The last step will require providing credentials for the public cloud you want to use, so have those handy beforehand. 

## Using JAAS from the CLI

You can use JAAS from the Juju CLI by following these steps.

### Install Juju

If you haven’t installed juju yet follow these instructions to get it running on your system.

### Register

If you’re using Juju 2.1 add the JAAS controller with:

      juju register jimm.jujucharms.com

If you’re using Juju 2.2 use:
	
      juju login jaas

## Viewing your models

If you added a model via the GUI you can now see it in the CLI using:

      juju models

## Creating a new model

If you’ve not yet entered a credential in JAAS previously,  you will need to enter one. We can do this with the `add-credential` command. It will walk us through entering the pertinent credential data for the cloud specified:

      juju add-credential google

For more details about JAAS and credentials see the documentation here: https://jujucharms.com/docs/stable/credentials

You can now add a new model from the CLI via:

      juju add-model mygce google

And now deploy kubernetes-core. 

      juju deploy kubernetes-core

You can view our model in the JAAS web UI by going to https://jujucharms.com.

## Let’s collaborate
Share your model with another user in JAAS. 

      juju grant uros@external read mygce

You can also share your model with others via the GUI via the sharing button.



Entering the other user’s name and permissions is straightforward.







