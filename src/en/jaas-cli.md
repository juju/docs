Title: Using JAAS from the command line

# Using JAAS from the command line

The Juju controller you already have running in JAAS can also be used
from the command line, giving you powerful, fast access to 
perform common operations. In order to use the command line, you will 
first need to install the Juju client software on your machine.

## Install Juju

Juju is available for various types of Linux, macOS, and Windows. 
Click on the sections below for the relevant instructions.


<style>
details  {
    padding-bottom: 6px;
}
</style>

^# On a snap enabled OS

   For Ubuntu 16.04 LTS (Xenial) and other OSes which have snaps enabled 
   ([see the snapcraft.io site][snapcraft]) you can install the latest
   stable release of Juju with the command:
   
         sudo snap install juju --classic

   You can check which version of Juju you have installed with 

         sudo snap list juju

   And update it if necessary with:

         sudo snap refresh juju

   It is possible to install other versions, including beta releases of 
   Juju via a snap package. See the [releases] page for more information.

   
^# From the Ubuntu PPA

   A PPA resource is available containing the latest stable version of
   Juju. To install:

       sudo add-apt-repository ppa:juju/stable
       sudo apt update
       sudo apt install juju

^# For Windows

   A Windows installer is available for Juju. 

   [juju-setup-2.1.2.exe](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe/+md5))
   
   Please see the [releases page][releases] for other  
   versions.

^# For macOS

   The easiest way to install Juju on macOS is with the brew package 
   manager. With brew installed, simply enter the following into a 
   terminal:

       brew install juju

   If you previously installed Juju with brew, the package can be 
   updated with the following:

       brew upgrade juju

   For alternative installation methods, see the [releases page][releases].

^# For CentOS

   A pre-compiled binary is available for CentOS.

   Please see the [releases page][releases] for a link to the latest 
   version.



## Register or login to JAAS

To authorise JAAS from the command line, enter the following command:

```bash
juju register jimm.jujucharms.com
```

This command will open a new window in your default web browser and use
[Ubuntu SSO][ubuntusso] to authorise your account. If the browser doesn't open,
you can manually copy and paste the unique authorisation URL from the command
output.

After successful authentication, you will be asked to enter a descriptive name
for the JAAS controller, giving you access to the same controller used by the
JAAS web interface. This means any models or applications you have already
deployed are now accessible from the command line. 

## View your models

If you previously added one or more models using the web interface, you can
view them in the CLI with the following command: 

```bash
juju models
```

If you have more than one model, you will need to switch focus to one of these
before you can perform any actions:

```bash
juju switch mymodel
```

You can check on the status of the currently active model, showing any
applications currently deployed, with the following command:

```bash
juju status
```
## Create and deploy a model

If you have not yet entered credentials for the public cloud of your choice
into JAAS, enter one now with the `add-credential` command. See 
[Cloud credentials][credentials] for more information.

To create a new model, use the [add-model][addmodel] command and specify both a
model name and the cloud you wish to use:

```bash
juju add-model newmodelname aws
```

You can also specify a region for the new model, such as `aws/us-east-1`. Use
the `juju regions` command, followed by your cloud's name, to get a list of
supported regions for your cloud. 

## Deploy

The [Charm store][charmstore] is the default repository for [charms][charms]
and [bundles][bundles]. Whether you deploy [Kibana][kibana] or
[OpenStack][openstack], it's JAAS and Juju that handle the complexity. 

To deploy the [Canonical Kubernetes][kubernetes] bundle, for example, type the
following:

```bash
juju deploy canonical-kubernetes
```

The output from the above command will show each component of the Kubernetes
bundle being deployed to your cloud. The `juju status` command will give a more
comprehensive overview, showing each application as it steps through
deployment, allocation and execution. Finally, each applications will turn
green when all interrelated components are in place and linked to one another. 

Kubernetes is now ready for action!

## Destroy a model

When you've finished with a deployment, the `destroy-model` command will remove it from
JAAS and free any resources being used by your cloud.

To remove the model hosting Kubernetes, type the following:

```bash
juju destroy-model newmodelname
```

After confirming the action, the model will be removed completely, making the
model and its resources no longer accessible from either the command line or
the web interface. The process isn't instantaneous but should take only a
couple of minutes.

Log in to your cloud provider's dashboard to confirm the machines created for
your model were terminated.

## Logout of JAAS

To remove the local authorization that links your Ubuntu SSO account with JAAS,
use the `unregister` command with the controller name as an argument:

```bash
juju unregister myjaas
```

This command doesn't remove any other models or applications, all of which can still
be accessed either via the web interface or by registering your account again
on the command line.

## Next steps

With JAAS and Juju on the command line, you now have access to a vast
collection of deployable operational expertise via the 
[Charm store][charmstore]. But you also have access to the comprehensive set of
functions and facilities of Juju itself.

We'd recommend next stepping through the [Juju documentation][jujudocs] to see
exactly what it's capable of.


[credentials]: ./credentials.html
[installjuju]: ./getting-started-general.html
[models]: ./models.html
[addmodel]: ./models-adding.html
[snapcraft]: https://snapcraft.io/docs/core/install
[charmstore]: https://jujucharms.com
[kibana]: https://jujucharms.com/kibana
[openstack]: https://jujucharms.com/q/openstack/?type=bundle
[charms]: ./charms.html
[bundles]: ./charms-bundles.html
[kubernetes]: https://jujucharms.com/canonical-kubernetes/bundle/21
[jujudocs]: ./clouds.html
[ubuntusso]: https://login.ubuntu.com/
[releases]: ./reference-releases.html
