# Configuring for Windows Azure

This process requires you to have an Windows Azure account. If you have not
signed up for one yet, it can obtained at http://azure.microsoft.com/en-us/.

You should start by generating a generic configuration file for Juju, using the
command:

    juju generate-config

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

**Note:** The above command will not overwrite your existing environments.yaml
file, or output to stdout. In order to see the boilerplate environment.yaml on
stdout you need to append the `--show` option. This is helpful if you have an
existing environment.yaml and just need to add a section. For example:

    juju generate-config --show

You can then copy and paste the needed section.

The generic configuration sections generated for Windows Azure will look
something like this:

    # https://jujucharms.com/docs/config-azure.html
        azure:
            type: azure
            # location specifies the place where instances will be started,
            # for example: West US, North Europe.
            #
            location: West US
            # The following attributes specify Windows Azure Management
            # information. See:
            # http://msdn.microsoft.com/en-us/library/windowsazure
            # for details.
            #
            management-subscription-id: 00000000-0000-0000-0000-000000000000
            management-certificate-path: /home/me/azure.pem
            # storage-account-name holds Windows Azure Storage info.
            #
            storage-account-name: abcdefghijkl
            # force-image-name overrides the OS image selection to use a fixed
            # image for all deployments. Most useful for developers.
            #
            # force-image-name: b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-13_10-amd64-server-DEVELOPMENT-20130713-Juju_ALPHA-en-us-30GB
            # image-stream chooses a simplestreams stream to select OS images
            # from, for example daily or released images (or any other stream
            # available on simplestreams).
            #
            # image-stream: "released"

This is the configuration environments.yaml file needed to run on Windows Azure.
You will need to set the `management-subscription-id`,
`management-certificate-path`, and `storage-account-name`, replacing the dummy
values with the relevant details for your account.

**Note:** Other than `location` the other key vaule defaults are recommended,
but can be updated to your preference.

**Note:** Ensure that you set `management-certificate-path` is set to use the
.pem file, NOT the .cer file, doing so will result in an
[out of memory error](https://bugs.launchpad.net/ubuntu/+source/juju-core/+bug/1250007).

## Config Values

Generate a new certificate for juju usage (or use an existing one). Suggest to
use a 'Common Name' with 'Juju' in it so its obvious in the web UI later. Run
the following commands on Ubuntu to generate a new certificate:

    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout azure.pem -out azure.pem
    openssl x509 -inform pem -in azure.pem -outform der -out azure.cer
    chmod 600 azure.pem

Login to the Windows Azure console @
[https://manage.windowsazure.com](https://manage.windowsazure.com). From here
you can gather the following information:

- **Settings** Left Navigation: get the `SUBSCRIPTION ID` of the account you upload to. This will be used for the `management-subscription-id`
- **Settings** Left Navigation: "upload" the MyCert.cer file above (if you created one). This is the certificate you used for the `management-certificate-path`
- **Storage** Left Navigation:
  - Click New (bottom left)
  - Click Quick Create
  - Add a name in url (for example `juju0useast0`). This is the value to be used for `storage-account-name`.
  - Select Location (for example: West US)
  - Select Subscription
  - Disable "Enable Geo-Replication" (not applicable)

**Note:** You must create the storage account in the same region/location
specified by the `location` key value. For example, if `location: West US` is
set then `storage-account-name:` must also have a storage set up in `West US`.
Failure to do so will result in a group affinity error.

Ensure the environments.yaml is configured with the above values and save.

## Using Availability Sets

With Azure, each Cloud Service has zero or more Availability Sets within it; 
a Role can be assigned to at most one of them. As long as there are at least two
Roles in the same Availability Set, then Azure will guarantee at least
99.95% availability under the Azure Service Level Agreement (SLA).

Juju creates a single Availability Set for each Cloud Service, and all roles
are added to it. Thus, all Juju-deployed services are, by default, covered
by the Azure SLA.

You can [read more about Availability Sets on the Azure website](http://azure.microsoft.com/en-gb/documentation/articles/virtual-machines-manage-availability/)
