(commands-available-on-a-juju-machine)=
# Commands available on a Juju machine

Commands available on a machine provisioned by Juju:

    juju-dumplogs
    juju-introspect
    juju-run

<!--TODO document each. -->

<!--Also juju-updateseries, but we want to get rid of this one.-->

The `juju-introspect` command accepts a wide range of options. Since it can be tedious to type them up, you can use instead the following aliases:

<!--THESE ARE THE AGENT INTROSPECTION DOCS. ONCE WE HAVE A REFERENCE DOC FOR JUJU-INTROSPECT, LINK TO IT FROM EACH OF THESE DOCS.-->

* juju_cpu_profile
* [juju_engine_report](https://juju.is/docs/dev/agent-introspection-juju-engine-report)
* [juju_goroutines](https://juju.is/docs/dev/agent-introspection-juju-goroutines)
* [juju_heap_profile](https://juju.is/docs/dev/agent-introspection-juju-heap-profile)
* [juju_machine_lock](https://juju.is/docs/dev/agent-introspection-juju-machine-lock) (since 2.3.9, 2.4.2)
* [juju_metrics](https://juju.is/docs/dev/agent-introspection-juju-metrics)
* juju_pubsub_report (since 2.3)
* juju_presence_report (since 2.4)
* [juju_start_unit](https://juju.is/docs/dev/agent-introspection-juju-start-unit) (since 2.9)
* juju_statepool_report
* juju_statetracker_report
* [juju_stop_unit](https://juju.is/docs/dev/agent-introspection-juju-stop-unit) (since 2.9)
* [juju_unit_status](https://juju.is/docs/dev/agent-introspection-juju-unit-status) (since 2.9)