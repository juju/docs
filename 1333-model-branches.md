Normally, when changes are made to an application, the changes are applied immediately to all its units. Examples of such changes include:

- upgrading a charm
- attaching a resource to an application
- setting configuration options for an application

Model "branches" enable application changes to be applied on a per-unit basis. Differences between units of the main branch and unaffected units is intended as transitional. The transition allows for you to inspect and validate the progress of upgrades as the upgrade is rolled out. The procedure is completed by having the changes applied to all application units. This operational mode is known as *model generations*.

The primary use case of model generations is to support blue-green deployments. Rather than upgrading every unit at the same time, units are upgraded in small batches. , are m for a large infrastructure that consists of a great number of application units. It is an optional conservative approach for managing infrastructure changes.

[note type="important" status="In-progress feature"]
To use model branches, you need to enable the feature flag: `branches`, e.g.:

```
export JUJU_DEV_FEATURE_FLAGS=branches
```

Development of model branches is not complete.
[/note]

## Terminology

*branch*
*track*
*commit*
*generations*

## Overview

1. [Adding a branch to the model](#adding-a-branch)
1. [Setting units to track a branch](#setting-units-to-track-a-branch)
1. [Changing application configuration for a branch](#changing-config)
1. [Validating that units are tracked](#validating)
1. [Committing a branch](#committing-a-branch)
1. [Aborting a branch](#aborting-a-branch)


<div id="adding-a-branch"></div>

## Adding a branch to the model

```text
juju add-branch <name-of-branch>
```

```plain
$ juju add-branch test   
Created branch "test" and set active
```
This leads to creating a new branch "test", which units can track. 
Charm configuration applied to that branch can be applied to the units following it.

<div id=setting-units-to-track-a-branch></div>

## Setting Units to track a branch

First of all, we need to have an application and some units as a setup. 

In this example we are using `mediawiki`.

```plain
$ juju deploy mediawiki           
Located charm "cs:mediawiki-19".
Deploying charm "cs:mediawiki-19".

$ juju add-unit mediawiki

$ juju add-unit mediawiki
```
With the application and its units set up, we can ask the units to track a specific branch.

```
juju track [options] <branch name> <entities>

Examples:
    juju track test mediawiki/0
    juju track test mediawiki
```
Specific units can be set to track a branch by supplying multiple unit IDs.
All units of an application can be set to track a branch by passing an
application name. Units can only track one branch at a time.

Tracking the specific /0 unit:

```plain
$ juju track test mediawiki/0
```

`juju status` can be used to verify which unit is tracking which branch. 
The `#<number>` under **Unit** inidicates the branch a Unit is following.

The `*` indicates under **Branch** the current active branch.

Following above leads to below example which shows the following information:

- The current active branch is: `test` and has a `reference` called `#1`.
- `mediawiki/0` follows `test` because it has a ref to `#1`.
- `mediawiki/1` does not follow `test`.

```plain
$ juju status                     
Model    Controller  Cloud/Region      Version      SLA          Timestamp
default  awsspace2   aws/eu-central-1  2.8-beta1.1  unsupported  10:26:11+01:00

Branch  Ref  Created        Created By
test*   #1   9 minutes ago  admin

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  blocked      2  mediawiki  jujucharms   19  ubuntu  

Unit             Workload  Agent  Machine  Public address  Ports  Message
mediawiki/0* #1  blocked   idle   1        18.196.255.248         Database required
mediawiki/1      blocked   idle   3        3.122.95.32            Database required

Machine  State    DNS             Inst id              Series  AZ             Message
0        started  172.31.3.4      i-0e34b325342fd34a6  bionic  eu-central-1a  running
1        started  18.196.255.248  i-0afa54d075bd82ac8  trusty  eu-central-1a  running
```


## Changing application config on a branch

Only one branch can be active at a time to apply changes.

The `juju branch` command displays the current active branch:

```plain
$ juju branch       
Active branch is "test"
```

To make a change under the branch `test`, use `juju config`. This change will change the `use_suffix` parameter to `true` from `true`.

```
$ juju config mediawiki use_suffix=false
```

## Validating that units are tracked

Verify that the change is set to false
```plain
$ juju config mediawiki use_suffix
false
```
   
switch to branch `master`, the default branch, again:
```
$ juju branch master                    
Active branch set to "master"
```

verify that the change has not been applied yet
```
$ juju config mediawiki use_suffix
true
```

## Committing the branch

Now we can test the changes on unit `/0` and realized the changes are working as expected.
With this, we can apply the branch `test` to `master`.

```plain
$ juju commit test       
Branch "test" committed; model is now at generation 1
Active branch set to "master"
```

To have a changelog and verify what changes we did we have the following commands:
`juju commits` and `juju show-commit`

`juju commits`
shows the timeline of changes to the model that occurred through branching.
information consists of:
- the commit number 
- user who committed the branch 
- when the branch was committed 
- the branch name

```
$ juju commits       
Commit	Committed at  	Committed by	Branch name
1     	26 seconds ago	admin       	test       
```



`juju show-commit`
Show-commit shows the committed branches to the model.
Details displayed include:
- user who committed the branch 
- when the branch was committed 
- user who created the branch 
- when the branch was created 
- configuration  made under the branch for each application
- a summary of how many units are tracking the branch
```
❯ juju show-commit 1     
branch:
  test:
    applications:
    - application: mediawiki
      units:
        tracking:
        - mediawiki/0
        - mediawiki/1
      config:
        use_suffix: false
committed-at: 18 Feb 2020 11:14:13+01:00
committed-by: admin
created: 18 Feb 2020 10:16:41+01:00
created-by: admin
```

## 6. Aborting a branch
The advantage of using branches is that one can test the changes and either `commit` or `abort` them.
The above example under **5.** committed the branch.

But let's assume that the change we added is not working as expected.
With this, we can instead to commit, abort the branch.
Note that we can only abort branches when no units are tracking it.

Following the above example, we need to remove the tracking unit:
Branch `bla` is already in use and a unit is tracking it.
```
❯ juju abort test               
ERROR branch is in progress. Either reset values on tracking units or remove them to abort.
```
Therefore the current way to remove it is to do either one of the following:
- EITHER: reset the changes to the application and commit the branch:
```
juju config mediawiki --reset use_suffix
juju commit test
```
- OR: remove the unit tracking the branch 
```
~
❯ juju remove-unit mediawiki/0
removing unit mediawiki/0

~
❯ juju abort bla              
Aborting all changes in "bla" and closing branch.
Active branch set to "master"

```
