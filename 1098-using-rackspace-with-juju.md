<!--
Todo:
- Review required
-->

Juju already has knowledge of the Rackspace cloud, which means adding your Rackspace account to Juju is quick and easy.

More specific information on Juju's Rackspace support (e.g. the supported regions) can be seen locally or, since `v.2.6.0`, remotely (on a live cloud). Here, we'll show how to do it locally (client cache):

```text
juju show-cloud --local rackspace
```

[note]
In versions prior to `v.2.6.0` the `show-cloud` command only operates locally (there is no `--local` option).
[/note]

To ensure that Juju's information is up to date (e.g. new region support), you can update Juju's public cloud data by running:

```text
juju update-public-clouds
```

<h2 id="heading--adding-credentials">Adding credentials</h2>

The [Cloud credentials](/t/credentials/1112) page offers a full treatment of credential management.

Using Juju's interactive authentication, importing Rackspace credentials into Juju is a simple process. The only information you'll need is your Rackspace username, password and tenant name (which is actually a number):

- **`username`** The name used to login to the Rackspace cloud control panel.
- **`password`** The password used to login to the Rackspace cloud control panel.
- **`tenant-name`** The Rackspace account number. You can view this in the cloud control panel in the top-right corner (under your username), as shown in the following image:

![Rackspace control panel showing tenant id](https://assets.ubuntu.com/v1/ec435490-config-rackspace_tenant_id.png)

Credentials can now be added by running the following command:

``` text
juju add-credential rackspace
```

The first question will ask for an arbitrary credential name, which you choose for yourself. This will be how you remember and refer to this Rackspace credential in Juju. The second question will ask you to select an 'Auth Type', with the options being either `access-key` or `userpass`.

Enter `userpass` as the authentication type and then enter your username, password and tenant-name, as described above.

You can now start using Juju with your Rackspace cloud.

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'rackspace':

``` text
juju bootstrap rackspace rackspace-controller
```

Above, the name given to the new controller is 'rackspace-controller'. Rackspace will provision an instance to run the controller on.

The controller will now be visible in the [Rackspace cloud control panel](https://mycloud.rackspace.com):

![bootstrap machine 0 in Rackspace portal](https://assets.ubuntu.com/v1/259ef4ad-config-rackspace_portal-machine_0.png)

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
