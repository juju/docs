Title: Using JAAS from the command line

# Using JAAS from the command line

The Juju controller you already have running in JAAS can also be used
from the command line, giving you powerful, fast access to 
perform common operations. In order to use the command line, you will 
first need to install the Juju client software on your machine.

## Install Juju

Juju is available for various types of Linux, MacOSX, and Windows. 
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

   Please see the [releases page][releases] for a link to the latest 
   version.

^# For MacOSX

   The easiest way to install Juju on MacOS is with the brew package 
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



## Register or login to JAAS from Juju

```bash
juju register jimm.jujucharms.com
```


## View your models

If you added a model using the GUI, you can see it in the CLI, like this:

```bash
juju models
```

## Create a new model

If you have not yet entered credentials for the public cloud of your choice
into JAAS, enter one now with the `add-credential` command. See [Cloud credentials][credentials]
for more information.

To add a new model and perform model-related tasks from the CLI, see [Models][models].

View the new model in the JAAS web UI by logging in to [https://jujucharms.com](https://jujucharms.com).

[credentials]: ./credentials.html
[installjuju]: ./getting-started-general.html
[models]: ./models.html
[snapcraft]: https://snapcraft.io/docs/core/install
[releases]: ./releases.md
