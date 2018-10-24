Title: Credentials
TODO:  Investigate: shouldn't `model-config` have a default-credential setting?
       Add to mycreds.yaml: cloudsigma, rackspace, and oracle. also openstack using access-key
       Investigate: can private keys always be replaced by a file path?
       Add remote LXD certs/key (server cert, client cert, client key)
table_of_contents: True

# Credentials

In order to access your cloud, Juju needs to know how to authenticate itself.
We use the term *credentials* to describe the material necessary to do this
(e.g. username & password, or just a secret key). Such a set of credentials is
represented by a *credential name* that is used to refer to those credentials
in subsequent commands.

When credentials are added for a given cloud they become available to use on
that cloud's controller and models. There are therefore two categories of
credentials: those that are available to the Juju client (local) and those that
are active and have been uploaded to a controller (remote). A credential
becomes active when it is needed to bring about a change in Juju for the first
time.

An active credential is always associated with one cloud, one Juju user, and
one, or more, models. A model, however, is always linked to a single
credential.
 
## Adding credentials

Juju supports three methods for adding credentials:

 - accepting credentials provided interactively by the user on the command line
 - scanning for existing credentials via environment variables and/or "rc"
   files (only supported by certain providers)
 - reading a user-provided [YAML-formatted][yaml] file
  
!!! Note:
    Local LXD deployments are a special case. Accessed from a Juju admin user,
    they do not require credentials. Accessed from a non-admin user, a
    *certificate credential* is needed. See
    [Additional LXD resources][clouds-lxd-resources-non-admin-creds] for
    details. 

### Adding credentials interactively

To add credentials interactively use the `add-credential` command. To do so
with the AWS cloud:

```bash
juju add-credential aws
```

You will be asked for credential information based on the chosen cloud. For our
AWS cloud the resulting interactive session would look like:

```no-highlight
Enter credential name: carol
Using auth-type "access-key".
Enter access-key: *******
Enter secret-key: *******
```

