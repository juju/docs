Title: Getting started with Juju  
TODO: Testing section needs rewrite
      Commands are as spec, but not implemented yet
      Headings need looking at!
      Links need to be reverified when supporting pages are written

!!! Note: These instructions are currently transitional. They will become the
standard instructions for the stable 2.0 release, but as not all features of
that release are fully finalised, some parts may change. If you are currently
using a pre-release version of Juju, please also refer to the release notes
for caveats and install information. There are many broken links etc, this is
all work in progress

# Getting started with Juju

Before you start on your Juju adventure, please make sure you have the
following:

  - An Ubuntu, CentOS, MacOSX, or Windows machine to install the client on.
  - Credentials to access a cloud (e.g. AWS, GCE, OpenStack...)
  - An SSH key-pair. On Linux and Mac OSX: `ssh-keygen -t rsa -b 2048` On Windows:
  See the [Windows instructions for SSH and PuTTY][keygen].

The rest of this page will guide you through installing the software, accessing
your cloud and deploying a test workload.

# 1. Install Juju

Juju is currently available for Ubuntu, CentOS, MacOSX and Windows.

## Ubuntu

To install Juju, you simply need to grab the latest juju2 package from the
PPA:

```bash
sudo add-apt-repository ppa:juju/devel
sudo apt-get update && sudo apt-get install juju2
```

Using this PPA resource gurantees you will always have access to the very latest
development version of Juju.


## CentOS, MacOSX, Windows

See [the releases page](reference-releases.html) for instructions on how to
install the versions currently available.


# 2. Choose a cloud

Juju maintains knowledge about supported public clouds and their regions. To see
the list of clouds Juju currently knows about, simply enter:

```bash
juju list-clouds
```
Which should return a list like this:

<!--CLOUD LIST -->
```no-highlight
CLOUD        TYPE        REGIONS
aws          ec2         us-east-1, us-west-1, us-west-2, eu-west-1, eu-central-1, ap-southeast-1, ap-southeast-2 ...
aws-china    ec2         cn-north-1
aws-gov      ec2         us-gov-west-1
azure        azure       centralus, eastus, eastus2, northcentralus, southcentralus, westus, northeurope ...
azure-china  azure       chinaeast, chinanorth
cloudsigma   cloudsigma  hnl, mia, sjc, wdc, zrh
google       gce         us-east1, us-central1, europe-west1, asia-east1
joyent       joyent      eu-ams-1, us-sw-1, us-east-1, us-east-2, us-east-3, us-west-1
rackspace    rackspace   DFW, ORD, IAD, LON, SYD, HKG
```

Juju already knows how to talk to these cloud providers, but it can also work
with other clouds, including any OpenStack cloud, a MAAS environment, or the
amazingly fast 'local' provider (Linux only), which is ideal for development
and testing.

To let Juju know about other clouds, or to customise the configuration further,
please [read the instructions on managing clouds][clouds].

If you have an account with a listed cloud, you don't need to configure anything,
Juju just needs your credentials for accessing the cloud.

!!! Note: alpha/beta versions require some extra configuration for streams,
see the release notes!

# 3. Enter your credentials

Juju currently uses three possible ways to get your credentials for a cloud:

  - Scanning appropriate environment variables for credentials
  - Reading its own credentials.yaml file
  - Passing the values on the commandline when bootstrapping

## Using environment variables  

Some cloud providers (e.g. AWS, Openstack) have commandline tools which rely on
environment variables being used to store credentials. If these are in use on
your system already, or you choose to define them ([there is extra info here][env]),
Juju will use them too.

For example, AWS uses the following environment variables (among others):

  **`AWS_ACCESS_KEY_ID`**

  **`AWS_SECRET_ACCESS_KEY`**

If these are already set in your shell (you can `echo $AWS_ACCESS_KEY_ID` to
test) they can be used by Juju.

To store these credentials permanently for Juju, it is recommended to run the
command:

```bash
juju autoload-credentials
```  


## Specifying credentials

Juju maintains a file of known credentials
(`~/.local/share/juju/credentials.yaml` on Ubuntu) for accessing clouds. You can
add credentials by running the command:

```bash
juju add-credential <cloud>
```  
Juju will then interactively ask for the information it needs. This may vary
according to the cloud you are using, but will typically look something like
this:

```bash
juju add-credential aws
credential name: carol
select auth-type [userpass, oauth, etc]: userpass
enter username: cjones
enter password: *******
```
You can also specify a YAML format source file for the credentials. The source
file would be similar to:

