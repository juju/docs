Introduction
===

Note: This is a sharp knife feature - be careful with it. It was added to Juju in version 2.3.1.


Cloudinit-userdata
--
Allows the user to provide additional cloudinit data to be included in the cloudinit data created by Juju.

Specifying a key will overwrite what juju puts in the cloudinit file with the following caveats: 
1. `users` and `bootcmd` keys will cause an error
2. The `packages` key will be appended to the packages listed by juju
3. The `runcmds` key will cause an error.  You can specify `preruncmd` and `postruncmd` keys to prepend and append the runcmd created by Juju.


### Use cases

- setting a default locale for deployments that wish to use their own locale settings
- adding custom CA certificates for models that are sitting behind an HTTPS proxy 
- adding a private apt mirror to enable private packages to be installed
- blacklist SSH fingerprints from being printed to the console for security-focused deployments

## Background

Juju uses [cloud-init](cloud-init.io) to customise instances once they have been provisioned by the cloud. The `cloudinit-userdata` model configuration setting (model config) allows you to tweak what happens to machines when they are created up via the "user data" feature.

From the website:

> ![cinit-logo|51x35](upload://ndGkV8MfQVYoMSYDu9OXQQAyVxK.png) 
>
> Cloud images are operating system templates and every instance starts out as an identical clone of every other instance. *It is the user data that gives every cloud instance its personality and cloud-init is the tool that applies user data to your instances automatically.*

Using
--

### Providing custom user data to cloudinit

Create a file, `cloudinit-userdata.yaml`, which starts with the `cloudinit-userdata` key and data you wish to include in the cloudinit file.  Note: juju reads the value as a string, though formatted as YAML.

Template `cloudinit-userdata.yaml`:

```plain
cloudinit-userdata: |
    <key>: <value>
    <key>: <value>
```

Provide the path your file to the `model-config` command:


```plain
juju model-config cloudinit-userdata.yaml
```

### Reading the current setting

To read the current value, provide the `cloudinit-userdata` key to the `model-config` command as a command-line parameter. Adding the `--format yaml` option ensures that it is properly formatted.

```plain
juju model-config cloudinit-userdata --format yaml
```

Sample output:

    cloudinit-userdata: |
      packages:
        - 'python-keystoneclient'
        - 'python-glanceclient'

### Clearing the current custom user data

Use the `--reset` option to the `model-config` command to clear anything that has been previously set.

```plain
juju model-config --reset cloudinit-userdata
```

Known Issues
--
- In cloud-init, the `runcmd` key accepts both lists of strings and strings. However, Juju only supports strings currently. This will be resolved when ["cloudinit-userdata doesn't handle lists in rancid properly"](https://bugs.launchpad.net/juju/+bug/1759398) is fixed.
- custom cloudinit-userdata must be passed via file, not as options on the command line (like the `config` command)


## Further reading

Model configuration settings are documented as part of Juju's official docs:

https://discourse.jujucharms.com/t/configuring-models/1151

To read more about how various levels of settings inter-operate in the Juju model, read this post in Discourse:

https://discourse.jujucharms.com/t/fantastic-settings-and-where-to-find-them/2284
