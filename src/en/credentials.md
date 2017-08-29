Title: Juju credentials
TODO:  Investigate: shouldn't `model-config` have a default-credential setting?

# Cloud credentials

In order to access your cloud, Juju will need to know how to authenticate
itself. We use the term *credentials* to describe the tokens or keys or secrets
used - a set of credentials is represented by a _credential name_ that is used
to refer to those credentials in subsequent commands.

!!! Important:
    This page assumes that you have already created a controller for your
    cloud (`juju bootstrap` command). If this is not the case, please see
    [Creating a controller][controllers-creating] first.

Juju selects a credential according to how many credentials are defined. If you
have only one credential, or if a credential is labelled 'default', then this
is the credential that will be used by Juju. When multiple credentials are
defined, with no default, a credential name must be specified at the model
level.

Juju can import your cloud credentials in one of three ways:

- Accepting credentials provided interactively by the user on the command line
- Scanning for existing credentials (e.g. environment variables, "rc" files)
- Reading a user-provided [YAML-formatted][yaml] file
 
Each of these methods are explained below, but if you are still having
difficulty you can get extra help by selecting your cloud from among this list:

[Amazon AWS][aws] |
[Microsoft Azure][azure] |
[Google GCE][gce] |
[Joyent][joyent] |
[MAAS][clouds-maas] |
[OpenStack][clouds-openstack] |
[VMware vSphere][clouds-vmware] |
[Oracle Compute][clouds-oracle] |
[Rackspace][rackspace]

!!! Note:
    LXD deployments are a special case. Accessed locally, they do not require
    credentials. Accessed remotely, they need a *certificate credential*. See
    [Using LXD as a cloud][lxd] for further details. 

### Adding credentials via the command line

You can add credentials by running the command:

```bash
juju add-credential <cloud>
```

Juju will then ask for the information it needs. This may vary 
according to the cloud you are using, but will typically look something like
this:

```no-highlight
Enter credential name: carol
Using auth-type "access-key".
Enter access-key: *******
Enter secret-key: *******
Credentials added for cloud aws.
```

Once you have supplied all the information, the credentials will be added.

At present, you will need to manually set one to be the default, if you 
have more than one for a cloud:

```bash
juju set-default-credential <cloud> <credential>
```

Setting a default credential means this will be used by the bootstrap 
command when creating a controller, without having to specify it with
the `--credential` option in the `juju add-model` command.


### Scanning existing credentials

Some cloud providers (e.g. AWS, Openstack) have command line tools which rely on 
environment variables being used to store credentials. If these are in use on 
your system already, or you choose to define them 
([there is extra info here][env]), Juju can import them.

For example, AWS uses the following environment variables (among others):

**AWS_ACCESS_KEY_ID**

**AWS_SECRET_ACCESS_KEY**

If these are already set in your shell (you can echo $AWS_ACCESS_KEY_ID to test)
they can be used by Juju.

To scan your system for credentials Juju can use, run the command:

```bash
juju autoload-credentials
```

This will will ask you whether to store each set of credentials
it finds. Note that this is a 'snapshot' of those stored values - Juju will not 
notice if they change in future.

### Adding credentials from a YAML file

You can also specify a YAML format file for the credentials. This
file would be similar to, but shorter than this extensive sample, which
we will call mycreds.yaml:

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
      homestack:
        default-region: region-a
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
          auth-type: userpass
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
```

A source file like the above can be added to Juju's list of credentials with 
the command:

```bash
juju add-credential aws -f mycreds.yaml
```

This sample includes all of the default cloud options plus a couple of
special cloud options, MAAS and an OpenStack cloud called `homestack` in
the sample. See [Clouds](./clouds.html).

## Managing credentials

You can check what credentials are stored by Juju by running the command:

```bash
juju credentials
```

...which will return a list of the known credentials. For example:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju credentials -->
```no-highlight
Cloud      Credentials
aws     bob*, carol
google  wayne
```

The asterisk '*' denotes the default credential, which will be used for the
named cloud unless another is specified.

For YAML output that includes detailed credential information, including
secrets like access keys and passwords:

```bash
juju credentials --format yaml --show-secrets
```

The YAML output will be similar to our 'mycreds.yaml' sample above.

You can set the default credential:

```bash
juju set-default-credential aws carol
```

To replace or update an existing credential, edit or create a file, such as
our 'mycreds.yaml' example above, then run:

```bash
juju add-credential aws -f mycreds.yaml --replace
```

This will overwrite existing credential information, so make sure all current
credentials are contained in the file, not just the new or changed one.

If a credential is no longer required, it can be removed:

```bash
juju remove-credential aws bob
```

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[lxd]: ./clouds-LXD.html#remote_user_credentials
[aws]: ./help-aws.html
[azure]: ./help-azure.html
[gce]: ./help-google.html
[joyent]: ./help-joyent.html
[rackspace]: ./help-rackspace.html
[clouds-maas]: ./clouds-maas.html
[clouds-oracle]: ./help-oracle.html
[clouds-openstack]: ./help-openstack.html
[clouds-vmware]: ./help-vmware.html
[controllers-creating]: ./controllers-creating.html
