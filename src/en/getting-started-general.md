Title: Getting started with Juju
TODO: Testing section needs rewrite
      Commands are as spec, but not implemented yet
      Headings need looking at!
      Links need to be reverified when supporting pages are written
      Remove PPA info when Juju2 lands a stable release in main repo

# Getting started with Juju

Before you start on your Juju adventure, please make sure you have the
following:

- An Ubuntu, CentOS, MacOSX, or Windows machine to install the client on.
- Credentials to access a cloud (e.g. AWS, GCE, OpenStack...)
- An SSH key-pair. On Linux and Mac OSX: `ssh-keygen -t rsa -b 2048` On Windows:
  See the [Windows instructions for SSH and PuTTY][keygen].

The rest of this page will guide you through installing the software, accessing
your cloud and deploying a test workload.


## 1. Install Juju

Juju is currently available for Ubuntu, CentOS, MacOSX and Windows.

### Ubuntu

To install Juju, you simply need to grab the 'juju' package from the
PPA:

```bash
sudo add-apt-repository ppa:juju/stable
sudo apt update
sudo apt install juju
```
Using the stable PPA resource guarantees you will always have access to the very latest
stable version of Juju.

### CentOS, MacOSX, Windows

See [the releases page](reference-releases.html) for instructions on how to
install the versions currently available.

## 2. Choose a cloud

Juju maintains knowledge about supported public clouds and their regions. To see
the list of clouds Juju currently knows about, simply enter:

```bash
juju list-clouds
```
Which should return a list like this:

<!--CLOUD LIST -->
```no-highlight
Cloud        Regions  Default        Type        Description
aws               11  us-east-1      ec2         Amazon Web Services
aws-china          1  cn-north-1     ec2         Amazon China
aws-gov            1  us-gov-west-1  ec2         Amazon (USA Government)
azure             18  centralus      azure       Microsoft Azure
azure-china        2  chinaeast      azure       Microsoft Azure China
cloudsigma         5  hnl            cloudsigma  CloudSigma Cloud
google             4  us-east1       gce         Google Cloud Platform
joyent             6  eu-ams-1       joyent      Joyent Cloud
rackspace          6  dfw            rackspace   Rackspace Cloud
localhost          1  localhost      lxd         LXD Container Hypervisor
```

Juju already knows how to talk to these cloud providers, but it can also work
with other clouds, including any OpenStack cloud, a MAAS provider, or the
amazingly fast 'local' provider (Linux only), which is ideal for development
and testing.

To let Juju know about other clouds, or to customise the configuration further,
please [read the instructions on managing clouds][clouds].

If you have an account with a listed cloud, you don't need to configure anything,
Juju just needs your credentials for accessing the cloud.

## 3. Enter your credentials

Juju currently uses three possible ways to get your credentials for a cloud:

- Scanning appropriate environment variables for credentials
- Reading its own credentials.yaml file
- Passing the values on the command line when bootstrapping

^# Using environment variables

   Some cloud providers (e.g. AWS, Openstack) have command line tools which rely on environment variables being used to store credentials. If these are in use on your system already, or you choose to define them, Juju will use them too.

   For example, AWS uses the following environment variables (among others):

     **`AWS_ACCESS_KEY_ID`**

    **`AWS_SECRET_ACCESS_KEY`**

   If these are already set in your shell (you can `echo $AWS_ACCESS_KEY_ID` to test) they can be used by Juju.

   To store these credentials permanently for Juju, it is recommended to run the command:

        juju autoload-credentials



^# Specifying credentials

   Juju maintains a file of known credentials
   (`~/.local/share/juju/credentials.yaml` on Ubuntu) for accessing clouds. You can add credentials by running the command:

       juju add-credential <cloud>

   Juju will then interactively ask for the information it needs. This may vary according to the cloud you are using, but will typically look something like this:

        juju add-credential aws
       credential name: carol
       select auth-type [userpass, oauth, etc]: userpass
       enter username: cjones
       enter password: *******

   You can also specify a YAML format source file for the credentials. The source file would be similar to:

         credentials:
         aws:
           default-credential: bob
           default-region: us-east-1
           bob:
             auth-type: access-key
             access-key: AHJHKUWK7HIW
             secret-key: 21f8cbb668263a1223755b5f15c48a

    A source file like the above can be added to Juju's list of credentials with the command:

          juju add-credential aws -f mycreds.yaml



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


## 4. Bootstrap

Before you can start using Juju to spin up applications in a cloud, it needs to
create its own instance to act as a controller. The controller is your Juju
agent in the cloud, receiving and processing commands and communicating with any
other instances you create there.

To do this, we use the `bootstrap` command:

```bash
juju bootstrap <cloud> <controller-name>
```

So, assuming we are using the cloud 'aws', we should run:

```bash
juju bootstrap aws test
```

This bootstrap process may take a few minutes to complete as it creates a new
instance in the cloud and fetches the software it requires, but you should see
plenty of feedback in your shell.

## 5. Testing

Juju is now ready to deploy any applications from the hundreds included in the
[juju charm store](https://jujucharms.com). It is a good idea to test your new
model. How about a Mediawiki site?

```bash
juju deploy mediawiki-single
```

This will fetch a 'bundle' from the Juju store. A bundle is a pre-packaged set
of applications, in this case 'Mediawiki', and a database to run it
with. Juju will install both these applications and add a relation between them -
this is part of the magic of Juju: it isn't just about deploying applications,
Juju  also knows how to connect them together.

Installing shouldn't take long. You can check on how far Juju has got by running
the command:

```bash
juju status
```

When the applications have been installed the output to the above command will
look something like this:

![juju status](./media/juju-mediawiki-status.png)

There is quite a lot of information there but the important parts for now are
the [APP] section, which show that Mediawiki and MySQL are installed, and
the [UNIT] section, which crucially shows the IP addresses allocated to them.

By default, Juju is secure - you won't be able to connect to any applications
unless they are specifically exposed. This adjusts the relevant firewall
controls (on any cloud, not just LXD) to allow external access. To make
our Mediawiki visible, we run the command:

```bash
juju expose mediawiki
```

From the status output, we can see that the Mediawiki application is running on
10.78.0.239 (your IP may vary). If we open up Firefox now and point it at that
address, you should see the site running.

!["mediawiki site"](./media/juju-mediawiki-site.png)

Congratulations, you have just deployed an application with Juju!

!!! Note: To remove all the applications in the model you just created, it is
often quickest to destroy the model with the command 'juju destroy-model default`
and then create a new model.

## Next Steps

Now that you have a Juju-powered cloud, it is time to explore the amazing
things you can do with it!

We suggest you continue your journey by discovering
[how to add controllers for additional clouds][tut-cloud]


[charm store]: https://jujucharms.com "Juju Charm Store"
[releases]: reference-releases.html
[keygen]: ./getting-started-keygen-win.html "How to generate an SSH key with Windows"
[concepts]: ./juju-concepts.html "Juju concepts"
[charms]: ./developer-getting-started.html
[credentials]: ./credentials.html
[tut-cloud]: ./tut-google.html
