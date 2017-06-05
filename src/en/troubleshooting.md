Title: Juju troubleshooting


# Troubleshooting

We know that even in the best of times things go wrong. Here we help you dive
into what's going on and chase down those details you need when things don't
go according to plan.

## Gathering details

When things don't seem to be working the first step is to pull together the
important information that Juju is providing.


### Filtering status

`juju status` supports specifying an application to be shown. In this way,
`juju status mysql` will only show the status information relevant to that
application. The default output of `juju status` is a nice tabular format.
However, sometimes there are additional details in the machine readable output.
You can see this at any time by passing the flag `--format=yaml` to any status
command in Juju:

```bash
juju status mysql --format=yaml

```

...will result in the output that looks like:

```yaml
model:
  name: documentation-demo
  controller: jaas
  cloud: aws
  region: eu-west-1
  version: 2.1.2
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

Here we're given a lot more detail as to the state of things regarding the
MySQL unit. This includes status, timestamps, additional networking
information, etc. When filing bugs and requesting help it's almost always
better to use the YAML format so that everyone has additional insight into
what's going on.


### Beyond Juju status

Juju status is juju a summary of what's going on. It cannot provide all of the
details all the time. Often Juju status will help provide users a hint that
they are able to chase down additional details with a more specific command.
One of the most important commands is `juju show-machine` where an application
failing to deploy might be due to the machine never getting assigned for
Juju's use. Explore the CLI for other useful commands that will provide more
details in different troubleshooting conditions.


For example, if I deploy active-directory into a cloud that does not have
Windows images available I might get an error showing:

```bash
Unit                Workload  Agent       Machine  Public address  Ports  Message
active-directory/0  waiting   allocating  1                               waiting for machine
```

However, if I want additional details I can run `juju show-machine 1` to see
the details about the machine that this unit is meant to be running on.

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

Here we are given much more clear details as to what Juju is looking for. Make
sure to leverage the `show-` commands to dive deeper into what's going on.
juju `show-model` and `show-controller` can often provide useful information when
filing bug reports or requesting assistance.

Make sure to look beyond the default information in `juju status`.


### Using the --debug option

Most commands support a `--debug` option that can be used to gain additional
insight as to what's going on. This is especially true of commands such
as `juju bootstrap`.

Compare the sample output of `juju deploy --debug`. It includes all of the
URLs that Juju is attempting to reach. These might be of vital importance if
you're behind a proxy or firewall at work.


```
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

In the above log output we can see that there are calls to the IP addresses of
the controller as well as to the charmstore to retrieve details about the
charm that the user is attempting to deploy. If a user is behind any sort of
proxy or egress firewall Juju will need to be able to reach these endpoints to
be successful.

### Collecting the logs

The primary method of collecting logs is using the `juju debug-log` command.
It aggregates logs across the models in a way that allows for seeing
everything going on as well as diving into the details with advanced filtering
techniques. See [this Juju logs](./troubleshooting-logs.html) page for
additional details about the logs Juju keeps.


### Increase the logging level

At times it's necessary to increase the logging level to help diagnose an
issue. You can verify the current logging level with the `model-config`
comamnd.

```
juju model-config logging-config
<root>=WARNING; unit=INFO
```

Users can increase the logging level for additional details. The logging
levels in order from most verbose to least verbose are TRACE, DEBUG, INFO,
WARNING, and ERROR. When diagnosing an issue or gathering information for
filing a bug it's often useful to increase the log verbosity by moving to
DEBUG or TRACE levels. Users can increase the logging level to DEBUG and all
the way to TRACE by setting the model-config property.

Increase the logging level:

```
juju model-config logging-config="<root>=DEBUG;unit=TRACE"
```

Once the issue is diagnosed or the logging information is collected make sure
to reset the logging levels so that you're not collecting massive amounts of
data over a long period of time unnecessarily.

```
juju model-config logging-config="<root>=WARNING;unit=INFO"
```


## Additional troubleshooting topics

- [Troubleshooting model upgrades](./troubleshooting-upgrade.html) - help for
upgrading Juju across a model.
- [Troubleshooting tools](./troubleshooting-tools.html)
- [Cloud specific troubleshooting](./troubleshooting-clouds.html)

If your issue is not addressed here, consider the
[Juju section on askubuntu.com](http://askubuntu.com/search?q=juju).
