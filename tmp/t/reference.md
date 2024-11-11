(reference)=
# Reference

Technical information - specifications, APIs, architecture.

## Performance

Explore the performance of COS Lite under heavy testing scenarios and discover the varying amounts of ingested data that different VM specifications can yield

- {ref}`COS Lite Performance on `4cpu-8gb-ssd` <cos-lite-ingestion-limits-for-4cpu-8gb-ssd>`
- {ref}`COS Lite Performance on `8cpu-16gb-ssd` <cos-lite-ingestion-limits-for-8cpu-16gb-ssd>`

## Kubernetes Charms

A list of Kubernetes charms that either form integral components of COS Lite or serve as complementary additions to various deployment scenarios.

- [Alertmanager K8s](https://charmhub.io/alertmanager-k8s) A charm for Alertmanager. It is **an essential part of the COS Lite bundle.**
- [Prometheus K8s](https://charmhub.io/prometheus-k8s) A charm for Prometheus. It is **an essential part of the COS Lite bundle.**
- [Scrape Target K8s](https://charmhub.io/prometheus-scrape-target-k8s) Supports metrics aggregation from applications outside any Juju model.
- [Scrape Config K8s](https://charmhub.io/prometheus-scrape-config-k8s) An adapter charm between metrics providers and prometheus.
- [Loki K8s](https://charmhub.io/loki-k8s) A charm for Loki. It is **an essential part of the COS Lite bundle.**
- [Grafana K8s](https://charmhub.io/grafana-k8s) A charm for Grafana. It is **an essential part of the COS Lite bundle.**
- [Grafana Agent K8s](https://charmhub.io/grafana-agent-k8s) A telemetry collector for sending metrics, logs, and trace data to COS.
- [Catalogue K8s](https://charmhub.io/catalogue-k8s) A charmed operator helping users to locate the user interfaces of the charms related to it. It is **an essential part of the COS Lite bundle.**
- [Mimir Coordinator K8s](https://charmhub.io/mimir-coordinator-k8s) A workloadless charm that coordinates the operations of mimir-worker charms and routes traffic to them.
- [Mimir Worker K8s](https://charmhub.io/mimir-worker-k8s) An open source, horizontally scalable, highly available, multi-tenant TSDB for long-term storage for Prometheus.
- [Traefik K8s](https://charmhub.io/traefik-k8s) A charm for Traefik. It is **an essential part of the COS Lite bundle.**
- [Tempo K8s](https://charmhub.io/tempo-k8s) A distributed tracing backend by Grafana.
- [COS Config K8s](https://charmhub.io/cos-configuration-k8s) An auxiliary charm that facilitates forwarding freestanding files from a git repository to COS operators.
- [Karma K8s](https://charmhub.io/karma-k8s) Aggregator and alternative UI for Alertmanager.
- [Karma Alertmanager Proxy K8s](https://charmhub.io/karma-alertmanager-proxy-k8s) Relation data provider for Karma charm.

## Machine Charms
A list  of machine charms designed to facilitate the integration of COS Lite with other machine charms.
- [Grafana Agent](https://charmhub.io/grafana-agent) A telemetry collector for sending metrics, logs, and trace data to COS.
- [COS Proxy](https://charmhub.io/cos-proxy) An intermediate charm that forms as an adapter between the legacy LMA relations and COS relations.

## Security
- {ref}`Cryptographic documentation for all COS-Lite charms. <cos-lite-docs-security>`