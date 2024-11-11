(the-lxd-cloud-and-juju)=
# The LXD cloud and Juju

<!--To see the older HTG-style doc, see version 39. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > LXD </small>

<!--
LXD is a hypervisor that provides system containers that are secure, lightweight, and easy to use. When your computer has LXD installed, Juju can operate the `localhost` cloud.  
-->

This document describes details specific to using your existing LXD cloud with Juju. 

----
```{dropdown} Expand to view how to get a LXD cloud quickly on Ubuntu


Your Ubuntu likely comes with LXD preinstalled. Configure it as below. Juju will then recognize it as the `localhost` cloud.

```text
lxd init --auto
lxc network set lxdbr0 ipv6.address none
```

```
---
> See more: [LXD](https://documentation.ubuntu.com/lxd/en/latest/) 

When using the LXD cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1093md>` and (2) {ref}`not some other cloud <1093md>`. 

> See more: {ref}`Cloud differences in Juju <1093md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

---
```{dropdown} Expand to view some reasons to use a LXD cloud

The LXD cloud, especially when used locally, is great for: <p> - creating a repeatable deployment: Juju enables you to quickly iterate to construct the optimal deployment for your situation, then distribute that across your team <p> -- local development: Juju's localhost cloud can mirror the production ops environment (without incurring the costs involved with duplicating it) <p> - learning Juju: LXD is a lightweight tool for exploring Juju and how it operates <p> - rapid prototyping: LXD is great for when you're creating a new charm and want to be able to quickly provision capacity and tear it down 

```

----
```{dropdown} Expand to find out why Docker wouldn't work

Juju expects to see an operating system-like environment, so a LXD system container fits the bill. Docker containers are laid out for a singular application process, with a self-contained filesystem rather than a base userspace image.

```
-----



|Juju points of variation|Notes for the LXD cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`||
|supported versions:|Juju `2.9.x`: LXD `5.0`<p> Juju `3.x.x`: LXD `5.x`|
|requirements:|TBA|
|{ref}`definition: <1093md>`|:information_source: Juju automatically defines a cloud of this type.|
|- name:|`localhost` or user-defined|
|- type:|`lxd`|
|- authentication types:|`{ref}`certificate, interactive]`|
|- regions:|[TO BE ADDED]|
|- cloud-specific model configuration keys:|**project** (string) <br> The LXD project name to use for Juju's resources.|
|[CREDENTIAL <credential>`||
|definition:|**local LXD cloud:** If you are a Juju admin user: Already known to Juju. Run `juju bootstrap`, then `juju credentials` to confirm. (Pre-defined credential name in Juju: `localhost`.) Otherwise: Add manually as you would a remote. <p> **clustered LXD cloud**: In Juju, this counts as a remote cloud. You must add its definition to Juju explicitly. <p> **remote LXD cloud:** Requires the API endpoint URL for the remote LXD server.  <br> > See more: [LXD \| How to add remote servers](https://documentation.ubuntu.com/lxd/en/latest/remotes/) <p> **If you want to use a YAML file:**  <p> (Pro tip: If you define a trust password, you can just use a `trust-password` key, and that will retrieve the certificates for you.) <p> `credentials:` <br> &ensp;`<user-defined cloud name>:` <br> &ensp;&ensp; `<user-defined credential name>:` <br> &ensp;&ensp;&ensp; `auth-type: certificate`<br> &ensp;&ensp;&ensp; `client-key: \|` <br>&ensp;&ensp;&ensp;&ensp; `-----BEGIN RSA PRIVATE KEY---` <br> &ensp;&ensp;&ensp;&ensp; `<content-of-rsa-private-key>` <br> &ensp;&ensp;&ensp;&ensp; `-----END RSA PRIVATE KEY-----` <br> &ensp;&ensp;&ensp; `client-cert: \|` <br> &ensp;&ensp;&ensp;&ensp; `-----BEGIN CERTIFICATE-----` <br> &ensp;&ensp;&ensp;&ensp; `<content-of-certificate>` <br> &ensp;&ensp;&ensp;&ensp; `-----END CERTIFICATE-------` <br> &ensp;&ensp;&ensp; `server-cert: \|` <br> &ensp;&ensp;&ensp;&ensp; `-----BEGIN CERTIFICATE-----` <br> &ensp;&ensp;&ensp;&ensp; `<content of certificate>` <br> &ensp;&ensp;&ensp;&ensp; `-----END CERTIFICATE-------`     |
|{ref}`CONTROLLER <controller>`||
|notes on bootstrap:|--|
|||
|||
|**other (alphabetical order:)**||
| {ref}`CONSTRAINT <constraint>`|With LXD system containers, constraints are interpreted as resource *maximums* (as opposed to *minimums*). <p> There is a 1:1 correspondence between a Juju machine and a LXD container. Compare `juju machines` and `lxc list`.|
|conflicting:|TBA|
|supported?||
|- {ref}``allocate-public-ip` <1093md>`|&#10060;|
|- {ref}``arch` <1093md>`|:white_check_mark: <br> Valid values: `{ref}`host arch]`.|
|- [`container` <1093md>`|&#10060;|
|- {ref}``cores` <1093md>`|:white_check_mark:|
|- {ref}``cpu-power` <1093md>`|&#10060;|
|- {ref}``image-id` <1093md>`|&#10060;  |
|- {ref}``instance-role` <1093md>`|&#10060;|
|- {ref}``instance-type` <1093md>`||
|- {ref}``mem` <1093md>`|The maximum amount of memory that a machine/container will have.|
|- {ref}``root-disk` <1093md>`||
|- {ref}``root-disk-source` <1093md>`|:white_check_mark: <br> `root-disk-source` is the LXD storage pool for the root disk. The default LXD storage pool is used if root-disk-source is not specified.|
|- {ref}``spaces` <1093md>`|&#10060;|
|- {ref}``tags` <1093md>`|&#10060;|
|- {ref}``virt-type` <1093md>`|&#10060;|
|- {ref}``zones` <1093md>`|&#10060;|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1093md>`|TBA|
|{ref}``subnet=...` <1093md>`|&#10060;  |
|{ref}``system-id=...` <1093md>`|&#10060;|
|{ref}``zone=...` <1093md>`|:white_check_mark: <br> If there's no '=' delimiter, assume it's a node name.|
|{ref}`MACHINE <machine>`||
|{ref}`RESOURCE  (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|&#10060;  |



## Other notes



<a href="#heading--simple-bootstrap-of-a-remote-lxd-server"><h3 id="heading--simple-bootstrap-of-a-remote-lxd-server">Simple bootstrap of a remote LXD server</h3></a>

From Juju 2.9.5, the easiest method for bootstrapping a remote LXD server is to add the remote to your local LXC config then bootstrap with `juju`.

On the remote server:
```bash
# ensure the LXD daemon is listening on an accessible IP
lxc config set core.https_address '{ref}`::]'
# give the LXD daemon a trust password so the client can register credentials
lxc config set core.trust_password mytrustpassword
```

On the bootstrapping client:
```bash
# add the remote LXD server to the local LXC config
lxc remote add myremote 11.22.33.44 --password mytrustpassword
# bootstrap juju using the remote name in LXC
juju bootstrap myremote
```

```{note}
The bootstrapping client must be able to reach the remote LXD containers. This may require the setup of a bridge device with the hosts ethernet device.
```

<!--
For more advanced setup of LXD with clusters and using Juju remotely see [Using LXD with Juju - Advanced <1093md>`. 
-->

<a href="#heading--non-admin-user-credentials"><h3 id="heading--non-admin-user-credentials">Non-admin user credentials</h3></a>


See {ref}`Credentials <how-to-manage-credentials>` for more details on how Juju credentials are used to share a bootstrapped controller.

To share a LXD server with other users on the same machine or remotely, the best method is to use LXC remotes. See [Simple bootstrap of a remote LXD server](https://discourse.charmhub.io/t/lxd/1093#heading--simple-bootstrap-of-a-remote-lxd-server) above.

<a href="#heading--add-resilience-via-lxd-clustering"><h3 id="heading--add-resilience-via-lxd-clustering">Add resilience via LXD clustering</h3></a>


LXD clustering provides the ability for applications to be deployed in a high-availability manner. In a clustered LXD cloud, Juju will deploy units across its nodes. For more, see [Using LXD clustering with Juju](https://discourse.charmhub.io/t/using-lxd-clustering-with-juju/1091).

<a href="#heading--use-lxd-profiles-from-a-charm"><h3 id="heading--use-lxd-profiles-from-a-charm">Use LXD profiles from a charm</h3></a>


LXD Profiles allows the definition of a configuration that can be applied to any instance. Juju can apply those profiles during the creation or modification of a LXD container. For more, see [Using LXD profiles with Juju](https://discourse.charmhub.io/t/using-lxd-profiles-with-juju/4453).

<a href="#heading--lxd-images"><h3 id="heading--lxd-images">LXD images</h3></a>


LXD is image based: All LXD containers come from images and any LXD daemon instance (also called a "remote") can serve images. When LXD is installed a locally-running remote is provided (Unix domain socket) and the client is configured to talk to it (named 'local'). The client is also configured to talk to several other, non-local, ones (named 'ubuntu', 'ubuntu-daily', and 'images').

An image is identified by its fingerprint (SHA-256 hash), and can be tagged with multiple aliases.

For any image-related command, an image is specified by its alias or by its fingerprint. Both are shown in image lists. An image's *filename* is its *full* fingerprint, while an image *list* displays its *partial* fingerprint. Either type of fingerprint can be used to refer to images.

Juju pulls official cloud images from the 'ubuntu' remote (http://cloud-images.ubuntu.com) and creates the necessary alias. Any subsequent requests will be satisfied by the LXD cache (`/var/lib/lxd/images`).

Image cache expiration and image synchronization mechanisms are built-in.

<br>

**Contributors: @barryprice , @danieleprocida , @hpidcock, @jameinel , @pedroleaoc , @pmatulis , @timClicks , @tmihoc**