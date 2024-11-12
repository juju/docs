(the-google-gce-cloud-and-juju)=
# The Google GCE cloud and Juju

<!--To see the older HTG-style, see version 21. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Google GCE </small>

This document describes details specific to using your existing Google GCE cloud with Juju. 

> See more: [Google GCE](https://cloud.google.com/compute) 

When using the Google GCE cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1088md>` and (2) {ref}`not some other cloud <1088md>`. 

> See more: {ref}`Cloud differences in Juju <1088md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

|Juju points of variation|Notes for the Google GCE cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`||
|supported versions:||
|requirements:|Permissions: Service Account Key Admin, Compute Instance Admin, and Compute Security Admin. <br> See more: [Google \| Compute Engine IAM roles and permissions](https://cloud.google.com/compute/docs/access/iam).|
|{ref}`definition: <1088md>`|:information_source: Juju automatically defines a cloud of this type.|
|- name:|`google` or user-defined|
|- type:|`gce`|
|- authentication types:|`{ref}`oauth2, jsonfile`]|
|- regions:|[TO BE ADDED]|
|- cloud-specific model configuration keys:|**`base-image-path`** (string) <br> Sets the base path to look for machine disk images.|
|[CREDENTIAL <credential>`||
|definition:|`auth-type`: `jsonfile` or  `oauth2`  <br> > See more: [Google \| Authenticate to Compute Engine](https://cloud.google.com/compute/docs/authentication), [Google \| Create and delete service account keys](https://cloud.google.com/iam/docs/keys-create-delete#iam-service-account-keys-create-gcloud) <p> **If you want to use environment variables:** <p> - `CLOUDSDK_COMPUTE_REGION` <p> - `GOOGLE_APPLICATION_CREDENTIALS=<link to JSON credentials file>`|
|{ref}`CONTROLLER <controller>`||
|notes on bootstrap:|--|
|||
|||
|**other (alphabetical order:)**||
| {ref}`CONSTRAINT <constraint>`||
|conflicting:|`{ref}`instance-type]` vs. `[arch, cores, cpu-power, mem]`|
|supported?||
|- [`allocate-public-ip` <1088md>`|:white_check_mark:|
|- {ref}``arch` <1088md>`|:white_check_mark:|
|- {ref}``container` <1088md>`|:white_check_mark:|
|- {ref}``cores` <1088md>`|:white_check_mark:|
|- {ref}``cpu-power` <1088md>`|:white_check_mark:|
|- {ref}``image-id` <1088md>`|&#10060;  |
|- {ref}``instance-role` <1088md>`|&#10060;|
|- {ref}``instance-type` <1088md>`|:white_check_mark:|
|- {ref}``mem` <1088md>`|:white_check_mark:|
|- {ref}``root-disk` <1088md>`|:white_check_mark:|
|- {ref}``root-disk-source` <1088md>`|&#10060;|
|- {ref}``spaces` <1088md>`|&#10060;|
|- {ref}``tags` <1088md>`|&#10060;|
|- {ref}``virt-type` <1088md>`|&#10060;|
|- {ref}``zones` <1088md>`|:white_check_mark:|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1088md>`|TBA|
|{ref}``subnet=...` <1088md>`|&#10060;  |
|{ref}``system-id=...` <1088md>`|&#10060;|
|{ref}``zone=...` <1088md>`|:white_check_mark:|
|{ref}`MACHINE <machine>`||
|{ref}`RESOURCE  (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|&#10060;|