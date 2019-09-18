Juju already has knowledge of the OCI cloud ([Oracle Cloud Infrastructure](https://cloud.oracle.com/en_US/cloud-infrastructure)), which means adding your Oracle account to Juju is quick and easy.

More specific information on Juju's OCI support (e.g. the supported regions) can be seen locally or, since `v.2.6.0`, remotely (on a live cloud). Here, we'll show how to do it locally (client cache):

``` text
juju show-cloud --local oracle
```

[note]
In versions prior to `v.2.6.0` the `show-cloud` command only operates locally (there is no `--local` option).
[/note]

To ensure that Juju's information is up to date (e.g. new region support), you can update Juju's public cloud data by running:

``` text
juju update-public-clouds
```

[note]
The previous iteration of Oracle's public cloud is now known to Juju as 'oracle-classic'. It is supported (see [2.3 documentation](https://docs.jujucharms.com/2.3/en/help-oracle)) but should be considered deprecated. These instructions cover Oracle OCI only and is known to Juju as cloud 'oracle'.
[/note]

<h2 id="heading--understanding-and-preparing-your-oci-account">Understanding and preparing your OCI account</h2>

The instructions on this page refer to certain OCI concepts. Familiarise yourself with them by reading Oracle's [Concepts](https://docs.cloud.oracle.com/iaas/Content/GSG/Concepts/concepts.htm) page. The key concepts for us here are "Tenancy", "Compartment", and "OCID".

Your Tenancy can be designed according to how you intend to use your OCI account but there is no hard requirement to perform any configuration changes to it in order to use it with Juju. However, for enterprise rollouts you will most certainly need to do this for both organisational and security reasons.

To organise your Tenancy and its associated compartments read Oracle's [Setting up your Tenancy](https://docs.cloud.oracle.com/iaas/Content/GSG/Concepts/settinguptenancy.htm) page.

[note]
Oracle's [SDK tools](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/sdks.htm) can also be used to manage your OCI account.
[/note]

<h2 id="heading--gathering-information">Gathering information</h2>

The following bits of information need to be gathered:

- SSL keypair and fingerprint
- Oracle Cloud Identifiers (OCIDs)

<h3 id="heading--ssl-keypair-and-fingerprint">SSL keypair and fingerprint</h3>

An SSL keypair (private and public keys) needs to be generated on your local system. It will be used to contact Oracle's API. A "fingerprint" of the private key will be needed to identify that key. The below list of Linux-based commands accomplish all this. For a full explanation of them, in addition to what to do on a non-Linux system, see Oracle's [Required Keys and OCIDs](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm) page.

``` text
mkdir ~/.oci
openssl genrsa -out ~/.oci/oci_ssl_key_private.pem -aes128 2048
chmod go-rwx ~/.oci/oci_ssl_key_private.pem
openssl rsa -pubout -in ~/.oci/oci_ssl_key_private.pem -out ~/.oci/oci_ssl_key_public.pem
openssl rsa -pubout -outform DER -in ~/.oci/oci_ssl_key_private.pem | openssl md5 -c
```

The first `openssl` invocation will create an encrypted private key and will therefore prompt you for a passphrase. You will need this for later. Omit option `-aes128` to disable encryption.

The last command will output the fingerprint of the private key.

The private key is now in file `~/.oci/oci_ssl_key_private.pem` and the public key is in file `~/.oci/oci_ssl_key_public.pem`.

We'll later make reference to the private key, the fingerprint, and the passphrase using these variables, respectively:

`$SSL_PRIVATE_KEY`
`$SSL_PRIVATE_KEY_FINGERPRINT`
`$SSL_PRIVATE_KEY_PASSPHRASE`

<h3 id="heading--oracle-cloud-identifiers-ocids">Oracle Cloud Identifiers (OCIDs)</h3>

OCIDs are required for the following objects:

-   Tenancy
-   User
-   Compartment

They are all gathered via Oracle's web [Console](https://console.us-phoenix-1.oraclecloud.com/).

[note]
The below instructions for navigating the Oracle web interface assume you are the account administrator. If this is not the case, your experience may differ. In particular, you may need to access information in the top-right corner (look for "User Settings").
[/note]

**User OCID**
The User OCID is found by clicking in the top-left menu and choosing 'Identity' and then sub-menu 'Users'. Here, we'll assign this value to a variable so we can refer to it later:

`OCID_USER=ocid1.user.oc1..aaaaaaaaizcm5ljvk624qa4ue1i8vx043brrs27656sztwqy5twrplckzghq`

**Tenancy OCID**
The Tenancy OCID is found similarly but in the sub-menu 'Compartments'. Again, we'll assign this to a variable:

`OCID_TENANCY=ocid1.tenancy.oc1..aaaaaaaanoslu5x9e50gvq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia`

**Compartment OCID**
The Compartment OCID is found on the same page:

`OCID_COMPARTMENT=ocid1.tenancy.oc1..aaaaaaaanoslu5x9e50gvq3mdilr5lzjz4imiwj3ale4s3qyivi5liw6hcia`

In this example, for the Compartment OCID, we decided to use the compartment provided to us by default (the *root Compartment*). Notice how it's the same as the Tenancy OCID.

[note type="caution"]
You will need to specify the Compartment OCID during the controller-creation process.
[/note]

<h3 id="heading--provide-the-public-ssl-key-to-oracle">Provide the public SSL key to Oracle</h3>

In order for the SSL keypair to be of any use the public key must be placed on the remote end.

Within the 'Users' sub-menu, click on the user's email address, and then on 'Add Public Key'. Paste in the key generated earlier (stored in file `~/.oci/oci_ssl_key_public.pem`) and click the 'Add' button.

<h2 id="heading--adding-credentials">Adding credentials</h2>

The [Credentials](/t/credentials/1112) page offers a full treatment of credential management.

In order to access Oracle OCI, you will need to add credentials to Juju. This can be done in one of two ways (as shown below).

<h3 id="heading--using-the-interactive-method">Using the interactive method</h3>

Armed with the gathered information, credentials can be added interactively with the command `juju add-credential oracle`. However, due to the private SSL key that needs to be provided this method is not recommended. Use the file method outlined next.

<h3 id="heading--using-a-file">Using a file</h3>

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential information for any cloud. The file in this example would be based on the following (replace the variables with your own values):

``` text
credentials:
  oracle:
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

- The `$SSL_PRIVATE_KEY_PASSPHRASE` value is placed within double-quotes. If the key was not encrypted just use "".
- The `$CLOUD_REGION` is an Oracle region (`juju regions oracle`).
- The `$CREDENTIAL_NAME` is an arbitrary label.

See section [Adding credentials from a file](/t/credentials/1112#heading--adding-credentials-from-a-file) for guidance on what such a file can look like.

This information is then added to Juju by referencing the file with the `add-credential` command:

``` text
juju add-credential oracle -f mycreds.yaml
```

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'oracle' (replace the variable with your own value):

``` text
juju bootstrap --config compartment-id=$OCID_COMPARTMENT oracle oracle-controller
```

Above, the name given to the new controller is 'oracle-controller'. OCI will provision an instance to run the controller on.

You can optionally change the definition of cloud 'oracle' to avoid having to specify the compartment like this. See [General cloud management](/t/clouds/1100#heading--general-cloud-management) for guidance.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
