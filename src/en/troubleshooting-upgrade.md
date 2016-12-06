Title: Juju troubleshooting - environment upgrade  


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
