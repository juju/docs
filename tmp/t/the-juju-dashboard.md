(the-juju-dashboard)=
# The Juju dashboard

> See also: [Charmhub | `juju-dashboard`](https://charmhub.io/juju-dashboard), {ref}`How to manage the Juju dashboard <how-to-manage-the-juju-dashboard>` 

<!--{ref}`The Juju Web CLI <the-juju-web-cli>`-->

```{note}

Note: a small number of dashboard features (e.g. the web CLI) are dependent on the deployment environment. These are noted as “requirements” in this document.

```


Juju Dashboard aims to expose Juju environments, providing at-scale management, status and collaboration features not found in the Juju CLI. It is intended to supplement the CLI experience with  aggregate views and at a glance health checks. In particular, it provides a quick way to view details for all the entities in your Juju environment (models, controllers, etc.), and in places also provides functionality related to the ongoing maintenance of your estate.

Juju Dashboard is hosted on [JAAS](https://jaas.ai/) for use with JAAS controllers, but can also be [deployed](https://juju.is/docs/juju/manage-the-juju-dashboard#heading--set-up-the-dashboard) on local controllers.

![models list|690x448](upload://7oxSg7horl7ihpr7R1hTw4DVzMD.png)

```{caution}

Prior to `juju v.3.0`,  the Juju dashboard was automatically deployed with every controller, but from `juju v.3.0` it needs to be set up by [deploying](https://juju.is/docs/juju/manage-the-juju-dashboard#heading--set-up-the-dashboard) the `juju-dashboard` or `juju-dashboard-k8s` charm in the controller model and integrating it with the `controller` application. 

```

**Contents:**

 - [Models view](#heading--models-view)
     - [Group by](#heading--group-by)
     - [Search and filtering](#heading--search-and-filtering)
 - [Model details view](#heading--model-details-view)
     - [Unit view](#heading--unit-view)
     - [Machine view](#heading--machine-view)
     - [Integrations view](#heading--integrations-view)
     - [Configuring applications](#heading--configuring-applications)
     - [Web CLI](#heading--web-cli)
 - [Controllers view](#heading--controllers-view)
     - [Register a controller](#heading--register-a-controller)
 - [Model access management](#heading--model-access-management)
 - [Running actions from the dashboard](#heading--running-actions-from-the-dashboard)
     - [Viewing action logs](#heading--viewing-action-logs)
- [Common questions and problems](#heading-common-questions-and-problems)



<a href="#heading--models-view"><h2 id="heading--models-view">Models view</h2></a>

The models view lists all the models associated with the connected controllers that you have some form of access to. The list displays the models across clouds. This allows you to access the health of all the models at a glance, surfacing any relevant errors so you can quickly investigate what has happened.

 <a href="#heading--group-by"><h3 id="heading--group-by">Group by</h3></a>

The list can be grouped by status, cloud, or owner. The default grouping is by status, which brings the models with errors to the top of the list.

![|433x66](https://lh3.googleusercontent.com/2wTGGIF3reAitFHnsSSLPnVE2cZtFnEXGwMagKeOCSQTNZiVMwbQUeiuutRaCmtreOrkzri2w_U3uoSRsS8LmSJYbOHbkSgg1E0yAHTsDByJ63NG_ZSGvEs_jbNAaVirUTS9ie-A)

 <a href="#heading--search-and-filtering"><h3 id="heading--search-and-filtering">Search and filtering</h3></a>

The dashboard provides comprehensive search and filter functionality. This allows you to perform complex filtering of the models list which can be shared via the URL.

![|287x472](https://lh5.googleusercontent.com/zrpkWYRo8uF9kkRxD4pRC3aAsKGY0fxVYyMGw8xuS_IGFNZXhUQXVe_GJlALHmlk38ITz7seUgwbv7aa7EUCeb6R9-Azyfz6L8BEpL9b4mpHSgXy6G20jpvPvCdbCM7mH74KZRC2)


 <a href="#heading--model-details-view"><h2 id="heading--model-details-view">Model details view</h2></a>


The purpose of the model details view is to provide a list of the applications running on that model. In this view you can also [manage access to the model](https://juju.is/docs/olm/working-with-multiple-users#model-access).

This view can be accessed by navigating to the model list (click “Models” in the side navigation) and then clicking on the title of a model in the list.

![model-applications|690x448](upload://AsWhwVWD2qk7qL9fxPkaPh7WooF.png)

 <a href="#heading--unit-view"><h3 id="heading--unit-view">Unit view</h3></a>

The unit view scopes your list of units to the model and application you are inspecting. This view will give fine-grained information about the status of each unit and information on this public availability.

![unit|690x448](upload://trPvfxZBC0erlJre45Edtz4rmbR.png)

 <a href="#heading--machine-view"><h3 id="heading--machine-view">Machine view</h3></a>

```{note}

Requirements: this view is only available for a [machine charm](https://juju.is/docs/sdk/charm-taxonomy#heading--charm-types-by-substrate) environment and will not be visible when deployed on Kubernetes.

```

The machine view displays all [machine instances](https://juju.is/docs/juju/machine) managed by Juju. It all also displays the machine status and any applications running on the machines.

![machines|690x448](upload://jwOKxMlpFSbFOdmjLNXehajDEka.png)

The machine details view displays all machine information for the selected machine. Machine details is accessible via an application deployed to a model. The machine details view shows a list of the units running on the machine and the applications associated with the units.

![machine|690x448](upload://9kr7GsgTcCxpKHa8ASIBFkd6MVb.png)

 <a href="#heading--integrations-view"><h3 id="heading--integrations-view">Integrations view</h3></a>


The integrations view (sometimes called relations) displays the information about each integration in a model. This view is accessible from the model details view as an option in the tabbed navigation at the top of the page.

![integrations|690x448](upload://exLf9tpsoKGH6bTQtLuPx749rcq.jpeg)

This view provides information about each integration and acts as an at a glance overview of the health of your models relations and a status to help you debug any issues.

 <a href="#heading--configuring-applications"><h3 id="heading--configuring-applications">Configuring applications</h3></a>

Applications can be configured from the dashboard. Navigate to an application details page and click the 'Configure' button on the left hand side and you will be shown the configuration panel.

By clicking on a configuration option you can see the description for that option that has been provided by the charm maintainer.

![configure-app|690x448](upload://qDY25AzNAARCE4DPYGVvR0s7XBe.jpeg)

 <a href="#heading--web-cli"><h3 id="heading--web-cli">Web CLI</h3></a>

```{note}

Requirements: the web CLI is only available when the dashboard is deployed on a local controller and is not available when using JAAS.

```

The dashboard provides a way to run Juju CLI commands from the web interface. For full details see the [web CLI docs](https://juju.is/docs/olm/the-juju-web-cli).

<a href="#heading--controllers-view"><h2 id="heading--controllers-view">Controllers view</h2></a>

The controllers view offers a top level view, monitoring across different controllers, and the possibility to add, edit, and manage controllers. It displays a set of aggregate charts to represent the status of the controllers that have been added to the dashboard. It also displays a table listing each controller and the usage of each entity hosted by the controller.

![controllers|690x448](upload://grFXedVYeGHZ0WtX1bdXjErYVLj.png)

<a href="#heading--model-access-management"><h2 id="heading--model-access-management">Model access management</h2></a>

If you have admin rights on a model, the dashboard allows you to add, remove, or modify other users' access to the model. Once model access has been granted, the model will automatically appear in that user's model list.

The model access panel can be opened from a button that appears on hover in the [model list](https://juju.is/docs/juju/the-juju-dashboard#heading--models-view) for models you have admin access to and will also appear on the left side of the [model details](https://juju.is/docs/juju/the-juju-dashboard#heading--model-details-view) views.

![|256x139](https://lh4.googleusercontent.com/teykb00qwRKKc3PyTPZyCFwQt1dzOpBhmQwNXVIGotDz8dl5POA_KwKazM0oFCipgd2o5IszxDy3S87QmWAPkirMMVtRf9FrhmwtrgjRcvfewBj9L2dHET9q9CoVmMQTUrMNaQJu)

To add a user, enter the username of the person you want to grant access too. Then select the permission level you would like to grant. Finally, click the “Add user” button.

When using an external authentication provider the user domain will need to be included in the format `[username]@[domain]`.

JAAS uses the Ubuntu SSO provider and to allow access to other users you can use the format `[ubuntu-sso-username]@external`.

![|602x491](https://lh4.googleusercontent.com/XQED66vDNykBjzuTrBgljemjE5M4a4BPIPY4jKFPuYUKSpKdiJfIqHhHk-ZCGT7qGinAXt9y3iafk55TehPmfG1ufH5PeefLHqWbXtSiHljditmPwjjfXgnBkG5dlFPHDdErShYO)

<a href="#heading--running-actions-from-the-dashboard"><h2 id="heading--running-actions-from-the-dashboard">Running actions from the dashboard</h2></a>
 

If you have write or admin permissions on a model, you can trigger any available action the charmed application provides. If the action requires options, the UI will provide these as a form with help text to describe the options and the default values.

![|374x155](https://lh6.googleusercontent.com/DzRGwCoR46PkFoMMRwMDWIdWvUxgnz3oVcwJS5eLzBndig1kOKhphD5njL_aUceXKFAFRqaSnIt0aCeBSqvNEK5UDEDhGd-Qc1UqpyrXSUNGTqBzvCOxM5t8TuVLELTmQH_O9uQs)

Actions are run on the unit level. To view and trigger actions, visit an application's unit view, select the units you would like the action to run on, and click the Run actions button. This will bring up a side panel with a list of available actions. Find and select the action you wish to run, provide any necessary options, and click "Run action".

![run-action|690x448](upload://sFaK6H3XnWKFuh7FsESnmSSJ4Ld.jpeg)

<a href="#heading--running-actions-on-multiple-applications"><h3 id="heading--running-actions-on-multiple-applications">Running actions on multiple applications</h3></a>

You can also run action on units of multiple applications of the same type at once. Navigate to the list of applications in a model and perform a search using the search input in the header.

![Screenshot 2023-06-15 at 1.22.59 pm|454x60](upload://eW6zC2Zx4ATgB16yTrbKHweg1r8.png) 

Tick the applications you want to perform actions on and click the 'Run action' button. If you've selected applications with different charm or revision types you'll need to choose one charm/revision combination to perform the action.

![Screenshot 2023-06-15 at 1.23.08 pm|418x196](upload://76LbtZejjfivOnNYpf4OjAn53LO.png) 

<a href="#heading--viewing-action-logs"><h3 id="heading--viewing-action-logs">Viewing action logs</h3></a>

Once an action has been triggered, the action log displays the status and latest result of the action.

![action-logs|690x448](upload://k7S3JZ0am9I7D099ens5KCiLE1h.png)

<a href="#heading--common-questions-and-problems"><h2 id="heading--common-questions-and-problems">Common questions and problems</h2></a>
<a href="#heading-why-cant-i-access-the-dashboard"><h4 id="heading-why-cant-i-access-the-dashboard">Why can't I access the dashboard?</h4></a>

To be able to access the dashboard that is deployed on a local controller make sure you run the `juju dashboard` command from the same computer as your web browser. This will set up a secure proxy to the dashboard.

If you’re having trouble accessing the dashboard on [JAAS](http://jaas.ai) then get in touch on [Juju Discourse](https://discourse.charmhub.io/) or find us on [Mattermost](https://chat.charmhub.io/landing#/charmhub/channels/juju).

<a href="#heading-why-cant-i-log-in-to-the-dashboard"><h4 id="heading-why-cant-i-log-in-to-the-dashboard">Why can't I log in to the dashboard?</h4></a>

If you’ve set up a local controller and this is your first time logging in, make sure you’ve set up a password in Juju with `juju change-user-password {ref}`your-username]`

<a href="#heading-how-do-i-deploy-the-dashboard"><h4 id="heading-how-do-i-deploy-the-dashboard">How do I deploy the dashboard?</h4></a>

The dashboard can be deploy on a controller model using the [juju-dashboard <4898md>` or {ref}`juju-dashboard-k8s <4898md>` charm. See the [deployment instructions](https://juju.is/docs/juju/manage-the-juju-dashboard#heading--set-up-the-dashboard) for full details.

<a href="#heading-how-do-i-make-the-dashboard-accessible-over-the-network"><h4 id="heading-how-do-i-make-the-dashboard-accessible-over-the-network">How do I make the dashboard accessible over the network?</h4></a>

To make the dashboard available over your network without using the `juju dashboard` command you will need to [set up a secure proxy](https://juju.is/docs/juju/manage-the-juju-dashboard#heading--access-without-the-cli).

<a href="#heading-why-cant-i-see-the-web-cli"><h4 id="heading-why-cant-i-see-the-web-cli">Why can't I see the web CLI?</h4></a>

If you’re trying to access the web CLI on a local controller, make sure there is nothing blocking the model’s `/commands` websocket.

At the time of writing the web CLI is not available on JAAS.

<a href="#heading-why-cant-i-see-the-machine-views"><h4 id="heading-why-cant-i-see-the-machine-views">Why can't I see the machine views?</h4></a>

The machine views are only available when using the dashboard with machine
charms, and is not available when using a Kubernetes deployment.