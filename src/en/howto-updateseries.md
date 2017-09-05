Title: Update a juju machine's series

#  Update a juju machine's series

## Overview

This guide will cover how to update the series on an existing juju machine.

## Prerequisites

Verify that the charm for the applications on the given machine support the
series you wish to update to.

## Updating the series

### Shutdown juju services running on the machine.

Start by sshing to the machine you wish to update
```
juju ssh ghost/0
```

#### Series using systemd, 16.04 and beyond

Find the juju services running, there should be 1 for the machine and 1 per
unit installed on the machine.
```
$ sudo systemctl status juju*
● jujud-machine-1.service - juju agent for machine-1
...
● jujud-unit-ghost-0.service - juju unit agent for ghost/0
...
```
In this case, the machine has 1 unit.

```
$ sudo systemctl stop juju*
```

#### Series using upstart, prior to 16.04

Find the juju services running, there should be 1 for the machine and 1 per
unit installed on the machine.
```
$ initctl list | grep juju
jujud-machine-2 start/running, process 4403
jujud-unit-ghost-1 start/running, process 4456
juju-clean-shutdown stop/waiting
```
In this case, the machine has 1 unit.

```
$ sudo stop jujud-machine-2
jujud-machine-2 stop/waiting
$ sudo stop jujud-unit-ghost-1
jujud-unit-ghost-1 stop/waiting
```

### Do the update

Follow the documentation on how to update existing machine.

### 14.04 to 16.04

## Restart juju services on the unit 

https://wiki.ubuntu.com/SystemdForUpstartUsers

### Considerations pre-juju2.3

### Juju 2.3 and later
