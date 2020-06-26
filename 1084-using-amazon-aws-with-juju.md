<!--
Todo:
- Consider the aws cli tool
-->

## Overview

To manage workloads on Amazon AWS, there are three steps:

1. Create an IAM User account with the ability to modify EC2 resources
2. Use `juju add-credential` to register that account with Juju
3. Create a Juju controller


<h2 id="heading--gathering-credential-information">Create an AWS user account</h2>

### Log in to the AWS console

Visit the [AWS Management Console](http://console.aws.amazon.com) and log in.

### Create a user account with full EC2 access

Select <kbd>My Security Credentials</kbd> from the drop-down menu:

![AWS credentials drop-down](https://assets.ubuntu.com/v1/b8c092cd-getting_started-aws_security2.png)

If you see a pop-up with the button "Get Started with IAM Users" go ahead and click on it and then "Add user". If you do not see such a pop-up then, in the top bar, choose <kbd>Services</kbd> &gt; <kbd>IAM</kbd> &gt; <kbd>Users</kbd> &gt; <kbd>Add user</kbd>:

![AWS IAM set user details](https://assets.ubuntu.com/v1/90a979b4-getting_started-aws_newuser2.png)

Enter a name for your user and set **Programmatic access** as the AWS access type before clicking <kbd>Next: Permissions</kbd> to continue.

On the next page create a group which, by default, will contain your new user. Name the group and select one or many pre-existing policies that correspond to your requirements. The  [AmazonEC2FullAccess](https://console.aws.amazon.com/iam/home#policies/arn:aws:iam::aws:policy/AmazonEC2FullAccess) policy will be sufficient for most use cases.  

Here we've chosen AdministratorAccess, which is the most privileged policy available. This could be useful if we wish to use the `juju trust` to allow charms to provision any  AWS service later on.

![AWS IAM group creation](https://assets.ubuntu.com/v1/17a687c6-getting_started-aws_groups.png)

Click the <kbd>Create group</kbd> button and then <kbd>Next: Tags</kbd>. Tags are optional is skipped here by clicking <kbd>Next: Review</kbd> straight away. On the next page click <kbd>Create user</kbd>. 

Successfully creating a new user results in a Success message appear:

![AWS IAM user csv](https://assets.ubuntu.com/v1/c7a1cf49-getting_started-aws_credentials-csv2.png)

### Download credentials for Juju registration

Click on the <kbd>Download .csv</kbd> button to get a copy of this account's security credentials. The contents of this file will look similar to this:

``` text
jlaurin,,AKIAIFII8EH5BOCYSJMA,WXg6S5Y1DvwuGt72LwzLKnItt+GRwlkn668sXHqq,https://466421367158.signin.aws.amazon.com/console
```


<h2 id="heading--adding-credentials">Adding credentials</h2>

There are multiple methods for adding security credentials to Juju. Each processwill require two fields from the CSV file that you downloaded from the user account (Hyphens indicate that the field is unnecessary). 

``` text
-,-,<access-key>,<secret-key>,-
```

Alternately, you can use your credentials with [Juju as a Service](/t/getting-started-with-juju/1134), where charms can be deployed within a graphical environment that comes equipped with a ready-made controller.


<h3 id="heading--using-the-interactive-method">Using the interactive method</h3>

Credentials can be added with the `juju add-credential` command:

``` text
juju add-credential aws
```

An example session:

``` text
Enter credential name: jlaurin

Using auth-type "access-key".

Enter access-key: AKIAIFII5EH5FOCYZJMA

Enter secret-key: ******************************

Credential "jlaurin" added locally for cloud "aws".
```

<h3 id="heading--using-a-file">Using a file</h3>

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential information for any cloud. This information is then added to Juju by pointing the `add-credential` command to the file:

``` text
juju add-credential aws -f mycreds.yaml
```

See section [Adding credentials from a file](/t/credentials/1112#heading--adding-credentials-from-a-file) for guidance on what such a file looks like.

<h3 id="heading--using-environment-variables">Using environment variables</h3>

With AWS you have the option of adding credentials using the following environment variables that may already be present (and set) on your client system:

`AWS_ACCESS_KEY_ID`
`AWS_SECRET_ACCESS_KEY`

Add this credential information to Juju in this way:

``` text
juju autoload-credentials
```

For any found credentials you will be asked which ones to use and what name to store them under.

On Linux systems, files `$HOME/.aws/credentials` and `$HOME/.aws/config` may be used to define these variables and are parsed by the above command as part of the scanning process.

For background information on this method read section [Adding credentials from environment variables](/t/credentials/1112#heading--adding-credentials-from-environment-variables).

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'aws':

``` text
juju bootstrap aws aws-controller
```

Above, the name given to the new controller is 'aws-controller'. AWS will provision an instance to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

<h2 id="heading--aws-specific-features">AWS specific features</h2>

### Awareness of regions and instance types

Juju contains built-in knowledge of AWS regions, instance types and their capabilities.

``` text
juju show-cloud --local aws
```

Replacing the `--local` option with `--controller` to report regions known to a controller. 

Use `juju update-public-clouds` to update Juju's knowledge of new AWS regions as they are available.

### Custom tags

 Consistent naming, tagging, and the ability to add user-controlled tags to created instances. See [Instance naming and tagging](/t/instance-naming-and-tagging-in-clouds/1102) for more information.

### Instance type selection

 Juju's default AWS instance type is *m3.medium*. A different type can be selected via a constraint: `juju add-machine --constraints 'instance-type=t2.medium'`. For more information see [Constraints](/t/juju-constraints/1160). You can also view the list of [Amazon EC2 instance types](https://aws.amazon.com/ec2/instance-types/).

### Support for Virtual Private Cloud (VPC) functionality

A controller can be placed in a specific *virtual private cloud* (VPC). See [Passing a cloud-specific setting](/t/creating-a-controller/1108#heading--passing-a-cloud-specific-setting) for instructions.

[note status="Important note for AWS accounts created before 2013-12-04"]
These accounts do not have a default VPC. Juju may select a much larger instance type than what is required. To remedy this, create a [default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html) for your AWS account.
[/note]

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
