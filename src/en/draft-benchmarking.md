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

## Load generation charm

### Subordinate load generation charm


# How to write a benchmark
