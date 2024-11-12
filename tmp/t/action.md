(action)=
# Action

<!--
- Might have to add this to the Nav of OLM also:
{ref}``actions.yaml` <file-actionsyaml>`
- Clarify what 'an administrator' means. Link to the User  access levels doc.
- Define action ID, action ID prefix.
- Can we make the connection to units by rephrasing: "to allow an administrator to interact with an application *unit*?
-->

> See also: {ref}`How to manage actions <how-to-manage-actions>`

In Juju, an **action** is a script that is triggered via {ref}`the `juju` CLI client <juju-juju-client>` and applied to a {ref}`unit <unit>`. It contains a list of commands defined by a  {ref}`charm <charm>` to allow a {ref}`user <user>` with the right {ref}`access level <user-access-levels>` to interact with an {ref}`application <application>` in ways specific to the application. This may include anything from creating a snapshot of a database, adding a user to a system, dumping debug information, etc. 

> See examples: [Charmhub | `kafka` > Actions](https://charmhub.io/kafka/actions), [Charmhub | `prometheus-k8s` > Actions](https://charmhub.io/prometheus-k8s/actions), etc.

<!--UPDATES IN JUJU V.3.0:
https://discourse.charmhub.io/t/new-feature-in-juju-2-8-improved-actions-experience/3182
-->

(Starting with `juju v.3.0`: )
 Actions are identified by integers (instead of [UUIDs](https://en.wikipedia.org/wiki/Universally_unique_identifier)). 

(Starting with `juju v.3.0`: ) Running an action defaults to waiting for the output before returning. This synchronous behaviour allows actions to be easily included in command-line pipelines. 

(Starting with `juju v.3.0`: ) The execution of an action is organised into {ref}`tasks <task>` and {ref}`operations <operation>`. (If an action defines a named unit of work -- e.g., back up the database -- that can be executed on selected units, a task is the execution of the action on each target unit, and an operation is the group of tasks queued by running an action across one or more units.)


<!--
Actions are composed of **tasks** and **operations**. More specifically, an action defines a named unit of work (e.g., back up the database) that can be executed on selected units. When you run an action on a specified unit, the execution of the action on each target unit is called a **task**, and the group of tasks queued via a `juju run ... <action>` command -- an **operation**.
-->


<!--
an action is the definition of a {ref}`task <6208md>`. At the top level it can be invoked via an {ref}`operation <6208md>`.

Actions spawn an operation per application, and operations spawn a task per unit.

In Juju, a **task** is the execution of an [action](https://discourse.charmhub.io/t/6208) on a single unit.

In Juju, an **operation** represents a top level invocation of an [action](https://discourse.charmhub.io/t/6208) targeted to one or more units.

an action defines a named unit of work (eg backup the database) that can be executed on selected units. when "juju run" is used to run an action, target units are specified; the execution of the action on each target unit is a task. the group of tasks is an opertion.

listing operation shows the status of each "juju run" invocation that has been done. show operation is used to see the status of the individual tasks beloning to that operation. and show task is used to drill down to the result of running an action on a specific unit; the stdout, stderror, log messages etc

-->

<!--
> See also: 
> - {ref}``actions` <6208md>`, {ref}``cancel-action` <6208md>`, {ref}``run-action` <6208md>`, {ref}``show-action-output` <6208md>`, {ref}``show-action-status` <6208md>`, {ref}``hook-tool` <6208md>`
> - {ref}`Application <application>`, {ref}`Charmed operator ('charm') <charm>`, {ref}`User <user>`
-->

<!--
> See also:
> - {ref}``juju actions` <6208md>`
> - {ref}``juju cancel-action` <6208md>`
> - {ref}``juju run-action` <6208md>`
> - {ref}``juju show-action-output` <6208md>`
> - {ref}``juju show-action-status` <6208md>`
> - {ref}``juju hook-tool` <6208md>`
> - {ref}`Charmed operator ('charm') <charm>`
-->

<!--
In Juju, an **action** is a list of commands defined by a charm to allow an administrator to interact with the application. 
-->

<!--TODO relevance to Juju OLM user -->

<!--TODO add examples of actions -->

<!--
An **action** is functionality defined by a charmed operator for its applications. Administrators can run actions via the client.

An action is used to define operations for a charm.

backup, restore, get status >> this is not managing, just getting info 

`juju run-action 

 -->

<!--
*Actions* are scripts that are triggered via the client, and applied to a unit. They are described within individual charms. An action's parameters are defined as a map in a YAML file, and are validated against the schema defined in `actions.yaml`. See {ref}`Actions for the charmed operator author <6208md>` for detailed information.
-->