(telemetry-flow-in-cos-lite)=
# Telemetry flow in COS Lite

COS Lite includes Loki, a logs backend, and Prometheus, a metrics backend. The API endpoints of Loki and Prometheus are communicated to other charms via Juju integrations. This way, telemetry producers (or aggregators) are able to push telemetry to Loki and Prometheus.
Prometheus is also able to pull metrics directly from metric providers.

In the recommended deployment scenarios, a telemetry aggregator, such as grafana agent, is used to funnel logs and metrics to COS. In this case, grafana agent takes over the responsibility to push logs as well as metrics into COS: so it’s not required for the COS stack to be able to reach the grafana agent, but the agent must be able to reach the COS stack.
The grafana agent needs to be able to reach the charms and workloads generating the telemetry, and the other way around. 

![image|690x168](upload://2eMVIb5opFm3yeVEiezwyMqXRA6.jpeg)

The image below describes a typical COS deployment observing both a LXD- and a Kubernetes cloud. In the following sections, you’ll find a brief summary of the use case of each of the components that make up a data path between a telemetry emitter and COS itself.

![image|690x428](upload://auDfAaceMksTN25N96RSEI2GR8Q.jpeg)


### COS Proxy

The COS Proxy bridges the gap between workloads instrumented using NRPE, allowing it to be turned into metrics stored as timeseries in Prometheus. This charm is meant to serve as a stepping stone, and not as a future-proof solution. Going forward, all charms built by Canonical will instead exposemetrics directly, allowing users to omit the proxy.

### Grafana Agent

The Grafana Agent machine charm aims to collect both host and application telemetry in deployment scenarios where a full virtual machine is being used. It is powered by the `grafana-agent` snap, and handed a configuration containing all scrape targets available on the machine, including a `node_exporter` endpoint provided by the snap itself.

### Grafana Agent K8s

The Grafana Agent K8s charm is analogous to the machine ditto but deployed in a K8s pod. In contrast to the machine charm, the K8s charm is not installed in the same container as the workload, which means scraping or log forwarding happens between pods rather than in-pod.

### Prometheus Scrape Config

`prometheus-scrape-config` is a workloadless charm used to alter the configuration of individual scrape jobs. It is commonly used to modify the scrape interval of the cos-proxy nrpe checks, as triggering an involved bash script once every minute has the potential of degrading system performance.

In a typical OpenStack + COS deployment, there are multiple of these with different scrape intervals, depending on the part of the system you are monitoring.