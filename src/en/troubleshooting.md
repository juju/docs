Title: Troubleshooting
TODO: Logs from the machines/applications

# Troubleshooting

Juju does a brilliant job at simplifying the deployment of big software at
scale. But trying to accommodate every variation of model, cloud and connection
is a huge challenge, and one that can occasionally cause a few bumps along
the way to cloud nirvana.

Fortunately, Juju is well equipped to help in instances like these, both in the
output it can provide and in specific additional steps that can be taken to
mitigate any problems.

## Gathering details

When things don't seem to be working, the first step should always be to gather
as much information as possible. Juju offers the following general options for
data gathering, which we'll cover below:

- [Advanced status output](#advanced-status-outout)
- [*show* commands](#using-the-show-commands)
- [Debug details](#using-the---debug-option)
- [Log files](#collecting-the-logs)

### Advanced status output

The `juju status` command is typically used to show the status of an entire
model. But it can also be used to target the details for a specific application
or unit. Typing `juju status mysql`, for example, will show only the status
information relevant to `mysql`.

The default output from `status` uses a tabular format to fit as much detail as
possible into a terminal.  However, by specifying `yaml` as an output format,
additional details are included in its serialised output. 

!!! Note:
    When filing bugs and requesting help it's almost always better to use the
    YAML format so that everyone has additional insight into what's going on.

To see all the details on a deployed 'mysql' application, enter the following:

```bash
juju status mysql --format=yaml
```

We've split the output from this command into three separate sections so we
can annotate the most useful parts for troubleshooting.

```yaml
model:
  name: documentation-demo
  controller: jaas
  cloud: aws
  region: eu-west-1
  version: 2.1.2
```

The above 'model' section includes the region for the deployment and the
version number of the Juju agent used by the model. 

This version number should ideally match the Juju client version you're using,
as well as the version used to deploy the controller. 

Type `juju --version` to see the client version and `juju controllers` to see
the version numbers of any controllers. 

To update a controller and its models, see
[Upgrading Juju software][modelsupgrade] for further details.

```yaml
machines:
  "2":
    juju-status:
      current: pending
      since: 18 May 2017 13:33:58-04:00
    dns-name: 10.96.51.68
    ip-addresses:
    - 10.96.51.68
    instance-id: i-0510eb612038f780a
    machine-status:
      current: running
      message: running
      since: 18 May 2017 13:34:23-04:00
    series: xenial
    hardware: arch=amd64 cores=1 cpu-power=350 mem=3840M root-disk=8192M availability-zone=eu-west-1a
applications:
```

The 'machines' section of the status output deals with the machine(s) running
the selected application. The `dns-name` and `ip-addresses` fields are
obviously useful when trying to solve network and connectivity issues. 

```yaml
  mysql:
    charm: cs:mysql-57
    series: xenial
    os: ubuntu
    charm-origin: jujucharms
    charm-name: mysql
    charm-rev: 57
    exposed: false
    application-status:
      current: waiting
      message: waiting for machine
      since: 18 May 2017 13:33:56-04:00
    relations:
      cluster:
      - mysql
    units:
      mysql/0:
        workload-status:
          current: waiting
          message: waiting for machine
          since: 18 May 2017 13:33:56-04:00
        juju-status:
          current: allocating
          since: 18 May 2017 13:33:56-04:00
        machine: "2"
        public-address: 10.96.51.68
```

The final section of status output deals with the application itself. This
includes details on the current status of the machine, various timestamps and
additional networking details such as the public address of the application. 

### Using the show commands

The output from `juju status` provides a great summary of what's going on and it
can often provide enough clues to isolate a problem. But there are a range of
other commands to accompany `status` that offer more specific details.

One of the most important commands is `juju show-machine` as this can help
specifically when an application is failing to deploy

One example where `show-machine` might be useful is if you were to deploy
'active-directory' and the application gets stuck with a `waiting for machine`
message in the `juju status` output:

```bash
Unit                Workload  Agent       Machine  Public address  Ports  Message
active-directory/0  waiting   allocating  1                               waiting for machine
```

You can find more about this failed deployment by running
`juju show-machine 0`:


```yaml
model: documentation-demo
machines:
  "1":
    juju-status:
      current: down
      message: agent is not communicating with the server
      since: 18 May 2017 13:26:55-04:00
    instance-id: pending
    machine-status:
      current: provisioning error
      message: no "win2012" images in Region1 with arches [amd64]
      since: 18 May 2017 13:26:55-04:00
    series: win2012
```

The output above includes more details on what Juju is looking for. In
particular, the message within the 'machine-status' sub-section indicates that
there is no Windows image available for this deployment. This is what's holding
up the deployment of 'active-directory'. 

!!! Note:
    The `show-machine` command defaults to YAML output without any further
    arguments.

Juju includes the following *show-* commands to help provide more details on
specific areas of your deployment:

| Command         | Description                            |
|-----------------|----------------------------------------|
| show-cloud      | Shows detailed information on a cloud.|
| show-controller | Shows detailed information of a controller.|
| show-machine    | Show a machine's status.|
| show-model      | Shows information about the current or specified model.|
| show-user       | Show information about a user.|

If you need to request assistance or make a bug report, include the output from
`show-model` and `show-controller`. This will help when analysing the problem.

### Using the --debug option

Most Juju commands support the addition of a `--debug` argument.  Adding
`--debug-` is useful because the output will now detail each step taken by Juju
to execute a command. It's especially helpful with commands that perform a
complex series of tasks, such as `bootstrap`:

```bash
juju bootstrap localhost --debug
```

The above command will output both *INFO* and *DEBUG* messages for each action
performed by Juju, from parsing the command arguments to waiting for a network
address. If `bootstrap` fails at any point, you will either see this in the
output or the problem will be with the final step undertaken by Juju.

Another good example is `juju deploy --debug`, the output of which is shown
below:

```no-highlight
13:48:40 INFO  juju.cmd supercommand.go:63 running juju [2.2 gc go1.8.1]
13:48:40 DEBUG juju.cmd supercommand.go:64   args: []string{"juju", "deploy", "kibana", "--debug"}
13:48:40 INFO  juju.juju api.go:73 connecting to API addresses: [jimm.jujucharms.com:443 162.213.33.250:443 162.213.33.28:443]
13:48:40 DEBUG juju.api apiclient.go:683 dialing "wss://jimm.jujucharms.com:443/model/UUID/api"
13:48:40 DEBUG juju.api apiclient.go:683 dialing "wss://162.213.33.250:443/model/UUID/api"
13:48:40 DEBUG juju.api apiclient.go:683 dialing "wss://162.213.33.28:443/model/UUID/api"
13:48:41 DEBUG juju.api apiclient.go:687 successfully dialed "wss://jimm.jujucharms.com:443/model/UUID/api"
13:48:41 INFO  juju.api apiclient.go:594 connection established to "wss://jimm.jujucharms.com:443/model/UUID/api"
13:48:41 DEBUG juju.api apiclient.go:683 dialing "wss://1.eu-west-1.aws.jaas.jujucharms.com:443/model/UUID/api"
13:48:41 DEBUG juju.api apiclient.go:683 dialing "wss://52.213.20.147:17070/model/UUID/api"
13:48:42 DEBUG juju.api apiclient.go:687 successfully dialed "wss://1.eu-west-1.aws.jaas.jujucharms.com:443/model/UUID/api"
13:48:42 INFO  juju.api apiclient.go:594 connection established to "wss://1.eu-west-1.aws.jaas.jujucharms.com:443/model/UUID/api"
13:48:43 DEBUG juju.cmd.juju.application deploy.go:781 cannot interpret as local bundle: bundle not found: kibana
13:48:43 DEBUG httpbakery client.go:244 client do GET https://api.jujucharms.com/charmstore/v5/xenial/kibana/meta/any?include=id&include=supported-series&include=published {
13:48:43 DEBUG httpbakery client.go:246 } -> error <nil>
13:48:44 DEBUG httpbakery client.go:244 client do GET https://api.jujucharms.com/charmstore/v5/kibana/meta/any?include=id&include=supported-series&include=published {
13:48:45 DEBUG httpbakery client.go:246 } -> error <nil>
13:48:45 INFO  cmd deploy.go:1000 Located charm "cs:trusty/kibana-15".
13:48:45 INFO  cmd deploy.go:1001 Deploying charm "cs:trusty/kibana-15".
13:48:46 DEBUG juju.api monitor.go:35 RPC connection died
13:48:46 INFO  cmd supercommand.go:465 command finished
```

In the above log output, we can see many calls to the IP addresses of the
controller and the [Charm store][charmstore], which is used to retrieve details
about the charm the user is attempting to deploy. A user will have problems if
these IP addresses are behind any sort of proxy or egress firewall - Juju needs
to reach these endpoints if a deployment is to be successful.  

### Collecting the logs

Juju aggregates the logs from all machines and units on a model and makes these
available through the `juju debug-log` command. This allows you to see
everything going on and lets you delve into the details by using advanced
filtering techniques, just as you might with any log file. 

See [Juju log][logs] documentation for additional details on the logs Juju
keeps and how best to access the information they contain.

### Increase the logging level

At times, it may help to increase the logging level when attempting to diagnose
an issue.

You can verify the current logging level with the `model-config`
command:

```bash
juju model-config logging-config
```

Output will be similar to the following:

```no-highlight
<root>=WARNING; unit=INFO
```

Increasing the logging level will provide additional details. Logging levels,
from most verbose to least verbose, are as follows:

- TRACE
- DEBUG
- INFO
- WARNING
- ERROR

When diagnosing an issue or gathering information for filing a bug, it's often
useful to increase the log verbosity by moving to DEBUG or TRACE levels.

To increase the logging level from our previous example, you would enter the
following command:

```bash
juju model-config logging-config="<root>=DEBUG;unit=TRACE"
```
Once the issue has been diagnosed, or the logging information is collected,
make sure the logging levels are reset so that you don't collect massive
amounts of unnecessary data:

```bash
juju model-config logging-config="<root>=WARNING;unit=INFO"
```

## Additional troubleshooting topics

After identifying the source of a problem, take a look at our further
troubleshooting documentation for help on finding a solution:

- [Troubleshooting model upgrade][upgrade] includes help for upgrading Juju across a model
- [Cloud specific troubleshooting][clouds] covers issues with specific clouds 

Alternatively, if your issue is not addressed here, get in touch via our
[Contacts page][contactus] or consider the 
[Juju section on askubuntu.com](http://askubuntu.com/search?q=juju).

<!-- LINKS -->

[modelsupgrade]: ./models-upgrade.html "Upgrading Juju software"
[charmstore]: https://jujucharms.com/
[logs]: ./troubleshooting-logs.html
[upgrade]: ./troubleshooting-upgrade.html
[clouds]: ./troubleshooting-clouds.html
[contactus]: ./contact-us.html
