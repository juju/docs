Sometimes software doesn't do what you'd expect. Each of the agents that Juju runs has an internal worker for responding to introspection requests.

As the agents start up, a goroutine is started to listen on an abstract domain socket. The listener talks HTTP, and has a number of registered endpoints. The initial work was to expose the internal golang runtime debugging endpoints for getting access to the running goroutines, CPU profiles, and memory heap profiles. This was then extended to add additional endpoints for much more Juju specific information.

The Juju machine agent writes out a file to `/etc/profile.d/juju-introspection.sh` that defines a number of functions to easily get information out of the agent. These function names changed in Juju 2.3.9 and 2.4.2 to use underscores instead of dashes.

* [juju_goroutines](https://discourse.jujucharms.com/t/agent-introspection-juju-goroutines/118)
* juju_cpu_profile
* juju_heap_profile
* [juju_engine_report](https://discourse.jujucharms.com/t/agent-introspection-juju-engine-report/146)
* juju_metrics
* juju_statepool_report
* juju_statetracker_report
* juju_pubsub_report (since 2.3)
* juju_presence_report (since 2.4)
* [juju_machine_lock](https://discourse.jujucharms.com/t/agent-introspection-juju-machine-lock/116) (since 2.3.9, 2.4.2)
