(the-oracle-oci-cloud-and-juju)=
# The Oracle OCI cloud and Juju

<!--To see the older HTG-style doc, see version 20. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Oracle OCI </small>

This document describes details specific to using your existing Oracle OCI cloud with Juju. 

> See more: [Oracle OCI](https://docs.oracle.com/en-us/iaas/Content/home.htm) 

When using the Oracle OCI cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1096md>` and (2) {ref}`not some other cloud <1096md>`. 

> See more: {ref}`Cloud differences in Juju <1096md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

|Juju points of variation|Notes for the Oracle OCI cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`||
|supported versions:||
|requirements:||
|{ref}`definition: <1096md>`|:information_source: Juju automatically defines a cloud of this type.|
|- name:|`oracle` or user-defined|
|- type:|`oci`|
|- authentication types:|`{ref}`httpsig]`|
|- regions:|[TO BE ADDED]|
|- cloud-specific model configuration keys:|**`address-space`** (string) <br> The CIDR block to use when creating default subnets. The subnet must have at least a /16 size. <p> **`compartment-id`** (string) <br> The OCID of the compartment in which juju has access to create resources.<br>|
|[CREDENTIAL <credential>`||
|definition:| :warning: Starting with Juju 3.3.1, the region field is ignored. <p> `auth-type`: `httpsig`. You will be asked to provide your SSL private key fingerprint, SSL private key, a cloud region, your SSL private key passphrase, and your user, tenancy, and compartment OCID. <br> > See more: [Oracle OCI `|` Account and access concepts](https://docs.oracle.com/en-us/iaas/Content/GSG/Concepts/concepts-account.htm) <p> **If you want to use a YAML file:** <p> `credentials:` <br> &ensp;`oracle:` <br> &ensp;&ensp;`<user-defined credential name>:` <br> &ensp;&ensp;&ensp;`auth-type: httpsig` <br> &ensp;&ensp;&ensp;`fingerprint: <SSL private key fingerprint>` <br>&ensp;&ensp;&ensp;`key: <SSL private key>`<br> &ensp;&ensp;&ensp;`region: <cloud region>` <br>&ensp;&ensp;&ensp;`pass-phrase: <SSL private key passphrase>` <br> &ensp;&ensp;&ensp;`tenancy: <tenancy OCID>` <br> &ensp;&ensp;&ensp;`user: <user OCID>`|
|{ref}`CONTROLLER <controller>`||
|notes on bootstrap:|You have to specify the compartment OCID via the cloud-specific `compartment-id` model configuration key (see below). <br> Example: `juju bootstrap --config compartment-id=<compartment OCID> oracle oracle-controller`|
|**other (alphabetical order:)**||
|{ref}`CONSTRAINT <constraint>`||
|conflicting:|TBA|
|supported?||
|- {ref}``allocate-public-ip` <1096md>`||
|- {ref}``arch` <1096md>`|:white_check_mark: <br> Valid values: `{ref}`amd64, arm64]`.|
|- [`container` <1096md>`|&#10060;|
|- {ref}``cores` <1096md>`|:white_check_mark:|
|- {ref}``cpu-power` <1096md>`|:white_check_mark:|
|- {ref}``image-id` <1096md>`|&#10060;|
|- {ref}``instance-role` <1096md>`|&#10060;|
|- {ref}``instance-type` <1096md>`|:white_check_mark:|
|- {ref}``mem` <1096md>`|:white_check_mark:|
|- {ref}``root-disk` <1096md>`|:white_check_mark:|
|- {ref}``root-disk-source` <1096md>`|&#10060;|
|- {ref}``spaces` <1096md>`|&#10060;|
|- {ref}``tags` <1096md>`|&#10060;|
|- {ref}``virt-type` <1096md>`|&#10060;|
|- {ref}``zones` <1096md>`|:white_check_mark:|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1096md>`|TBA|
|{ref}``subnet=...` <1096md>`|&#10060;|
|{ref}``system-id=...` <1096md>`|&#10060;|
|{ref}``zone=...` <1096md>`|TBA|
|{ref}`MACHINE <machine>`||
|{ref}`RESOURCE (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|&#10060;  |