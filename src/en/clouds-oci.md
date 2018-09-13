Title: Using Oracle Cloud Infrastructure with Juju
TODO:  Review required: 2.5 changes still to come

# Using Oracle Cloud Infrastructure with Juju

Juju has built-in support (!!!!) for [Oracle Cloud Infrastructure][oracle-oci],
Oracle's public cloud. This means that there is no need to add the Oracle cloud
to Juju. An exception to this is if you have an Oracle Compute trial account.
Both types of accounts, paid and trial, are covered here.

This page will cover the following steps:

 1. For trial accounts, add the Oracle cloud to Juju.
 1. Add cloud
 1. Add credentials to Juju so it can make use of your Oracle Compute account.
 1. Create the Juju controller

## Gathering information 

Upon first login (to 'My Services URL') you will be prompted to change the
temporary password to arrive at your final password.

Concepts
https://docs.cloud.oracle.com/iaas/Content/GSG/Concepts/concepts.htm

- Tenancy
- Compartment

=================

https://cloud.oracle.com/en_US/cloud-infrastructure

sign up

https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm

- SSL keypair and fingerprint
- Oracle Cloud Identifier (OCID)
https://docs.cloud.oracle.com/iaas/Content/General/Concepts/identifiers.htm

directory:

mkdir ~/.oci
openssl genrsa -out ~/.oci/oci_api_key.pem -aes128 2048
chmod go-rwx ~/.oci/oci_api_key.pem
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
openssl rsa -pubout -outform DER -in ~/.oci/oci_api_key.pem | openssl md5 -c
(last command: fingerprint)

In the Console:
https://console.us-phoenix-1.oraclecloud.com/

OCID (tenancy):
ocid1.tenancy.oc1..aaaaaaaanosly647z7davq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia

OCID (user):
ocid1.user.oc1..aaaaaaaaizcm5ljvk624qa4ue34d5tupearr5u7656sztwqy5twrplckzghq

Upload the public key (under 'API Keys')

Setting Up Your Tenancy:
https://docs.cloud.oracle.com/iaas/Content/GSG/Concepts/settinguptenancy.htm

OCID (compartment [root]; same as the tenancy OCID):
ocid1.tenancy.oc1..aaaaaaaanosly647z7davq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia

Add cloud:
Create a cloud file (e.g. 'oci-cloud.yaml') and replace the variables with the
corresponding values for your account.
Here we've used 'oci-test' and 'us-ashburn-1' for cloud name and cloud region respectively.
Your region is listed in the Console.

clouds:
  $CLOUD_NAME:
    type: oci
    auth-types: [httpsig]
    regions:
      $CLOUD_REGION: {}

Now add the cloud to Juju. Use your own cloud name and cloud file:

juju add-cloud oci-test oci-cloud.yaml

Add credential:
Create a credential file (e.g. 'oci-creds.yaml') and replace the variables with the
corresponding values for your account:

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

Add the credential to Juju. Use your own cloud name and credential file:

juju add-credential oci-test -f oci-creds.yaml

Creat a controller:
juju bootstrap --config compartment-id=$OCID_COMPARTMENT oci-test oci-test-controller

## Trial accounts

As mentioned, you will need to add your Oracle cloud to Juju if you're using a
trial account. This requires a 'REST Endpoint'. To get this, navigate to 'My
Account URL', scroll down to 'Oracle Compute Cloud Service', and click on it.
The resulting page will look similar to this:

![REST endpoint](./media/oracle_myservices-endpoint-2.png)

There may be multiple endpoints. In that case, trial and error may be needed
below (hint: the endpoint domain should be resolvable using DNS).

You are now ready to use the interactive `add-cloud` command:

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  oracle
  vsphere

Select cloud type: oracle

Enter a name for your oracle cloud: oracle-cloud

Enter the API endpoint url for the cloud:
https://compute.uscom-central-1.oraclecloud.com/

Cloud "oracle-cloud" successfully added
You may bootstrap with 'juju bootstrap oracle-cloud'
```

We've called the new cloud 'oracle-cloud' and used an endpoint of
'https://compute.uscom-central-1.oraclecloud.com/'.

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

Here is a partial output:

```no-highlight
Cloud            Regions  Default          Type        Description
.
.
.
oracle                 5  uscom-central-1  oracle      Oracle Compute Cloud Service
oracle-cloud           0                   oracle      Oracle Compute Cloud Service
```

Cloud 'oracle' is for the built-in (for pay) service and cloud 'oracle-cloud'
is tied to your trial account.

## Adding an OCI cloud

Use the interactive `add-cloud` command to add your MAAS cloud to Juju's list
of clouds. You will need to supply a name you wish to call your cloud and the
unique MAAS API endpoint.

For the manual method of adding a MAAS cloud, see below section
[Manually adding MAAS clouds][#clouds-maas-manual].

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  oracle
  vsphere

Select cloud type: maas

Enter a name for your maas cloud: maas-cloud

Enter the API endpoint url: http://10.55.60.29:5240/MAAS

Cloud "maas-cloud" successfully added
You may bootstrap with 'juju bootstrap maas-cloud'
```

We've called the new cloud 'maas-cloud' and used an endpoint of
'http://10.55.60.29:5240/MAAS'.

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
maas-cloud         0                   maas        Metal As A Service
```

### Manually adding an OCI cloud

This example covers manually adding a MAAS cloud to Juju (see
[Adding clouds manually][clouds-adding-manually] for background information).
It also demonstrates how multiple clouds of the same type can be defined and
added.

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. Here is an example:

```yaml
clouds:
   devmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://devmaas/MAAS
   testmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://172.18.42.10/MAAS
   prodmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://prodmaas/MAAS
```

This defines three MAAS clouds and refers to them by their respective region
controllers.

To add clouds 'devmaas' and 'prodmaas', assuming the configuration file is
`maas-clouds.yaml` in the current directory, we would run:

```bash
juju add-cloud devmaas maas-clouds.yaml
juju add-cloud prodmaas maas-clouds.yaml
```

## Adding credentials

The [Credentials][credentials] page offers a full treatment of credential
management.

Use the interactive `add-credential` command to add your credentials to the new
cloud:

```bash
juju add-credential maas-cloud
```

Example user session:

```no-highlight
Enter credential name: maas-cloud-creds

Using auth-type "oauth1".

Enter maas-oauth:

Credentials added for cloud maas-cloud.
```

We've called the new credential 'maas-cloud-creds'. When prompted for
'maas-oauth', you should paste your MAAS API key.

!!! Note:
    The API key will not be echoed back to the screen.

## Creating a controller

You are now ready to create a Juju controller for cloud 'maas-cloud':

```bash
juju bootstrap maas-cloud maas-cloud-controller
```

Above, the name given to the new controller is 'maas-cloud-controller'. MAAS
will allocate a node from its pool to run the controller on.

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
[oracle-oci]: https://maas.io
[cloudoracle]: https://cloud.oracle.com/home
[maas-manual]: ./clouds-maas-manual.md
[create-a-controller-with-constraints]: ./controllers-creating.md#create-a-controller-with-constraints
[#clouds-maas-manual]: #manually-adding-maas-clouds
[clouds-adding-manually]: ./clouds.md#adding-clouds-manually
[credentials]: ./credentials.md
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
