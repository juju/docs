# Using Juju with Vagrant

The Juju Vagrant images are a way of extending the portability and ease of use
of LXC containers to other platforms. The initial image is based on the Ubuntu
Cloud Images. Juju is configured to use the local LXC provider and is preseeded
with the latest LTS releases so deployments should be relatively fast.

Using these images gives you a couple of things:

- A Vagrant development environment for developing your charms.
- The Juju GUI accessible locally through your browser.
- A functional, self contained Juju environment.

In short, enough of an environment to write and test charms or sandbox your
Juju deployments.

## Installing

The following instructions will help you get the environment set up:

[Ubuntu](.) [Mac OSX](.) [Windows](.)

To install vagrant and the other required tools on Ubuntu, run:

    sudo apt-get update 
    sudo apt-get -y install virtualbox vagrant sshuttle

1. Fetch and install VirtualBox from
[virtualbox.org](https://www.virtualbox.org/) 1. Install Vagrant from
[vagrantup.com](http://www.vagrantup.com/downloads.html) 1. (optional) Install
Sshuttle. You can do this via `homebrew`: brew install sshuttle

Or you can get the source from
[github.com/apenwarr/sshuttle](https://github.com/apenwarr/sshuttle)

1. Fetch and install VirtualBox from
[virtualbox.org](https://www.virtualbox.org/) 1. Install Vagrant from
[vagrantup.com](http://www.vagrantup.com/downloads.html) 1. (optional) Install
Sshuttle. (this requires the [node.js binary for
Windows](http://nodejs.org/download/))

Run: `npm install sshuttle`

## Choosing "boxes"

Vagrant uses "boxes," as a way of distributing the virtual machine images. We
have put all our boxes on the Ubuntu Cloud Images site. The quick links are:

### 14.04 LTS:

- [trusty-server-cloudimg-amd64-juju-vagrant-disk1.box](http://cloud-images.ubuntu.com/vagrant/trusty/trusty-server-cloudimg-amd64-juju-vagrant-disk1.box)
- [trusty-server-cloudimg-i386-juju-vagrant-disk1.box](http://cloud-images.ubuntu.com/vagrant/trusty/trusty-server-cloudimg-i386-juju-vagrant-disk1.box)

### 12.04 LTS:

- [precise-server-cloudimg-amd64-juju-vagrant-disk1.box](http://cloud-images.ubuntu.com/vagrant/precise/precise-server-cloudimg-amd64-juju-vagrant-disk1.box)
- [precise-server-cloudimg-i386-juju-vagrant-disk1.box](http://cloud-images.ubuntu.com/vagrant/precise/precise-server-cloudimg-i386-juju-vagrant-disk1.box)

If you are unsure which one to fetch, use the 64-bit builds as most modern
machines are now 64bit (x86_64 AMD64). If you need other versions of Ubuntu,
check out the [Cloud Images](http://cloud-images.ubuntu.com/vagrant/). These
images are also listed on [Vagrant Cloud](https://vagrantcloud.com/ubuntu).

## Getting started!

Vagrant makes getting started really easy.

Choose a directory to work in. This directory will be shared with the guest,
and contain the vagrant configuration for the machine. Run:

    vagrant box add JujuBox <URL>

The URL can be from the list above or a local file if you have already
downloaded a suitable box. For example:

    vagrant box add JujuBox
http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-juju-vagrant-disk1.box

This will download the box from the URL you chose above.The box will be given
the name of "JujuBox"

## Initialise and start

Initialize this environment by running:

    vagrant init JujuBox

Then start it with:

    vagrant up

The box will start and configure Juju for you.

![Step two](./media/config-vagrant-step02.png)

## Access the GUI

In order to access the GUI, go to the url:
[http://127.0.0.1:6080](http://127.0.0.1:6080). Until the Juju GUI is deployed,
you will see a status page. Wait a few minutes, refresh the page. Once the GUI
is deployed, it will display the password on the login page.

![Step three](./media/config-vagrant-step03.png)

The GUI is only accessible from your local host. From there you will be able to
deploy charms, add relations, etc.

## Vagrant lifecycle

To shut down the machine run `vagrant halt`

To destroy it, run `vagrant destroy`

To ssh in, run `vagrant ssh`

## SSHuttle (optional)

If you want to use this environment for developing Juju Charms, you can do so
with the aid of SSHuttle. SSHuttle is a slick tool for using SSH as a VPN. When
used with the Juju Vagrant images, it means that you can have a completely
disposable development environment, you can use your preferred editor, and
access your charms locally.

The box uses 10.0.3.0/24 as the LXC network. To grant local access
to that group, run:

        sshuttle -r vagrant@localhost:2222 10.0.3.0/24


Use the password "vagrant"
