Title:  Vagrant Juju Workflow on OS X  


#  Vagrant Juju Workflow on OS X

Running Juju on Ubuntu is a straightforward process thanks to the addition of
the Local Provider. OS X does not support virtualization at the operating
system level, however. The next best solution is to use a virtualization
wrapper like [Vagrant](https://www.vagrantup.com).


##  Getting started

Ensure the following software components are installed on your development
machine:

- [Homebrew](http://brew.sh)
- [Vagrant](https://www.vagrantup.com)
- [VirtualBox](https://www.virtualbox.org/)

### Preparing to use Vagrant

See [Configuring for Vagrant](./config-vagrant.html) for instructions on
downloading and preparing your new virtual machine.


## Writing your first charm

###  Preparing our local charm repository

We will need to create a directory structure that reflects the current standard
for Juju charm repositories.

```bash
mkdir -p ~/vagrant/charms/trusty
```

Feel free to add any other LTS based target directory, for example if you were
to target Precise Pangolin as a release for your charm, the command would be:

```bash
mkdir -p ~/vagrant/charms/precise
```

For the remainder of this tutorial Trusty will be used.

###  Installing charm tools

Charm Tools offer a means for users and charm authors to create, search, fetch,
update, and manage charms.

These can be installed via homebrew.

```bash
brew install charm-tools
```

##  Creating our first charm

Let's write a charm for [GenghisApp](http://genghisapp.com/) - a single file
MongoDB administration application.

```bash
cd charms/trusty
charm create genghisapp -t bash
```

This will create a skeleton structure of a charm ready for you to edit and
populate with your services deployment and orchestration logic.

```no-highlight
├── README.ex
├── config.yaml
├── hooks
│   ├── config-changed
│   ├── install
│   ├── relation-name-relation-broken
│   ├── relation-name-relation-changed
│   ├── relation-name-relation-departed
│   ├── relation-name-relation-joined
│   ├── start
│   ├── stop
│   └── upgrade-charm
├── icon.svg
├── metadata.yaml
└── revision
```

### Writing the charm

Begin by editing the metadata.yaml file to populate the information about our
charm.

```yaml
   name: genghisapp
   summary: Genghisapp the single file MongoDB administration tool
   maintainer: Charles Butler <chuck@dasroot.net>
   description: |
      deploys the genghisapp gem, defaults to running on port 80. No additional relations are required to speak to the MongoDB Service. All data relating to the connection is stored in the browser Local Storage engine.
   categories:
     - app
   subordinate: false
   provides:
     website:
      interface: http
```

Now that Juju knows something about our service we're ready to start writing the
hooks.

####  Install hook

```bash
#!/bin/bash
set -ex
# Prior to ubuntu 14.04, rubygems-integration should be replaced by rubygems on the following line
apt-get install -y ruby1.9.3 rubygems-integration build-essential
HOME=/root gem install genghisapp bson_ext --no-ri --no-rdoc
```

####  Config-Changed hook

```bash
#!/bin/bash
set -ex
hooks/stop
sleep 2
hooks/start
```

####  Start hook

```bash
#!/bin/bash
set -ex
PORT=80
if [ ! -f /root/.vegas/genghisapp/genghisapp.pid ] ; then
    HOME=/root genghisapp -L -p $PORT
fi
open-port $PORT
```

####  Stop hook

```bash
#!/bin/bash
set -ex
HOME=/root genghisapp -K
```

### Preparing Vagrant

Since vagrant is going to be our working environment, we'll want to make sure
its aware of all our charms; not just the current charm we are working on.

```bash
cd ~/vagrant
vagrant init JujuBox
vagrant up
```

![Vagrant Bootstrap](media/howto-vagrant-workflow-vagrantup.png)

You now have a Juju installation ready to be used for testing your charm on
OSX, and an instance of Juju Gui to interface with your services. Validate that
the GUI is accessible from [http://localhost:6080](http://localhost:6080)

!!! Note: The password is output in your console feedback from the Juju
bootstrap.

!!! Note: All your charms in $HOME/charms are available in the /vagrant
directory of our JujuBox.


### Deploying our charm in Vagrant

You'll need to enter the Juju environment we just bootstrapped in $HOME/charms:

```bash
vagrant ssh
juju deploy mongodb
juju deploy --repository=/vagrant/charms local:trusty/genghisapp
```

Progress can be tracked with the GUI.

![juju-gui](media/howto-vagrant-workflow-juju-gui-wait.png)

When the Genghis badge turns green, it is time to tunnel (VPN) traffic through
the Vagrant image and interface with the Genghis server.


### Routing local traffic to Vagrant

!!! Note: If your local network is using 10.0.3.x you will need to alter the
Juju networking in the Vagrant box, and substitute the network provided in the
command above.


#### Native routing (OS X 10.10 and above)

It is possible to natively route traffic from your local machine to the LXC
containers running within the Vagrant virtual machine.

```bash
sudo route add -net 10.0.3.0/24 172.16.250.15
```

This will only work until your next reboot. Instead, there is a way to create
the route when you `up` your Vagrant image and tear it down when you `halt`:

Install the [vagrant-triggers](https://github.com/emyl/vagrant-triggers) plugin:

```bash
vagrant plugin install vagrant-triggers
```

Add the config.trigger rules in your Vagrantfile:

```no-highlight
config.trigger.after [:provision, :up, :reload] do
    system('sudo route add -net 10.0.3.0/24 172.16.250.15 >/dev/null')
end

config.trigger.after [:halt, :destroy] do
    system('sudo route delete -net 10.0.3.0/24 172.16.250.15 >/dev/null')
end
```

Now, when you `up` and `halt` your Vagrant box, the route will be handled for
you.


#### Using sshuttle (OS X 10.9 and below)

sshuttle creates a transparent proxy server on your local machine that allows
you to connect directly to the LXC containers running within the Vagrant
virtual machine. This process disassembles the TCP stream locally, multiplexes
it statefully over the ssh session, and reassembles the packets on the other
end of the tunnel.

Ensure that you have sshuttle installed

```bash
brew install sshuttle
sshuttle -r vagrant@localhost:2222 10.0.3.0/24
```

!!! Note: You can skip the brew install line if you already have sshuttle
installed

!!! Note: sshuttle does not work under OS X 10.10 (Yosemite) due to the
deprecation of ipfw in favor of pf.

When prompted for the password enter `vagrant`.


## Connecting to your application

Now we are free to connect to Genghis. Open up the Genghis running unit list
and click on the Genghis host, then click on the port 80 link in the service
detail.

![](media/howto-vagrant-workflow-juju-gui-wait.png)

![](media/howto-vagrant-workflow-genghis.png)


##  Iterating

With Vagrant fully set up and our charm deployed, we can iterate over our charm
and update/test via normal means.

- Make edits on your HOST in your favorite editor, such as
  [TextMate](http://macromates.com/), [Atom](https://atom.io/), or
  [Brackets](http://brackets.io/).
- Run commands inside the JujuBox vagrant environment. `juju upgrade-charm
  genghisapp`
- View results in your HOST browser of choice.


## Next steps

Installing Juju, for deploying to non-local environments


## Reporting issues with the Vagrant image

If you encounter any issues with the Vagrant images, please
[file a bug report](https://bugs.launchpad.net/juju-vagrant-images).
