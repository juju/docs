Title: Juju support for CentOS7

Juju 1.24.0 has initial support for CentOS as a deployment OS (the Juju client
software is already supported on CentOS - see the 
[Releases](./reference-releases.html) page). This is experimental and has a 
number of known issues. However, most of thefunctionality of Juju is there and
ready to be used and tested. 
CentOS should be deployable on any cloud that supports `cloud-init` in it's
CentOS images. It is possible to use CentOS as both a state machine (taking
the [known limitations](#current-known-issues) into account) and as a normal 
machine.

Deploying a charm on CentOS is no different than deploying one on Ubuntu or
Windows. The only thing that needs to change is the series which is "centos7".
For example, from Launchpad:

```bash 
juju deploy lp:~me/centos7/charm
```

or from a local charm:

```
juju deploy --repository=/home/user/charms local:centos7/charm
```

Currently there are no charms in the Charm Store available for CentOS.
The process or writing one should be no different from the Ubuntu charms besides
keeping in mind the fact that one shouldn't use Ubuntu specific calls
(such as `apt-get`).

There is a guide for setting up a MAAS environment using CentOS at:

http://wiki.cloudbase.it/juju-centos

Note that Centos 7 agents are already in streams. There is no need install Go,
compile, tar, and running Juju metadata. You can sync the streams to a web 
server visible to your Juju environment.

```bash
mkdir local
juju sync-tools --local-dir local
cp -r local/tools <path/to/webserver>
```

## current known issues

 - Containers are not yet supported
 - There is a lack of mongo tools at the moment so any functionality depending 
   on those is not available(for example backups)
 - There is no way to currently specify a proxy or mirror for `yum` in the
   environment configuration. The values that you specify for `apt` packages 
   will be used for `yum` packages as well. This limitation will be fixed as 
   soon as possible.
