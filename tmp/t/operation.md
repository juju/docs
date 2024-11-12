(operation)=
# Operation

> See also: {ref}`How to manage action operations <7934md>`

In Juju, an **operation** is the group of {ref}`tasks <task>` queued by running an {ref}`action <action>` or other arbitrary scripts across one or more {ref}`units <unit>`.

<!--
Actions are composed of **tasks** and **operations** , where an action defines a named unit of work (e.g., back up the database) that can be executed on selected units, a *task* is the execution of the action on each target unit, and an *operation* is the group of tasks queued by running an action across one or more units.-->