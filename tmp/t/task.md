(task)=
# Task

> See also: {ref}`How to manage action tasks <7933md>`

In Juju, a **task** is the execution of an {ref}`action <action>` (via {ref}``juju run` <7933md>`) or of other arbitrary scripts (via {ref}``juju exec` <7933md>`) on a target {ref}`unit <unit>`. 

Action tasks are run as defined by the charm author (default: sequentially), whereas tasks related to other scripts are run as set by the charm user (default: parallel).

A group of tasks queued by running an action across one or more units forms an {ref}`operation <operation>`.


<!--
Actions are composed of **tasks** and **operations** , where an action defines a named unit of work (e.g., back up the database) that can be executed on selected units, a task is the execution of the action on each target unit, and an operation is the group of tasks queued by running an action across one or more units.
-->