<!--
Todo:
- Review required
-->

Juju already has knowledge of the Joyent cloud, which means adding your Joyent account to Juju is quick and easy.

More specific information on Juju's Joyent support (e.g. the supported regions) can be seen locally or, since `v.2.6.0`, remotely (on a live cloud). Here, we'll show how to do it locally (client cache):

```text
juju show-cloud --local joyent
```

[note]
In versions prior to `v.2.6.0` the `show-cloud` command only operates locally (there is no `--local` option).
[/note]

To ensure that Juju's information is up to date (e.g. new region support), you can update Juju's public cloud data by running:

```text
juju update-public-clouds
```

<h2 id="heading--adding-credentials">Adding credentials</h2>

The [Credentials](/t/credentials/1112) page offers a full treatment of credential management.

In order to authenticate itself to the Joyent cloud, Juju will need the following information:

- **sdc-user** - obtained from the Joyent Dashboard
- **sdc-key-id** - The fingerprint of an SSH key uploaded to Joyent (obtained from the Joyent Dashboard)
- **private-key-path** - full local path to the actual private key (e.g. '/home/ubuntu/.ssh/id_rsa'). See note below.

The first two values are easily obtained from the 'Account' section via the Joyent Dashboard

![Joyent Account](https://assets.ubuntu.com/v1/779bc621-getting_started-joyent-account-dropdown.png)

[note]
The private key is currently uploaded to the cloud in order to remotely sign requests to the Joyent API. It is highly recommended that the private key used in this way *should not* be a common SSH key you use for other purposes, but a specific one used for the Joyent cloud.
[/note]

With the above information, you can now run the command:

``` text
juju add-credential joyent
```

...and supply relevant answers to the questions. Note that the path to the SSH key must be the full system path, not using any bash shortcuts such as '~'.

[note]
During initial setup if you are having issues deploying charms contact Joyent support at <https://help.joyent.com/home> to verify your account is capable of provisioning virtual machines.
[/note]

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'joyent':

``` text
juju bootstrap joyent joyent-controller
```

Above, the name given to the new controller is 'joyent-controller'. Joyent will provision an instance to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
