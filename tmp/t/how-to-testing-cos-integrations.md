(how-to-testing-cos-integrations)=
# How to: Testing COS integrations

Integrating a charm with [COS](https://charmhub.io/topics/canonical-observability-stack) means:
- having your app's metrics and corresponding alert rules reach [prometheus](https://charmhub.io/prometheus-k8s/)
- having your app's logs and corresponding alert rules reach [loki](https://charmhub.io/loki-k8s/)
- having your app's dashboards reach [grafana](https://charmhub.io/grafana-k8s/)

The COS team is responsible for some aspects of testing, and some aspects of testing belong to the charms integrating with COS.

## Tests for the built-in alert rules
### Unit tests
- You can use [`promtool test rules`](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/) to make sure they fire when you expect them to fire. As part of the test you hard-code the time series values you are testing for.
- [`promtool check rules`](https://prometheus.io/docs/prometheus/latest/command-line/promtool/#promtool-check)
- [`cos-tool validate`](https://github.com/canonical/cos-tool). The advantage of cos-tool is that the same executable can validate both prometheus and loki rules.
- Make sure your alerts manifest matches the output of:
  - `juju ssh prometheus/0 curl localhost:9090/api/v1/rules | jq -r '.data.groups | .[] | .rules | .[] | .name'`.
  - `juju ssh loki/0 curl localhost:3100/loki/api/v1/rules`

### Integration tests
- A fresh deployment shouldn't fire alerts, e.g. due to missing past data that is interpreted as 0.

## Tests for the metrics endpoint and scrape job
### Integration tests
- [`promtool check metrics`](https://prometheus.io/docs/prometheus/latest/command-line/promtool/#promtool-check) to lint the the metrics endpoint, e.g. `curl -s http://localhost:8080/metrics | promtool check metrics`.
- For scrape targets: when related to prometheus, and after a scrape interval elapses (default: 1m), all prometheus targets listed in `GET /api/v1/targets` should be `"health": "up"`. Repeat the test with/without ingress, TLS.
- For remote-write (and scrape targets): when related to prometheus, make sure that `GET /api/v1/labels` and `GET /api/v1/label/juju_unit` have your charm listed.
- Make sure that the metric names in your alert rules have matching metrics in your own `/metrics` endpoint.

## Tests for log lines
### Integration tests
- When related to loki, make sure your logging sources are listed in:
  - `GET /loki/api/v1/label/filename/values`
  - `GET /loki/api/v1/label/juju_unit/values`.

## Tests for dashboards
### Unit tests
- json lint

### Integration tests
- Make sure the dashboards manifest you have in the charm matches `juju ssh grafana/0 curl http://admin:password@localhost:3000/api/search`.

## Additional thoughts
- A rock's CI could dump a record of the `/metrics` endpoint each time the rock is built. This way some integration tests could turn into unit tests.

## See also
- https://discourse.charmhub.io/t/prometheus-k8s-docs-troubleshooting-integrations/14351
- https://discourse.charmhub.io/t/loki-k8s-docs-troubleshooting-missing-logs/14187