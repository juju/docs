Title: Writing charm tests

# Writing Charm Tests

Charm authors will have the best insight into whether or not a charm is working
properly. It is up to the author to create tests that ensure quality and
compatibility with other charms.

## The purpose of tests

The intention of charm tests is to assert that the charm works well on the
intended platform and performs the expected configuration steps. Examples of
things to test in each charm is:

- After install, expose, and adding of required relations, the application is
  running correctly (such as listening on the intended ports).
- Adding, removing, and re-adding a relation should work without error.
- Setting configuration values should result in a change reflected in the
  application's operation or configuration.

## Where to put tests

The charm directory should contain a sub-directory named 'tests'. This
directory will be scanned by a test runner for executable files. The executable
files will be run in lexical order by the test runner, with a default Juju
model. The tests can make the following assumptions:

- A minimal install of the release of Ubuntu which the charm is targeted at
  will be available.
- A version of Juju is installed and available in the system path.
- A Juju model with no applications deployed inside it is already
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

The charm tests will be run automatically, so all tests must not require user
interaction. The test code must install or package the files required to test
the charm. The test runner will find and execute each test within that
directory and produce a report.

If tests exit with applications still in the model, the test runner may clean
them up, whether by destroying the model or destroying the applications
explicitly, and the machines may be terminated as well. For this reason tests
should not make assumptions on machine or unit numbers or other factors in the
model that could be reset. Any artifacts needed from the test machines should
be retrieved and displayed before the test exits.

### Exit codes

Upon exit, the test's exit code will be evaluated to mean the following:

- 0: Test passed
- 1: Failed test
- 100: Test is skipped because of a timeout or incomplete setup

## charm proof

The `charm-tools` package contains a static charm analysis tool called
`charm proof`. This tool checks the charm structure and gives Informational,
Warning, and Error messages on potential issues with the charm structure. To be
in line with [Charm Store policy](./authors-charm-policy.html), all
charms should pass `charm proof` with Information messages only.
Warning or Error messages indicate a problem in the charm and the automated
tests will fail the on the `charm proof` step.

## The Amulet Test Library

While you can write tests in Bash or other languages, the
[Amulet library](./tools-amulet.html) makes it easy to write tests in Python
and is recommended.

## Executing Tests via BundleTester

The charm test runner is a tool called
[`bundletester`](https://github.com/juju-solutions/bundletester). The
`bundletester` tool is used to find, fetch, and run tests on charms and
[bundles](./charms-bundles.html).

You should execute bundletester against a built charm. In order to
test the vanilla charm that you built in [Getting
Started](./developer-getting-started.html), you would do the
following:

```
charm build
bundletester -t $JUJU_REPOSITORY/trusty/vanilla
```

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
executable file with a name that sorts first (`00-setup` for example), which
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
from Python to set up and deploy the charms. The other methods starting with
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

### Debugging Your Tests

If you're running tests with bundletester, debugging the tests
themselves can be a little tricky. Setting breakpoints will simply
make the test hang, as bundletester runs the tests in a separate
process.

You can run the tests directly, however. Let's say that you named the
test in the example above "01-deployment". You could run it like so:

```
build charm
cd $JUJU_REPOSITORY/trusty/vanilla
python3 tests/01-deployment
```

(Note that you'd need to run your setup script manually first, or run
your modified test, with breakpoints, against an already deployed
charm.)

The Deployment class in amulet also has a .log attribute, which can be
useful for diagnosing problems after the tests have run. In the
example tests above, you might invoke it with a line like the
following:

```
    self.deployment.log.debug("Some debug message here.")
```

## Unit testing a layered charm

Amulet is a mature tool for deploying and testing a charm in a test environment.

For layered charms, it is often desirable to be able to run some tests before the charm has been built, however. For example, you may wish to run unit tests as you write your code. Waiting for the charm to build so that amulet can run tests on it would introduce unnecessary delays into the unit testing cycle. What follows are some best practices for writing unit tests for a layered charm.

### Create a separate tox ini file

You will usually want to create a second .ini file for tox, along with a separate requirements file, so that requirements for your unit tests don't clobber the requirements for Amulet tests. You might call this file `tox_unit.ini`, and put the following inside of it:

```
[tox]
skipsdist=True
envlist = py34, py35
skip_missing_interpreters = True

[testenv]
commands = nosetests -v --nocapture tests/unit
deps =
    -r{toxinidir}/tests/unit/requirements.txt
    -r{toxinidir}/wheelhouse.txt

setenv =
    PYTHONPATH={toxinidir}/lib

```

### Put library functions into packaged Python libraries.

If you import objects from a Python module that exists in another layer, Python will raise an ImportError when you execute your unit tests. Building the charm will fix this ImportError, but will slow down your unit testing cycle.

Layer authors can help you get around this issue by putting their library functions in a Python library that can be built and installed via the usual Python package management tools. You can add the library to your unit testing requirements.

This isn't always practical, however. This brings us to the next step:

### When importing modules from a layer, structure your imports so that you can monkey patch

Let's say that you want to use the very useful "options" object in the base layer. If you import it as follows, you will get an import error that it very hard to work around:

```
from charms.layer import options

class MyClass(object):
    def __init__(self):
        self.options = options

```

If you instead import it like so, you can use libraries like Python's mock library to monkey patch the import out when you run your tests:

```
from charms import layer

class MyClass(object):
    def __init__(self):
        self.options = layer.options

```

Here's an example of a test that uses the mock (note that we pass create=True -- this is important!):

```

    @mock.patch('mycharm.layer.options', create=True)
    def test_my_class(self, mock_options):
        ...

```

If your charm does not have a lib/charms/layer directory, you'll still wind up with an ImportError that can be hard to work around. In this case, we recommend creating that directory, and dropping a blank file called `<your charm name>.py` into it. This isn't ideal, but it will save you some trouble when writing your tests.
