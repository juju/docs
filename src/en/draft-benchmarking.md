# Why benchmarking

Before proceeding make sure to read and understand the [Juju Actions](./authors-charm-actions)
section of the docs as it will be referenced heavily in the upcoming sections

# Types of benchmarks in charms

There are two main ways to deliver benchmarks in Juju. These three types are
covered in each section below. How your service is benchmarked will determine
which of these three methods you'll wish to use. For the cases where benchmarking
is done as part of the software you're delivering, then the
[As part of the charm](#as-part-of-the-charm) section will work best for you.
If you charm requires software to be run externally across a network to
benchmark the service, creating a [Load generation charm](#load-generation-charm)
will be the section of most interest for you.

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


## Load generation charm

### Subordinate load generation charm


# How to write a benchmark
