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
sudo apt update
sudo apt install juju
```

!!! Note: the above currently installs the 'devel' version of Juju, for 
pre-release testing of Juju 2.0. 

Using this PPA resource gurantees you will always have access to the very latest
stable version of Juju.


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
lxd          lxd         localhost
maas         maas        
manual       manual      
rackspace    rackspace   dfw, ord, iad, lon, syd, hkg
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
  
^# Using environment variables  

   Some cloud providers (e.g. AWS, Openstack) have commandline tools which rely on environment variables being used to store credentials. If these are in use on your system already, or you choose to define them ([there is extra info here][env]), Juju will use them too.

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
instance in the cloud and fetches the software it requires, but you should see
plenty of feedback in your shell.

!!! Note: If there any errors in the bootstrap process, take a look at our 
[FAQ][faq] for possible solutions!


# 5. Testing 

Juju is now ready to deploy any services from the hundreds included in the
[juju charm store](https://jujucharms.com). It is a good idea to test your new 
model. How about a Mediawiki site?

```bash
juju deploy mediawiki-single
```
This will fetch a 'bundle' from the Juju store. A bundle is a pre-packaged set
of services, in this case the 'Mediawiki' service, and a database to run it 
with. Juju will install both these services and add a relation between them - 
this is part of the magic of Juju: it isn't just about deploying services, Juju 
also knows how to connect them together.

Installing shouldn't take long. You can check on how far Juju has got by running
the command:
 
```bash
juju status
```
When the services have been installed the output to the above command will look
something like this:

![juju status](./media/juju-mediawiki-status.png)

There is quite a lot of information there but the important parts for now are 
the [Services] section, which show that Mediawiki and MySQL are installed, and
the [Units] section, which crucially shows the IP addresses allocated to them.

By default, Juju is secure - you won't be able to connect to any services 
unless they are specifically exposed. This adjusts the relevant firewall 
controls (on any cloud, not just LXD) to allow external access. To make
our Mediawiki visible, we run the command:

```bash
juju expose mediawiki
```

From the status output, we can see that the Mediawiki service is running on 
10.0.3.60 (your IP may vary). If we open up Firefox now and point it at that 
address, you should see the site running.

!["mediawiki site"](./media/juju-mediawiki-site.png)

Congratulations, you have just deployed a service with Juju!

!!! Note: To remove all the services in the model you just created, it is 
often quickest to destroy the model with the command 'juju destroy-model default` 
and then create a new model.


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
