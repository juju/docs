Title: Juju credentials

# Cloud credentials

In order to access your cloud (with the exception of [LXD][lxd]), Juju will
need to know how to authenticate itself. We use the term “credentials” to 
describe the tokens or keys or secrets used - a set of credentials 
is represented by a _credential name_ that is used to refer to those 
credentials in subsequent commands.


Currently, Juju can use one of three ways to get your credentials for a cloud:

 - Entering credentials interactively on the command-line
 - Scanning existing credentials (e.g. environment variables, .novarc files)
 - Importing a user-provided [YAML-formatted][yaml] file.
 

These methods are explained in more detail below.

If you are having difficulty determining the credentials needed for your 
particular cloud, you should find these pages on specific clouds helpful: 

  [Amazon Web Services][aws]
  
  [Microsoft Azure][azure]
  
  [Google Compute Engine][gce]
  
  [Joyent][joyent]
  
  [Rackspace][rackspace]


### Adding credentials via the commandline

You can add credentials by running the command:

```bash
juju add-credential <cloud>
```
Juju will then ask for the information it needs. This may vary 
according to the cloud you are using, but will typically look something like
this:

```no-highlight
juju add-credential aws 
credential name: carol
select auth-type [userpass, oauth, etc]: userpass
enter username: cjones
enter password: *******
```

Once you have supplied all the information, the credentials will be added.

At present, you will need to manually set one to be the default, if you 
have more than one for a cloud:

```bash
juju set-default-credential <cloud> <credential>
```

Setting a default credential means this will be used by the bootstrap 
command when creating a controller, without having to specify it with
the `--credential` option.


### Scanning existing credentials

Some cloud providers (e.g. AWS, Openstack) have commandline tools which rely on 
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

### Adding credentials from a YAML file.

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
          access-key: key
          secret-key: secret
        paul:
          auth-type: access-key
          access-key: key
          secret-key: secret
      homemaas:
        peter:
          auth-type: oauth1
          maas-oauth: mass-oauth-key
      homestack:
        default-region: region-a
        peter:
          auth-type: userpass
          password: secret
          tenant-name: tenant
          username: user
      google:
        peter:
          auth-type: jsonfile
          file: path-to-json-file
      azure:
        peter:
          auth-type: userpass
          application-id: blah
          subscription-id: blah
          application-password: blah
      joyent:
        peter:
          auth-type: userpass
          sdc-user: blah
          sdc-key-id: blah
          private-key: blah (or private-key-path)
          algorithm: blah
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
juju list-credentials
```

...which will return a list of the known credentials. For example:

```no-highlight
CLOUD   CREDENTIALS
aws     bob*, carol
google  wayne
```

The asterisk '*' denotes the default credential, which will be used for the
named cloud unless another is specified.

You can set the default credential:

```bash
juju set-default-credential aws carol
```

If a credential is no longer required, it can be removed:

```bash
juju remove-credential aws bob
```
 





[yaml]: http://www.yaml.org/spec/1.2/spec.html
[lxd]: ./clouds-LXD.html
[aws]: ./help-aws.html
[azure]: ./help-azure.html
[gce]: ./help-google.html
[joyent]: ./help-joyent.html
[rackspace]: ./help-rackspace.html
