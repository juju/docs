Title: Benchmarking Juju Services

# Overview

Note: [Juju Actions](authors-charm-actions.html) are required for Juju
Benchmarking and knowledge of them is assumed in this section.

With the introduction of Actions, you are now able to write repeatable,
reliable, composable benchmarks. This allows you to perform the same benchmark
against a variety of hardware configuration, architecture, and cloud provider
to identify bottlenecks and test configuration changes so that you can get the
most out of your computing dollar.


# Benchmark Execution Methods

There are three ways to execute benchmarks in Juju and the nature of the
benchmark will determine which method to use:

1. [Integrated into a service charm](#integrated-into-a-service-charm)
    - Use this if you bundle benchmarking as part of your service, or if the
      benchmark suite for your application runs on the same machine.
2. [Load generation charm](#load-generation-charm)
    - Use this if your charm requires software to be run externally across a
      network to benchmark the service.
3. [Subordinate load generation charm](#subordinate-load-generation-charm)
    - Use this for general-purpose benchmarks applied against a variety of
      services.


## Integrated into a Service Charm

With this method, we add a *benchmark-enabled* action to a charm.

The name of the action can be whatever best represents the action the user is
taking. For example, to run the cassandra-stress tool in the cassandra charm,
the action can be named "stress". If there is no simple name, "benchmark" is a
great placeholder.

In this section and in the ones that follow, the benchmark action is named
"load-gen".

Here's the `action.yaml` for our charm, which informs Juju about the action
we're exposing and what parameter(s) it takes:

```yaml
load-gen:
  description: Generate load against the service
  params:
    size:
      type: number
      description: size of load to generate
      default: 1
```


## Load generation charm

Writing a benchmark is similar to writing a charm, with a few new additions.
First is the addition of `actions.yaml` and the `actions` directory, containing
files corresponding to the benchmark defined in the previous `actions.yaml`
example. There's also a new `benchmark` interface to support, plus installing a
lightweight support library, `charm-benchmark`.

This is an example layout for a load-generation charm:

```no-highlight
.
├── README.md
├── actions
│   └── load-gen
├── actions.yaml
├── hooks
│   ├── benchmark-relation-changed
│   ├── install
│   └── upgrade-charm
├── icon.svg
└── metadata.yaml
```

Use the install hook to ensure all the required software to run your benchmarks
is installed. For example:

```bash
#!/bin/bash
set -eux

apt-get install -y python-pip load-gen && pip install -U charm-benchmark
```

A good example of a load generation charm is the
[Siege](https://github.com/juju-solutions/siege) charm.


## Subordinate load generation charm

[Subordinate charms](authors-subordinate-services.html) are installed to the
machine they are related to. This can be useful when you have a benchmark that
functions against multiple types of charms.

The [mysql-benchmark](https://github.com/juju-solutions/mysql-benchmark) charm,
for instance, is a subordinate charm that can run against any related
MySQL-compatible database, such as MySQL, Percona, and MariaDB.


# Anatomy of a Benchmark

## charm-benchmark

The `charm-benchmark` helper library makes the development of benchmarks
easier. Although this library is a Python package, it includes shims to call its
commands from any language. For usage see the
[charm-benchmark documentation](http://charm-benchmark.readthedocs.org/en/latest/).


## How to Write a Benchmark

Benchmarks are simply *Juju Actions* that follow a specific pattern. For
example, here's what `actions/load-gen` might look like:

```bash
#!/bin/bash
set -eux

# Get any parameters as defined in actions.yaml
duration=`action-get duration`
threads=`action-get threads`

run=`date +%s`

mkdir -p /opt/load-gen/cpu/results/$run

benchmark-start

load-gen --duration=${duration} --threads=${threads} > /opt/load-gen/cpu/results/$run/load-gen.log

benchmark-finish

# Handling results: you can use whatever tools you like to slice the output
# of your benchmark.

# Raw results
benchmark-raw /opt/load-gen/cpu/results/$run/load-gen.log

# Parse the output from load-gen
score=`awk '{print $1}' /opt/load-gen/cpu/results/$run/load-gen.log`
availability=`awk '{print $2}' /opt/load-gen/cpu/results/$run/load-gen.log`
responsetime=`awk '{print $3}' /opt/load-gen/cpu/results/$run/load-gen.log`
throughput=`awk '{print $4}' /opt/load-gen/cpu/results/$run/load-gen.log`

benchmark-data 'score' '${score}' 'requests/sec' 'desc'
benchmark-data 'availability' '${availability}'
benchmark-data 'throughput' '${throughput}' 'bytes/sec' 'desc'
benchmark-data 'response-time' '${responsetime}' 'secs' 'asc'

# Set the composite score
benchmark-composite ${score} "requests/sec" "desc"
```


## Interfaces

You may have noticed the `benchmark-relation-changed` hook in the [Load
generation charm](#load-generation-charm). This new interface allows a
benchmark-enabled charm to inform the Benchmark GUI of what actions are
available. While not required, it is highly recommended to implement this
interface. It allows for better integration between your benchmarks and the
Benchmark GUI.

Simply add the interface to the 'provides' stanza of `metadata.yaml`:

```yaml
provides:
  benchmark:
    interface: benchmark
```

And add a `benchmark-relation-changed` hook like so:

```bash
#!/bin/bash
set -eux

benchmark-actions load-gen

```
