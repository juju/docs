Title: Machine constraints  

# Machine constraints

Machine constraints allow you to choose the hardware to which your services will
be deployed.

Constraints can be set for environments and services, with service constraints
overriding environment constraints, the default values set by Juju when
otherwise unspecified. Changes to constraints do not affect any unit that has
already been assigned to a machine.

Constraints can be set by the `juju set-constraints` command, taking an optional
`--service` arg, and any number of `key=value` pairs. When the service name is
specified, the constraints are set on that service; otherwise they are set on
the environment.

Valid choices for the `value` are generally dependent on the particular
constraint, with one exception:

  - An empty value always means "not constrained". This allows you to ignore
    environment settings at the service level without having to explicitly
    remember and reset the Juju default values. Note that there is no way to
    change the Juju default values, though environment settings will override
    them.

The commands `juju deploy`, `juju bootstrap`, and `juju add-machine` have a
`--constraints` flag which expects a single string of space-separated
constraints, understood as above. Deployment constraints will be set on the
service before the first unit is deployed, and bootstrap constraints will be
set on the environment and used to provision the initial master machine.

The `juju get-constraints` command is used to see the currently applicable
constraints. When called without an argument, it outputs the environment
constraints as key=value pairs. Alternatively, you can request yaml or json with
the `--format` flag. By passing the name of a service as an argument, it will
output the constraints on that particular service.

## Examples

Deploy MySQL on a machine with at least 32GiB of RAM, and at least 8 ECU of CPU
power (architecture will be inherited from the environment, or default to
amd64):

```bash
juju deploy --constraints "cpu-cores=8 mem=32G" mysql
```

Deploy to t1.micros on AWS:

```bash
juju bootstrap --constraints "cpu-power=0 cpu-cores=0 mem=512M"
```

Launch all future "mysql" machines with at least 8GiB of RAM and 4 ECU:

```bash
juju set-constraints --service mysql mem=8G cpu-cores=4
```
Output current environment constraints:

```bash
juju get-constraints
```
Output constraints for mysql

```bash
juju get-constraints mysql
```
# Provider constraints

See a [complete listing of constraints](reference-constraints.html) for details
on what each constraint means. Two of the most commonly used are:

  - `cpu-cores`: The minimum processing power of the machine, roughly indicated
     by how many cores are available.
  - `mem`: The minimum memory for the machine, defaulting to 512MB.

# Working with constraints

Here are some examples of working with constraints.

When bootstrapping an environment, you can set the constraints directly:

```bash
juju bootstrap --constraints arch=i386
```
The above command did two things:

  - Set the environment constraints to require machines with an i386 
    architecture, leaving the other defaults untouched; this is precisely
    equivalent to:
    ```bash
    juju bootstrap --constraints "arch=i386 cpu-cores= mem= "
    ```
...but rather more convenient to type.

  - Started the bootstrap/master machine with the above constraints.

Because the environment constraints were set, subsequent deployments will use
the same values:

```bash
juju deploy mysql
```
...but other services can be started with their own constraints:

```bash
juju deploy wordpress --constraints mem=1024
```

Note that if you try to deploy a machine or service with a constraint that
cannot be fulfilled by the environment, the deployment will fail. Running `juju
status` will show an error in the status for that machine. You can fix the
problem by removing the machine (and the service assigned to the machine, if
any) and retrying the deployment with different constraints.

##  MAAS constraints

If you are deploying to a MAAS provider, you may use the additional constraint
`tags=`, followed by a comma-delimited list of tags. Only MAAS nodes thus tagged
will be considered appropriate for deploying the service.

E.g.

```bash
juju deploy mysql --constraints tags=foo,bar
```

...will deploy MySQL only to a node which has been tagged with both "foo" and
"bar".

