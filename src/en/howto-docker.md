# Orchestrating Docker Containers

There has been interest in the Juju community on how to integrate Juju with
[Docker](http://docker.io). Ben Saller has been working on experimental
orchestration of Docker containers with Juju:

[https://github.com/bcsaller/juju-docker](https://github.com/bcsaller/juju-docker)

This shows orchestrating RethinkDB using Juju. It's very basic and really just
shows how you'd restart the container on `config-change` and on relation
change. This allows passing new env/cli options to the container so it can
participate in its deployment.

The group of related rethinkdb containers talking together front-ended by an
haproxy.  Someone with a better understanding of rethinkdb could easily take
this further.

## RethinkDB running from Docker

This is currently at the proof of concept level and should not be considered
anything other than a demonstration.

This shows how to restart a docker container on its hook invocations with new
cli/env settings.

This version is somewhat improved in terms of robustness beyond the initial
release.

### Testing

The following should result in a deployment with the Juju GUI and haproxy.
Going to the exposed haproxy port will get you the admin interface to
rethinkdb.

#### Deploy 

    juju bootstrap juju deploy --repository . local:trusty/rethinkdb-docker rdb
juju expose rdb sleep 60 echo juju debug-hooks rdb/0 juju add-unit rdb

#### Deploy the Juju GUI

    juju deploy cs:precise/juju-gui juju expose juju-gui

#### Relate HAProxy and RethinkDB

    juju deploy cs:precise/haproxy juju add-relation haproxy rdb juju expose
haproxy
