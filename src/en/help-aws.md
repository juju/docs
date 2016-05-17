Title: Help with Amazon Web Service clouds

# Using the Amazon Web Service public cloud

Juju already has knowledge of the AWS cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. AWS
will appear in the list of known clouds when you issue the command:
  
```bash
juju list-clouds
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
already set.

These can easily be imported into Juju. Run the command:
  
```bash
juju autoload-credentials
```
This will scan known locations and environment variables for cloud credentials
and ask which ones to use/what name to store them under.

### 2. Manually adding credentials

You can retrieve the values for the Access key and Secret Key easily from your 
AWS Management Console at
[http://console.aws.amazon.com][aws]. Click on your
name in the top-right and then the "Security Credentials" link from the drop
down menu.

![Amazon accounts page with Security Creds](./media/getting_started-aws_security.png)

Under the "Access Keys" heading click the "Create New Root Key" button. You
will be prompted to "Download Key File" which by default is named rootkey.csv.
Open this file to get the **access-key** and **secret-key**.

![Amazon Access Credentials page showing key values](./media/getting_started-aws_keys.png)
.
Armed with these values, you can then use the interactive command line tool to 
add them to Juju:
  
```bash
juju add-credential aws
```



## Bootstrap

To create the controller for AWS, you then need to run:

```bash
juju bootstrap mycloud aws
```

That's it!


## AWS specific features

Features supported by Juju-owned instances running within AWS:

- Consistent naming, tagging, and the ability to add user-controlled tags to
  created instances. See [Instance naming and tagging][tagging] for
  more information.

- Juju deploys to what Amazon refers to as *m3.medium* instances by default. you
  can specify different instance types by using [constraints][constraints].
  

[aws]: http://console.aws.amazon.com
[constraints]:./reference-constraints.html
[tagging]: ./config-tagging.html
