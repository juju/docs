Title: Juju Metrics

# Why does Juju collect metrics?

Knowing an application's configuration isn’t enough to effectively operate and
manage it. Consider that a well-designed application will have as few
configurable parameters as possible. As an operator, you may find yourself
wanting to know more about the resources that an application in your model
consumes and provides -- resources such as:

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

# Using metrics

View the most recent measurements from workloads that collect them with the
`juju metrics` command.

View measurements for an entire model with:

```bash
juju metrics --all
```

Measurements from all metered workloads in the model are displayed:

```bash
UNIT				TIMESTAMP				METRIC		VALUE
webapp/0			2016-09-19T22:17:57Z	requests	11903
webapp/1			2016-09-19T22:17:52Z	requests	13719
ceph-mon/0			2016-09-19T22:15:36Z	gb-usage	5.2711902345
auth-sso/0			2016-09-19T22:14:29Z	users		28
auth-sso/0			2016-09-19T22:14:31Z	tokens		6
```

View measurements for specific units:

```bash
juju metrics webapp/0
```

Only `webapp/0` measurements are shown:

```bash
UNIT				TIMESTAMP				METRIC		VALUE
webapp/0			2016-09-19T22:17:57Z	requests	13719
```

View measurements for applications as well:

```bash
juju metrics sso-auth
```

Measurements from all matching units are shown:

```bash
auth-sso/0			2016-09-19T22:14:29Z	users		28
auth-sso/0			2016-09-19T22:14:31Z	tokens		6
```

Machine readable formats are also supported:

```bash
juju metrics auth-sso --format yaml
```

Producing output ideal for integrating with data analysis and automation systems:

```yaml
- unit: auth-sso/0
  timestamp: 2016-09-29T21:55:54.182Z
  metric: users
  value: "30"
- unit: auth-sso/0
  timestamp: 2016-09-29T21:55:53.319Z
  metric: tokens
  value: "7"
```

# What does a charm measure?

The measurements collected by a charm are declared in its `metrics.yaml`. For
example:

```yaml
metrics:
  users:
    type: gauge
    description: Number of users
  tokens:
    type: gauge
    description: Number of active tokens
```

For a more detailed explanation of `metrics.yaml`, refer to the
[Metric types](./developer-metrics.html#metric-types) section in the developer
documentation.

# What else are metrics used for?

Measurements collected by Juju are also sent to Canonical, where they are
aggregated across all deployments of the charm for analytics.

This information may be used to improve Juju, and may be shared with the charm
developer to better support and improve the charm.

Canonical respects the privacy of its users and will not disclose the specific
usage of individual users without prior consent.

You may opt-out of anonymous analytics at any time by setting the model
configuration parameter `transmit-vendor-metrics=false`.
