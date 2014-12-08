#  Vagrant Juju Workflow on OS X

Running juju on Ubuntu is an extremely straightforward process thanks to the addition of the local provider. OS X does not support virtualization at the operating system level, however. The next best solution is to use a virtualization wrapper like [Vagrant](config-vagrant.html).

##  Getting Started

To start you will want to ensure you've got the following tools installed on your development machine:

- [Homebrew](http://brew.sh)
- [Vagrant](http://vagrantup.com)
- [VirtualBox](https://www.virtualbox.org/)

### Preparing to use Vagrant

Head over to the [Juju Vagrant](config-vagrant.html) provider documentation for instructions on downloading and preparing your new virtual machine.

## Writing your first charm


###  Preparing our local charm repository

We will need to create a directory structure that reflects the current standard for juju charm repositories.

    mkdir -p ~/vagrant/charms/trusty

Feel free to add any other LTS based target directory, for example if you were to target Precise Pangolin as a release for your charm, the command would be:

    mkdir -p ~/vagrant/charms/precise

For the remainder of this tutorial, I will assume we are targeting Trusty, as it's the current LTS target of choice.

###  Installing Charm-Tools

Now is a good time to fetch Charm Tools. But what are charm tools you ask?

> Charm Tools offer a means for users and charm authors to create, search, fetch, update, and manage charms.

These can be installed via homebrew.

    brew install charm-tools

##  Creating our first charm

Lets charm up [GenghisApp](http://genghisapp.com/) - a single file MongoDB
administration app.

    cd charms/trusty
    charm create genghisapp -t bash

This will create a skeleton structure of a charm ready for you to edit and
populate with your services deployment and orchestration logic.

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

### Writing the Charm

We'll start by editing the metadata.yaml to populate the information about our
charm.

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

Now that juju knows something about our service we're ready to start writing the
hooks.

####  Install Hook

    #!/bin/bash
    set -ex
    apt-get install -y ruby1.9.3 rubygems
    update-alternatives --set ruby /usr/bin/ruby1.9.1
    update-alternatives --set gem /usr/bin/gem1.9.1
    HOME=/root gem install genghisapp bson_ext --no-ri --no-rdoc

####  Config-Changed Hook

    #!/bin/bash
    set -ex
    hooks/stop
    sleep 2
    hooks/start

####  Start Hook

    #!/bin/bash
    set -ex
    PORT=`config-get port`
    if [ ! -f /root/.vegas/genghisapp/genghisapp.pid ] ; then
        HOME=/root genghisapp -L -p $PORT
    fi
    open-port $PORT

####  Stop Hook

    #!/bin/bash
    set -ex
    HOME=/root genghisapp -K

### Preparing Vagrant

Since vagrant is going to be our working environment, we'll want to make sure
its aware of all our charms; not just the current charm we are working on.

    cd ~/vagrant
    vagrant init JujuBox
    vagrant up

![Vagrant Bootstrap](media/howto-vagrant-workflow-vagrantup.png)

You now have a Juju installation ready to be used for testing your charm on OSX,
and an instance of Juju-Gui to interface with your services. Validate that the
GUI is accessible from [http://localhost:6080](http://localhost:6080)

**Note:** The password is output in your console feedback from the juju bootstrap.

**Note:** All your charms in $HOME/charms are available in the /vagrant directory of our JujuBox

### Deploying our charm in vagrant

You'll need to enter the juju environment we just bootstrapped in $HOME/charms

    vagrant ssh
    juju deploy mongodb
    juju deploy --repository=/vagrant local:trusty/genghisapp

We are now free to watch progress through the GUI

![juju-gui](media/howto-vagrant-workflow-juju-gui-wait.png)

When the Genghis badge turns green, we are ready to vpn our traffic through the
vagrant image and interface with the Genghis server

### Routing traffic with sshuttle

Ensure that you have sshuttle installed

    brew install sshuttle
    sshuttle -r vagrant@localhost:2222 10.0.3.0/24

**Note:** You can skip the brew install line if you already have sshuttle installed

**Note:** If your local network is using 10.0.3.x you will need to alter the Juju networking in the vagrant box, and substitute the network provided in the command above

When prompted for the password enter `vagrant` and you should see output similar to the following:

Now we are free to connect to genghis. Open up the Genghis running unit list and click on the Genghis host, then click on the port 80 link in the service detail.

![](media/howto-vagrant-workflow-juju-gui-wait.png)

![](media/howto-vagrant-workflow-genghis.png)

##  Iterating

With vagrant fully setup, our charm deployed. We can now iterate over our charm
and update/test via normal means.

- Make edits on your HOST in your favorite editor, such as [TextMate](http://macromates.com/), [Atom](https://atom.io/), or [Brackets](http://brackets.io/).
- run commands inside the JujuBox vagrant environment. `juju upgrade-charm genghisapp`
- view results in your HOST browser of choice.

## Next steps

Installing juju, for deploying to non-local environments
