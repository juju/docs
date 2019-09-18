The engine report is a window into the internals of the agent. This is primarily useful to developers to help debug problems that may be occurring in deployed systems.

In order to manage complexity in the juju agents, there are *workers* that have very distinct and limited purpose. Workers can have dependencies on other workers. The [dependency engine](https://godoc.org/gopkg.in/juju/worker.v1/dependency) is the entity that runs the workers and deals with those dependencies. The `juju_engine_report` is the current view into the dependency engine running the agent's workers.

```text
manifolds:
  agent:
    inputs: []
    report:
      agent: machine-0
      model-uuid: 1b13f1f5-c0cf-47c5-86ae-55c393e19405
    resource-log: []
    start-count: 1
    started: 2018-08-09 22:01:39
    state: started
  api-address-updater:
    inputs:
    - agent
    - api-caller
    - migration-fortress
    - migration-inactive-flag
    report:
      servers:
      - - 10.173.141.131:17070
        - 127.0.0.1:17070
        - '[::1]:17070'
    resource-log:
    - name: migration-inactive-flag
      type: '*engine.Flag'
    - name: migration-fortress
      type: '*fortress.Guest'
    - name: agent
      type: '*agent.Agent'
    - name: api-caller
      type: '*base.APICaller'
    start-count: 1
    started: 2018-08-09 22:01:41
    state: started
  api-caller:
    inputs:
    - agent
    - api-config-watcher
    resource-log:
    - name: agent
      type: '*agent.Agent'
    start-count: 1
    started: 2018-08-09 22:01:40
    state: started
# and many more
```
