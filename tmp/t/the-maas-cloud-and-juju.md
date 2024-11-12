(the-maas-cloud-and-juju)=
# The MAAS cloud and Juju

<!--To see the older HTG-style doc, see version 24. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > MAAS </small>

This document describes details specific to using your existing MAAS cloud with Juju. 

> See more: [MAAS](https://maas.io/) 

When using the MAAS cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1094md>` and (2) {ref}`not some other cloud <1094md>`. 

> See more: {ref}`Cloud differences in Juju <1094md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

|Juju points of variation|Notes for the MAAS cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`||
|supported versions:|Starting with `juju v.3.0`, versions of MAAS <2 are no longer supported.|
|requirements:|TBA|
|{ref}`definition: <1094md>`||
|- name:|user-defined|
|- type:|`maas`|
|- authentication types:|`{ref}`oauth1]`|
|- regions:|[TO BE ADDED]|
|- cloud-specific model configuration keys:|-|
|[CREDENTIAL <credential>`||
|definition:|`auth-type`: `oauth1`, which requires you to provide your `maas-oauth`, i.e., your MAAS API key. <br> <blockquote> See more: [`MAAS` \| How to add an API key for a user](https://maas.io/docs/how-to-manage-user-accounts#heading--api-key) </blockquote> |
|{ref}`CONTROLLER <controller>`||
|notes on bootstrap:|--|
|||
|||
|**other (alphabetical order:)**||
| {ref}`CONSTRAINT <constraint>`||
|conflicting:|TBA|
|supported?||
|- {ref}``allocate-public-ip` <1094md>`|&#10060;|
|- {ref}``arch` <1094md>`|:white_check_mark: <br> Valid values: See cloud provider.|
|- {ref}``container` <1094md>`|:white_check_mark:|
|- {ref}``cores` <1094md>`|:white_check_mark:|
|- {ref}``cpu-power` <1094md>`|&#10060;|
|- {ref}``image-id` <1094md>`|:white_check_mark: (Starting with Juju 3.2) <br> Type: String. <br> Valid values: An image name from MAAS.|
|- {ref}``instance-role` <1094md>`|&#10060;  |
|- {ref}``instance-type` <1094md>`|&#10060;|
|- {ref}``mem` <1094md>`|:white_check_mark:|
|- {ref}``root-disk` <1094md>`|:white_check_mark:|
|- {ref}``root-disk-source` <1094md>`|&#10060;|
|- {ref}``spaces` <1094md>`|:white_check_mark:|
|- {ref}``tags` <1094md>`|:white_check_mark:|
|- {ref}``virt-type` <1094md>`|&#10060;|
|- {ref}``zones` <1094md>`|:white_check_mark:|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1094md>`|TBA|
|{ref}``subnet=...` <1094md>`|&#10060;  |
|{ref}``system-id=...` <1094md>`|:white_check_mark:|
|{ref}``zone=...` <1094md>`|:white_check_mark: <br> If there's no '=' delimiter, assume it's a node name.|
|{ref}`MACHINE <machine>`||
|{ref}`RESOURCE  (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|&#10060;  |

<br>

> <small> **Contributors:** @anthonydillon, @jadonn, @pedroleaoc, @pmatulis, @sparkiegeek, @timclicks, @tmihoc, @toaksoy, @wallyworld </small>