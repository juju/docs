Title: Configuring Juju for Joyent Cloud  

# Configuring for Joyent Cloud 

This process requires you to have a Joyent account. If you have not signed up
for one yet, you can do so at
[http://www.joyent.com/](http://www.joyent.com/).

You should start by generating a generic configuration file for Juju, using the
command:

```bash
juju generate-config
```

This will generate a file, `environments.yaml`, which, in Linux, will reside in
your `~/.juju/` directory (and will create the directory if it doesn't already
exist).

!!! Note: If you have an existing configuration, you can use `juju
generate-config --show` to output the new config file, then copy and paste
relevant areas in a text editor etc.

The generic configuration sections generated for Joyent will look something
like this:

```yaml
joyent: 
  type: joyent

  # SDC config Can be set via env variables, or specified here sdc-user:
  # <secret> Can be set via env variables, or specified here sdc-key-id:
  # <secret> url defaults to us-west-1 DC, override if required sdc-url:
  # https://us-west-1.api.joyentcloud.com

  # Manta config Can be set via env variables, or specified here
  # manta-user: <secret> Can be set via env variables, or specified here
  # manta-key-id: <secret> url defaults to us-east DC, override if required
  # manta-url: https://us-east.manta.joyent.com

  # Auth config private-key-path is the private key used to sign Joyent
  # requests.  Defaults to ~/.ssh/id_rsa, override if a different ssh key
  # is used.  Alternatively, you can supply "private-key" with the content
  # of the private key instead supplying the path to a file.
  # private-key-path: ~/.ssh/id_rsa algorithm defaults to rsa-sha256,
  # override if required algorithm: rsa-sha256
```

This is a simple configuration intended to run on Joyent with Manta storage.
Values for the default settings can be changed simply by editing this file,
uncommenting the relevant lines and adding your own settings. All you need to
do to get Juju deploying services on Joyent is to set:

- `sdc-user` (Joyent login username)
- `sdc-key-id` (finger print from ssh key uploaded to Joyent)
- `manta-user` (login username -same as `sdc-user`)
- `manta-key-id` (finger print from uploaded ssh key -same as `sdc-key-id`)
- `private-key-path` (if your private is not at `~/.ssh/id_rsa`)

!!! Note: The private key is currently uploaded to the cloud in order to
remotely sign requests to the Joyent API. It is highly recommended that the
private key used in this way _should not_ be a common SSH key you use for other
purposes, but a specific one used for the Joyent cloud.  Until there is a more
robust workaround, you are strongly urged to generate a new keypair for use
with the Joyent cloud, and either set that file in your `private-key-path` or
paste it directly into the configuration as a `private-key` value, instead of
the `private-key-path`.  Remember to indent properly and to append a `|` after
`private-key` to span multiple lines.

You can retrieve these values easily from Joyent Dashboard at
[https://my.joyent.com/main/#!/account](https://my.joyent.com). Click on your
name in the top-right and then the "Account" link from the drop down menu.

![Joyent Dashboard to access username and
fingerprint](./media/getting_started-joyent-account-dropdown.png)

!!! Note: During initial setup if you are having issues deploying charms contact
Joyent support at [https://help.joyent.com/home](https://help.joyent.com/home) 
to verify your account is capable of provisioning virtual machines.
