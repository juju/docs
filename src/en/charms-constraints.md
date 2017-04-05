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
    
  - **spaces** : Target a particular network space, or avoid one (not supported
  all clouds).
  
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
juju deploy mariadb --constraints mem=4G cores=2
```

or, if you prefer to enclose all contraints in quotes:

```bash
juju deploy mariadb --constraints "mem=4G cores=2"
```

To ignore any constraints which may have been previously set, you can assign a 
'null' value. If the application or model constraints for the 'mariadb' charm
have already been set to 8 cpu-cores for example, you can ignore that constraint
at deploy time with:
  
```bash
juju deploy mariadb --constraints mem=4G cores= 
```

In the event that a constraint cannot be met, the unit will not be deployed.

!!! Note: Constraints work on an "or better" basis: If you ask for 4 CPUs, you 
may get 8, but you won't get 2


    
## Using constraints when creating a controller

A controller is created using the `bootstrap` command, which accepts a 
'--constraints' switch to specify which machine to use. When you create the
controller with constraints, the same constraints apply to each subsequent 
machine created, so setting constraints on the controller is the same as making
global constraints. These can of course be overriden by constraints at the
model, application or machine level as detailed below.

Example:
  
Creating a new AWS controller to use a particular amount of memory:
  
```bash
juju bootstrap aws mycloud --constraints mem=4G
```

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

As with similar commands, you can 'unset' the constraint by setting its value to
null:
  
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

The `juju add-machine` command also accepts the '--constraints' flag, which can
be useful when trying to target a specific machine or type of machine.

For example:

```bash 
juju add-machine --constraints spaces=storage,db
```

Will provision a machine that is connected to both the 'storage' and 'db' 
network spaces. You can subsequently deploy applications to this machine using
the '--to' placement switch - 
[see the documentation on deploying charms](./charms-deploying.html)
