# Juju Actions (DRAFT)

Juju charms can describe actions that users can take on deployed services. 
Actions are parametrized events that can be addressed and delivered to a 
service or unit. Parameters for an action take the form of a YAML document,
limited to things we can validate with JSON Schemas.

The following juju commands are specified:

    actions
    do
    wait
    queue
    kill

In addition, the `status` command grows the ability to show status for 
an action.




## User experience

A user can list the actions that a service or unit exports, as well as 
the actions associated with interfaces to a service:

    $ juju actions mysql
    backup         benchmark      dump           ps             restart        
    restore        start          stop           test
    $ juju actions mysql/2
    pause          resume         sync

A user can take an action from the command-line passing an optional YAML
file as parameters.

    $ juju do mysql backup
    action: UUID
    result: <text display of yaml result>
    $

    $ juju do mysql tpcc
    mysql has no 'tpcc' action
    $

    $ juju do mysql benchmark
    action: UUID
    result: <text display of yaml result>
    $

    $ juju do mysql benchmark --parameters bm.yaml
    action: UUID
    result: <text display of yaml result>
    $

    $ juju do mysql restart
    action: UUID
    result: <text display of yaml result>
    $

You can direct an action to a specific unit:

    $ juju do mysql/2 restart 
    action: UUID
    result: <text display of yaml result>
    $

In the simple case, Juju will let you specify action parameters directly
on the command-line, providing the config needed:

    $ juju do mysql benchmark bench="foo"
    action: UUID
    result: <text display of yaml result>
    $

If your configuration is more complex than a single record of property / values,
then you'd need to create your action configuration as YAML and pass it to the action:

    $ juju do mysql benchmark --config=bench.yaml
    action: UUID
    result: <text display of yaml result>
    $

When actions are directed at the service or a relation rather than the unit,
they are delivered to the unit which Juju has designated the leader for the
service. 

That leader may in turn invoke activity in its peers via peer relations.
If a leader has not yet been elected, Juju may need to select a good leader.


Juju `do` blocks until a result is available, unless `--async` is passed on the
command line in which case the action token (UUID) is returned.

    $ juju do --async mysql benchmark bench="foo"
    action: UUID
    $ juju do --async mysql/2 pause
    action: UUID
    $


If you cancel an action while you are waiting, you will see the UUID.

    $ juju do mysql dump
    action: UUID
    ^C
    action:UUID continues, use juju kill to stop it.
    $

You can use the action UUID to retrieve the result of the action, using juju `wait`.

    $ juju wait action:UUID   # time passes slowly...
    status: running
    action: benchmark
    invoked: 13:45:21 21 Jan 2015 UTC1
    result:
    tpcc: 2342.34
    terasort: 4323525.23
    $ juju wait action:BAD-UUID
    Action has expired from history or never occurred.

And you can terminate an action with juju `kill`:

    $ juju kill action:UUID
    action: benchmark
    status: killed
    invoked: 13:45:21 21 Jan 2015 UTC
    killed:  13:48:53 21 Jan 2015 UTC
    result:
    tpcc: 2342.34
    terasort: killed

Juju status can also give the current status of an action, without blocking.

    $ juju status action:UUID
    action: UUID
    status: running
    invoked: TIME
    $ juju status action:UUID
    action: UUID
    status: failure
    failure: <message>

## Queued actions

Actions are serialized for the service; at any given time, only one action
is running for the service. Actions directed at individual units or relations
are queued in this same service-level serialization. You can see the queue of
actions with the new `queue` command, which also shows events and `run` commands:

    $ juju queue
    running action UUID mysql backup
    running action UUID wordpress update-content
    running run    UUID haproxy "ls -lR /var/cache/proxy"
    pending set    UUID mysql config-changed
    pending action UUID mysql vacuum-all
    pending action UUID mysql analyze-queries
    pending action UUID wordpress update-themes

The status of each of these entries is one of running or pending.

## The actions log

You can see a log of past actions with the new `log` command.

    $ juju log
    action UUID success mysql/2 pause
    action UUID success wordpress update-content
    action UUID failure haproxy flush-caches
    action UUID killed  mysql backup
    $ 

