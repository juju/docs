Title: Using Oracle OCI with Juju

# Using Oracle OCI with Juju

Juju already has knowledge of the OCI cloud
([Oracle Cloud Infrastructure][oracle-oci]), which means adding your Oracle
account to Juju is quick and easy.

You can see more specific information on Juju's OCI support (e.g. the
supported regions) by running:

```bash
juju show-cloud oracle
```

If at any point you believe Juju's information is out of date (e.g. Oracle just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Understanding and preparing your OCI account

The instructions on this page refer to certain OCI concepts. Familiarise
yourself with them by reading Oracle's [Concepts][oracle-oci-concepts] page.
The key concepts for us here are "Tenancy", "Compartment", and "OCID".

Your Tenancy can be designed according to how you intend to use your OCI
account but there is no hard requirement to perform any configuration changes
to it in order to use it with Juju. However, for enterprise rollouts you will
most certainly need to do this for both organisational and security reasons.

To organise your Tenancy and its associated compartments read Oracle's
[Setting up your Tenancy][oracle-oci-tenancy] page.

!!! Note:
    Oracle's [SDK tools][oracle-oci-cli] can also be used to manage your OCI
    account.

## Gathering information 

The following bits of information need to be gathered:

 - SSL keypair and fingerprint
 - Oracle Cloud Identifiers (OCIDs)

### SSL keypair and fingerprint

An SSL keypair (private and public keys) needs to be generated on your local
system. It will be used to contact Oracle's API. A "fingerprint" of the private
key will be needed to identify that key. The below list of Linux-based commands
accomplish all this. For a full explanation of them, in addition to what to do
on a non-Linux system, see Oracle's [Required Keys and OCIDs][oracle-oci-ssl]
page.

```bash
mkdir ~/.oci
openssl genrsa -out ~/.oci/oci_ssl_key_private.pem -aes128 2048
chmod go-rwx ~/.oci/oci_ssl_key_private.pem
openssl rsa -pubout -in ~/.oci/oci_ssl_key_private.pem -out ~/.oci/oci_ssl_key_public.pem
openssl rsa -pubout -outform DER -in ~/.oci/oci_ssl_key_private.pem | openssl md5 -c
```

The first `openssl` invocation will create an encrypted private key and will
therefore prompt you for a passphrase. You will need this for later. Omit
option `-aes128` to disable encryption.

The last command will output the fingerprint of the private key.

The private key is now in file `~/.oci/oci_ssl_key_private.pem` and the public
key is in file `~/.oci/oci_ssl_key_public.pem`.

We'll later make reference to the private key, the fingerprint, and the
passphrase using these variables, respectively:

`$SSL_PRIVATE_KEY`  
`$SSL_PRIVATE_KEY_FINGERPRINT`  
`$SSL_PRIVATE_KEY_PASSPHRASE`

### Oracle Cloud Identifiers (OCIDs)

OCIDs are required for the following objects:

 - Tenancy
 - User
 - Compartment

They are all gathered via Oracle's web [Console][oracle-oci-console].

!!! Note:
    The below instructions for navigating the Oracle web interface assume you
    are the account administrator. If this is not the case, your experience may
    differ. In particular, you may need to access information in the top-right
    corner (look for "User Settings").

**User OCID**  
The User OCID is found by clicking in the top-left menu and choosing 'Identity'
and then sub-menu 'Users'. Here, we'll assign this value to a variable so we
can refer to it later:

`OCID_USER=ocid1.user.oc1..aaaaaaaaizcm5ljvk624qa4ue1i8vx043brrs27656sztwqy5twrplckzghq`

**Tenancy OCID**  
The Tenancy OCID is found similarly but in the sub-menu 'Compartments'. Again,
we'll assign this to a variable:

`OCID_TENANCY=ocid1.tenancy.oc1..aaaaaaaanoslu5x9e50gvq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia`

**Compartment OCID**  
The Compartment OCID is found on the same page:

`OCID_COMPARTMENT=ocid1.tenancy.oc1..aaaaaaaanoslu5x9e50gvq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia`

In this example, for the Compartment OCID, we decided to use the compartment
provided to us by default (the *root Compartment*). Notice how it's the same as
the Tenancy OCID.

### Provide the public SSL key to Oracle

In order for the SSL keypair to be of any use the public key must be placed on
the remote end.

Within the 'Users' sub-menu, click on the user's email address, and then on
'Add Public Key'. Paste in the key generated earlier and click the 'Add'
button.

## Adding credentials

The [Credentials][credentials] page offers a full treatment of credential
management.

In order to access Oracle OCI, you will need to add credentials to Juju. This
can be done in one of two ways (as shown below).

Alternately, you can use your credentials with [Juju as a Service][jaas], where
charms can be deployed within a graphical environment that comes equipped with
a ready-made controller.

### Using the interactive method

Armed with the gathered information, credentials can be added interactively
with the command `juju add-credential oracle`. However, due to the private SSL
key that needs to be provided this method is not recommended. Use the file
method outlined next.

### Using a file

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential
information for any cloud. The file in this example would be based on the
following (replace the variables with your own values):

```no-highlight
credentials:
  oracle:
    default-region: $CLOUD_REGION
    $CREDENTIAL_NAME:
      auth-type: httpsig
      fingerprint: $SSL_PRIVATE_KEY_FINGERPRINT
      key: |
        $SSL_PRIVATE_KEY
      region: $CLOUD_REGION
      pass-phrase: $SSL_PRIVATE_KEY_PASSPHRASE
      tenancy: $OCID_TENANCY
      user: $OCID_USER
```

Notes:

 - The `$SSL_PRIVATE_KEY_PASSPHRASE` value is placed within double-quotes. If the key was not encrypted just
use "".
 - The `$CLOUD_REGION` is an Oracle region (`juju regions oracle`).
 - The `$CREDENTIAL_NAME` is an arbitrary label.

See section [Adding credentials from a file][credentials-adding-from-file] for
guidance on what such a file can look like.

This information is then added to Juju by referencing the file with the
`add-credential` command:

```bash
juju add-credential oracle -f mycreds.yaml
```

## Creating a controller

You are now ready to create a Juju controller for cloud 'oracle' (replace the
variable with your own value):

```bash
juju bootstrap --config compartment-id=$OCID_COMPARTMENT oracle oracle-controller
```

Above, the name given to the new controller is 'oracle-controller'. OCI will
provision an instance to run the controller on.

You can optionally change the definition of cloud 'oracle' to avoid having to
specify the compartment like this. See
[General cloud management][clouds-general-cloud-management] for how to do this.

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

## Next steps

A controller is created with two models - the 'controller' model, which should
be reserved for Juju's internal operations, and a model named 'default', which
can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[oracle-oci]: https://cloud.oracle.com/en_US/cloud-infrastructure
[oracle-oci-concepts]: https://docs.cloud.oracle.com/iaas/Content/GSG/Concepts/concepts.htm
[oracle-oci-ssl]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm
[oracle-oci-tenancy]: https://docs.cloud.oracle.com/iaas/Content/GSG/Concepts/settinguptenancy.htm
[oracle-oci-cli]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/sdks.htm
[oracle-oci-console]: https://console.us-phoenix-1.oraclecloud.com/
[credentials]: ./credentials.md
[jaas]: ./getting-started.md
[credentials-adding-from-file]: ./credentials.md#adding-credentials-from-a-file
[clouds-general-cloud-management]: ./clouds.md#general-cloud-management
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
