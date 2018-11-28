Title: Using Amazon AWS with Juju
TODO:  Review required (use style from the other cloud pages)

# Using Amazon AWS with Juju

Juju already has knowledge of the AWS cloud, which means adding your AWS
account to Juju is quick and easy.

You can see more specific information on Juju's AWS support (e.g. the
supported regions) by running:

```bash
juju show-cloud aws
```

If at any point you believe Juju's information is out of date (e.g. AWS just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Gathering credential information

Amazon recommends the use of [IAM][iam] (Identity and Access Management) to
control access to AWS services and resources. IAM enables you to create users
and groups with specific access rights and permissions, much like users and
groups within a Unix-like environment. This is in contrast to the AWS-wide
access that comes with using root-level secret keys.

To create both a user and a group for use with Juju, click on your name from
the AWS Management Console at [http://console.aws.amazon.com][aws] and select
"My Security Credentials" from the drop-down menu.

![Amazon accounts page with Security Creds](https://assets.ubuntu.com/v1/70391c31-getting_started-aws_security.png)

Unless already disabled, a warning will appear, notifying you that any
generated account credentials will provide unlimited access to your AWS
resources.

Click on "Get Started with IAM Users" and click "Add user" to initiate user
creation.

![Amazon IAM set user details](https://assets.ubuntu.com/v1/7dfba4c7-getting_started-aws_newuser.png)

Enter a name for your user and set `Programmatic access` as the AWS access type
before clicking "Next: Permissions" to continue. 

On the next page you can create a group which, by default, will contain your
new user. Give the group a name and enable `AdministratorAccess`, or adequate
access that corresponds to your requirements and security policies. 

![Amazon IAM group creation](https://assets.ubuntu.com/v1/17a687c6-getting_started-aws_groups.png)

Click the "Create group" button and you'll see an overview of both the new
user and the group details. Click "Create user" to accept these details.

The next page will declare user creation a success and include both the 
`Access key ID` and the `Secret access key` for your new user, as well as the
option to download these details as an CSV.

![Amazon Access Credentials page showing key values](https://assets.ubuntu.com/v1/8313c002-getting_started-aws_credentials-csv.png)

## Adding credentials

The [Cloud credentials][credentials] page offers a full treatment of credential
management.

In order to access AWS, you will need to add credentials to Juju. This can be
done in one of three ways.

### Using the interactive method

Armed with the gathered information, you can add credentials with the command:

```bash
juju add-credential aws
```

The command will interactively prompt you for the information needed for the
chosen cloud.

Alternately, you can use these credentials with [Juju as a Service][jaas] where
you can deploy charms using a web GUI.

### Using a file

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential
information for any cloud. This information is then added to Juju by pointing
the `add-credential` command to the file:

```bash
juju add-credential aws -f mycreds.yaml
```

See section [Adding credentials from a file][credentials-adding-from-file] on
the Credentials page for guidance on what such a file looks like.

### Using environment variables

With AWS you have the option of adding credentials using the following
environment variables that may already be present (and set) on your client
system:

`AWS_ACCESS_KEY_ID`  
`AWS_SECRET_ACCESS_KEY`

Add this credential information to Juju in this way:
  
```bash
juju autoload-credentials
```

For any found credentials you will be asked which ones to use and what name to
store them under.

On Linux systems, files `$HOME/.aws/credentials` and `$HOME/.aws/config` may be
used to define these variables and are parsed by the above command as part of
the scanning process.

For background information on this method read section
[Adding credentials from environment variables][credentials-adding-from-variables].

## Creating a controller

You are now ready to create a Juju controller for cloud 'aws':

```bash
juju bootstrap aws aws-controller
```

Above, the name given to the new controller is 'aws-controller'. AWS will
provision an instance to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

## AWS specific features

Features supported by Juju-owned instances running within AWS:

- Consistent naming, tagging, and the ability to add user-controlled tags to
  created instances. See [Instance naming and tagging][tagging] for
  more information.

- Juju's default AWS instance type is *m3.medium*. A different type can be
  selected via a constraint:
  `juju add-machine --constraints 'instance-type=t2.medium'`. For more
  information see [Constraints][constraints]. You can also view the list of
  [Amazon EC2 instance types][aws-instance-types].

- A controller can be placed in a specific *virtual private cloud* (VPC). See
  [Passing a cloud-specific setting][controllers-creating-include-config] for
  instructions.

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[aws]: http://console.aws.amazon.com
[iam]: https://aws.amazon.com/iam/
[constraints]:./reference-constraints.md
[jaas]: ./getting-started.md
[tagging]: ./config-tagging.md
[aws-instance-types]: https://aws.amazon.com/ec2/instance-types/
[controllers-creating-include-config]: ./controllers-creating.md#passing-a-cloud-specific-setting
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
[credentials]: ./credentials.md
[credentials-adding-from-variables]: ./credentials.md#adding-credentials-from-environment-variables
[credentials-adding-from-file]: ./credentials.md#adding-credentials-from-a-file