Each action is recorded as success, failure, crashed, or cancelled.  The 
result is available with "juju status action:UUID". A `crashed` status 
means the hook failed to complete properly, not that the action was unable
to be completed.

You can limit the queue listing to a service, or unit:

    $ juju queue
    action UUID running mysql backup
    ...
    $ juju queue mysql
    action UUID running mysql backup
    action UUID pending mysql vacuum-all
    ...
    $ juju queue mysql/2
    action UUID running mysql/2 pause
    ...


## Action output

There are two forms of action output:

Action Status takes the form of YAML which will be included in the `juju status`
for the action. It is also dependent on the hook exit code (a non-zero code 
implies the action crashed).

Action Output takes the form of a set of files which are available on demand from
the Juju state servers. These include stdout and stderr, and any number of other
smaller files that the action would like to share, subject to prudential limits 
on file size.

When an action completes, you can see the status of the action with Juju status:

    $ juju status action:UUID
    action: foo
    result: success
    invoked:  TIME
    started:  TIME
    finished: TIME
    files:
        - stderr
        - stdout
        - backup.pdf
    status:
        YAML

The status is YAML, and it includes some common elements, such as the action
name, the result (crashed, success, failure, killed) and the time invoked,
started and finished.

If the action sent anything to stdout or stderr, these are available 

    juju fetch @UUID backup.pdf
    juju fetch @UUID stdout
    juju fetch @UUID stderr

## Hook interaction

The hooks that handle the action will produce a result that can be retrieved
by whoever triggered the action.

A hook script should exit with status zero, meaning the action took place
correctly, even if the script was not able to achieve the desired result.
A non-zero exit code implies the hook crashed in an unmanaged fashion.

The script can make use of the new tool, action-set, to report an action
failure, to report fields that will be part of the response document, or
to create a file that can be retrieved later. For example:

    action-set backup.size=10.1GB backup.path=/var/backup
    action-set backup.time=$(date)

Setting result fields in the same line or in multiple lines produces the
same result. The fields are all aggregated and dispatched as a consolidated
result once the script returns, successfully or not.

The dotted notation allows setting nested fields. Alternatively, that same
result might be provided to juju-action as a single YAML document:

    cat <<END | action-set -
    backup:
        size: 10.1GB
        path: /var/backup
        time: $(date)
    END

    juju fetch @UUID backup.pdf
    juju fetch @UUID stdout
    juju fetch @UUID stderr

Besides providing results data about the action, the juju-report tool also
allows retrieving the parameters that the client provided to the action.
The syntax is similar to the one used for setting fields, including the
dotted notation:

    S3_BUCKET=$(action-get target.s3-bucket)

Executing juju-action without any arguments returns all the provided parameters
at once as a YAML document:

    action-get | process-yaml

To report that the action has failed, the --failed parameter should be used 
with a parameter that conveys the reason for the failure:

    action-get --failed "Could not allocate space to complete the action."

The client receives a result corresponding to the hook interaction:

    $ juju do mysql backup target.s3-bucket=$S3_BUCKET
    action: UUID
    status: success
    command: backup
    invoked: 13:45:21 21 Jan 2015 UTC
    finished:  13:48:53 21 Jan 2015 UTC
    result:
        backup:
            size: 10.1GB
            path: /var/backup
            time: Tue Mar 11 10:16:46 BRT 2014

On failures, the result content is also provided, in addition to the failure reason:

    $ juju do mysql backup target.s3-bucket=$S3_BUCKET
    action: UUID
    status: failure
    failure: Could not allocate space to complete the action.
    command: backup
    invoked: 13:45:21 21 Jan 2015 UTC
    finished:  13:48:53 21 Jan 2015 UTC
    result:
        backup:
            size: 10.1GB
            path: /var/backup
            time: Tue Mar 11 10:16:46 BRT 2014


## Declarations

Charms declare actions with a language that describes both required and 
optional parameters. Juju will reject actions that fail to meet the declared
requirements or which step outside the optionally allowed parameters.

Use the syntax from Juju Schemas for action parameters.

