Title: Configuring Juju for Amazon Web Services

# Configuring for Amazon Web Services

This process requires you to have an Amazon Web Services (AWS) account. If you
have not signed up for one yet, it can obtained at
[http://aws.amazon.com](http://aws.amazon.com).

You should start by generating a generic configuration file for Juju, using the
command:

```bash
juju generate-config
```

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

**Note:** If you have an existing configuration, you can use `juju
generate-config --show` to output the new config file, then copy and paste
relevant areas in a text editor etc.

The generic configuration sections generated for AWS will look something like
this:

```yaml
# https://jujucharms.com/docs/config-aws.html
    amazon:
        type: ec2
        # region specifies the EC2 region. It defaults to us-east-1.
        #
        # region: us-east-1
        # access-key holds the EC2 access key. It defaults to the
        # environment variable AWS_ACCESS_KEY_ID.
        #
        # access-key: <secret>
        # secret-key holds the EC2 secret key. It defaults to the
        # environment variable AWS_SECRET_ACCESS_KEY.
        #
        # secret-key: <secret>
        # image-stream chooses a simplestreams stream to select OS images
        # from, for example daily or released images (or any other stream
        # available on simplestreams).
        #
        # image-stream: "released"
```

This is a simple configuration intended to run on EC2 with S3 permanent
storage. Values for the default setting can be changed simply by editing this
file, uncommenting the relevant lines and adding your own settings. All you
need to do to get this configuration to work is to either set the
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` via environment variables, or
uncomment and add the values to the configuration file.

You can retrieve these values easily from your AWS Management Console at
[http://console.aws.amazon.com](http://console.aws.amazon.com). Click on your
name in the top-right and then the "Security Credentials" link from the drop
down menu.

![Amazon accounts page with Security Creds](./media/getting_started-aws_security.png)

Under the "Access Keys" heading click the "Create New Root Key" button. You
will be prompted to "Download Key File" which by default is named rootkey.csv.
Open this file to get the **access-key** and **secret-key** for the
`environments.yaml` file.

![Amazon Access Credentials page showing key values](./media/getting_started-aws_keys.png)

The **region:** value corresponds to the AWS regions.

By default, Juju will deploy units to m1.small instances, unless otherwise constrained.

## AWS specific features

Features supported by Juju-owned instances running within AWS:

- Consistent naming, tagging, and the ability to add user-controlled tags to
  created instances. See [Instance naming and tagging](config-tagging.html) for
  more information.

- The selection (placement) of availability zones, if existing, when adding a
  machine:

```bash
juju machine add zone=us-east-1a
```


## Additional notes

See [General config options](config-general.html) for additional and advanced
customization of your environment.
