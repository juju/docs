(how-to-debug-a-charm)=
# How to debug a charm

> See also: {ref}`Tools for debugging <4837md>`

This section will show how to debug a charm if it isn't working as intended.

<!--, or you'd just like some tools above and beyond `printf` debugging with `logging` to `juju debug-log`.-->

**Contents:**

- [View Juju and charm logs at once](#heading--view-juju-and-charm-logs-at-once)
- [View integration data](#heading--view-integration-data)
- [View controller logs](#heading--view-controller-logs)
- [View past logs](#heading--view-past-logs)
- [View logs live](#heading--view-logs-live)
- [View the Pebble plan](#heading--view-the-pebble-plan)
- [Debug a single failing hook](#heading--debug-a-single-failing-hook)
- [Debug a flow](#heading--debug-a-flow)


<a href="#heading--view-juju-and-charm-logs-at-once"><h2 id="heading--view-juju-and-charm-logs-at-once">View Juju and charm logs at once</h2></a>
> See also: [Juju | `juju debug-log`](https://juju.is/docs/olm/juju-debug-log), [Juju | `juju model-config`](https://juju.is/docs/olm/juju-model-config), [Juju | `juju model-defaults`](https://juju.is/docs/olm/juju-model-defaults)

To view all of the Juju messages from Juju and charm logs at the same time, run `juju debug-log`. The logs can show you the detailed inner workings of Juju as well as any `juju-log` messages that are run from the charm code. 

In the case of charm logs, the Operator Framework Ops sets up a Python `logging.Handler` which forwards all of your `logging` messages to `juju-log`, so you'll see those also.

By default logging is set to the `INFO` level for newly-created models so, if you have debug messages logging in your code, you’ll need to run this to see them:

    juju model-config logging-config="<root>=INFO;unit=DEBUG"

Alternatively, you can do this for every model created by a controller, or on a per-controller basis using the `model-defaults` command:

	juju model-defaults -c <controller name> logging-config='<root>=INFO; unit=DEBUG'

See the [Juju logs documentation](https://juju.is/docs/olm/juju-logs) for details about what you can do with logs: replay them, filter them, send to a remote target, check audit logs, and more.

<a href="#heading--view-integration-data"><h2 id="heading--view-integration-data">View integration data</h2></a>

```{important}

Before `juju v.3.0` , ‘integrations’ were called ‘relations’. Remnants of this persist in the names, options, and output of certain commands, and in integration event names.

```

When an integration between charms is established, Juju offers several ways to view the state of the integration. If many integrations have been established, you may want to be very explicit about the integration and data you are querying. In other cases, you may want to  see all the integration data a given unit has access to.

### Specific interface
If you want to be specific,  you can get a list of which integrations are established on a specified interface, then query a specific integration to find the application on the other side, and finally get the data for that integration.

```bash
$ juju run --unit your-charm/0 "relation-ids foo"
foo:123
$  juju run --unit your-charm/0 "relation-list -r bar:foo"
other-charm/0
$ juju run --unit nova-compute/0 "relation-get -r foo:30 - other-charm/0"
hostname: 1.2.3.4
password: passw0rd
private-address: 2.3.45.
somekey: somedata
```

### All  data
In other cases, it may be preferable to interrogate a unit for _all_ of the data it can see.

```bash
$ juju show-unit grafana/0
```
```yaml
grafana/0:
  opened-ports: []
  charm: local:focal/grafana-k8s-20
  leader: true
  relation-info:
  - endpoint: grafana-peers
    related-endpoint: grafana-peers
    application-data: {}
    local-unit:
      in-scope: true
      data:
        egress-subnets: 10.152.183.202/32
        ingress-address: 10.152.183.202
        private-address: 10.152.183.202
  - endpoint: grafana-source
    related-endpoint: grafana-source
    application-data:
      grafana_source_data: '{"model": "lma", "model_uuid": "c80e14c0-39c0-41b1-8c2b-c9d92abbc2ed",
        "application": "prometheus", "type": "prometheus"}'
    related-units:
      prometheus/0:
        in-scope: true
        data:
          egress-subnets: 10.152.183.175/32
          grafana_source_host: 10.1.48.94:9090
          ingress-address: 10.152.183.175
          private-address: 10.152.183.175
  provider-id: grafana-0
  address: 10.1.48.70
```

The [`show-unit`](https://juju.is/docs/olm/juju-show-unit) command can return a more fined-tuned result with additional arguments.

<a href="#heading--view-past-logs"><h2 id="heading--view-past-logs">View past logs</h2></a>

Since log messages stream in real time, it is possible to miss messages while using the debug-log command. If you need to view log entries from before you ran the `juju debug-log` command, you can pass the `--replay` option. 

Alternatively, you can SSH to the machine and view the log files. To access the individual machine use `juju ssh <machine-number>` to get access to the machine. For Kubernetes charms,  you can SSH to a unit with `juju ssh your-charm/0` for the first unit, `juju ssh your-charm/1` for the second unit, and so on.

The Juju log files can be found in the /var/log/juju directory for machine charms.


<a href="#heading--view-controller-logs"><h2 id="heading--view-controller-logs">View controller logs</h2></a>

The machine running the controller is not represented in the Juju model and therefore not accessible by machine number. If you need the log files from the controller, you have a few options. More directly, you can change to the `controller` context in Juju and SSH by number:

```text
juju switch controller
juju ssh 0
```

Alternatively, if you're dealing with a Kubernetes charm, you can SSH to the controller with `juju ssh -m controller 0`.
> See also: [How to get logs from a Kubernetes charm](https://juju.is/docs/sdk/get-logs-from-a-kubernetes-charm).

<a href="#heading--view-logs-live"><h2 id="heading--view-logs-live">View logs live</h2></a>
> See also: [Juju | `juju debug-code`](https://juju.is/docs/olm/juju-debug-code), [Python | `pdb`](https://docs.python.org/3/library/pdb.html)

If you're dealing with a charm written with the Ops library, you can jump into live debugging using `pdb` without needing to change the charm code at all by running the following command:

`juju debug-code --at=hook <unit>`

This will make the Operator framework automatically interrupt the running charm at the beginning of the registered callback method(s) for any events and/or actions. A tmux window will be opened, and it will wait status until a hook or callback executes. 

When that happens, it will place you into an interactive debugging session with `pdb`.

Example output:

```
2021-06-18 12:50:25,494 DEBUG    Operator Framework 1.2.0 up and running.
2021-06-18 12:50:25,503 DEBUG    Legacy hooks/config-changed does not exist.
2021-06-18 12:50:25,538 DEBUG    Emitting Juju event config_changed.

Starting pdb to debug charm operator.
Run `h` for help, `c` to continue, or `exit`/CTRL-d to abort.
Future breakpoints may interrupt execution again.
More details at https://discourse.jujucharms.com/t/debugging-charm-hooks

> /var/lib/juju/agents/unit-content-cache-k8s-0/charm/src/charm.py(63)_on_config_changed()
-> msg = 'Configuring workload container (config-changed)'
(Pdb) n
> /var/lib/juju/agents/unit-content-cache-k8s-0/charm/src/charm.py(64)_on_config_changed()
-> logger.info(msg)
(Pdb) n
2021-06-18 12:50:32,831 INFO     Configuring workload container (config-changed)
> /var/lib/juju/agents/unit-content-cache-k8s-0/charm/src/charm.py(65)_on_config_changed()
-> self.model.unit.status = MaintenanceStatus(msg)
(Pdb) self.model.unit
<ops.model.Unit content-cache-k8s/0>
(Pdb) self.model.unit.status
ActiveStatus('Ready')
(Pdb) n
> /var/lib/juju/agents/unit-content-cache-k8s-0/charm/src/charm.py(66)_on_config_changed()
-> self.configure_workload_container(event)
(Pdb) self.model.unit.status
MaintenanceStatus('Configuring workload container (config-changed)')
(Pdb) n
2021-06-18 12:50:47,213 INFO     Assembling k8s ingress config
2021-06-18 12:50:47,305 INFO     Assembling environment configs
2021-06-18 12:50:47,356 INFO     Assembling pebble layer config
2021-06-18 12:50:47,380 INFO     Assembling Nginx config
2021-06-18 12:50:47,414 INFO     Updating Nginx site config
2021-06-18 12:50:47,484 INFO     Updating pebble layer config
2021-06-18 12:50:47,533 INFO     Stopping content-cache
2021-06-18 12:50:47,922 INFO     Starting content-cache
2021-06-18 12:50:49,018 INFO     Ready
--Return--
> /var/lib/juju/agents/unit-content-cache-k8s-0/charm/src/charm.py(66)_on_config_changed()->None
-> self.configure_workload_container(event)
```

Typing `n` at this point (execute the next command) will run the final line of the `config-changed` handler, and then end the `pdb` session. 

As you can see, during this process we were able to inspect Operator Framework primitives directly at runtime, such as `self.model.unit` and `self.model.unit.status`. For more information about what you can do with `pdb`, see [Python | `pdb`](https://docs.python.org/3/library/pdb.html).

You can also pass the name of the event or action if you only want to debug or inspect a specific event or action:

`juju debug-code --at=hook <unit> config-changed`

This will interrupt your running charm at the beginning of the handler for the `config-changed` event, which might be defined in your code as follows:

	self.framework.observe(self.on.config_changed, self._on_config_changed)

If you prefer to set a specific breakpoint at a particular line of code in your charm, you can add this at the relevant place:

`self.framework.breakpoint()`

Then run `juju debug-code <unit>`, and your `pdb` session would begin whenever the above line is reached. No need to specify `--at=`

 <a href="#heading--considerations"><h3 id="heading--considerations">Considerations</h3></a>

While you’re debugging one unit, execution of all hooks on that machine or related to that charm is blocked, since Juju locks the model until the hook is resolved. 

This is generally helpful, because you don’t want to have to contend with concurrent changes to the runtime environment while you're debugging, but you should be aware that multiple `debug-code` sessions for units assigned to the same machine will block one another, and that you can’t control relative execution order directly other than by erroring out of hooks you don’t want to run yet, and retrying them later.

<a href="#heading--view-the-pebble-plan"><h2 id="heading--view-the-pebble-plan">View the Pebble plan</h2></a>
> See also: {ref}`Pebble <4837md>`

If your workload is running on Kubernetes, it’s often useful to be able to inspect the running Pebble plan. To do so, you should `juju ssh` into the workload container for your charm, and run `/charm/bin/pebble plan`. Here’s an example:

```
$ juju ssh --container concourse-worker concourse-worker/0
# /charm/bin/pebble plan
services:
    concourse-worker:
        summary: concourse worker node
        startup: enabled
        override: replace
        command: /usr/local/bin/entrypoint.sh worker
        environment:
            CONCOURSE_BAGGAGECLAIM_DRIVER: overlay
            CONCOURSE_TSA_HOST: 10.1.234.43:2222
            CONCOURSE_TSA_PUBLIC_KEY: /concourse-keys/tsa_host_key.pub
            CONCOURSE_TSA_WORKER_PRIVATE_KEY: /concourse-keys/worker_key
            CONCOURSE_WORK_DIR: /opt/concourse/worker
```

In some cases, your workload container might not allow you to run things in it, if, for instance, it’s based on a “scratch” image. To get around this, you can run the same command from your charm container with a small modification to point to the correct location for the pebble socket.

```
$ juju ssh concourse-worker/0
# PEBBLE_SOCKET=/charm/containers/concourse-worker/pebble.socket /charm/bin/pebble plan
services:
    concourse-worker:
        summary: concourse worker node
        startup: enabled
        override: replace
        command: /usr/local/bin/entrypoint.sh worker
        environment:
            CONCOURSE_BAGGAGECLAIM_DRIVER: overlay
            CONCOURSE_TSA_HOST: 10.1.234.43:2222
            CONCOURSE_TSA_PUBLIC_KEY: /concourse-keys/tsa_host_key.pub
            CONCOURSE_TSA_WORKER_PRIVATE_KEY: /concourse-keys/worker_key
            CONCOURSE_WORK_DIR: /opt/concourse/worker
```

<!--
Hopefully this has given you some additional tools for troubleshooting and debugging your charm! Comments and discussion welcome.
-->

<a href="#heading--debug-a-single-failing-hook"><h2 id="heading--debug-a-single-failing-hook">Debug a single failing hook</h2></a>
> See also: [Juju | `juju debug-hooks`](https://juju.is/docs/olm/juju-debug-hooks), {ref}``jhack` <jhack>`, [Python | `pdb`](https://docs.python.org/3/library/pdb.html)

```{important}

This section references [`jhack`](https://snapcraft.io/jhack) (in particular [`jhack sync`](https://github.com/PietroPasotti/jhack#sync), but you can probably do without it, if you know how to handle rsync, or  `juju ssh` the files you touch when you like to.

```

Suppose you notice you have a unit of `<your app>` erroring out on, say, `X-relation-changed`. Some bug in the Python code.

To debug, you can start a debug-hooks session for any hook or for a specific hook:

```bash
juju debug-hooks mysql/0                     # for any hook
juju debug-hooks mysql/0 X-relation-changed  # for a specific hook
```

```{dropdown} More details

```{important}


A debugging session lands you in `/var/lib/juju`, and as soon as a hook fires, the tmux session automatically takes you to `/var/lib/juju/agents/unit-mysql-0/charm`.


```

```

There, you need to execute hook manually. This means running `./dispatch`, which launches your charm code with the current hook's context.
You can `./dispatch` multiple times, modifying your charm code in between, as your investigation progresses. You could:
- directly edit `src/charm.py` in the tmux session; or
- manually sync with [`juju scp`](https://juju.is/docs/olm/juju-scp) or `rsync`; or
- automatically sync with `jhack sync`; etc.

Moreover, if you (temporarily) include `import pdb; pdb.set_trace()` anywhere in your code, then you'll be placed in a pdb session whenever `./dispatch` encounters a `set_trace()` statement.

For example:
<!--THE NEXT TWO SECTIONS ARE FROM https://discourse.charmhub.io/t/advanced-ops-charm-fu/7606 -->
<!--# Recipe 1: debug a single failing hook-->

1. Run `juju debug-hooks mysql/0 X-relation-joined`.
1. Create the integration (`juju integrate ...`).
1. Wait for the `debug-hooks` session to start.
1. Start a `jhack sync` session including whatever file is surfacing the error.

---
```{dropdown} Expand to see how

`cd` into the charm root folder on your local filesystem.

If the code raising the exception is in `/lib` or `/src`, you don't have to do anything special. If not, check the documentation for `jhack sync` to see how you can include the file.


Run  `jhack sync <name of broken unit>`.


This will start listening for changes in your local tree and push them to the unit. Whatever edits you make locally will be ssh'd into the live running unit.

```
----
5. Write wherever you like: `import pdb; pdb.set_trace()` and save (so that `jhack` will sync the change).
6. In the `debug-hooks` shell, type `./dispatch` (a small shell script  located in the charm folder on the unit that executes the charm code) .
7. Welcome to `pdb`.

This recipe is interesting because it allows you to run the same event handler over and over while making changes to the code. 
You can run `./dispatch`, debug at will, exit the debugger. Remove the `pdb` call, try dispatching again. Once, twice... Is the bug gone? Very well, you're done. Not gone? Rinse and repeat.


###  Example: Debug a tracing relation in a testing environment

Suppose you have a unit of `tempo` and a `tester` charm that relate over a `tracing` relation.

Suppose that the hook you need to debug is `tracing_relation_created`. 
```bash
# in shell A
$ juju debug-hooks tester/0 tracing-relation-joined 

# in shell B
$ jhack nuke tester:tracing
$ juju relate tester tempo

# in shell A
{ref}`...]
./dispatch                                                 
tmux kill-session -t tester/0 # or, equivalently, CTRL+a d 
                                                           
4. CTRL+a is tmux prefix.                                  
                                                           
More help and info is available in the online documentation
https://juju.is/docs/juju/debug-charm-hooks                 
                                                           
root@tester-0:/var/lib/juju/agents/unit-tester-0/charm#


# in shell B
$ cd /path/to/tester/charm/root
$ jhack sync tester/0

$ vim ./src/charm.py
[...]  
# insert at some line: 
#import pdb; pdb.set_trace(header="hello debugger-world")
```

At this point you're set. If you save the file, `jhack sync` will push it to `tester/0`. That means that if you dispatch the event, you will execute the code you just changed.

```bash
# in shell A:
$ ./dispatch
hello debugger-world                                                           
> /var/lib/juju/agents/unit-tester-0/charm/src/charm.py(34)__init__()          
-> self.container: Container = self.unit.get_container(self._container_name)   
(Pdb) self                                                                     
<__main__.TempoTesterCharm object at 0x7f3af724e370>                           
(Pdb)                                                                          
```


<a href="#heading--debug-a-flow"><h2 id="heading--debug-a-flow">Debug a flow</h2></a>
> See also: [`jhack` <jhack>`

```{important}

This section references [`jhack`](https://snapcraft.io/jhack) (in particular [`jhack sync`](https://github.com/PietroPasotti/jhack#sync), but you can probably do without it, if you know how to handle rsync, or `juju ssh` the files you touch when you like to.

```

<!--Recipe 2: developing event handlers in sequence-->

1. Start a `jhack sync` session on the charm root (see note in recipe 1).
1. `jhack fire` the event you wish to debug or work on the unit you're syncing to.
1. Look at the logging or the resulting state (charm status, app data, workload config, etc...).

What is good about this flow is that:
1) You're not forced to wait for an event to occur "for real" in order to execute the handler for it.
2) You can easily test several handlers in succession by firing different events. For example, `relation-created`, `relation-changed` ...

What is risky about this flow is that the context that the event normally occurs in is not granted to be there. If you `jhack fire X-relation-created` while in fact there is no relation X, your charm might make some bad assumptions (which is why you should always write your charm code making basically no assumptions).

### Example: again the tracing relation

Working with the same example as in [Debug a single failing hook](#heading--debug-a-single-failing-hook) above, the commands would be:

```bash
# in shell A
$ cd /path/to/tester/charm/root
$ jhack sync tester/0

# in shell B
jhack fire tester/0 tracing-relation-changed
```

And you're basically set up. 
In your editor you can locally make any change you like to the tester source, and when you're done you can manually trigger the event.