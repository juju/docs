Title: Help with Amazon Web Service clouds

# Using the Amazon Web Service public cloud

Juju already has knowledge of the AWS cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. AWS
will appear in the list of known clouds when you issue the command:
  
```bash
juju clouds
```
And you can see more specific information (e.g. the supported regions) by 
running:
  
```bash
juju show-cloud aws
```

If at any point you believe Juju's information is out of date (e.g. Amazon just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Credentials

In order to access AWS, you will need to add some credentials for Juju to use.
These can easily be set by either:
  
### 1. Using environment variables

If you already use your AWS account with other tools, you may find that the 
environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are 
already set. Note that the the additional fallback environment variables
`AWS_ACCESS_KEY` and `AWS_SECRET_KEY` are also supported.

These can easily be imported into Juju. Run the command:
  
```bash
juju autoload-credentials
```
This will scan known locations and environment variables for cloud credentials
and ask which ones to use/what name to store them under.

### 2. Manually adding credentials

Amazon recommends the use of [IAM][iam] (Identity and Access Management) to
control access to AWS services and resources. IAM enables you to create users
and groups with specific access rights and permissions, much like users and
groups within a Unix-like environment. This is in contrast to the AWS-wide
access that comes with using root-level secret keys.

To create both a user and a group for use with Juju, click on your name from
the AWS Management Console at [http://console.aws.amazon.com][aws] and select
"My Security Credentials" from the drop-down menu.

![Amazon accounts page with Security Creds](./media/getting_started-aws_security.png)

Unless already disabled, a warning will appear, notifying you that any
generated account credentials will provide unlimited access to your AWS
resources.

Click on "Get Started with IAM Users" and click "Add user" to initiate user
creation.

![Amazon IAM set user details](./media/getting_started-aws_newuser.png)

Enter a name for your user and set `Programmatic access` as the AWS access type
before clicking "Next: Permissions" to continue. 

On the next page you can create a group which by default will contain your new
user. Give the group a name and enable `AdministratorAccess`, or adequate
access that corresponds to your requirements and security policies. 

![Amazon IAM group creation](./media/getting_started-aws_groups.png)

Click the "Create group" button and you'll see an overview of both the new
user and the group details. Click "Create user" to accept these details.

The next page will declare user creation a success and include both the 
`Access key ID` and the `Secret access key` for your new user, as well as the
option to download these details as an CSV.

![Amazon Access Credentials page showing key values](./media/getting_started-aws_credentials-csv.png)

Armed with these values, you can then use the interactive command line tool to 
add them to Juju:
  
```bash
juju add-credential aws
```

Alternately, you can also use this credential with [Juju as a Service][jaas] and
create and deploy your model using its GUI.

### 3. Create and use a YAML file

Place the AWS information in a `~/.aws/credentials` file, or
`%USERPROFILE%/.aws/credentials` on Windows. The file will contain YAML
formatted information.

See [Cloud credentials](./credentials.html) for more about adding
credentials from a YAML file.

## Bootstrap

To create the controller for AWS, you then need to run:

```bash
juju bootstrap aws mycloud
```

That's it!


## AWS specific features

Features supported by Juju-owned instances running within AWS:

- Consistent naming, tagging, and the ability to add user-controlled tags to
  created instances. See [Instance naming and tagging][tagging] for
  more information.

- Juju deploys to what Amazon refers to as *m3.medium* instances by default. you
  can specify different instance types by using [constraints][constraints].

- You can create a new model in a specific virtual private cloud (VPC) from the
  command line using the `vpc-id`: `juju add-model --config vpc-id=<id>`.
  

[aws]: http://console.aws.amazon.com
[iam]: https://aws.amazon.com/iam/
[constraints]:./reference-constraints.html
[jaas]: ./getting-started.html "Getting Started with Juju as a Service"
[tagging]: ./config-tagging.html
