Title: Juju troubleshooting - Local Provider (LXC)


# Troubleshooting the Local Provider (LXC)

The LXC Local Provider uses LXC containers to provide nodes for you to deploy
on. This section is a collection of best practices for diagnosing and solving
LXC Local Provider issues.


## Bootstrap fails

Every time bootstrap fails, you'll need to run `juju destroy-environment -e
local` prior to continuing. First let's rerun a bootstrap in debug mode:

```bash
juju bootstrap --show-log --debug
```

This will print very verbose output. If you're receiving `connection failed,
will retry: dial tcp 127.0.0.1:37017: connection refused` error at the end of
the run, proceed with the troubleshooting guide. If not the error presented will 
inform you what went wrong.

In certain cases you might get this something similar to this error: `Get
http://10.0.3.1:8040/provider-state: dial tcp 10.0.3.1:8040: connection
refused`.

This can be solved by removing miscellaneous .jenv files in
`~/.juju/environments` and rerunning the bootstrap command.


## Connection failed, will retry

This occurs when the juju API server and Database server fail to start within
the allotted timeout. This can occur for one of several reasons. After the
bootstrap command fails run the following command:

```bash
sudo initctl list | grep juju
```

You should see two jobs listed. One that starts with `juju-db` the other `juju-
agent`. If these are both in a start/running state then your machine took longer
than juju expected to get these services started.

If either of these have stopped, investigate the logs at 
`/var/log/upstart/juju-db*.log` or `/var/log/upstart/juju-agent*.log` If the 
juju-db service failed to start with messages of unsupported command-line 
options, check the version of mongodb installed:

```bash
dpkg -l | grep mongodb-server
```

If you have a version less than 1:2.2.4-0ubuntu1 make sure you have either the
[Cloud Tools Archive](https://wiki.ubuntu.com/ServerTeam/CloudToolsArchive) or
ppa:juju/stable added to your system. `sudo apt-get update` then install juju-
local package. Before retrying, make sure you run `juju destroy-environment`


## No machines start

If you get a successful bootstrap, but services you deploy never come up,
there's a chance that you have an older version of the Ubuntu Cloud Image 
cached on your machine. To verify this, check the timestamp of the contents in
`/var/cache/lxc/cloud-precise/`

```bash
ls -lh /var/cache/lxc/cloud-precise/
```

If the contents of this directory are older than a few weeks, delete files
present, destroy the environment with `juju destroy-environment`, re-bootstrap
and attempt deployment again.


##  Unit KVM / LXC container problems:

You may see unexpected behaviour on a unit when deploying to a nested KVM
virtual machine or LXC container via juju deploy --to lxc:# and its KVM
equivalent. It can be helpful to capture the output of the commands being run
on the unit:

```bash
juju set-env 'logging-config=juju.container.kvm=TRACE'
juju set-env 'logging-config=juju.container.lxc=TRACE'
```

This will increase log verbosity dramatically. When no longer needed the
logging level should be reset to its default value:

```bash
juju set-env 'logging-config=<root>=WARN'
```

See [Viewing logs](./troubleshooting-logs.html).
