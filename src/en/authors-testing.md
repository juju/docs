Title: Testing Juju charms

# Charm Testing

Juju has been designed from the start to foster a large collection of "charms".
Charms are expected to number in the thousands, and be self contained, with 
well defined interfaces for defining their relationships to one another.

Because this is a large complex system, not unlike a Linux software
distribution, there is a need to test the charms and how they interact with one
another. This specification defines a plan for implementing a simple framework
to help this happen.

Static tests have already been implemented in the `charm proof` command as part
of `charm-tools`. Any static testing of charms is beyond the scope of this
specification.

## Phase 1 - Generic tests

All charms share some of the same characteristics. They all have a yaml file
called `metadata.yaml`, and when deployed, juju will always attempt to progress
the state of the service from install to config to started. Because of this, 
all charms can be tested using the following algorithm:

```no-highlight
    deploy charm
     while state != started
     if timeout is reached, FAIL
     if state == install_error, config_error, or start_error, FAIL
     if state == started, PASS
```

Other generic tests may be identified, so a collection of generic tests should
be the focus of an implementation.

Note that this requirement is already satisfied by [Mark Mims' jenkins tester](https://github.com/mmm/charmtester/).

## Phase 2 - Charm Specific tests

Charm authors will have the best insight into whether or not a charm is working
properly.

A simple structure will be utilised to attach tests to charms. Under the charm
root directory, a sub-directory named 'tests' will be scanned by a test runner
for executable files. These will be run in lexical order by the test runner,
with a predictible environment. The tests can make the following assumptions:

- A minimal install of the release of Ubuntu which the charm is targeted at 
  will be available.
- A version of juju is installed and available in the system path.
- A juju environment with no services deployed inside it is already 
  bootstrapped, and will be the default for command line usage.
- The CWD is the `tests` directory off the charm root.
- Full network access to deployed nodes will be allowed.
- the bare name of any charm in arguments to juju will be resolved to a charm 
  url and/or repository arguments of the test runner's choice. This means that 
  if you need mysql, you do not do `juju deploy cs:mysql` or 
  `juju deploy --repository ~/charms local:mysql`, but just `juju deploy mysql`.
  A wrapper will resolve this to the latest version of the given charm from the
  list of official charms.

The following restrictions may be enforced:

- Internet access will be restricted from the testing host.

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

### Purpose of tests

The purpose of these tests is to assert that the charm works well on the
intended platform and performs the expected configuration steps. Examples of
things to test in each charm beyond install/start is:

- After install, expose, and adding of required relations, the service is 
  listening on the intended ports and is functional.
- Adding, removing, and re-adding a relation should work without error.
- Setting config values should result in the config value reflected in the 
  service's configuration.
- Adding multiple units to a web app charm and relating to a load balancer 
  results in the same HTML on both units directly and the load balancer.

### Exit Codes

Upon exit, the test's exit code will be evaluated to mean the following:

- 0: Test passed
- 1: Failed test
- 100: Test is skipped because of incomplete environment

### Output

There is a general convention which output should follow, though it will not be
interpreted by machine. On stdout, a message indicating the reason for the exit
code should be printed, with a prefix string corresponding to the exit codes
defined above. The correlation is:

- PASS - 0
- FAIL - 1
- SKIP - 100

Anything else intentional should be prefixed with the word 'INFO'. If the
contents of files are to be logged, the contents should be preceded by `INFO:
BEGIN filename`, where filename is a logical name unique to this run of the
test, and then the file ended with `INFO: END filename`.

### Example Tests

#### Deploy requirements and Poll

The test below deploys mediawiki with mysql and memcached related to it, and 
then tests to make sure it returns a page via http with `<title>` somewhere 
in the content:

```bash
#!/bin/sh

set -e

teardown() {
    if [ -n "$datadir" ] ; then
        if [ -f $datadir/passed ]; then
            rm -r $datadir
        else
            echo INFO: $datadir preserved
            if [ -f $datadir/wget.log ] ; then
                echo INFO: BEGIN wget.log
                cat $datadir/wget.log
                echo INFO: END wget.log
            fi
        fi
    fi
}
trap teardown EXIT


juju deploy mediawiki
juju deploy mysql
juju deploy memcached
juju add-relation mediawiki:db mysql:db
juju add-relation memcached mediawiki
juju expose mediawiki

for try in `seq 1 600` ; do
    host=`juju status | tests/get-unit-info mediawiki public-address`
    if [ -z "$host" ] ; then
        sleep 1
    else
        break
    fi
done

if [ -z "$host" ] ; then
    echo FAIL: status timed out
    exit 1
fi

datadir=`mktemp -d ${TMPDIR:-/tmp}/wget.test.XXXXXXX`
echo INFO: datadir=$datadir

wget --tries=100 --timeout=6 http://$host/ -O - -a $datadir/wget.log | grep -q '<title>'

if [ $try -eq 600 ] ; then
    echo FAIL: Timed out waiting.
    exit 1
fi

touch $datadir/passed

trap - EXIT
teardown

echo PASS
exit 0
```

### Test config settings

The following example tests checks to see if the default_port change the admin
asks for is actually respected post-deploy:

```bash
#!/bin/sh

if [ -z "`which nc`" ] ; then
    echo "SKIP: cannot run tests without netcat"
    exit 100
fi

set -e

juju deploy mongodb
juju expose mongodb

for try in `seq 1 600` ; do
    host=`juju status | tests/get-unit-info mongodb public-address`
    if [ -z "$host" ] ; then
        sleep 1
    else
        break
    fi
done

if [ -z "$host" ] ; then
    echo FAIL: status timed out
    exit 1
fi

assert_is_listening() {
    local port=$1
    listening=""
    for try in `seq 1 10` ; do
        if ! nc $host $port < /dev/null ; then
            continue
        fi
        listening="$port"
        break
    done

    if [ -z "$listening" ] ; then
       echo "FAIL: not listening on port $port after 10 retries"
       return 1
    else
        echo "PASS: listening on port $listening"
        return 0
    fi
}

assert_is_listening 27017

juju set mongodb default_port=55555
assert_is_listening 55555
echo PASS: config change tests passed.
exit 0
```

**get-unit-info**: The example tests script uses a tool that is not widely 
available yet, `get-unit-info`. In the future enhancements should be made to
Juju core to allow such things to be made into plugins. Until then, it can be
included in each test dir that uses it, or we can build a package of tools 
that are common to tests.

## Test Runner

A test runner will periodically poll the collection of charms for changes since
the last test run. If there have been changes, the entire set of changes will
be tested as one delta. This delta will be recorded in the test results in such
a way where a developer can repeat the exact set of changes for debugging
purposes.

All of the charms will be scanned for tests in lexical order by series, charm
name, branch name. Non official charms which have not been reviewed by charmers
will not have their tests run until the test runner's restrictions have been
vetted for security, since we will be running potentially malicious code. It is
left to the implementor to determine what mix of juju, client platform, and
environment settings are appropriate, as all of these are variables that will
affect the running charms, and so may affect the outcome.

If tests exit with services still in the environment, the test runner may clean
them up, whether by destroying the environment or destroying the services
explicitly, and the machines may be terminated as well. Any artifacts needed
from the test machines should be retrieved and displayed before the test exits.
