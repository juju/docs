(agent-introspection)=
# Agent introspection

Sometimes software doesn't do what you'd expect. Each of the {ref}`agents <117md>` that Juju runs has an internal worker for responding to introspection requests.

As the agents start up, a goroutine is started to listen on an abstract domain socket. The listener talks HTTP, and has a number of registered endpoints. The initial work was to expose the internal golang runtime debugging endpoints for getting access to the running goroutines, CPU profiles, and memory heap profiles. This was then extended to add additional endpoints for much more Juju specific information.

The Juju machine agent writes out a file to `/etc/profile.d/juju-introspection.sh` that defines a number of functions to easily get information out of the agent. These function names changed in Juju 2.3.9 and 2.4.2 to use underscores instead of dashes.

- `juju_agent`
- `juju_agent_call`
- `juju_application_agent_name`
- `juju_controller_agent_name`
- `juju_cpu_profile`
- {ref}``juju_engine_report` <agent-introspection-juju_engine_report>`
- {ref}``juju_goroutines` <agent-introspection-juju_goroutines>`
- {ref}``juju_heap_profile` <agent-introspection-juju_heap_profile>`
- `juju_machine_agent_name`
- {ref}``juju_machine_lock` <agent-introspection-juju_machine_lock>` (since 2.3.9, 2.4.2)
- {ref}``juju_metrics` <agent-introspection-juju_metrics>`
- `juju_pubsub_report` (since 2.3)
- `juju_presence_report` (since 2.4)
- {ref}``juju_start_unit` <agent-introspection-juju_start_unit>` (since 2.9)
- `juju_statepool_report`
- `juju_statetracker_report`
- {ref}``juju_stop_unit` <agent-introspection-juju_stop_unit>` (since 2.9)
- {ref}``juju_unit_status` <agent-introspection-juju_unit_status>` (since 2.9)