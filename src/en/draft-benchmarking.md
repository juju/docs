# Why benchmarking

Before proceeding make sure to read and understand the [Juju Actions](./authors-charm-actions)
section of the docs as it will be referenced heavily in the upcoming sections

# Types of benchmarks in charms

Two types of benchmark: specific and generic.

There are three ways to deliver benchmarks in Juju, covered in the sections below. How your service is benchmarked will determine which methods you'll wish to use.

For the cases where benchmarking is done as part of the software you're delivering, then the [As part of the charm](#as-part-of-the-charm) section will work best for you.
If you charm requires software to be run externally across a network to
benchmark the service, creating a [Load generation charm](#load-generation-charm)
will be the section of most interest for you. Lastly, you can create a [subordinate load generation charm](#subordinate-load-generation-charm) that runs general-purpose benchmarks across a variety of services.

## As part of the charm

If you bundle a benchmarking service as part of your service, or if the benchmark
suite for your application runs on the same machine, this will likely be the path
for you.

To start, create an action for your charm. The name of this action can be whatever
best represents the action the user is taking. As an example, to run the
cassandra-stress tool in the cassandra charm, you run the action named "stress".
If there is no simple name, "benchmark" is a great placeholder. Going forward, in
this example, the benchmark action will be named "load-gen". Here's an example
`action.yaml`

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

If the benchmarking service you wish to run should be run from a standalone machine, this is likely the path for you. You can find a good example of this in the [Siege](https://github.com/juju-solutions/siege) charm.

Writing a benchmark is similar to writing a charm, with a few new additions.
First is the addition of `actions.yaml` and the `actions` directory, containing files corresponding to the benchmark defined in the previous `actions.yaml` example. There's also a new `benchmark` interface to support, plus installing a lightweight support library, `charm-benchmark`

Here is an example of what a load-generation charm might look like:

```bash
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

Use the install hook to make sure all necessary software is installed to run your benchmarks. For example

```bash
#!/bin/bash
set -eux

apt-get install -y python-pip load-gen && pip install charm-benchmark
```

### Subordinate load generation charm

[Subordinate](./authors-subordinate-service) charms are installed to the machine they are related to. This can be useful when you have a benchmark that functions against multiple types of charm.

The [mysql-benchmark](https://github.com/juju-solutions/mysql-benchmark) charm, for example, is a subordinate that can run against any related MySQL-compatible database, such as MySQL, Percona, and MariaDB.

# Anatomy of a benchmark

## charm-benchmark

We've created a helper library to ease the development of benchmarks. The `charm-benchmark` library is a Python package, but includes shims to call it's commands from any language. You can find the latest documentation on using it at [readthedocs.org](http://charm-benchmark.readthedocs.org/en/latest/).

## How to write a benchmark

Benchmarks are simply *Juju Actions* that follow a specific pattern. For example, here's what `actions/load-gen` might look like:

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

You may have noticed the `benchmark-relation-changed` hook in the previous example of a load-gen charm. This new interface allows a benchmark-enabled charm to inform the Benchmark GUI of what actions are available. While not required, it is highly recommended to implement this interface. It allows for better integration between your benchmarks and the Benchmark GUI.

Simply add the interface to the provides stanza of `metadata.yaml`:

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
