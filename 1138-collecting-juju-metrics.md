While it is possible to write charms that collect metrics about charms (see [Metric collecting charms](/t/metric-collecting-charms/1125)), it is also possible to collect metrics about Juju itself. Each controller provides an HTTPS endpoint to expose [Prometheus](https://prometheus.io) metrics. To feed these metrics into Prometheus, you must add a new *scrape target* to your already installed and running Prometheus instance. For this use case, the only constraint on where Prometheus is running is that the server must be able to contact the controller's API address/port.

The Juju controller's metrics endpoint requires authorisation, so create a user and password for Prometheus to use:

    juju add-user prometheus
    juju change-user-password prometheus

When prompted, enter the password twice:

    new password: <password>
    type new password again: <password>

For the `prometheus` user to be able to access the metrics endpoint, grant the user read access to the controller model:

    juju grant prometheus read controller

Juju serves the metrics over HTTPS, with no option of degrading to HTTP. You can configure your Prometheus instance to skip validation, or enter this to store the controller’s CA certificate in a file for Prometheus to verify the server’s certificate against:

``` text
juju controller-config ca-cert > /path/to/juju-ca.crt
```

To add a scrape target to Prometheus, add the following to `prometheus.yaml`:

``` yaml
scrape_configs:
  job_name: juju
    metrics_path: /introspection/metrics
    scheme: https
    static_configs:
      targets: ['<controller-address>:17070']
    basic_auth:
      username: user-prometheus
      password: <password>
    tls_config:
      ca_file: /path/to/juju-ca.crt
```

<!-- LINKS -->
