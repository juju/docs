Title: Constraints

# Constraints

Constraints allow you to choose the hardware (or virtual hardware)
to which your applications will be deployed, e.g. by specifying the amount of 
RAM you want them to have. This is particularly useful for making sure that the
application is deployed somewhere it can actually run efficiently, or that it is
connected to the right network. Constraints may be set for models and
applications, with application constraints taking precedence. Changes to
constraints do not affect any units which have already been placed on machines.

For more granularity, it is also possible to add a machine with specific 
constraints (`juju add-machine`) and then specify that machine when deploying 
applications ([see the documentation on `juju deploy`](./charms-deploying.html)).

## What constraints can be used?

There is a full list of the constraints used 
[in the reference section](reference-constraints.html). Be aware that some of 
these are specific to the type of cloud you are using. For example, one may
understand an "instance-type" constraint, but another may not. 

The most useful constraints for Juju in general are:
  
  - **mem** : This indicates the minimum number of megabytes of RAM that must 
  be available to an application unit. An optional suffix of M/G/T/P indicates
  the value is mega-/giga-/tera-/peta- bytes.

  - **cores** :  How many cpu cores the host machine should have. This is a
  crude indicator of system performance.
    
  - **spaces** : Target a particular network space, or avoid one. See 
  [Network spaces][network-spaces].
  
  - **arch** : Short for 'architecture', indicates the processor type an
  application must run on. One of amd64, arm, i386, arm64, or ppc64el.
  
With these you can make sure an application has the resources it needs to run 
properly.

Constraints can be used with commands that support the '--constraints' option. 
These are covered in more detail below, but there are some aspects of specifying
constraints that are worth mentioning first.

In the following examples, we will be using the `juju deploy` command, as this
is the simplest and most frequent case for using constraints. So, to deploy the
'mariadb' application to a machine with 4 gigabytes of memory or more:
  
```bash
juju deploy mariadb --constraints mem=4G
```

To further ensure that it also has at least 2 CPU cores:
  
```bash
juju deploy mariadb --constraints "mem=4G cores=2"
```

!!! Note: 
    When setting more than one constraint you will need to utilize quotes.

To ignore any constraints which may have been previously set, you can assign a 
'null' value. If the application or model constraints for the 'mariadb' charm
have already been set to 8 cpu-cores for example, you can ignore that constraint
at deploy time with:
  
```bash
juju deploy mariadb --constraints "mem=4G cores=" 
```

In the event that a constraint cannot be met, the unit will not be deployed.

!!! Note: 
    Constraints work on an "or better" basis: If you ask for 4 CPUs, you 
    may get 8, but you won't get 2.
    
## Setting constraints for a controller

Constraints can be applied to a controller during its creation
(`juju bootstrap` command) by using the `--bootstrap-constraints` option. See
[Creating a controller][controllers-creating] for details and examples.

## Setting default model constraints

Default model constraints can be set during the controller-creation process by
using the `--constraints` option (with the `juju bootstrap` command). See
[Creating a controller][controllers-creating] for more information on how to do
this.

Default model constraints can be overridden for specific models, applications,
or machines, as detailed below.

## Setting constraints for a model

At the model level, constraints can be set like this:
  
```bash
juju set-model-constraints mem=4G
```

In this example, any subsequent machines created in this model will have at
least 4 gigabytes of memory. You can check the current constraints with:
  
```bash
juju get-model-constraints
```

As with similar commands, you can 'unset' the constraint by setting its value
to null:
  
```bash
juju set-model-constraints mem=
```

Model-related constraints can also be overridden at the application and machine
level.

## Setting constraints for an application

Usually, constraints for an application are set at deploy time, by passing the 
required parameters using the deploy command:
  
```bash
juju deploy mariadb cores=4
```

Subsequently, you can set constraints for the any additional units added to the 
application by running:
  
```bash
juju set-constraints mariadb cores=2
```

The constraints work on a named-application as well. So the following also works
as expected:
  
```bash
juju deploy mariadb database1
juju deploy mariadb database2
juju set-constraints database1 mem=4096M
```

You can fetch the current constraints like this:
  
```bash
juju get-constraints mariadb
juju get-constraints database1
```

## Adding a machine with constraints

The `juju add-machine` command also accepts the `--constraints` option, which
can be useful when trying to target a specific machine or type of machine.

For example:

```bash 
juju add-machine --constraints spaces=storage,db
```

Will provision a machine that is connected to both the 'storage' and 'db' 
network spaces. See [Network spaces][network-spaces] for more information on
spaces.

You can subsequently deploy applications to the above machine using
the `--to` switch with the `deploy` command. See
[Deploying to specific machines][charms-deploying-to-option] for how to do
this.

Both positive and negative entries are accepted, the latter prefixed by '^', in
a comma-delimited list. For example, given the following:

```no-highlight
--constraints spaces=db-space,^storage,^dmz,internal
```

Juju will provision instances connected to one of the subnets of both
'db-space' and 'internal' spaces, and **not** connected to either the 'storage'
or 'dmz' spaces.


<!-- LINKS -->

[controllers-creating]: ./controllers-creating.html
[network-spaces]: ./network-spaces.html
[charms-deploying-to-option]: ./charms-deploying.html#deploying-to-specific-machines