If you end up adding multiple credentials for the same cloud you will need to
set one as the default. See below section
[Setting default credentials][#setting-default-credentials].

### Adding credentials from environment variables

Certain cloud providers offer command line tools that rely on environment
variables to store credentials. Juju supports the scanning of such variables as
a way to add them to itself. Scanning is done with the `autoload-credentials`
command:

```bash
juju autoload-credentials
```

Any variables detected will cause a prompt to appear. You will be asked to
confirm the addition of their respective values as well as to provide a name to
call the credential set.

!!! Note:
    You will need to rescan the variables if their values ever change. A scan
    only picks up *current* values.

There are three providers that use tools that support this method:
[Amazon AWS][clouds-aws-using-env-variables],
[Google GCE][clouds-google-using-env-variables], and
[OpenStack][clouds-openstack-using-env-variables].

The `autoload-credentials` command is also used to generate a certificate
credential for localhost clouds. This is needed for providing access to
non-admin Juju users. See
[Additional LXD resources][clouds-lxd-resources-non-admin-creds].
    
### Adding credentials from a file

You can use a YAML-formatted file to store credentials for any cloud. Below we
provide a sample file, which we will call `mycreds.yaml`. It includes many of
the clouds supported by Juju and uses the most common options. Note the MAAS
cloud and the two OpenStack clouds, called 'homemaas', 'myopenstack' and
'homestack' respectively.

```yaml
credentials:
  aws:
    default-credential: peter
    default-region: us-west-2
    peter:
      auth-type: access-key
      access-key: AKIAIH7SUFMBP455BSQ
      secret-key: HEg5Y1DuGabiLt72LyCLkKnOw+NZkgszh3qIZbWv
    paul:
      auth-type: access-key
      access-key: KAZHUKJHE33P455BSQB
      secret-key: WXg6S5Y1DvwuGt72LwzLKnItt+GRwlkn668sXHqq
  homemaas:
    peter:
      auth-type: oauth1
      maas-oauth: 5weWAsjhe9lnaLKHERNSlke320ah9naldIHnrelks
  myopenstack:
    default-region: region-a
    john:
      auth-type: access-key
      access-key: bae7651caeab41ed876cfdb342bae23e
      secret-key: 7172bc91a21c3df1787423ac12093bcc
      tenant-name: admin
      username: admin   
  homestack:
    default-region: region-b
    peter:
      auth-type: userpass
      password: UberPassK3yz
      tenant-name: appserver
      username: peter
  google:
    peter:
      auth-type: jsonfile
      file: ~/.config/gcloud/application_default_credentials.json
    juju-gce-1-sa:
      auth-type: oauth2
      project-id: juju-gce-1
      private-key: |
        -----BEGIN PRIVATE KEY-----
        MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCzTFMj0/GvhrcZ
        3B2584ZdDdsnVuHb7OYo8eqXVLYzXEkby0TMu2gM81LdGp6AeeB3nu5zwAf71YyP
        erF4s0falNPIyRjDGYV1wWR+mRTbVjYUd/Vuy+KyP0u8UwkktwkP4OFR270/HFOl
        Kc0rzflag8zdKzRhi7U1dlgkchbkrio148vdaoZZo67nxFVF2IY52I2qGW8VFdid
        z+B9pTu2ZQKVeEpTVe5XEs3y2Y4zt2DCNu3rJi95AY4VDgVJ5f1rnWf7BwZPeuvp
        0mXLKzcvD31wEcdE6oAaGu0x0UzKvEB1mR1pPwP6qMHdiJXzkiM9DYylrMzuGL/h
        VAYjhFQnAgMBAAECggEADTkKkJ10bEt1FjuJ5BYCyYelRLUMALO4RzpZrXUArHz/
        CN7oYTWykL68VIE+dNJU+Yo6ot99anC8GWclAdyTs5nYnJNbRItafYd+3JwRhU0W
        vYYZqMtXs2mNMYOC+YNkibIKxYZJ4joGksTboRvJne4TN7Et/1uirr+GtLPn+W/e
        umXfkpbOTDDAED8ceKKApAn6kLIW98DwHyK0rUzorOgp4DFDX9CjuWC+RG3CFGsk
        oVOcDuTevJlb9Rowj1S2qYhGjuQVpVD7bcRg5zaSJKS88YbK63DCHZFpXn9JR0Fg
        Vou9dnc99FdMo5vtHg7Adxh91gdqEvoaF1lHx8Var0q32QDse+spvv7K6/+7G35k
        3+1gDgF74/uMr/AVrjpoUjmGAuWweXY/vn1MVN2Uld4KPYafkOF8oTuDK5f1fu0d
        cMEoKRSXQh1NCD3PZWfQt4ypYPzn9R+VBGwnBcPorytlhM9qdLxKKlaHjBlprS6Y
        Be1z6FO+MqWhFlwPrKH/2uwd4QKBgQDCGESJur9OdEeroBQyYyJF7DnJ/+wHSiOr
        qzvb9YW1Ddtg1iiKHHZO5FS59/D62kPaGsysCMKxI9FW53TzSxUiTaEG636C5v8J
        eRdzxX04BNYNzqXbm1agBEjAa7tK8xJAjk0to4zqadUaYZog0uQs2X7Aexj2c9T/
        HQVLILHjBwKBgD/yuoLNbST+cGbuZl1s2EnTP796xPkkUm3qcUzofzmn6uivz7Qp
        FMThZhHZ/Der98tra91a4e8fHaUTL5d4eCMeCL1mWXoNMnm02D/ugpEC8yDefi3T
        xlM/Ed0IEVogcd49tvTvQfrhfbW/6Que/rkLKCoUlAldfIOYkS4YyyTBAoGACCpH
        L9gYVi+UGEc6skfzWCew4quOfVwEFiO09/LjNhOoJ/G6cNzzqSv32H7yt0rZUeKQ
        u6f+sL8F/nbsN5PwBqpnXMgpYU5gakCa2Pb05pdlfd00owFs6nxjpxyhG20QVoDm
        BEZ+FhpvqZVzi2/zw2M+7s/+49dJnZXV9Cwi758CgYAquNdD4RXU96Y2OjTlOSvM
        THR/zY6IPeO+kCwmBLiQC3cv59gaeOp1a93Mnapet7a2/WZPL2Al7zwnvZYsHc4z
        nu1acd6D7H/9bb1YPHMNWITfCSNXerJ2idI689ShYjR2sTcDgiOQCzx+dwL9agaC
        WKjypRHpiAMFbFqPT6W2uA==
        -----END PRIVATE KEY-----
      client-id: "206517233375074786882"
      client-email: juju-gce-sa@juju-gce-123.iam.gserviceaccount.com
  azure:
    peter:
      auth-type: service-principal-secret
      application-id: niftyapp
      subscription-id: 31fb132e-e774-49dd-adbb-d6a4e966c583
      application-password: UberPassK3yz
  joyent:
    peter:
      auth-type: userpass
      sdc-user: admingal
      sdc-key-id: 2048 00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff
      private-key: key (or private-key-path, like `~/.ssh/id_rsa.pub`)
      algorithm: "rsa-sha256"
  vsphere:
    ashley:
      auth-type: userpass
      password: passw0rd
      user: administrator@xyz.com
  lxd-node2:
    interactive:
      auth-type: interactive
      trust-password: ubuntu
```

Credentials are added to Juju on a per-cloud basis. To add credentials for the
defined 'azure' cloud, for instance, we would do this:

```bash
juju add-credential azure -f mycreds.yaml
```

!!! Note:
    All available authentication types are outlined in section
    [Adding clouds manually][clouds-adding-clouds-manually] on the Clouds page.
    
## Managing credentials

The following credential management tasks are covered:

 - [Setting default credentials][#setting-default-credentials]
 - [Listing local credentials][#listing-local-credentials]
 - [Listing remote credentials][#listing-remote-credentials]
 - [Updating local credentials][#updating-local-credentials]
 - [Updating remote credentials][#updating-remote-credentials]
 - [Removing local credentials][#removing-local-credentials]
 - [Changing a remote credential for a model][#changing-a-remote-credential-for-a-model]

### Setting default credentials

To set the default credential for a cloud:

```bash
juju set-default-credential aws carol
```

If only one credential exists for a cloud, it becomes the effective default
credential for that cloud.

Setting a default affects operations that require a credential such as creating
a controller (`bootstrap`) and adding a model (`add-model`). It does not change
what is currently in use (on a controller). With both these commands a
credential can be specified with the `--credential` option.

A default must be defined if multiple credentials exist for a given cloud.
Failure to do so will cause an error to be emitted from those commands that
require a credential:

```no-highlight
ERROR more than one credential is available
specify a credential using the --credential argument
```

### Listing local credentials

You can display what credentials are available by running the
`credentials` command:

```bash
juju credentials
```

Sample output:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju credentials -->
```no-highlight
Cloud   Credentials
aws     bob*, carol
google  wayne
```

An asterisk denotes a default credential. In the above output, credential 'bob'
is the default for cloud 'aws' and no default has been specified for cloud
'google'. Default credentials are covered in more depth later on.

To reveal actual authentication material (e.g. passwords, keys):

```bash
juju credentials --format yaml --show-secrets
```

Sample output:

```no-highlight
local-credentials:
  aws:
    bob:
      auth-type: access-key
      access-key: AKIAXZUYGB6UED2GNC5A
      secret-key: StB2bmL1+tX+VX7neVgy/3JosJAwOcBIO53nyCVp
```

Notice how the output says 'local-credentials', meaning they are stored on
the local Juju client.

### Listing remote credentials

To see what credential is in use by a model (here the 'default' model) the
`show-model` command can be used:

```bash
juju show-model default
```

Partial output:

```no-highlight
default:
  name: admin/default
  ...
  ...
  credential:
    name: bob
    owner: admin
    cloud: aws
```

The `models --format yaml` command also shows this information, albeit for all
models.

The above commands do not display authentication material. Use the
`show-credentials` command to view the active credentials, including the cloud
name, credential names, and model names:

```bash
juju show-credentials --show-secrets
```

Sample output:

```no-highlight
controller-credentials:
  aws:
    bob:
      content:
        auth-type: access-key
        access-key: AKIAXZUYGB6UED2GNC5A
        secret-key: StB2bmL1+tX+VX7neVgy/3JosJAwOcBIO53nyCVp
      models:
        controller: admin
        default: admin
```

Notice how the output says 'controller-credentials', meaning they are stored on
the controller.

The `show-credentials` command queries the controller to get its information.

### Updating local credentials

To update an existing credential locally use the `add-credential` command with
the `--replace` option.

Here we decided to use the file 'mycreds.yaml' from a previous example:

```bash
juju add-credential aws -f mycreds.yaml --replace
```

Any existing credential will be overwritten by an identically named credential
in the file. As a safeguard to inadvertently overwriting credentials, an error
will be emitted if the `--replace` option is not used:

```no-highlight
ERROR local credentials for cloud "aws" already exist; use --replace to overwrite / merge
```

Updating credentials in this way does not update credentials currently in use
(on an existing controller/cloud). See the next section for that. The
`add-credential` command is always "pre-bootstrap" in nature.

### Updating remote credentials

To update credentials currently in use (i.e. cached on the controller) the
`update-credential` command is used. The requirements for using this command,
as compared to the initial `juju bootstrap` (or `juju add-model`) command, are:

 - same cloud name
 - same Juju username (logged in)
 - same credential name

The update is a two-step process. First change the credentials locally with the
`add-credential` command (in conjunction with the `--replace` option) and then
upload those credentials to the controller.

Below, we explicitly log in with the correct Juju username ('admin'), change
the contents of the credential called 'joe', and then update them on a Google
cloud controller:

```bash
juju login -u admin
juju add-credential --replace joe
juju update-credential google joe
```

The `update-credential` command is the only command that can alter a credential
cached on a controller.

#### Updating remote credentials using a different Juju user

If you are unable to ascertain the original Juju username then you will need
to use a different one. This implies adding a new credential name, copying over
any authentication material into the old credential name, and finally updating
the credentials. Below we demonstrate this for the Azure cloud:

Add a new temporary credential name (like 'new-credential-name') and gather all
credential sets (new and old):

```bash
juju add-credential azure
juju credentials azure --format yaml --show-secrets > azure-creds.yaml
```

Copy the values of `application-id` and `application-password` from the new set
to the old set.

Then replace the local credentials and upload them to the controller:

```bash
juju add-credential azure -f azure-creds.yaml --replace
juju update-credential azure old-credential-name
```

To be clear, the file `azure-creds.yaml` (used with `add-credential`) should
look similar to:

```no-highlight
Credentials:
  azure:
    new-credential-name:
      auth-type: service-principal-secret
      application-id: foo1
      application-password: foo2
      subscription-id: bar
    old-credential-name:
      auth-type: service-principal-secret
      application-id: foo1
      application-password: foo2
      subscription-id: bar
```

### Removing local credentials

The `remove-credential` command is used to remove a local credential (i.e. not
cached on a controller):

```bash
juju remove-credential aws bob
```

### Changing a remote credential for a model

To change what remote credential is used for a model the `set-credential`
command (`v.2.5.0`) is available to the controller admin or the model owner.
For instance, to have remote credential 'bob' be used for model 'trinity' (for
cloud 'aws'):

```bash
juju set-credential -m trinity aws bob
```

!!! Note:
    If the stated credential does not exist remotely but it does locally then
    the local credential will be uploaded to the controller. The command will
    error out if the credential is neither remote nor local.


<!-- LINKS -->

[clouds-aws]: ./help-aws.md
[clouds-azure]: ./help-azure.md
[clouds-google]: ./help-google.md
[clouds-joyent]: ./help-joyent.md
[clouds-rackspace]: ./help-rackspace.md
[clouds-maas]: ./clouds-maas.md
[clouds-oracle]: ./help-oracle.md
[clouds-openstack]: ./help-openstack.md
[clouds-vmware]: ./help-vmware.md
[yaml]: http://www.yaml.org/spec/1.2/spec.html
[clouds-lxd-resources-non-admin-creds]: ./clouds-lxd-resources.md#non-admin-user-credentials
[clouds-aws-using-env-variables]: ./help-aws.md#using-environment-variables
[clouds-google-using-env-variables]: ./help-google.md#using-environment-variables
[clouds-openstack-using-env-variables]: ./help-openstack.md#using-environment-variables
[clouds-adding-clouds-manually]: ./clouds.md#adding-clouds-manually

[#setting-default-credentials]: #setting-default-credentials
[#listing-local-credentials]: #listing-local-credentials]
[#listing-remote-credentials]: #listing-remote-credentials
[#updating-local-credentials]: #updating-local-credentials
[#updating-remote-credentials]: #updating-remote-credentials
[#removing-local-credentials]: #removing-local-credentials
[#changing-a-remote-credential-for-a-model]: #changing-a-remote-credential-for-a-model
