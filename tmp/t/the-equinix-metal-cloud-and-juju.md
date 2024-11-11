(the-equinix-metal-cloud-and-juju)=
# The Equinix Metal cloud and Juju

<!--To see the older HTG-style doc, see version 14. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Equinix Metal </small>

This document describes details specific to using your existing Equinix Metal cloud with Juju. 

> See more: [Equinix Metal](https://deploy.equinix.com/developers/docs/metal/) 

When using the Equinix Metal cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <4988md>` and (2) {ref}`not some other cloud <4988md>`. 

> See more: {ref}`Cloud differences in Juju <4988md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

This document describes details specific to using your existing Equinix Metal cloud with Juju. 

> See more: [Equinix Metal](https://deploy.equinix.com/developers/docs/metal/) 

When using the Equinix Metal cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <4988md>` and (2) {ref}`not some other cloud <4988md>`. 

> See more: {ref}`Cloud differences in Juju <4988md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

|Juju points of variation|Notes for the Equinix Metal cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`||
|requirements:| TBA|
|{ref}`definition: <4988md>`|:information_source: Juju automatically defines a cloud of this type.|
|- name:|`equinix`|
|- type:|`equinix`|
|- authentication types:|`{ref}`project-id, api-token]`|
|- regions:|[TO BE ADDED]|
|- cloud-specific model configuration keys:|-|
|[CREDENTIAL <credential>`||
|definition:|`auth-type`: `access-key <br> > See more: [Equinix Metal \| API keys](https://deploy.equinix.com/developers/docs/metal/accounts/api-keys/) <p> **If you want to use a YAML file:** `credentials:` <br> &ensp;`equinix:` <br> &ensp;&ensp;`<user-defined credential name>:` <br> &ensp;&ensp;&ensp;`auth-type: access-key` <br> &ensp;&ensp;&ensp; `api-token: <key>` <br> &ensp;&ensp;&ensp; `project-id: <id>`|
|{ref}`CONTROLLER <controller>`||
|notes on bootstrap:|--|
|||
|||
|**other (alphabetical order:)**||
|{ref}`CONSTRAINT <constraint>`||
|conflicting:||
|{ref}``allocate-public-ip` <4988md>`|TBA|
|{ref}``arch` <4988md>`|TBA|
|{ref}``container` <4988md>`|TBA|
|{ref}``cores` <4988md>`|TBA|
|{ref}``cpu-power` <4988md>`|TBA|
|{ref}``instance-role` <4988md>`|:negative_squared_cross_mark:|
|{ref}``instance-type` <4988md>`|TBA|
|{ref}``mem` <4988md>`|TBA|
|{ref}``root-disk` <4988md>`|TBA|
|{ref}``root-disk-source` <4988md>`|TBA|
|{ref}``spaces` <4988md>`|:negative_squared_cross_mark:|
|{ref}``tags` <4988md>`|:negative_squared_cross_mark:|
|{ref}``virt-type` <4988md>`|TBA|
|{ref}``zones` <4988md>`|TBA|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <4988md>`|TBA|
|{ref}``subnet=...` <4988md>`|:negative_squared_cross_mark:|
|{ref}``system-id=...` <4988md>`|:negative_squared_cross_mark:|
|{ref}``zone=...` <4988md>`|TBA|
|{ref}`RESOURCE (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|:negative_squared_cross_mark:|


## Other notes

**Before deploying workloads to Equinix metal:** <br> Due to substrate limitations, the Equinix provider does not implement support for firewalls. As a result, workloads deployed to machines under the same project ID can reach each other even across Juju models. Deployed machines are always assigned both a public and a private IP address. This means that any deployed charms are implicitly exposed and proper access control mechanisms need to be implemented to prevent unauthorized access to the deployed workloads.