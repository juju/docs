Title: Cloud credentials
TODO:  Investigate: shouldn't `model-config` have a default-credential setting?
       Review required
       Add to mycreds.yaml: cloudsigma, rackspace, and oracle. also openstack using access-key
table_of_contents: True

# Cloud credentials

In order to access your cloud, Juju needs to know how to authenticate itself.
We use the term *credentials* to describe the material necessary to do this
(e.g. username & password, or just a secret key). Such a set of credentials is
represented by a *credential name* that is used to refer to those credentials
in subsequent commands.

Juju selects a credential according to how many credentials are defined. If you
have only one credential, or if a credential is labelled 'default', then this
is the credential that will be used by Juju. When multiple credentials are
defined, with no default, a credential name must be specified at the model
level.

## Adding credentials

Juju supports three methods for adding credentials:

 - Accepting credentials provided interactively by the user on the command line
 - Scanning for existing credentials via environment variables and/or "rc"
   files (only supported by certain providers)
 - Reading a user-provided [YAML-formatted][yaml] file
  
!!! Note:
    LXD deployments are a special case. Accessed from a Juju admin user, they
    do not require credentials. Accessed from a non-admin user, a *certificate
    credential* is needed. See
    [Additional LXD resources][clouds-lxd-resources-non-admin-creds] for
    details. 

### Adding credentials interactively

You can add credentials interactively in this way:

```bash
juju add-credential <cloud>
```

You will be asked for credential information based on the chosen cloud. Here
we're adding credentials for cloud 'aws':

```no-highlight
Enter credential name: carol
Using auth-type "access-key".
Enter access-key: *******
Enter secret-key: *******
Credentials added for cloud aws.
```

If you eventually set multiple credential names for the same cloud you will
need to set one as the default:

```bash
juju set-default-credential <cloud> <credential-name>
```

The default credential will be used when creating a controller with the
`bootstrap` command. Otherwise, a credential can be specified with the
`--credential` option with both the `bootstrap` and `add-model` commands.

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

There are three providers that use tools that support this variables method:

[Amazon AWS][clouds-aws-using-env-variables] |
[Google GCE][clouds-google-using-env-variables] |
[OpenStack][clouds-openstack-using-env-variables]

Each page provides details on using this method with its respective provider.

!!! Note:
    The `autoload-credentials` command is also used to generate a certificate
    credential for localhost clouds. This is needed for providing access to
    non-admin Juju users. See
    [Additional LXD resources][clouds-lxd-resources-non-admin-creds].
    
### Adding credentials from a file

You can use a YAML-formatted file to store credentials for any cloud. Below we
provide a sample file, which we will call `mycreds.yaml`. It includes many of
the clouds supported by Juju and uses the most common options. Note the MAAS
cloud and the two OpenStack clouds, called 'homemaas', 'homestack-kv2' and
'homestack-kv23' respectively.

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
  homestack-kv2:
    default-region: region-a
    john:
      auth-type: access-key
      access-key: bae7651caeab41ed876cfdb342bae23e
      secret-key: 7172bc91a21c3df1787423ac12093bcc
      tenant-name: admin
      username: admin   
  homestack-kv23:
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

There are several management tasks that can be done related to credentials.

### Listing credentials

When credentials are added to Juju they become available to use on a controller
and its models. There are therefore two categories of credentials: those that
are available and those that are currently in use.

#### Available

You can display what credentials are available by running the command:

```bash
juju list-credentials
```

Sample output:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju credentials -->
```no-highlight
Cloud   Credentials
aws     bob*, carol
google  wayne
```

The asterisk '*' denotes the default credential, which will be used for the
named cloud unless another is specified.

To reveal actual authentication material (e.g. passwords, keys):

```bash
juju list-credentials --format yaml --show-secrets
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

#### In use

To see what credentials are in use by a model (here the 'default' model):

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

The above commands do not display authentication material. To view the active
credentials, including the cloud name, credential names, and the names of
models:

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

### Setting default credentials

You can set the default credential for a cloud:

```bash
juju set-default-credential aws carol
```

Notes:

 - This affects operations that require a newly-input credential (e.g.
   `juju add-model`). In particular, it does not change what is currently in
   use (on a controller).
 - If only one credential name exists, it will become the effective default
   credential.

### Updating local credentials

To update an existing credential locally use the `add-credential` command with
the `--replace` option.

Here we decided to use the file 'mycreds.yaml' from a previous example:

```bash
juju add-credential aws -f mycreds.yaml --replace
```

This will overwrite existing credential information, so make sure all current
credentials are contained in the file, not just the new or changed one.

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

!!! Warning:
    It is not possible to update the credentials if the initial credential name
    is unknown. This restriction will be removed in an upcoming release of
    Juju.

####  Updating remote credentials using a different Juju user

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

If a local credential (i.e. not cached on a controller) is no longer required,
it can be removed:

```bash
juju remove-credential aws bob
```


<!-- LINKS -->

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[clouds-lxd-resources-non-admin-creds]: ./clouds-lxd-resources.md#non-admin-user-credentials
[clouds-aws]: ./help-aws.md
[clouds-azure]: ./help-azure.md
[clouds-google]: ./help-google.md
[clouds-joyent]: ./help-joyent.md
[clouds-rackspace]: ./help-rackspace.md
[clouds-maas]: ./clouds-maas.md
[clouds-oracle]: ./help-oracle.md
[clouds-openstack]: ./help-openstack.md
[clouds-vmware]: ./help-vmware.md
[clouds-aws-using-env-variables]: help-aws.md#using-environment-variables
[clouds-google-using-env-variables]: help-google.md#using-environment-variables
[clouds-openstack-using-env-variables]: help-openstack.md#using-environment-variables
[clouds-adding-clouds-manually]: ./clouds.md#adding-clouds-manually
