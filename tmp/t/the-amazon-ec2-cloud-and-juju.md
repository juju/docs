(the-amazon-ec2-cloud-and-juju)=
# The Amazon EC2 cloud and Juju

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Amazon EC2 </small>  


<!--To see the older HTG-style doc, see version 35. Note that it may be out-of-date. -->

This document describes details specific to using your existing Amazon EC2 cloud with Juju. 

> See more: [Amazon EC2](https://docs.aws.amazon.com/ec2/?icmpid=docs_homepage_featuredsvcs) 

When using the Amazon EC2 cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1084md>` and (2) {ref}`not some other cloud <1084md>`. 

> See more: {ref}`Cloud differences in Juju <1084md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

|Juju points of variation|Notes for the Amazon EC2 cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`| |
|requirements:| TBA|
|{ref}`definition: <1084md>`|:information_source: Juju automatically defines a cloud of this type.|
|- name:|`aws` or user-defined|
|- type:|`ec2`|
|- authentication types:|`[access-key, secret-key]`|
|- regions:|[TO BE ADDED]|
|- cloud-specific model configuration keys:|**`vpc-id`** (string) <br> Sets a specific AWS VPC ID. Optional. When not specified, Juju requires a default VPC or EC2-Classic features to be available for the account/region. :warning: If your AWS account was created before 04-12-2013: Your account does not have a default VPC. As a result, Juju may select a much larger instance type than what is required. To remedy this, create a [default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html). <p> **`vpc-id-force`** (boolean) <br> Forces Juju to use the AWS VPC ID specified with `vpc-id`, when it fails the minimum validation criteria. :warning: Not accepted without `vpc-id`. |
|{ref}`CREDENTIAL <credential>`||
|definition:	| `auth-type`: `access-key`,  which requires you to provide your access key and your secret key. See more: [Amazon \| AWS security credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) <p> **If you want to use a YAML file:** <p> `credentials:` <br> &ensp;`aws:` <br> &ensp;&ensp;`<user-defined credential name>:` <br> &ensp;&ensp;&ensp;`auth-type: access-key` <br> &ensp;&ensp;&ensp;`access-key: <key>` <br> &ensp;&ensp;&ensp;`secret-key: <key>` <p> **If you want to use environment variables:** <p> `AWS_ACCESS_KEY_ID="<id>"` <p> `AWS_SECRET_KEY_ID="<id>"`|
|{ref}`CONTROLLER <controller>`||
notes on bootstrap:	| You can authenticate the controller with the cloud using instance profiles: Use the cloud CLI to create an instance profile, then pass the instance profile to the controller during bootstrap via the `instance-role` constraint: `juju bootstrap --bootstrap-constraints="instance-role=<my instance profile>"`.  See more: `instance-role` below or {ref}`Discourse \| Using AWS instance profiles with Juju <1084md>`.|
|||
|||
|**other (alphabetical order:)**||
|{ref}`CONSTRAINT <constraint>`||
|conflicting:|`{ref}`instance-type]` vs. `[cores, cpu-power, mem]`|
|supported?||
|- [`allocate-public-ip` <1084md>`|:white_check_mark:|
|- {ref}``arch` <1084md>`|:white_check_mark:|
|- {ref}``container` <1084md>`|:white_check_mark:|
|- {ref}``cores` <1084md>`|:white_check_mark:|
|- {ref}``cpu-power` <1084md>`|:white_check_mark:|
|- {ref}``image-id` <1084md>`|:white_check_mark: (Starting with Juju 3.3) <br> Type: String. <br> Valid values: An AMI.|
|- {ref}``instance-role` <1084md>`|:white_check_mark: <br> Value: `auto` or an [instance profile](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) name. |
|- {ref}``instance-type` <1084md>`|:white_check_mark: <br> Valid values: See cloud provider. <br> Default value: `m3.medium`.|
|- {ref}``mem` <1084md>`|:white_check_mark:|
|- {ref}``root-disk` <1084md>`|:white_check_mark:|
|- {ref}``root-disk-source` <1084md>`|:white_check_mark:|
|- {ref}``spaces` <1084md>`|:white_check_mark:|
|- {ref}``tags` <1084md>`|&#10060;|
|- {ref}``virt-type` <1084md>`|&#10060;|
|- {ref}``zones` <1084md>`|:white_check_mark:|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1084md>`|:white_check_mark:|
|{ref}``subnet=...` <1084md>`|:white_check_mark:|
|{ref}``system-id=...` <1084md>`|:negative_squared_cross_mark:|
|{ref}``zone=...` <1084md>`|:white_check_mark: <br> If the query looks like a CIDR, then this will match subnets with the same CIDR. If it follows the syntax of a "subnet-XXXX", this will match the Subnet ID. Everything else is just matched as a Name.|
|{ref}`RESOURCE (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|:white_check_mark:|



<!--CLOUD DEF details. Removed because juju show-cloud aws --include-config already has the full list.

|definition in {ref}`File `clouds.yaml` <1084md>`:||
|&emsp;`.<cloud name>` | `aws`|
|&emsp; `..type`  | `ec2`|
|&emsp;`..auth-types`| `[access-key]` |
|&emsp;`..config` (cloud-specific) | **`vpc-id`** (string) <br> Sets a specific AWS VPC ID. Optional. When not specified, Juju requires a default VPC or EC2-Classic features to be available for the account/region. :warning: If your AWS account was created before 04-12-2013: Your account does not have a default VPC. As a result, Juju may select a much larger instance type than what is required. To remedy this, create a [default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html). <p> **`vpc-id-force`** (boolean) <br> Forces Juju to use the AWS VPC ID specified with `vpc-id`, when it fails the minimum validation criteria. :warning: Not accepted without `vpc-id`. |
-->