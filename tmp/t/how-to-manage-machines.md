(how-to-manage-machines)=
# How to manage machines

<!--FIGURE OUT A GOOD PLACE FOR THIS:
An interactive pseudo-terminal (pty) is enabled by default. For the OpenSSH client, this corresponds to the `-t` option ("force pseudo-terminal allocation").

Remote commands can be run as expected. For example: `juju ssh 1 lsb_release -c`. For complex commands the recommended method is by way of the `run` command.
-->

> See also: {ref}`Machine <machine>`

This document shows how to manage machines.

**Contents:**
- [Add a machine](#heading--add-a-machine)
- [Retry provisioning for a failed machine](#heading--retry-provisioning-for-a-failed-machine)
- [List all machines](#heading--list-all-machines)
- [View details about a machine](#heading--view-details-about-a-machine)	
- [Show the status of a machine](#heading--show-the-status-of-a-machine)
- [Manage constraints for a machine](#heading--manage-constraints-for-a-machine)	
- [Execute a command inside a machine](#heading--execute-a-command-inside-a-machine) 
- [Access a machine via SSH](#heading--access-a-machine-via-ssh) 
- [Copy files securely between machines](#heading--copy-files-securely-between-machines)
- [Upgrade a machine](#heading--upgrade-a-machine)	 
- [Remove a machine](#heading--remove-a-machine)


<a href="#heading--add-a-machine"><h2 id="heading--add-a-machine">Add a machine</h2></a>

{ref}`tabs]
[tab version="juju"]

To add a new machine to a model, run the `add-machine` command, as below. `juju` will start a new machine by requesting one from the cloud provider.


```text
juju add-machine
```

The command also provides many options. By using them you can customize many things. For example, you can provision multiple machines, specify the Ubuntu series to be installed on them, choose to deploy on a lxd container *inside* a machine, apply various constraints to the machine (e.g., storage, spaces, ...) to override more general defaults (e.g., at the model level), etc. 

Machines provisioned via `add-machine` can be used for an initial deployment (`deploy` ) or a scale-out deployment (`add-unit`).

> See more: [`juju add-machine` <command-juju-add-machine>`

[/tab]

[tab version="terraform juju"]
To add a machine to a model, in your Terraform plan add a resource of the `juju_machine` type, specifying the model. 

```terraform
resource "juju_machine" "machine_0" {
  model       = juju_model.development.name
}
```

You can optionally specify a base, a name, regular constraints, storage constraints, etc. You can also specify a `private_key_file`, `public_key_file`, and `ssh_address` -- that will allow you to add to the model an existing, manual machine (rather than a virtual one provisioned for you by the cloud).


> See more: [`juju_machine` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine)

[/tab]

[tab version="python libjuju"]

To add a machine to a model, on a connected Model object, use the `add_machine()` method. For example:

```python
await my_model.add_machine()
```

> See more: [`add_machine()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.add_machine), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

{ref}`/tab]

```{note}


Issue during machine provisioning can occur at any stage in the following sequence: 

> Provision resources/a machine M from the relevant cloud, via cloud-init maybe network config, download the jujud binaries from the controller, start jujud. 

To troubleshoot, try to gather more information until you understand what caused the issue.

> See more: [How to troubleshoot your deployment <5886md>`


```

{ref}`/tabs]

<a href="#heading--retry-provisioning-for-a-failed-machine"><h2 id="heading--retry-provisioning-for-a-failed-machine">Retry provisioning for a failed machine</h2></a>

[tabs]
[tab version="juju"]

To retry provisioning (a ) machine(s) (e.g., for a failed `deploy`, `add-unit`, or `add-machine`), run the `retry-provisioning` command followed by the (space-separated) machine ID(s). For example:

```text
juju retry-provisioning 3 27 57
```

> See more: [`juju retry-provisioning` <command-juju-retry-provisioning>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]


<a href="#heading--list-all-machines"><h2 id="heading--list-all-machines">List all machines</h2></a>

[tabs]
[tab version="juju"]

To see a list of all the available machines, use the `machines` command:

```text
juju machines
```

The output should be similar to the one below:

```text
Machine  State    Address         Inst id        Base          AZ  Message
0        started  10.136.136.175  juju-552e37-0  ubuntu@22.04      Running
1        started  10.136.136.62   juju-552e37-1  ubuntu@22.04      Running
```

> See more: [`juju machines` <command-juju-machines>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]

To see a list the names of all the available machines on a model, on a connected Model object, use the `get_machines()` method. For example:

```python
await my_model.get_machines()
```

To get a list of the machines as Machine objects on a model, use the `machines` property on the Model object. This allows direct interaction with any of the machines on the model. For example:

```python
machines = my_model.machines
my_machine = machines[0] # Machine object
print(my_machine.status)
```

> See more: [`get_machines()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.get_machines), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html), [Model.machines (property)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.machines), [Machine (object)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine)

{ref}`/tab]
[/tabs]

<a href="#heading--view-details-about-a-machine"><h2 id="heading--view-details-about-a-machine">View details about a machine</h2></a>

[tabs]
[tab version="juju"]


To see details about a machine, use the `show-machine` command followed by the machine ID. For example:

```text
juju show-machine 0
```

```{dropdown} Expand to see a sample output

```text
model: localhost-model
machines:
  "0":
    juju-status:
      current: started
      since: 27 Oct 2022 09:37:17+02:00
      version: 3.0.0
    hostname: juju-552e37-0
    dns-name: 10.136.136.175
    ip-addresses:
    - 10.136.136.175
    instance-id: juju-552e37-0
    machine-status:
      current: running
      message: Running
      since: 27 Oct 2022 09:36:10+02:00
    modification-status:
      current: applied
      since: 27 Oct 2022 09:36:07+02:00
    base:
      name: ubuntu
      channel: "22.04"
    network-interfaces:
      eth0:
        ip-addresses:
        - 10.136.136.175
        mac-address: 00:16:3e:cc:f2:16
        gateway: 10.136.136.1
        space: alpha
        is-up: true
    constraints: arch=amd64
    hardware: arch=amd64 cores=0 mem=0M
```

```

> See more: [`juju show-machine` <command-juju-show-machine>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]

To see details about a machine, on a connected Model object, get a hold of the Machine object within the model using the `machines` property. This allows direct interaction with the machine, such as accessing all the details (via the object properties) for that machine. For example:

```python
my_machine = await my_model.machines[0]
# Then we can access all the properties to view details
print(my_machine.addresses)
print(my_machine.agent_version)
print(my_machine.hostname)
print(my_machine.status)
```

> See more: [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html), [Model.machines (property)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.machines), [Machine (object)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine)

{ref}`/tab]
[/tabs]

<a href="#heading--show-the-status-of-a-machine"><h2 id="heading--show-the-status-of-a-machine">Show the status of a machine</h2></a>

[tabs]
[tab version="juju"]

To see the status of a machine, use the `status` command:

```text
juju status
```

This will report the status of the model, its applications, its units, and also its machines.

```{dropdown} Expand to see a sample output

```text
Model            Controller            Cloud/Region         Version  SLA          Timestamp
localhost-model  localhost-controller  localhost/localhost  3.0.0    unsupported  13:51:33+02:00

App       Version  Status   Scale  Charm     Channel  Rev  Exposed  Message
influxdb           waiting    0/1  influxdb  stable    24  no       waiting for machine

Unit        Workload  Agent       Machine  Public address  Ports  Message
influxdb/0  waiting   allocating  2                               waiting for machine

Machine  State    Address  Inst id  Base          AZ  Message
2        pending           pending  ubuntu@20.04      Retrieving image: rootfs: 4% (10.87MB/s)

```

```

> See more: [`juju status` <command-juju-status>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]

To see the status of a machine, on a connected Model object, get a hold of the Machine object within the model using the `machines` property. The status is then retrieved directly via the Machine object properties, in this case the `status` property. For example:

```python
my_machine = await my_model.machines[0]
print(my_machine.status)
```

> See more: [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html), [Model.machines (property)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.machines), [Machine (object)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine), [Machine.status (property)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine.status)

{ref}`/tab]
[/tabs]

<a href="#heading--manage-constraints-for-a-machine"><h2 id="heading--manage-constraints-for-a-machine">Manage constraints for a machine</h2></a>
> See also: [Constraint <constraint>`

{ref}`tabs]
[tab version="juju"]


**Set values.** You can set constraint values for an individual machine when you create it manually, by using the `add-machine` command with the `constraints` flag followed by a quotes-enclosed list of your desired key-value pairs, for example:

```text
juju add-machine --constraints="cores=4 mem=16G"
```

```{dropdown} Expand to see the command along with its result, including constraints

```text
$ juju add-machine --constraints="cores=4 mem=16G"
created machine 0
$ juju show-machine 0
model: test
machines:
  "0":
    juju-status:
      current: pending
      since: 20 Mar 2023 12:58:52+01:00
    instance-id: pending
    machine-status:
      current: pending
      since: 20 Mar 2023 12:58:52+01:00
    modification-status:
      current: idle
      since: 20 Mar 2023 12:58:52+01:00
    base:
      name: ubuntu
      channel: "22.04"
    constraints: cores=4 mem=16384M
```

```


> See more: [`juju add-machine --constraints` <command-juju-add-machine>`, {ref}`How to add a machine <5886md>`
 
**Get values.** You can get constraint values for for an individual machine by viewing details about the command with the `show-machine` command, for example:

```text
juju show-machine 0
```

```{dropdown} Expand to see a sample output, including constraints

```text
model: controller
machines:
  "0":
    juju-status:
      current: started
      since: 01 Mar 2023 15:08:34+01:00
      version: 3.1.0
    hostname: juju-6a1e1b-0
    dns-name: 10.136.136.239
    ip-addresses:
    - 10.136.136.239
    instance-id: juju-6a1e1b-0
    machine-status:
      current: running
      message: Running
      since: 07 Feb 2023 13:53:20+01:00
    modification-status:
      current: applied
      since: 20 Mar 2023 08:53:12+01:00
    base:
      name: ubuntu
      channel: "22.04"
    network-interfaces:
      enp5s0:
        ip-addresses:
        - 10.136.136.239
        mac-address: 00:16:3e:4d:aa:69
        gateway: 10.136.136.1
        space: alpha
        is-up: true
    constraints: virt-type=virtual-machine
    hardware: arch=amd64 cores=0 mem=0M virt-type=virtual-machine
    controller-member-status: has-vote
```

```

> See more: {ref}``juju show-machine` <command-juju-show-machine>`, {ref}`How to view details about a machine <5886md>`

[/tab]

[tab version="terraform juju"]
To set constraints for a machine, in your Terraform plan, in the machine resource definition, set the constraints attribute to the desired quotes-enclosed, space separated list of key=value pairs. For example:

```terraform
resource "juju_machine" "machine_0" {
  model       = juju_model.development.name
  name        = "machine_0"
  constraints = "tags=my-machine-tag"
}
```
> See more: [`juju_machine` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine)

[/tab]

[tab version="python libjuju"]

**Set values.** To set constraint values for an individual machine when you create it manually, on a connected Model, use the `add_machine()` method, passing constraints as a parameter. For example:

```python
machine = await model.add_machine(
            constraints={
                'arch': 'amd64',
                'mem': 256 * MB,
            })
```

**Get values.** The `python-libjuju` client does not currently support getting constraint values for for an individual machine. However, to retrieve machine constraints on a model, on a connected Model, use the `get_constraints()` method. For example:

```python
await my_model.get_constraints()
```

Note that this will return `None` if no constraints have been set on the model.

> See more: [`add_machine()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.add_machine),  [`get_constraints()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.get_constraints), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

{ref}`/tab]
[/tabs]

<a href="#heading--execute-a-command-inside-a-machine"><h2 id="heading--execute-a-command-inside-a-machine">Execute a command inside a machine</h2></a>

[tabs]
[tab version="juju"]

To run a command in a machine, use the `exec` command followed by the target machine(s) (`--all`, `--machine`, `--application` or `--unit`) and the commands you want to run. For example:

```text

# Run the 'echo' command in the machine corresponding to unit 0 of the 'ubuntu' application:
juju exec --unit ubuntu/0 echo "hi"

# Run the 'echo' command in all the machines corresponding to the 'ubuntu' application:
 juju exec --application ubuntu echo "hi"

```

The `exec` command can take many other flags, allowing you to specify an output file, run the commands sequentially (since `juju v.3.0`, the default is to run them in parallel), etc.

> See more: [`juju exec` <command-juju-exec>` (before `juju v.3.0`, `juju run`)

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]

To run a command in a machine, on a Machine object, use the `ssh()` method, passing a command as a parameter. For example:

```python
output = await my_machine.ssh("echo test")
assert 'test' in output
```

To run a command in all the machines corresponding to an application, on an Application object, use the `run()` method, passing the command as a parameter. For example:

```python
output = await my_application.run("echo test")
assert 'test' in output
```


> See more: [`ssh()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine.ssh), [Machine (object)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine), [`run()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.run), [Application (object)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/application.html)

[/tab]
[/tabs]

<a href="#heading--access-a-machine-via-ssh"><h2 id="heading--access-a-machine-via-ssh">Access a machine via SSH</h2></a>

[tabs]
[tab version="juju"]

There are two ways you can connect to a Juju machine: via `juju ssh` or via a standard SSH client. The former is more secure as it allows access solely from a Juju user with `admin` model access. 

----
- [Use the `juju ssh` command](#heading--use-the-juju-ssh-command)
- [Use the OpenSHH `ssh` command](#heading--use-the-openshh-ssh-command)
-----

<a href="#heading--use-the-juju-ssh-command"><h3 id="heading--use-the-juju-ssh-command">Use the `juju ssh` command</h3></a>

First, make sure you have `admin` access to the model and your public SSH key has been added to the model.

```{important}

If you are the model creator, your public SSH key is already known to `juju` and you already have `admin` access for the model. If you are not the model creator, see {ref}`How to manage users <how-to-manage-users>` and {ref}`User access levels <user-access-levels>` for how to gain `admin` access to a model and {ref}`How to manage SSH keys <how-to-manage-ssh-keys>` for how to add your SSH key to the model.

```

<!--
<h3 id="heading--providing-access-to-non-initial-controller-admin-juju-users">Providing access to non-initial controller admin Juju users</h3>

In order for a non-initial controller admin user to connect with `juju ssh` that user must:

- be created (`add-user`)
- have registered the controller (`register`)
- be logged in (`login`)
- have 'admin' access to the model
- have their public SSH key reside within the model
- be in possession of the corresponding private SSH key

As previously explained, 'admin' model access and installed model keys can be obtained by creating the model. Otherwise access needs to be granted (`grant`) by a controller admin and keys need to be added (`add-ssh-key` or `import-ssh-key`) by a controller admin or the model admin.
-->

Then, to initiate an SSH session or execute a command on a Juju machine (or container), use the `juju ssh` command followed by the target machine (or container). This target can be specified using a machine (or container) ID or using the ID of the unit that it hosts. Both can be retrieved from the output of `juju status`. For example, below we `ssh` into machine 0 and inside of it run `echo hello`:

```text
juju ssh 0 echo hello 
```

By passing further arguments and options, you can also run this on behalf of a different qualified user (other than the current user) or pass a private SSH key instead.

> See more: {ref}``juju ssh` <command-juju-ssh>`

<!--
Alternatively, you can pass a private key. The easiest way to ensure it is used is to have it stored as `~/.ssh/id_rsa`. Otherwise, you can do one of two things:

1. Use `ssh-agent`

1. Specify the key manually

The second option above, applied to the previous example, will look like this:

```text
juju ssh 0 -i ~/.ssh/my-private-key
```
-->

<a href="#heading--use-the-openshh-ssh-command"><h3 id="heading--use-the-openshh-ssh-command">Use the OpenSHH `ssh` command</h3></a>

First, make sure you've added a public SSH key for your user to the target model. 

```{important}

If you are the model creator, your public SSH key is already known to `juju` and you already have `admin` access for the model. If you are not the model creator, see {ref}`How to manage users <how-to-manage-users>` and {ref}`User access levels <user-access-levels>` for how to gain `admin` access to a model and {ref}`How to manage SSH keys <how-to-manage-ssh-keys>` for how to add your SSH key to the model.

```

Alternatively, for direct access using a standard SSH client, it is also possible to add the key to an individual machine using standard methods (manually copying a key to the `authorized_keys` file or by way of a command such as `ssh-import-id` in the case of Ubuntu).

Then, to connect to a machine via the OpenSSH client, use the OpenSSH `ssh` command followed by `<user account>@<machine IP address>`, where the default user account added to a Juju machine, to which public SSH keys added by `add-ssa-key` or `import-ssh-key`, is `ubuntu`. For example, for a machine with an IP address of `10.149.29.143`, do the following:

```text
ssh ubuntu@10.149.29.143
```
> See more: [OpenSSH](https://www.openssh.com/)

<!--HOW DOES ONE FIND THE MACHINE IP ADDRESS?-->

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

 <a href="#heading--copy-files-securely-between-machines"><h2 id="heading--copy-files-securely-between-machines">Copy files securely between machines</h2></a>

[tabs]
[tab version="juju"]

The `scp` command copies files securely to and from machines.

```{caution}

Options specific to scp must be preceded by double dashes: `--`.

```

Examples:

Copy 2 files from two MySQL units to the local backup/ directory, passing `-v` to scp as an extra argument:

```text
juju scp -- -v mysql/0:/path/file1 mysql/1:/path/file2 backup/
```

Recursively copy the directory `/var/log/mongodb/` on the first MongoDB server to the local directory remote-logs:

```text
juju scp -- -r mongodb/0:/var/log/mongodb/ remote-logs/
```

Copy a local file to the second apache2 unit in the model "testing". Note that the `-m` here is a Juju argument so the characters `--` are not used:

```text
juju scp -m testing foo.txt apache2/1:
```

```{important}

Juju cannot transfer files between two remote units because it uses public key authentication exclusively and the native (OpenSSH) `scp` command disables agent forwarding by default. Either the destination or the source must be local (to the Juju client).

```

> See more: [`juju scp` <command-juju-scp>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
To copy files securely between machines, on a Machine object, use the `scp_to()` and `scp_from()` methods, passing source and destination parameters for the transferred files or directories. For example:

```python
# Transfer from local machine to Juju machine represented by my_machine object
with open(file_name, 'r') as f:
    await my_machine.scp_to(f.name, 'testfile')

# Transfer from my_machine to local machine
with open(file_name, 'w') as f:
    await my_machine.scp_from('testfile', f.name)
    assert f.read() == b'contents_of_file'

# Pass -r for recursively copy a directory via the `scp_opts` parameter.
await my_machine.scp_to('my_directory', 'testdirectory', scp_opts=['-r'])

```


> See more: [`scp_to()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine.scp_to), [`scp_from()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine.scp_from), [Machine (object)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine)
{ref}`/tab]
[/tabs]


<a href="#heading--upgrade-a-machine"><h2 id="heading--upgrade-a-machine">Upgrade a machine</h2></a>

> See also: [Upgrading things <upgrading-things>`
<!--CRAFTED FROM https://discourse.charmhub.io/t/how-to-upgrade-a-machines-series/1198 . PS upgrade-series is deprecated.-->

[tabs]
[tab version="juju"]

<!--
https://discourse.charmhub.io/t/how-to-upgrade-a-machines-series/1198#heading--upgrading-a-controller-machine
-->

The process for how to upgrade a machine depends on whether the machine is a controller machine or a workload machine.

- [Upgrade a controller machine](#heading--upgrade-a-controller-machine)
- [Upgrade a workload machine](#heading--upgrade-a-workload-machine)


 <a href="#heading--upgrade-a-controller-machine"><h3 id="heading--upgrade-a-controller-machine">Upgrade a controller machine</h3></a>

You cannot upgrade a controller machine. Instead, you must bootstrap a new controller with the intended base, migrate your old models to it, configure the models to the new base, and then remove the old controller, as shown below.

**1. Create a new controller with the intended base.** To create a new controller with a base of your choice, run the `bootstrap` command with the `bootstrap-base` flag. For example:


```text
juju bootstrap aws aws-new --bootstrap-base=<base>
```

> See more: {ref}`How to create a controller <5886md>`, {ref}``juju bootstrap` <5886md>`

**2. Migrate your existing models to the new controller.**

> See more: {ref}`How to migrate a workload model to another controller <5886md>`


**3. Configure the migrated models such that all new machines have the new base.** 

``` text
juju model-config -m <model name> default-base=<base>
```

**4. Destroy the old controller.**

``` text
juju destroy-controller aws-old
```

 <a href="#heading--upgrade-a-workload-machine"><h3 id="heading--upgrade-a-workload-machine">Upgrade a workload machine</h3></a>

```{caution}

Support for upgrading the base for an individual machine after it has been provisioned will be removed starting with Juju 4. See more: [Discourse | Juju 4.0 to remove `upgrade-machine`...](https://discourse.charmhub.io/t/juju-4-0-to-remove-upgrade-machine-and-set-application-base/14758).

```

**1. Tell Juju to take the machine out of circulation, in preparation for an upgrade.** To achieve this, run the `upgrade-machine` command followed by the machine ID, the subcommand `prepare`, and the base to upgrade to. For example, the code below tells `juju` to prepare machine 3 for an upgrade to `ubuntu@22.04`.

```{caution}

Once the `prepare` command has been issued, there is no way to cancel or abort the process. Once you commit to prepare you must complete the process or you will end up with an unusable machine!

```

```{caution}

**If you're using Juju <3.1:** Instead of a {ref}`base <base>` you must specify the series. Thus, not `ubuntu@22.04` but rather `jammy`. 

```
```text
juju upgrade-machine 3 prepare ubuntu@22.04
```

This has multiple effects:

1.  The machine is no longer available for charm deployments or for hosting new containers. 
2. Juju prepares the machine for the upcoming OS upgrade. All units on the machine are taken into account.

**2. Perform the upgrade.** This is done manually. On an Ubuntu-based machine, you can do this by logging in to the machine via SSH and executing the `do-release-upgrade` command:

```text
juju ssh 3
$ do-release-upgrade
```

Make sure to reserve some time for maintenance, in case any issues arise.

**3. Tell Juju that the machine has been successfully upgraded.** To achieve this, run the `upgrade-machine` command with the `complete` subcommand.

```text
juju upgrade-machine 3 complete
```

Done! The upgraded machine is again available for charm deployments.

> See more: {ref}``juju upgrade-machine` <command-juju-upgrade-machine>` (before Juju 3, `upgrade-series`)

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--remove-a-machine"><h2 id="heading--remove-a-machine">Remove a machine</h2></a>
> See also: [Removing things <removing-things>`
<!--CRAFTED FROM https://discourse.charmhub.io/t/how-to-remove-a-machine/5885 -->

{ref}`tabs]
[tab version="juju"]

To remove a machine, use the `remove-machine` command followed by the machine ID. For example:

```text
juju remove-machine 3
```

```{important}

It is not possible to remove a machine that is currently hosting either a unit or a container. Either remove all of its units (or containers) first or, as a last resort, use the `--force` option.

```

```{note}

In some situations, even with the `--force` option, the machine on the backing cloud may be left alive. Examples of this include the Manual cloud or if harvest provisioning mode is not set (see [`provisioner-harvest-mode` <5886md>`). In addition to those situations, if the client has lost connectivity with the backing cloud, any backing cloud, then the machine may not be destroyed, even if the machine's record has been removed from the Juju database and the client is no longer aware of it.

```


By using various options, you can also customize various other things, for example, the model or whether to keep the running cloud instance or not. 

> See more: {ref}``juju remove-machine` <command-juju-remove-machine>`

<!--
By default, when a machine is removed, the backing system, typically a cloud instance, is also destroyed. The for example, `--keep-instance` option overrides this; it allows the instance to be left running.
-->

<!--DETAILS FOR ADD-MACHINE, originally from https://discourse.charmhub.io/t/how-to-set-constraints-for-a-machine/5884 
Constraints at the machine level can be set when adding a machine with the `add-machine` command. Doing so provides a way to override defaults at the all-units, application, model, and all-models levels.

Once such a machine has been provisioned, it can be used for an initial deployment (`deploy`) or a scale-out deployment (`add-unit`). See {ref}`Deploying to specific machines <5886md>` for the command syntax to use.

A machine with a constraint can be added in this way:

``` text
juju add-machine --constraints arch=arm
```

To add a machine that is connected to a space, for example `storage`, run:

``` text
juju add-machine --constraints spaces=storage
```

If a space constraint is prefixed by '^', then the machine will **not** be connected to that space. For example, the command below will result in an instance that is connected to both the `db-space` and `internal` spaces but not connected to either the `storage` or `dmz` spaces.

``` text
--constraints spaces=db-space,^storage,^dmz,internal
```

See the {ref}`network spaces <space>` page for details on spaces.

For a LXD cloud, to create a machine limited to two CPUs:

``` text
juju add-machine --constraints cores=2
```

To add eight Xenial machines such that they are evenly distributed among four availability zones:

``` text
juju add-machine -n 8 --series xenial --constraints zones=us-east-1a,us-east-1b,us-east-1c,us-east-1d
```
-->

[/tab]

[tab version="terraform juju"]
To remove a machine, remove its resource definition from your Terraform plan.

> See more: [`juju_machine` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine)

[/tab]

[tab version="python libjuju"]
To remove a machine, on a Machine object, use the `destroy()` method. For example:

```python
await my_machine.destroy()

```

> See more: [`destroy()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine.destroy), [Machine (object)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.machine.html#juju.machine.Machine)
[/tab]
[/tabs]

<br>

> <small>**Contributors:** @alhama7a, @cderici, @tmihoc </small>