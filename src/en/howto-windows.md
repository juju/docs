## This guide is currently experimental and under dev

Juju is capable of orchestrating Windows workloads thanks to the enablement
efforts of [CloudBase Solutions](http://cloudbaseit.com).

> Getting started with orchestrating windows workloads today is still a work in
progress - as it's only available on 2 substrates. MAAS 1.8 experimental, and
OpenStack with a custom image loaded in Cinder.

<!-- This may be completely overkill - but i wanted to be somewhat complete
if we were going with a MAAS + Juju approach, as thats the most tested
integration that we have today. If this doesn't belong here - feel free to
punt -->

### Set up MAAS

You will need to add the MAAS experimental PPA

    sudo add-apt-repository ppa:~maas-maintainers/experimental
    sudo apt-get update
    sudo apt-get install maas

On your workstation, you will also need to install the MAAS-CLI command

    sudo apt-get install maas-cli

#### Create the user in MAAS

    sudo maas-region-admin <admin>

Log into MAAS and visit the MAAS preferences pane

Under SSL keys, if you do not have one listed you will need to generate one

    maas-generate-winrm-cert

An ssl key will be printed to the screen. Click "Add SSL key" and paste it into
the provided textarea.

Select MAAS Boot Images

#### Add the windows boot resource

Import AMD64/Trusty/Release boot images, and wait for the clusters to sync.

Obtain the MAAS windows image from: [here](#) <!-- Needs Clarification on if
we can disclose the MAAS image creation process -->

Import the windows boot resource via MAAS-CLI

    maas <identifier> boot-resources create name=windows/win2012r2 \
    architecture=amd64/generic filetype=ddtgz content@=/path/to/windows2012r2

After the command completes, refresh your images UI and you should see "Windows
Server 2012 R2" under generated images.

In the MAAS settings page, set the default OS and Release to Windows.

- commissioning:
  - Default Ubuntu release for commissioning: Ubuntu Trusty (14.04)
- Deploy:
  - Default OS used for deployment: Windows
  - Default OS release used for deployment: Windows Server 2012 R2

#### Add Nodes to MAAS

Add your nodes to MAAS via the usual process found in the
[MAAS Documentation](https://maas.ubuntu.com/docs/nodes.html)


#### Configure Juju to talk to MAAS

Ensure Juju is installed and configured to talk to your MAAS region controller.
You can find this information in the getting started guide on setting up
[Juju and MAAS](https://jujucharms.com/docs/config-maas)

### Juju Deploy Windows Workloads

Bootstrap the state server as you would in any other environment.

    juju switch maas
    juju bootstrap



