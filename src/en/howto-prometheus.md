Title: Configure metrics gathering with Prometheus

#  Configure metrics gathering with Prometheus


## Overview

While it is possible to [write charms that collect metrics][developer-metrics], some
will want the power and options available from a full monitoring solution. For
convenience, starting with Juju 2.1 each Juju controller provides an HTTPS
endpoint to expose [Prometheus][prometheus] metrics. To feed these metrics into
Prometheus, you must add a new scrape target to your already installed and
running Prometheus instance. For this use case, the only constraint on where
Prometheus is running is that Prometheus must be able to contact the Juju
controller's API server address/port.


The Juju controller's metrics endpoint requires authorisation, so create a
user and password for Prometheus to use:

```
juju add-user prometheus
juju change-user-password prometheus
```
When prompted, enter the password twice:
```
new password: <password>
type new password again: <password>
```

For the `prometheus` user to be able to access the metrics endpoint, grant the
user read access to the controller model:

```
juju grant prometheus read controller
```

Juju serves the metrics over HTTPS, with no option of degrading to HTTP. You
can configure your Prometheus instance to skip validation, or enter this to
store the controller’s CA certificate in a file for Prometheus to verify the
server’s certificate against:

```
$ juju controller-config ca-cert > /path/to/juju-ca.crt
```

!!! Note: in 2.1-beta5 controller-config would print out the string in YAML
format, which will include a YAML multi-line prefix. For 2.1-beta5 you have
to remove the YAML formatting, as described in [this Launchpad bug][https://bugs.launchpad.net/juju/+bug/1661506].

To add a scrape target to Prometheus, add the following to `prometheus.yaml`:

```yaml
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

[developer-metrics]: ./developer-metrics.html
[prometheus]: https://prometheus.io/
