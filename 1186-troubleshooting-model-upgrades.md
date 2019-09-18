This section provides strategies and techniques to assist with broken model upgrades. See the main [Upgrading models](/t/upgrading-models/1154) page for background information.

<h2 id="heading--case-1---an-agent-does-not-restart-config">Case #1 - An agent does not restart (config)</h2>

It may occur that an agent does not restart upon upgrade. One thing that may help is the inspection and modification of its `agent.conf` file. Comparing it with its file before upgrading can be very useful.

Installing a different or modified configuration file will require a restart of the daemon. For example, for a machine with an ID of '2':

``` text
juju ssh 2 'ls -lh /etc/init/juju*'
```

This will return something similar to:

``` text
-rw-r--r-- 1 root root 506 Sep  2 00:57 /etc/init/jujud-machine-2.conf
-rw-r--r-- 1 root root 533 Sep  2 00:57 /etc/init/jujud-unit-mysql-0.conf
```

Therefore, if the agent for machine '2' is not coming up you can connect to the machine in this way:

``` text
juju ssh 2
```

Then modify or restore the agent file (`/var/lib/juju/agents/machine-2/agent.conf`), and while still connected to the machine, restart the agent:

``` text
sudo service jujud-machine-2 restart
```

<h2 id="heading--case-2---an-agent-does-not-restart-hook">Case #2 - An agent does not restart (hook)</h2>

The restart of an agent, due to invoking `upgrade-model` or by manual means (as above) may cause a hook for that particular unit/machine to be called. That can sometimes lead to hook failures. Connect to that unit using the `debug-hooks` command, see what is wrong, and retry the hook using the `resolved` command:

``` text
juju debug-hooks etcd/2
```

In a different terminal retry the failed hook:

``` text
juju resolved etcd/2
```

See [Debugging charm hooks](/t/debugging-charm-hooks/1116) for more information.

<h2 id="heading--case-3---an-agent-is-too-old">Case #3 - An agent is too old</h2>

When the running agent software that is more than 1 patch point behind the targeted upgrade version the upgrade process will abort.

One very common reason for "agent version skew" is that during a previous upgrade the agent could not be contacted and, therefore, was not upgraded along with the rest of the agents.

For example, the following error message will be printed when attempting to upgrade from 2.2.1 to 2.2.2 when an agent is still running, say, 2.2.0:

``` text
ERROR some agents have not upgraded to the current model version 2.2.1:
machine-0, unit-ubuntu-0
```

To overcome this situation you may force the upgrade by ignoring the agent version check:

``` text
juju upgrade-model --ignore-agent-versions
```

<h2 id="heading--case-4---dealing-with-an-upgrade-failure">Case #4 - Dealing with an upgrade failure</h2>

If an attempted upgrade results in failure it may prove difficult to return to a working setup and you may be compelled to start anew. Doing so will make the old controller completely inert and you should consider it a data loss situation.

Begin by removing the controller with `juju destroy-controller` or `juju kill-controller`. If this is insufficient you may need to ask Juju to simply "forget" about the controller. This is done with the `unregister` command.

Once the above is completed, a new controller can be created.

<!-- LINKS -->
