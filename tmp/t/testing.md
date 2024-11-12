(testing)=
# Testing

Charms should have tests to verify that they are functioning correctly. This document describes some of the various types of testing you may want to consider -- their meaning, recommended coverage, and recommended tooling in the context of a charm.

<!--
These tests should cover the behaviour of the charm both in isolation (unit tests) and when used with other charms (integration tests). Charm authors should use [tox](https://tox.wiki/en/latest/index.html) to run these automated tests.

The unit and integration tests should be run on the same minor Python version as is shipped with the OS as configured under the charmcraft.yaml bases.run-on key. With tox, for Ubuntu 22.04, this can be done using:

{ref}`testenv]

basepython = python3.10
-->


## Unit testing

> See also: [How to write a unit test for a charm with Harness <how-to-write-unit-tests-for-a-charm>`, {ref}`How to write a unit test for a charm with Scenario <how-to-write-scenario-tests-for-a-charm>`

A **unit test** is a test that targets an individual unit of code (function, method, class, etc.) independently. In the context of a charm, it refers to testing charm code against mock Juju APIs and mocked-out workloads as a way to validate isolated behaviour without external interactions.

Unit tests are intended to be isolating and fast to complete. These are the tests you would run every time before committing code changes.

**Coverage.** Unit testing a charm should cover:

- how relation data is modified as a result of an event
- what pebble services are running as a result of an event
- which configuration files are written and their contents, as a result of an event

**Tools.** Unit testing a charm can be done using:

- [`pytest`](https://pytest.org/) and/or [`unittest`](https://docs.python.org/3/library/unittest.html) and
- [`ops.testing.Harness`](https://operator-framework.readthedocs.io/en/latest/#module-ops.testing) and/or {ref}``ops-scenario` <scenario>`

<!--
Unit tests are written using the `unittest` library shipped with Python or [pytest](https://pypi.org/project/pytest/). To facilitate unit testing of charms, use the [testing harness](https://juju.is/docs/sdk/testing) specifically designed for charmed operators which is available in the [Charmed Operator SDK](https://operator-framework.readthedocs.io/en/latest/#module-ops.testing). 
-->



**Examples.**

- [https://github.com/canonical/prometheus-k8s-operator/blob/main/tests/unit/test_charm.py](https://github.com/canonical/prometheus-k8s-operator/blob/main/tests/unit/test_charm.py)

## Interface testing

In the context of a charm, interface tests help validate charm library behavior without individual charm code against mock Juju APIs. For more information, see [Interface tests](https://juju.is/docs/sdk/interface-tests).




## Integration testing
> See also: {ref}`How to write integration tests for a charm <how-to-write-integration-tests-for-a-charm>`

An **integration test** is a test that targets multiple software components in interaction. In the context of a charm, it checks that the charm operates as expected when Juju-deployed by a user in a test model in a real controller.

Integration tests should be focused on a single charm. Sometimes an integration test requires multiple charms to be deployed for adequate testing, but ideally integration tests should not become end-to-end tests.

Integration tests typically take significantly longer to run than unit tests.

**Coverage.**

* Charm actions
* Charm integrations
* Charm configurations
* That the workload is up and running, and responsive
* Upgrade sequence
  * Regression test: upgrade stable/candidate/beta/edge from charmhub with the locally-built charm.


```{caution}

When writing an integration test, it is not sufficient to simply check that Juju reports that running the action was successful; rather, additional checks need to be executed to ensure that whatever the action was intended to achieve worked.

```

**Tools.**

- [`pytest`](https://pytest.org/) and/or [`unittest`](https://docs.python.org/3/library/unittest.html) and
- [pytest-operator](https://github.com/charmed-kubernetes/pytest-operator) and/or [`zaza`](https://github.com/openstack-charmers/zaza)


**Examples.**

- [https://github.com/canonical/prometheus-k8s-operator/blob/main/tests/integration/test_charm.py](https://github.com/canonical/prometheus-k8s-operator/blob/main/tests/integration/test_charm.py)


<!--
 <a href="#heading--functional-testing"><h2 id="heading--functional-testing">Functional testing</h2></a>

A **functional** test is a test that checks whether your software behaves according to the functional requirements / specifications (i.e., "the charm behaves as stated in spec XXX"), which are in turn usually defined relative to end-user expectations (i.e., "this charm should be able to...).

Functional tests in charms often take the form of integration-, performance- and/or end-to-end tests. 


**What to cover.** [TBA]

**Which tools to use.** 

- [`pytest`](https://pytest.org/) and/or [`unittest`](https://docs.python.org/3/library/unittest.html) and
- [`harness`](https://operator-framework.readthedocs.io/en/latest/#module-ops.testing) and/or {ref}``scenario` <11125md>`


**When to run.** Functional tests are fast, so they should be run all the time, e.g., for every PR.


**Examples.** [TBA]
-->

<!--

@Pietro Pasotti says, however we classify them, harness and scenario are both about (1) bits of code in interaction and (2) simulated production environment.

@Vitaly Antonenko says:

> so... the key difference is that integration testing is focused on the interaction between different modules of a software system (juju cli --- juju apiserver --- juju provider), while functional testing is concerned with the verification the requirements ("the request to charmhub should looks according to spec JUXXX").

So, {unit, integration} and functional live on orthogonal dimensions and, as in our current charm styleguide, though a functional test is more likely to overlaps with an integration test than with a unit test:
-->