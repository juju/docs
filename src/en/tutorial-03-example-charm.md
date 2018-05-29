Title: Hello World example charm development (Part 3/3).

# What you will learn:

We will build on the previous tutorial: Hello World example charm development, [part 2/3](tutorial-02-example-charm.html) to:

* Make your charm proper to be shared with the community
* Target a specific version (series) of ubuntu for the charm.
* Push a charm to your account in the charmstore
* Deploy your example charm from the charmstore

## Adding a repo to 'layer.yaml'
Having a repo key helps others contribute to your charm.

Go ahead and a link to your repo last in the ** layer.yaml ** file. It should look like this where you replace the link to your own code.

<pre>
includes: 
  - 'layer:basic'
  - 'layer:apt'
  - 'interface:mysql'
options:
  apt:
    packages:
     - hello 
repo: git@github.com:erik78se/layer-example.git
</pre>

## Define a "series" in metadata.yaml
To help juju know which version of ubuntu your charm works best for, add a series tag to metadata.yaml.

Lets add an entry for both Ubuntu 16.04 (xenial) and 18.04 (bionic):

<pre>
name: example
summary: A very basic example charm
maintainer: Your Name <your.name@mail.com>
description: |
  This is a charm I built as part of my beginner charming tutorial.
tags:
  - misc
  - tutorial
requires:
  database:
    interface: mysql
series:
  - xenial
  - bionic
</pre>

Rebuild the charm.

```bash
cd ~/charms/layers
charm proof layer-example
charm build layer-example

build: Composing into /home/erik/charms
build: Destination charm directory: /home/erik/charms/builds/example
build: Processing layer: layer:basic
build: Processing layer: layer:apt
build: Processing layer: example (from layer-example)
build: Processing interface: mysql
proof: I: Includes template icon.svg file.
proof: W: Includes template README.ex file
proof: W: README.ex includes boilerplate: - Upstream mailing list or contact information
proof: W: README.ex includes boilerplate: - Feel free to add things if it's useful for users
proof: I: all charms should provide at least one thing

```

Your charm now ends up in the "Destination charm directory". In my case ** /home/erik/charms/builds/example **

This is what we will push up to charmstore soon.

## Your account on charmstore
Before you can push, you need a private Ubunu One account.

Go ahead and create your Ubuntu One account here: https://login.ubuntu.com/

Remember your account name, we are going to use it below. Im ny case its 'erik-lonroth'.

## Test to login via a browser
Your Ubuntu One account gives you a private namespace for your charms.

It will be accessible in a URL something like this:
<pre>
https://jujucharms.com/u/erik-lonroth
</pre>

![Charmstore](./media/tutorial-03-example-charm-charmstore.png)

Go ahead and browse your private namespace a bit. It will likely be feeling a bit empty,
but we'll soon add the charm in there.

Lets log in to charmstore from your build environment so we can push.

## Log in to charmstore
Follow the instructions when you get prompted for username and password.
```bash
cd ~/charms/layers
charm login

Login to Ubuntu SSO
Press return to select a default value.
E-Mail: erik.lonroth@gmail.com
Password: 
Two-factor auth (Enter for none):
```

After your have mangaged to login, you can now 'push'.

## Push to charmstore
Lets push the example charm to charmstore:
```bash
cd ~/charms/builds/example
charm push .
url: cs:~erik-lonroth/example-0
channel: unpublished
```
The charm is now pushed to a namespace in charmstore private to you. Nobody else can use it.

Lets try deploy it!

## Deploy from charmstore
Once a charm is uploaded to charmstore, it can be deployed with the url given by the output for the push command (in my case: ** cs:~erik-lonroth/example-0 **).

Lets try deploy, but remember to remove any previous example charm you have in your model before you try deploying.

```bash
juju remove-application example

removing application example

juju deploy cs:~erik-lonroth/example-0

Opening an authorization web page in your browser.
If it does not open, please open this URL:
https://api.jujucharms.com/identity/v1/login?waitid=839719e2f3668e4224549ae5384ba083
Created new window in existing browser session.
Located charm "cs:~erik-lonroth/example-0".
Deploying charm "cs:~erik-lonroth/example-0".

```

You should now be able to watch your example charm being deployed.

```bash
watch juju -c juju status --color
```

Congratulations! You have completed the beginner level tutorial series on juju charming!

## Author
Erik Lönroth http://eriklonroth.wordpress.com