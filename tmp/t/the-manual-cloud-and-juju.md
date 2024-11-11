(the-manual-cloud-and-juju)=
# The Manual cloud and Juju

<!--To see the older HTG-style doc, see version 19. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Manual </small>

This document describes details specific to using the Manual (`manual`) cloud with Juju. 

```{important}

The Manual (`manual`) cloud is a cloud you create with Juju from existing machines. 

The purpose of the Manual cloud is to cater to the situation where you have machines (of any nature) at your disposal and you want to create a backing cloud out of them. 

If this collection of machines is composed solely of bare metal you might opt for a {ref}`MAAS cloud <the-maas-cloud-and-juju>`. However, recall that such machines would also require [IPMI hardware](https://docs.maas.io/en/nodes-power-types) and a MAAS infrastructure. In contrast, the Manual cloud can make use of a collection of disparate hardware as well as of machines of varying natures (bare metal or virtual), all without any extra overhead/infrastructure.

```


When using the Manual cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1095md>` and (2) {ref}`not some other cloud <1095md>`. 

> See more: {ref}`Cloud differences in Juju <1095md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

|Juju points of variation|Notes for the Manual cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`||
|supported versions:| N/A|
|requirements:|- At least two pre-existing machines (one for the controller and one where charms will be deployed).<br> - The machines must be running on Ubuntu.<br> - The machines must be accessible over SSH from the terminal you're running the Juju client from  using public key authentication (in whichever way you want to make that possible using generic Linux mechanisms).<p> (`sudo` rights will suffice if this provides root access. If a password is required for `sudo`, juju will ask for it on the command line.) <p> - The machines must be able to `ping` one another.|
|{ref}`definition: <1095md>`|You will need to supply a name you wish to call your cloud and the ssh connection string for the controller, the username@<hostname or IP>, or the <hostname or IP>.|
|- name:|user-defined|
|- type:|`manual`|
|- authentication types:|No preset auth-types. Just make sure you can SSH into the controller machine.|
|- regions:|{ref}`TO BE ADDED]|
|- cloud-specific model configuration keys:|N/A|
|[CREDENTIAL <credential>`||
|definition:|Credentials should already have been set up via SSH. Nothing to do!|
|{ref}`CONTROLLER <controller>`||
|notes on bootstrap:|The machine that will be allocated to run the controller on is the one specified during the `add-cloud` step. <p>**If you encounter an error of the form "initializing ubuntu user: subprocess encountered error code 255 (ubuntu@{IP}: Permission denied (publickey).)":** <br> Edit your `~/.ssh/config` to include the following: <br> `Host <TARGET_IP_ADDRESS>` &nbsp;&nbsp;&nbsp;&nbsp; <br>&nbsp;&nbsp;&nbsp;&nbsp;`IdentityFile ~/.ssh/id_ed25519`<br> &nbsp;&nbsp;&nbsp;&nbsp; `ControlMaster no`<br> See more: https://bugs.launchpad.net/juju/+bug/2030507 |
|||
|||
|**other (alphabetical order:)**||
| {ref}`CONSTRAINT <constraint>`||
|conflicting:||
|supported?||
|- {ref}``allocate-public-ip` <1095md>`|&#10060;|
|- {ref}``arch` <1095md>`|:white_check_mark: <br> Valid values: For controller: `{ref}`host arch]`. For other machines: arch from machine hardware.|
|- [`container` <1095md>`|:white_check_mark:|
|- {ref}``cores` <1095md>`|:white_check_mark:|
|- {ref}``cpu-power` <1095md>`|&#10060;|
|- {ref}``image-id` <1095md>`|&#10060;  |
|- {ref}``instance-role` <1095md>`|&#10060;|
|- {ref}``instance-type` <1095md>`|&#10060;|
|- {ref}``mem` <1095md>`|:white_check_mark:|
|- {ref}``root-disk` <1095md>`|:white_check_mark:|
|- {ref}``root-disk-source` <1095md>`|&#10060;|
|- {ref}``spaces` <1095md>`|&#10060;|
|- {ref}``tags` <1095md>`|&#10060;|
|- {ref}``virt-type` <1095md>`|&#10060;|
|- {ref}``zones` <1095md>`|:white_check_mark:|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1095md>`|TBA|
|{ref}``subnet=...` <1095md>`|&#10060;  |
|{ref}``system-id=...` <1095md>`|&#10060;|
|{ref}``zone=...` <1095md>`|TBA|
|{ref}`MACHINE <machine>`|With any other cloud, the Juju client can trigger the creation of a backing machine (e.g. a cloud instance) as they become necessary. In addition, the client can also cause charmed operators to be deployed automatically onto those newly-created machines. However, with a Manual cloud the machines must pre-exist and they must also be specifically targeted during charmed operator deployment. <p> (Note: A MAAS cloud must also have pre-existing backing machines. However, Juju, by default, can deploy charmed operators onto those machines, or add a machine to its pool of managed machines, without any extra effort.) <p> Machines must be added manually, unless they are LXD. Example: <p>  `juju add-machine ssh:bob@10.55.60.93` <br> `juju add-machine lxd -n 2`<p> Further notes: <br> - Juju machines are always managed on a per-model basis. With a Manual cloud the `add-machine` process will need to be repeated if the model hosting those machines is destroyed. <br> -   To improve the performance of provisioning newly-added machines consider running an APT proxy or an APT mirror. See more: {ref}`Offline mode strategies <1095md>`. |
|{ref}`RESOURCE  (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.| N/A |

> <small>Contributors: @swalladge , @whershberger, @hmlanigan   </small>