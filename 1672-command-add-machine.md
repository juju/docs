**Usage:** `juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | winrm:[user@]host | placement]`

**Summary:**

Start a new, empty machine and optionally a container, or add a container to a machine.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--constraints (= "")`

Additional machine constraints

`--disks (= )`

Constraints for disks to attach to the machine

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-n (= 1)`

The number of machines to add

`--series (= "")`

The charm series

**Details:**

Juju supports adding machines using provider-specific machine instances (EC2 instances, OpenStack servers, MAAS nodes, etc.); existing machines running a supported operating system (see "manual provisioning" below), and containers on machines. Machines are created in a clean state and ready to have units deployed.

Without any parameters, add machine will allocate a new provider-specific machine (multiple, if "`-n`" is provided). When adding a new machine, you may specify constraints for the machine to be provisioned; the provider will interpret these constraints in order to decide what kind of machine to allocate.

If a container type is specified (e.g. "lxd"), then add machine will allocate a container of that type on a new provider-specific machine. It is also possible to add containers to existing machines using the format `:.` Constraints cannot be combined with deploying a container to an existing machine. The currently supported container types are: lxd, kvm.

Manual provisioning is the process of installing Juju on an existing machine and bringing it under Juju's management; currently this requires that the machine be running Ubuntu, that it be accessible via SSH, and be running on the same network as the API server.

It is possible to override or augment constraints by passing provider-specific "placement directives" as an argument; these give the provider additional information about how to allocate the machine. For example, one can direct the MAAS provider to acquire a particular node by specifying its hostname.

**Examples:**

      juju add-machine                      (starts a new machine)
      juju add-machine -n 2                 (starts 2 new machines)
      juju add-machine lxd                  (starts a new machine with an lxd container)
      juju add-machine lxd -n 2             (starts 2 new machines with an lxd container)
      juju add-machine lxd:4                (starts a new lxd container on machine 4)
      juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
      juju add-machine ssh:user@10.10.0.3   (manually provisions machine with ssh)
      juju add-machine winrm:user@10.10.0.3 (manually provisions machine with winrm)
      juju add-machine zone=us-east-1a      (start a machine in zone us-east-1a on AWS)
      juju add-machine maas2.name           (acquire machine maas2.name on MAAS)
**See also:**

[remove-machine](https://discourse.jujucharms.com/t/command-remove-machine/1787)
