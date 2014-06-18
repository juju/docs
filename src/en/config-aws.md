# Configuring for Amazon Web Services

This process requires you to have an Amazon Web Services (AWS) account. If you
have not signed up for one yet, it can obtained at
[http://aws.amazon.com](http://aws.amazon.com).

You can configure Juju for use with AWS by issuing the following command:

    juju quickstart -i

And follow the instructions for generating a config for AWS by scrolling down
to "Create a new environment" and selecting "new Amazon EC2 environment" and
then fill in the appropriate fields.

You can also generate a generic configuration file for Juju, using the
command:

    juju generate-config

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

**Note:** If you have an existing configuration, you can use `juju generate-config --show` to output the new config file, then copy and paste relevant areas in a text editor etc.

The generic configuration sections generated for AWS will look something like
this:

    # https://juju.ubuntu.com/docs/config-aws.html
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

This is a simple configuration intended to run on EC2 with S3 permanent storage. Values for the default setting can be changed simply by editing this file, uncommenting the relevant lines and adding your own settings. All you need to do to get this configuration to work is to either set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` via environment variables, or uncomment and add the values to the configuration file.

You can retrieve these values easily from your AWS Management Console at
[http://console.aws.amazon.com](http://console.aws.amazon.com). Click on your
name in the top-right and then the "Security Credentials" link from the drop
down menu.

![Amazon accounts page with Security Creds](./media/getting_started-aws_security.png)

Under the "Access Keys" heading click the "Create New Root Key" button. You will be prompted to "Download Key File" which by default is named rootkey.csv. Open this file to get the **access-key** and **secret-key** for the environments.yaml configuration file.

![Amazon Access Credentials page showing key values](./media/getting_started-aws_keys.png)

The **region:** value corresponds to the AWS regions.
