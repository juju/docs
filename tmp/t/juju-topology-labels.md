(juju-topology-labels)=
# Juju topology labels

Juju topology labels are [telemetry labels](https://discourse.charmhub.io/t/telemetry-labels-in-the-grafana-ecosystem/8873) that are used for identifying the origin of metrics and logs in juju models. In other words, the Juju topology labels are a fingerprint of a unit in some juju model that is emitting telemetry. Especially when you have hundreds, thousands of nodes, it is essential to be able to locate that one unit that has been causing your alerts to go off.
Therefore, Juju topology labels play a key role in the Canonical observability stack (COS).

> See also: [Model-driven observability: the magic of Juju topology for metrics](https://juju.is/blog/model-driven-observability-part-2-juju-topology-metrics)

This is what the Juju topology labels look like:
```yaml
        labels:
          model: "some-juju-model"
          model_uuid: "00000000-0000-0000-0000-000000000001"
          application: "fancy-juju-application"
          unit: "fancy-juju-application/0"
          charm_name: "fancy-juju-application-k8s"
```
The COS charm libraries wrapping any observability relation endpoint inject these labels into all outgoing metric, log, trace, and dashboard, so that the charm using them doesn't have to be aware of this at all. Any charm can ship with dashboards and (alert) rules to monitor its lifecycle. These are the so-called "built-in" dashboards and rules, and are workload-specific. When the charm is deployed and related to COS, the charm libraries mediating the COS integrations will automatically inject the juju topology labels in all built-in dashboards and rules.

The following sections outline what this means in practice, and which juju-topology-related modifications are applied to the built-in rules and dashboards.

## Dashboards
Depending on whether the charm where the dashboards reside is related directly to `grafana-k8s`, or whether the data flows through `grafana-agent` or `cos-proxy`, there are subtle differences in how the topology is injected.

### Charms relating directly to `grafana-k8s`
Built-in dashboards are enriched with topology drop-downs. This allows filtering dashboard data by topology labels. You can opt out of this behaviour by calling a `._reinitialize_dashboard_data(inject_dropdowns=False)` method on the `GrafanaDashboardProvider` relation wrapper object.

### Charms relating through `cos-configuration`
Incidental dashboards coming in from a git-repo via the `cos-configuration` charm are left intact.

### Charms relating through `grafana-agent` (`-k8s` or not)
When dashboards are forwarded through a `grafana-agent` intermediary, the juju topology labels of the charm of origin are injected (and not `grafana-agent`'s). Any subsequent chaining to additional grafana agent charms would leave the labels intact.

### Charms relating through `cos-proxy`
`cos-proxy` will apply its own topology to the labels, as old LMA-provider units don't implement the more modern interfaces that we would need to add topology to the telemetry. 

## Metrics 
Metrics are workload-specific and vary from charm to charm. 

### Charms relating through `grafana-agent` (`-k8s` or not)
For `grafana-agent`: any metrics coming from the principal charm will be tagged with the topology of the principal unit. The generic Linux metrics coming from the node exporter will be tagged with the grafana-agent unit topology.

For `grafana-agent-k8s`:  all metrics going through the charm are left unchanged.

### Charms relating through `cos-proxy`
`cos-proxy` will apply its own topology to the metrics.

## Alert rules
Alert rules are workload-specific and vary from charm to charm. For example, two different workloads can have an alert for "memory running out", but with different thresholds. We need to qualify each alert rule with a different set of labels, so that when an `expr` evaluates as true, it only fires for the intended metrics.

For built-in alert rules,
- Alert `expr`s are qualified with topology labels. This way, built-in alerts fire only for the particular charm they originated from.
- Alert labels are enriched with topology labels. This is meant for convenient reading of a rendered alert when presented to an on-caller. The labels would also be visible in the alert's rendered `expr`, but alert labels are more convenient to read.
- Alert rules are NOT enriched with the `unit` label. This is because we wouldn't want to replicated all rules per unit. Unit information is included in metric and log labels. Since alert rules are forwarded to prometheus/loki per related *app*, not unit, having multiple units does not result in prometheus having duplicated alerts per unit. If an alert was qualified with a unit (which one?), we wouldn't get alerts from any other units.
- Alert rules descriptions can use a  `{{ $labels.juju_unit }}` macro in the alert's annotations, which will be replaced with the unit name for better readability.

### Charms relating through `cos-configuration`
Incidental rule files coming in from a git-repo via the `cos-configuration` charm are left untouched and forwarded as-they-are.

### Charms relating through `grafana-agent` (`-k8s` or not)
When rule files are forwarded via grafana-agent, then they are enriched with juju topology labels of the relating charm (not grafana agent's topology). Any subsequent chaining to additional grafana agent charms would leave the labels intact.

Alerts coming from grafana-agent itself will be tagged with the grafana-agent unit topology.

### Charms relating through `cos-proxy`
`cos-proxy` will apply its own topology to the rules.

## Logs
K8s charms can stream logs to loki using the charm lib. Behind the scenes this is accomplished using `promtail`, and log streams are enriched with juju topology labels.

### Charms relating through `grafana-agent` (`-k8s` or not)
In `grafana-agent`, logs scraped from files, such as `/var/log`, will be tagged with the grafana-agent's own topology, while logs coming from the snap's slot will be tagged with the source unit's topology.

In `grafana-agent-k8s`, the charm will not modify the topology.

### Charms relating through `cos-proxy`
`cos-proxy` will apply its own topology to the logs. 

## Traces
Any charm can stream logs to Tempo using the `tracing` charm lib. Usually this is done by sending the logs to a grafana-agent, which forwards them to the COS stack. Grafana agent is configured to attach to any trace going through it the juju topology of the unit generating them.

### Charms relating directly to Tempo via `tracing`
If going via grafana-agent is not an option for you, you are yourself responsible for injecting juju topology into the root span's resource definition. As your workload will be forwarding traces straight into Tempo, and Tempo doesn't know where they are coming from, you should ensure that you can see that clearly in the spans themselves.

## Additional notes
- In the future, the `grafana-agent` charm may start exposing metrics and logs generated by its own workload, and those *would* be enriched by juju topology labels.
- In the future, the `cos-configuration` charm may start exposing metrics and logs generated by its own workload, `git-sync`, and those *would* be enriched by juju topology labels.
- In the future (2025) `grafana-agent` will be replaced by `otlp-collector`. The general data flow should remain unchanged.