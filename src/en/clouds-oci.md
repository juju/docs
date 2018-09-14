Title: Using Oracle Cloud Infrastructure with Juju
TODO:  Review required: 2.5 changes still to come

# Using Oracle Cloud Infrastructure with Juju

Juju has built-in support (!!!!) for [Oracle Cloud Infrastructure][oracle-oci]
(OCI), Oracle's public cloud. This means that there is no need to add the
Oracle cloud to Juju. An exception to this is if you are using a trial account.
Both types of accounts, paid and trial, are covered here.

This page will cover the following steps:

 1. For trial accounts, add the OCI cloud to Juju.
 1. Add credentials to Juju so it can make use of your OCI account.
 1. Create the Juju controller.

!!! Note:
    Oracle's [SDK tools][oracle-oci-cli] can also be used to manage your OCI
    account.

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

## Gathering information 

The following bits of information need to be gathered:

 - SSL keypair and fingerprint
 - Oracle Cloud Identifiers (OCIDs)

### SSL keypair and fingerprint

An SSL keypair (private and public keys) needs to be generated on your local
system. The below list of Linux-based commands accomplish this. For a full
explanation of them, in addition to what to do on a non-Linux system, see
Oracle's [Required Keys and OCIDs][oracle-oci-ssl] page.

```bash
mkdir ~/.oci
openssl genrsa -out ~/.oci/oci_ssl_key_private.pem -aes128 2048
chmod go-rwx ~/.oci/oci_ssl_key_private.pem
openssl rsa -pubout -in ~/.oci/oci_ssl_key_private.pem -out ~/.oci/oci_api_key_public.pem
openssl rsa -pubout -outform DER -in ~/.oci/oci_ssl_key_private.pem | openssl md5 -c
```

The last command prints the fingerprint of the private key to the screen.

We'll later make reference to the private key, the public key, and the
fingerprint using these variables:

`$SSL_PRIVATE_KEY`  
`$SSL_PUBLIC_KEY`  
`$SSL_PRIVATE_KEY_FINGERPRINT`

### Oracle Cloud Identifiers (OCIDs)

OCIDs are required for the following objects:

 - Tenancy
 - User
 - Compartment

They are all gathered via Oracle's web [Console][oracle-oci-console].

**Tenancy OCID**  
The Tenancy OCID is found by clicking in the top-right corner user icon and
choosing the 'Tenancy: your_username' menu entry. The resulting page will
provide the information.

Here, we'll assign this value to a variable so we can refer to it later:

`OCID_TENANCY=ocid1.tenancy.oc1..aaaaaaaanoslu5x9e50gvq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia`

**User OCID**  
The User OCID is found by clicking in the top-left menu and choosing 'Identity'
and then 'Users'. The resulting page will provide the information.

Again, we'll assign this to a variable:

`OCID_USER=ocid1.user.oc1..aaaaaaaaizcm5ljvk624qa4ue1i8vx043brrs27656sztwqy5twrplckzghq`

**Compartment OCID**  
The Compartment OCID is found on the same page but in the sub-menu
'Compartments':

`OCID_COMPARTMENT=ocid1.tenancy.oc1..aaaaaaaanoslu5x9e50gvq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia`

Notice that the Tenancy and Compartment values are identical. This is because,
in this example, we decided to use the compartment provided to us by default
(the *root Compartment*). If you created a new compartment at the "Preparing
your OCI account" step then your values should be different.

### Upload the public key

Upload the public key (under 'API Keys')

## Trial accounts

As mentioned, you will need to add your Oracle cloud to Juju if you're using a
trial account. This requires a 'REST Endpoint'. To get this, navigate to 'My
Account URL', scroll down to 'Oracle Compute Cloud Service', and click on it.
The resulting page will look similar to this:

![REST endpoint](./media/oracle_myservices-endpoint-2.png)

There may be multiple endpoints. In that case, trial and error may be needed
below (hint: the endpoint domain should be resolvable using DNS).

Use the interactive `add-cloud` command to add your OCI cloud to Juju's list
of clouds. You will need to supply a name you wish to call your cloud and
!!!!!!

For the manual method of adding an OCI cloud, see below section
[Manually adding an OCI cloud][#clouds-oci-manual].

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  lxd
  maas
  manual
  oci
  openstack
  oracle !!!!!!!!!!!!
  vsphere

Select cloud type: oci

Enter a name for your oci cloud: oci-test

Enter region name: us-ashburn-1

Enter another region? (y/N): N

Cloud "oci-cloud" successfully added

You may need to `juju add-credential oci-test' if your cloud needs additional credentials
then you can bootstrap with 'juju bootstrap oci-test'
```

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

Here is a partial output:

```no-highlight
Cloud        Regions  Default          Type        Description
.
.
.
oci-test           1  us-ashburn-1     oci
```

### Manually adding an OCI cloud

This example covers manually adding an OCI cloud to Juju (see
[Adding clouds manually][clouds-adding-manually] for background information).

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. Here is an example:

```yaml
clouds:
  oci-test:
    type: oci
    auth-types: [httpsig]
    regions:
      us-ashburn-1: {}
```

Here we've used 'oci-test' and 'us-ashburn-1' for cloud name and cloud region
respectively. Your region is listed in the Console.

To add cloud 'oci-test', assuming the configuration file is `oci-cloud.yaml` in
the current directory, we would run:

```bash
juju add-cloud oci-test oci-cloud.yaml
```

## Adding credentials

The [Cloud credentials][credentials] page offers a full treatment of credential
management.

In order to access Oracle OCI, you will need to add credentials to Juju. This
can be done in one of two ways (as shown below).

Alternately, you can use your credentials with [Juju as a Service][jaas], where
charms can be deployed within a graphical environment that comes equipped with
a ready-made controller.

### Using the interactive method

Armed with the gathered information, credentials can be added interactively
with the command `juju add-credential oci-test`. However, due to the private
SSL key that needs to be provided this method is not recommended. Use the file
method outlined next.

### Using a file

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential
information for any cloud. The credential file in this example would be based
on the following (replace the variables with your own values):

```no-highlight
credentials:
  $CLOUD_NAME:
    default-region: $CLOUD_REGION
    $CREDENTIAL_NAME:
      auth-type: httpsig
      fingerprint: $SSL_PUBLIC_KEY_FINGERPRINT
      key: |
        $SSL_PRIVATE_KEY
      pass-phrase: $SSL_PRIVATE_KEY_PASSPHRASE
      region: $CLOUD_REGION
      tenancy: $OCID_TENANCY
      user: $OCID_USER
```

See section [Adding credentials from a file][credentials-adding-from-file] for
guidance on what such a file looks like.

This information is then added to Juju by pointing the `add-credential`
command to the file:

```bash
juju add-credential oci-test -f mycreds.yaml
```

## Creating a controller

You are now ready to create a Juju controller for cloud 'oci-test':

```bash
juju bootstrap --config compartment-id=$OCID_COMPARTMENT oci-test oci-test-controller
```

Above, the name given to the new controller is 'oci-test-controller'. OCI
will provision an instance to run the controller on.

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
[#clouds-oci-manual]: #manually-adding-an-oci-cloud
[clouds-adding-manually]: ./clouds.md#adding-clouds-manually
[credentials]: ./credentials.md
[jaas]: ./getting-started.md
[credentials-adding-from-file]: ./credentials.md#adding-credentials-from-a-file
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
