Title: Testing Juju charms

# Charm Testing

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

## Test automation

Any automation concerns?

If tests exit with services still in the environment, the test runner may clean
them up, whether by destroying the environment or destroying the services
explicitly, and the machines may be terminated as well. Any artifacts needed
from the test machines should be retrieved and displayed before the test exits.

### Exit Codes

Upon exit, the test's exit code will be evaluated to mean the following:

- 0: Test passed
- 1: Failed test
- 100: Test is skipped because of incomplete environment

## charm proof

The `charm-tools` package contains a static charm analysis tool called
`charm proof`.  This tool checks the charm structure and gives Informational,
Warning, and Error messages on potential issues with the charm structure. All
charms should pass `charm proof` with no messages or Information messages only.
Warning or Error messages indicate a problem that should be fixed in the charm.

## Amulet

While you can write tests in Bash or other languages, the
[Amulet library](./tools-amulet) makes it easy to write tests in Python and is
recommended.

## bundletester

### tests.yaml
If present, tests/tests.yaml will be read to determine packages that need to be
installed on the host running tests in order to facilitate the tests. The
packages can _only_ be installed from the official, default Ubuntu archive for
the release which the charm is intended for, from any of the repositories
enabled by default in said release. The format of tests.yaml is as such:

```yaml
packages: [ package1, package2, package3 ]
```

If a tool is needed to perform a test and is not available in the Ubuntu
archive, it can also be included in the `tests/` directory, as long as the file
which contains it is not executable. Note that build tools cannot be assumed to
be available on the testing system.


### Example Tests

A common pattern is to use a filename that sorts first (00-setup for
example) which installs Juju if not already installed and any other packages
required for testing.

#### 00-setup
```bash
#!/bin/bash
# Check if amulet is installed before adding repository and updating apt-get.
dpkg -s amulet
if [ $? -ne 0 ]; then
    sudo add-apt-repository -y ppa:juju/stable
    sudo apt-get update
    sudo apt-get install -y amulet
fi
# Install any additional python packages or software here.
sudo apt-get install -y python3-requests
```

#### python example
