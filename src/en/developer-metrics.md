Title: Juju Metrics

# Writing charms that collect metrics

Knowing an application's configuration isn’t enough to effectively operate and
manage it. Consider that a well-designed application will have as few
configurable parameters as possible. Operators will want to know more about the
resources that your charm consumes and provides in their models -- resources
such as:

- Storage GiB used
- Number of user accounts
- Number of recently active users
- Active database connections

Juju Metrics complete the operational picture with application observability;
by modeling, sampling and collecting measurements of resources such as these.
Juju collects application metrics at a cadence appropriate for taking a
model-level assessment of application utilization and capacity planning.

There are many instrumentation and time-series data collection solutions
supporting devops. Juju’s metrics complement these fine-grained, lower-level
data sources with a model-level overview -- a starting point for deeper
analysis.

# Collecting metrics

Adding metrics to a charm is simple and straightforward with the reactive
framework.

## Add layer:metrics

Add `layer:metrics` to the charm’s `layer.yaml`. This layer provides the
[`collect-metrics`](./reference-charm-hooks.html#collect-metrics) hook, and allows metric collection to be defined completely by
`metrics.yaml`.

## Add metrics.yaml

Declare the metrics to be collected in your charm's `metrics.yaml`. Example:

```yaml
metrics:
  users:
    type: gauge
    description: Number of users
  tokens:
    type: gauge
    description: Number of active tokens
```

### Metric types
In Juju 2.0, only `type: gauge` fully supports operational use-cases. Other
types are experimental in this release.

#### `type: gauge`
Gauge metrics are a snapshot value reading at a point in time, as a positive decimal number.

#### `type: absolute`
Absolute metrics track the quantity since the last measurement, as a positive
decimal number. Future releases of Juju will track the cumulative aggregate of
absolutes, providing a more useful indicator to operators.

#### Built-in metric `juju-units`
There is also a built-in metric, which has no type or description, named
`juju-units`. When declared, this metric sends a "1" for each unit.

## Metric commands

When charming with `layer:metrics`, add a `command:` attribute to each metric
in `metrics.yaml`, containing a command line that measures the value when
executed. `layer:metrics` will then execute this command in the
`collect-metrics` hook for you automatically. Continuing with the example above:

```yaml
metrics:
  users:
    type: gauge
    description: Number of users
    command: scripts/count_users.py
  tokens:
    type: gauge
    description: Number of active tokens
    command: scripts/count_tokens.py
```

Commands can use any script or executable in your charm or installed elsewhere
on the workload. The current working directory for this command will be the
charm directory (`charmhelpers.core.hookenv.charm_dir`). The command must write
only the metric value to standard output, and terminate with exit code 0 in
order for the measurement to be to be counted valid.

Continuing with the metrics example above, a charm that relates to a PostgreSQL
database probably stores its "users" and "tokens" in database tables. These can
be counted with a simple SQL query. `scripts/count_users.py` in such a charm
might read as:

```python
#!/usr/bin/env python3

# Python packages will have been installed by the charm.
import configparser
import psycopg2


if __name__ == '__main__':
    # Read the application's configuration file, which will have been written
    # by the charm's relation hooks.
    with open('/opt/sso-auth/config.ini') as f:
        config_str = f.read()
    config = configparser.ConfigParser(strict=False)
    config.read_string(config_str)

    # Build a database connection string from configuration.
    dbname = config['database']['NAME']
    user = config['database']['USER']
    password = config['database']['PASSWD']
    hostport = config['database']['HOST']
    host, port = hostport.split(':')
    conn_str = 'dbname=%s user=%s password=%s host=%s port=%s' % (
        dbname, user, password, host, port)
    conn = psycopg2.connect(conn_str)
    try:
        cur = conn.cursor()
        try:
            # For sake of example, let's say we don't want to include the
            # default admin user account in the count.
            cur.execute("SELECT COUNT(1) FROM users WHERE name != 'admin';")
            row, = cur.fetchone()
            print(row)  # Print the measurement to standard output, for Juju
        finally:
            cur.close()
    finally:
        conn.close()
```

Note that this command will not have access to the normal lifecycle hook
environment. Refer to the
[`collect-metrics`](./reference-charm-hooks.html#collect-metrics) documentation
for more information.
