Title: Writing Charm Tests

# Writing Charm Tests

Charm authors will have the best insight into whether or not a charm is working
properly.  It is up to the author to create tests that ensure quality and
compatibility with other charms.

## The purpose of tests

The intention of charm tests is to assert that the charm works well on the
intended platform and performs the expected configuration steps. Examples of
things to test in each charm is:

- After install, expose, and adding of required relations, the service is
  running correctly (such as listening on the intended ports).
- Adding, removing, and re-adding a relation should work without error.
- Setting configuration values should result in a change reflected in the
  service's operation or configuration.

## Where to put tests

The charm directory should contain a sub-directory named 'tests'.  This
directory will be scanned by a test runner for executable files. The executable
files will be run in lexical order by the test runner, with a juju environment.
The tests can make the following assumptions:

- A minimal install of the release of Ubuntu which the charm is targeted at
  will be available.
- A version of juju is installed and available in the system path.
- A juju environment with no services deployed inside it is already
  bootstrapped, and will be the default for command line usage.
- The CWD is the `tests` directory off the charm root.
- Full access to other public charms will be available to build a solution of
  your choice.
- Tests should be self contained, meaning include or install the packages that
  it needs to test the software.
- Tests should run automatically and not require (such as passwords) or human
  intervention to get a successful test result.

If a tool is needed to perform a test and is not available in the Ubuntu
archive, it can also be included in the `tests/` directory, as long as the file
which contains it is not executable. Note that build tools cannot be assumed to
be available on the testing system.

## Test automation

The charm tests will be run automatically so all tests must not require user
interaction. The test code must install or package the files required to test
the charm.  The test runner will find and execute each test within that
directory and produce a report.

If tests exit with services still in the environment, the test runner may clean
them up, whether by destroying the environment or destroying the services
explicitly, and the machines may be terminated as well. For this reason tests
should not make assumptions on machine numbers or other factors in the
environment that could be reset.  Any artifacts needed from the test machines
should be retrieved and displayed before the test exits.

### Exit codes

Upon exit, the test's exit code will be evaluated to mean the following:

- 0: Test passed
- 1: Failed test
- 100: Test is skipped because of incomplete environment

## charm proof

The `charm-tools` package contains a static charm analysis tool called
`charm proof`.  This tool checks the charm structure and gives Informational,
Warning, and Error messages on potential issues with the charm structure. To be
in line with [Charm Store policy](./authors-charm-policy.html), all
charms should pass `charm proof` with Information messages only.
Warning or Error messages indicate a problem in the charm and the automated
tests will fail the on the `charm proof` step.

## Amulet

While you can write tests in Bash or other languages, the
[Amulet library](./tools-amulet.html) makes it easy to write tests in Python
and is recommended.

## BundleTester

The charm test runner is a tool called
[`bundletester`](https://github.com/juju-solutions/bundletester). The
`bundletester` tool is used to find, fetch, and run tests on charms and
[bundles](./charms-bundles.html).

### tests.yaml

The optional driver file, `tests/tests.yaml` can be used to to control the
overall flow of how tests are run. All values in this file are optional and
when not provided default values will be used.

Read the
[bundletester `README.md`](https://github.com/juju-solutions/bundletester)
file or more information on the options included in the  
[`tests.yaml`](https://github.com/juju-solutions/bundletester#testsyaml)
file.

### Example Tests

#### Initial test can install Amulet

Since the tests are run in lexical order, a common pattern is to use an
executable file with a name that sorts first (`00-setup` for example) which
installs Juju and the Amulet Python package if not already installed and any
other packages required for testing.

```bash
#!/bin/bash
# Check if amulet is installed before adding repository and updating apt-get.
dpkg -s amulet
if [ $? -ne 0 ]; then
    sudo add-apt-repository -y ppa:juju/stable
    sudo apt-get update
    sudo apt-get install -y amulet
fi
# Install any additional python packages or testing software here.
```

#### Following tests can be written in Amulet

The remaining tests can now assume Amulet is installed and use the library to
create tests for the charm.

You are free to write the tests in any style you want, but a common pattern is
to use the
["unittest" framework](https://docs.python.org/2/library/unittest.html)
from Python to set up and deploy the charms.  The other methods starting with
"test" will be run afterward.

```python
#!/usr/bin/env python3

import amulet
import requests
import unittest


class TestDeployment(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.deployment = amulet.Deployment()

        cls.deployment.add('charm-name')
        cls.deployment.expose('charm-name')

        try:
            cls.deployment.setup(timeout=900)
            cls.deployment.sentry.wait()
        except amulet.helpers.TimeoutError:
            amulet.raise_status(amulet.SKIP, msg="Environment wasn't stood up in time")
        except:
            raise
        cls.unit = cls.deployment.sentry.unit['charm-name/0']

# Test methods would go here.

if __name__ == '__main__':
    unittest.main()
```
