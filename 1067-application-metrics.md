As an operator, you may find yourself wanting to know more about the resources that an application in your model consumes and provides, such as:

-   Storage GiB used
-   Number of user accounts
-   Number of recently active users
-   Active database connections

Juju collects application metrics at a cadence appropriate for taking a model-level assessment of application utilisation and capacity planning.

<h2 id="heading--using-metrics">Using metrics</h2>

View the most recent measurements from workloads that collect them with the `metrics` command. View measurements for at the model level with:

``` text
juju metrics --all
```

Measurements from all metered workloads in the model are displayed:

``` text
UNIT                TIMESTAMP               METRIC      VALUE
webapp/0            2016-09-19T22:17:57Z    requests    11903
webapp/1            2016-09-19T22:17:52Z    requests    13719
ceph-mon/0          2016-09-19T22:15:36Z    gb-usage    5.2711902345
auth-sso/0          2016-09-19T22:14:29Z    users       28
auth-sso/0          2016-09-19T22:14:31Z    tokens      6
```

View measurements at the unit level:

``` text
juju metrics webapp/0
```

Only `webapp/0` measurements are shown:

``` text
UNIT                TIMESTAMP               METRIC      VALUE
webapp/0            2016-09-19T22:17:57Z    requests    13719
```

View measurements at the application level:

``` text
juju metrics sso-auth
```

Measurements from all matching units are shown:

``` text
auth-sso/0          2016-09-19T22:14:29Z    users       28
auth-sso/0          2016-09-19T22:14:31Z    tokens      6
```

Machine readable formats are also supported:

``` text
juju metrics auth-sso --format yaml
```

Producing output ideal for integrating with data analysis and automation systems:

``` yaml
- unit: auth-sso/0
  timestamp: 2016-09-29T21:55:54.182Z
  metric: users
  value: "30"
- unit: auth-sso/0
  timestamp: 2016-09-29T21:55:53.319Z
  metric: tokens
  value: "7"
```

<h2 id="heading--what-does-a-charm-measure">What does a charm measure?</h2>

The measurements collected by a charm are declared in its `metrics.yaml`. For example:

``` yaml
metrics:
  users:
    type: gauge
    description: Number of users
  tokens:
    type: gauge
    description: Number of active tokens
```

For a more detailed explanation of `metrics.yaml`, refer to the [Metric types](/t/metric-collecting-charms/1125#heading--metric-types) section in the developer documentation.

<h2 id="heading--what-else-are-metrics-used-for">What else are metrics used for?</h2>

Measurements collected by Juju are also sent to Canonical, where they are aggregated across all deployments of the charm for analytics. This information may be used to improve Juju, and may be shared with the charm developer to better support and improve the charm. Canonical respects the privacy of its users and will not disclose the specific usage of individual users without prior consent. You may opt-out of anonymous analytics at any time by setting the model configuration parameter `transmit-vendor-metrics=false`.

<!-- LINKS -->
