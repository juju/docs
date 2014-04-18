# Configuring for MAAS (bare metal)

Metal As A Service is software which allows you to deal with physical hardware
just as easily as virtual nodes. MAAS lets you treat physical servers like
virtual machines in the cloud. Rather than having to manage each server
individually, MAAS turns your bare metal into an elastic cloud-like resource.
Specifically, MAAS allows for services to be deployed to bare metal via Juju.
For more information about MAAS, see [ maas.ubuntu.com ](http://maas.ubuntu.com)

You should start by generating a generic configuration file for Juju, using the
command:

    juju generate-config

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

**Note:** If you have an existing configuration, you can use
`juju generate-config --show` to output the new config file, then copy and
paste relevant areas in a text editor etc.

#  Get your API key

You'll need an API key from MAAS so that the Juju client can access it. Each
user account in MAAS can have as many API keys as desired. One hard and fast
rule is that you'll need to use a different API key for each Juju environment
you set up within a single MAAS cluster.

To get the API key:

1. Go to your MAAS preferences page, or go to your MAAS home page and choose Preferences from the drop-down menu that appears when clicking your username at the top-right of the page.
1. Optionally add a new MAAS key. Do this if you're setting up another environment within the same MAAS cluster.
1. Copy the key value - you will need it shortly!

#  Edit or create the configuration

Create or modify `~/.juju/environments.yaml` with the following content: Create
or modify ~/.juju/environments.yaml with the following content:

      maas:
        type: maas
        maas-server: 'http://&LT;my-maas-server&GT;:80/MAAS'
        maas-oauth: '&LT;MAAS-API-KEY&GT;'

Substitute the API key from earlier into the `MAAS_API_KEY` slot. You may need
to modify the `my-maas-server` setting too; if you're running from the maas
package it should be something like "http://hostname.xxxx.yyy/MAAS".

An admin password will be generated when you try and bootstrap the Juju
instance.

The default series for MAAS will automatically be set to 'precise'.

For further steps with Juju, you should check out the [Juju instructions in the
MAAS documentation](http://maas.ubuntu.com/docs/juju-quick-start.html)
