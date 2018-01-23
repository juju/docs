Title: Juju troubleshooting - environment upgrade  
TODO:  Review required (some things: 'environment')

# Troubleshooting environment upgrades

This section provides strategies and techniques to assist with broken
environment upgrades. See
[Upgrading Juju software](./models-upgrade.html#upgrading-the-model-software) for
information and instructions pertaining to upgrading your environment.


## Case #1 - An agent does not restart (config)

It may occur that an agent does not restart upon upgrade. One thing that may
help is the inspection and modification of its `agent.conf` file. Comparing it
with its file before upgrading can be very useful.

Installing a different or modified configuration file will require a restart of
the daemon. For example, for machine #2:

```bash
juju ssh 2 'ls -lh /etc/init/juju*'
```

This will return something similar to:

```no-highlight
-rw-r--r-- 1 root root 506 Sep  2 00:57 /etc/init/jujud-machine-2.conf
-rw-r--r-- 1 root root 533 Sep  2 00:57 /etc/init/jujud-unit-mysql-0.conf
```

Therefore, if the agent for machine #2 is not coming up you can connect to the
machine:

```bash
juju ssh 2
```

Modify or restore the agent file
(`/var/lib/juju/agents/machine-2/agent.conf`), and while still connected to the
machine, restart the agent:

```bash
sudo service jujud-machine-2 restart
```


## Case #2 - An agent does not restart (hook)

The restart of an agent, due to invoking `upgrade-juju` or by manual means (as
above) may cause a hook for that particular unit/machine to be called. That can
sometimes lead to hook failures. Connect to that unit using the
`juju debug-hooks` command, see what is wrong, and retry the hook using the
`juju resolved` command:

```bash
juju debug-hooks etcd/2
```

In a different terminal retry the failed hook.

```bash
juju resolved etcd/2
```

See [Debugging Juju charm hooks](./developer-debugging.html) for more
information.


## Case #3 - An agent is too old

When the running agent software that is more than 1 patch point behind the
targeted upgrade version the upgrade process will abort.

One very common reason for "agent version skew" is that during a previous
upgrade the agent could not be contacted and, therefore, was not upgraded along
with the rest of the agents.

For example, the following error message will be printed when attempting to
upgrade from 2.2.1 to 2.2.2 when an agent is still running, say, 2.2.0:

```no-highlight
ERROR some agents have not upgraded to the current model version 2.2.1:
machine-0, unit-ubuntu-0
```

To overcome this situation you may force the upgrade by ignoring the agent
version check:

```bash
juju upgrade-juju --ignore-agent-versions
```

!!! Note:
    The flag `--ignore-agent-versions` is only available starting with Juju
    2.2.6.


## Case #4 - Recovering from an upgrade failure

If an attempted upgrade results in failure it may prove difficult to return to
a working setup. The first remediation plan is to remove the controller with
the `juju destroy-controller` or `juju kill-controller` commands. If this is
insufficient one way forward is to unregister the controller, add the
respective cloud, and then create a new controller. Doing this will not remove
the original controller so there will remnants of it in the database. This
method should therefore be used as a last resort. Here are the relevant
commands:

```bash
juju unregister <controller>
juju add-cloud --replace <cloud>
juju bootstrap <cloud>
```
