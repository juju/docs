Title: What's new in 2.4

# What's new in 2.4

The latest release of Juju has focused a little more on under-the-hood 
improvements, making Juju much more efficient at scale, but there are 
some major changes you should know about, which we have summarised here.


For full details on this release, see the [2.4 release notes][release-notes].

If you are new to Juju, you will probably want to read the
[Getting started][getting-started] guide first.



## 18.04 LTS (Bionic) support

Juju now fully supports running both containers and workloads on the latest
LTS release of Ubuntu! Currently, the default is to use 16.04 LTS (Xenial),
but you can choose a different series when bootstrapping or deploying. For
example, to create a new controller:

```bash
juju bootstrap --bootstrap-series=bionic localhost localcloud
```

Workloads will automatically be deployed on the newest available series 
supported by the charm.


## Controller network spaces

Two new controller configuration settings have been introduced to make it
easier to specify which network spaces and/or subnets should be used for
communication with the controller by workload agents, or between 
controllers in the case of a Highly Available setup:

  * juju-mgmt-space
  * juju-ha-space

For more information on how to use these new options, please read the 
documentation on [configuring controllers][controllers-config].

## Model Ownership

In previous releases, the user who originally created a new model had special
privileges over it. With this release, multiple users can be given admin
status, and any user can have admin status taken away, so there is
nothing unique about the original creator.

## Cloud credential changes

Credentials are essential for the Juju controller to authenticate and perform
actions on the underlying cloud. Juju has always kept credentials remotely on
the controller in addition to credentials stored locally by the Juju client.
This isn't going to change, but the ambiguity of where particular credentials
are stored has caused some confusion, so a new command has been added.

To discover the credentials for the current user and cloud, run:

```bash
juju show-credentials
```

Additionally, the `show-model` command now outputs some additional information
on credentials, for example:

```bash
  credential:
    name: default
    owner: admin
    cloud: aws
```
will appear in the YAML output.

 
<!-- LINKS -->

[getting-started]: ./getting-started.md
[release-notes]: ./reference-release-notes.md#juju_2.4.0
[controllers-config]: ./controllers-config.md
[credential-command]: ./commands.md#show-credentials