```yaml
credentials:
  aws:
    default-credential: bob
    default-region: us-east-1
    bob:
      auth-type: access-key
      access-key: AHJHKUWK7HIW
      secret-key: 21f8cbb668263a1223755b5f15c48a
```

A source file like the above can be added to Juju's list of credentials with
the command:

```bash
juju add-credential aws -f mycreds.yaml
```

You can check what credentials are stored by Juju by running the command:

```bash
juju list-credentials
```
which will return a list of the known credentials. For example:

```no-highlight
CLOUD   CREDENTIALS
aws     bob*, carol
google  wayne
```
The asterisk '*' denotes the default credential, which will be used for the
named cloud unless another is specified.

(For more help with credentials, auth-types and the commands mentioned here,
please [see this guide to credentials][credentials])

# 4. Bootstrap

Before you can start using Juju to spin up services in a cloud, it needs to
create its own instance to act as a controller. The controller is your Juju
agent in the cloud, receiving and processing commands and communicating with any
other instances you create there.

To do this, we use the `bootstrap` command:

```bash
juju bootstrap <controller-name>  <cloud>
```
So, assuming we are using the cloud 'aws', we should run:

```bash
juju bootstrap test aws
```

This bootstrap process may take a few minutes to complete as it creates a new
instance in the cloud and fetches the sofware it requires, but you should see
plenty of feedback in your shell.

!!! Note: If there any errors in the bootstrap process, take a look at our
[FAQ][faq] for possible solutions!


# 5. Testing

!!! Note: This section not yet updated for 2.0

With the Juju controller running, you can now start deploying services.

To start with, we will deploy WordPress:

```bash
juju deploy wordpress
```

Juju will download and use the WordPress charm, through the bootstrap instance,
to request and deploy whatever resources it needs to install this service.

Since WordPress requires a database, we will deploy one:

```bash
juju deploy mysql
```

Again, Juju will do whatever is necessary to deploy this service for you,
and it may take some time for the command to return.

**Note:** If you want to get more information on what is actually happening,
or to help resolve problems, you can add the `--show-log` switch to the juju
command to get verbose output.

Although we have deployed WordPress and a MySQL database, they are not linked
together in any way yet. To do this we run:

```bash
juju add-relation wordpress mysql
```

This command uses information provided by the relevant charms to associate these
services with each other in whatever way makes sense. There is much more to be
said about linking services together which is covered in the Juju [command
documentation](commands.html), but for the moment, we just need to know that it
will link these services together.

In order to make our WordPress public, we now need to expose this service:

```bash
juju expose wordpress
```

This service will now be configured to respond to web requests, so visitors can
see it. But where exactly is it? If we run the `juju status` command, we will be
able to see what services are running, and where they are located.

```bash
juju status
```

The output from this command should look something like this:

```no-highlight

TO BE UPDATED

```


From this output, we can see that WordPress is exposed and ready. If we
point a web browser at the address we should be able to access it:

![WordPress in a web browser](./media/getting_started-wordpress.png)

Congratulations, you have just deployed a service with Juju!

Now you are ready to deploy whatever service you want from the 100s
available at the [Juju Charm Store.](https://jujucharms.com).

To remove all current deployments and clear everything in your cloud, you can
run:

```bash
juju destroy-controller <controller-name>
```

Where `<controller-name>` is the name you gave the controller when you
bootstrapped it. A warning will be displayed and the user will be prompted whether
or not to continue.

# Next Steps

Now you have a Juju-powered cloud, it is time to explore the amazing things you
can do with it!

We suggest you take the time to read the following:

  - [Juju concepts][concepts] - This page explains the terminology used throughout this
    documentation and describes what Juju can do
  - [Clouds][clouds] goes into detail about configuring clouds, including the
    'local' cloud, which is great for lightning fast testing and development.
  - [Charms/Services][charms] - find out how to construct complicated workloads
    in next to no time.


[clouds]: ./clouds.html  "Configuring Juju Clouds"
[charm store]: https://jujucharms.com "Juju Charm Store"
[releases]: reference-releases.html
[keygen]: ./getting-started-keygen-win.html "How to generate an SSH key with Windows"
[concepts]: ./juju-concepts.html "Juju concepts"
[charms]: ./charms-intro.html
[credentials]: ./credentials.html
[faq]: ./getting-started-faq.html
