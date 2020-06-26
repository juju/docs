## Background and Motivation

Applications may have endpoints bound to specific [network spaces](/t/network-spaces/1157) such that communication about and across those endpoints take place on the specified network segments.

This is done at deploy time with the `--bind` argument to `juju deploy`. Once application is deployed, this binding has traditionally been fixed. The `juju bind` command allows you to change an application's endpoint bindings. 

## Limitations

Endpoints may only be moved from one space to another if the machines the units of the application are on have access to those spaces.

Juju will not mutate the machine definitions in any way to enable this.

It might be that the operator is looking to move an endpoint from one space to another, or to set a new endpoint to a specific space and the `bind` command allows these changes to take place. 

## Example usage

This example makes use of the [`cs:~juju-qa/space-defender`](https://jaas.ai/u/juju-qa/space-defender/bionic/1) and [`cs:~juju-qa/space-invader`](https://jaas.ai/u/juju-qa/space-invader/bionic/1) charms. These are used to test functionality, but don't implement any functionality for end users.

### Assumptions

A controller within a MAAS cloud has been created with the `juju bootstrap` command. The underlying cloud needs to have multiple spaces.

### Setting up the environment

Experimenting with `juju bind` requires setting up a model with machines that have multiple spaces. 

#### Create  the model

```plain
juju add-model bind-test
```
#### Add a machine with two NICs

This command only succeeds when 

```plain
juju add-machine --constraints spaces=default,space-alt2
```
Juju will report that the machine has been created:

```plain
created machine 0
```

This report does not actually imply that a machine is available that satisfies the `spaces` constraint that you've specified. To do that, use the `juju machines` command (or, alternatively, `juju status`).

```plain
juju machines
```

If you see a message like the following, you will need to re-configure your MAAS cloud:

```plain
Machine  State  DNS  Inst id  Series  AZ  Message
0        down        pending  bionic      cannot match subnets to zones: space "space-alt2" not found
```


#### Deploy charms

Deploy `~juju-qa/space-defender` to containers:

```plain
juju deploy  cs:~juju-qa/bionic/space-defender-0 \
    --to lxd:0 \
    --bind "default defend-b=space-alt2"
```
```plain
juju deploy  cs:~juju-qa/bionic/space-invader-1 \
    --to lxd:0 \
    --bind "invade-a=default invade-b=space-alt2"
```

####  Monitor progress

In new terminals, it's possible to track what the state of the database is by using th `juju debug-log` command:

```plain
juju debug-log --include space-defender --level INFO
```

```plain
juju debug-log --include space-invader --level INFO
```

### Add relations

Move back to the first terminal and elate the charms:

```plain
juju relate space-defender:defend-a space-invader:invade-a
```
```plain
juju relate space-defender:defend-b space-invader:invade-b
```

You will notice that the "relation-changed" events in the logs. Data passed via the relation will appear in the console windows. In all examples, you should notice the *space-defender* application receive a "config-changed" hook while, the *space-invader* application receiving a "relation-changed" hook for "invade-a".

#### Re-bind an endpoint

[note type=caution]
This must be run *before* the machine for space-defender (`0/lxd/0`) boots up.
[/note]

To update an endpoint default binding for a deployed application, provide it as an argument: 

```plain
juju bind space-defender defend-a=space-alt2
```
Produces the output:
```plain
ERROR merging application bindings: changing default space to "default" is not feasible: one or more deployed machines lack an address in this space
```

#### Re-bind with `--force`

The `juju bind` command will check to make sure that addresses are configured within the space. If you wish to proceed even when this check fails, add the `--force` option. 

```plain
juju bind space-defender defend-a=space-alt2 --force
```

Produces:

```plain
Updating endpoint "defend-a" from "default" to "space-alt2"
Leaving endpoint in "space-alt2": defend-b
```

#### Juju bind default behaviour

Running `juju bind` without arguments describes the current endpoint bindings:

```
$ juju bind space-defender
Leaving endpoints in "space-alt2": defend-a, defend-b
```
#### Using Juju bind to change default space for an application

```plain
$ juju bind space-defender defend-a=default
Updating endpoint "defend-a" from "space-alt2" to "default"
Updating endpoint "defend-b" from "space-alt2" to "default"
```

```plain
$ juju bind space-defender space-alt2
Updating endpoint "defend-a" from "default" to "space-alt2"
Updating endpoint "defend-b" from "default" to "space-alt2"

```
