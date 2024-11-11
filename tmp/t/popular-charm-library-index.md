(popular-charm-library-index)=
# Popular charm library index

> See also:
> - {ref}`How to manage charm libraries <how-to-manage-charm-libraries>`
> - {ref}`About charm libraries <library>`

<!--
Technical documentation may be found at [Creating and Using Charm Libraries](https://discourse.charmhub.io/t/creating-and-using-charm-libraries/4058). A shorter list with more detailed notes about a select subset of libraries is available in [Highlighting Charm Libraries](https://discourse.charmhub.io/t/highlighting-charm-libraries/5484).
-->

This is an index of the charm libraries that are currently known to be available.

```{note}


This list may be missing libraries from charms that are not publicly listed on Charmhub. If you would like to add a library to the list, please drop a comment using the feedback link below.

```

**Contents:**

- [Libraries that define relations](#heading--libraries-that-define-relations)
- [Libraries that provide tools](#heading--libraries-that-provide-tools)
    - [Libraries that provide tools for Kubernetes charms](#heading--libraries-that-provide-tools-for-kubernetes-charms)
    - [Libraries that provide tools for machine charms](#heading--libraries-that-provide-tools-for-machine-charms)


<a href="#heading--libraries-that-define-relations"><h2 id="heading--libraries-that-define-relations">Libraries that define relations</h2></a>

The following libraries provide programmatic instructions for relating to a specific charm.

| Library | Used in | Description |
| --- | --- | --- |
| [fluentbit](https://charmhub.io/fluentbit/libraries/fluentbit) | [fluentbit](https://charmhub.io/fluentbit/libraries/fluentbit) | Defines both sides of a relation interface to the [fluentbit charm](https://charmhub.io/fluentbit/libraries/fluentbit). |
| [redis](https://charmhub.io/redis-k8s/libraries/redis) |  | Import RedisRequires from this lib to relate your charm to the [redis-k8s charm](https://charmhub.io/redis-k8s). |
| [grafana-dashboard](https://charmhub.io/grafana-k8s/libraries/grafana-dashboard) | | Defines a relation interface for charms that provide a dashboard to the [grafana-k8s charm](https://charmhub.io/grafana-k8s). |
| [grafana-source](https://charmhub.io/grafana-k8s/libraries/grafana-source) | | Defines a relation interface for charms that serve as a data source for the [grafana-k8s charm](https://charmhub.io/grafana-k8s). |
| [prometheus-scrape](https://charmhub.io/prometheus-k8s/libraries/prometheus_scrape) | | Defines a relation interface for charms that want to expose metrics endpoints to the [prometheus charm](https://charmhub.io/prometheus-k8s). |
|[alertmanager-dispatch](https://charmhub.io/alertmanager-k8s/libraries/alertmanager_dispatch) | | Defines a relation to the [alertmanager-dispatch charm](https://charmhub.io/alertmanager-k8s). |
|[karma_dashboard](https://charmhub.io/karma-k8s/libraries/karma_dashboard) | [karma-k8s](https://charmhub.io/karma-k8s) | Defines an interface for charms wishing to consume or provide a karma-dashboard relation. |
| [loki_push_api](https://charmhub.io/loki-k8s/libraries/loki_push_api) | [loki_k8s](https://charmhub.io/loki-k8s) | Defines a relation interface for charms wishing to provide or consume the Loki Push API---e.g., a charm that wants to send logs to Loki. | 
| [log_proxy](https://charmhub.io/loki-k8s/libraries/log_proxy) | [loki_k8s](https://charmhub.io/loki-k8s) |  Defines a relation interface that allows a charm to act as a Log Proxy for Loki (via the Loki Push API). |
| [guacd](https://charmhub.io/apache-guacd/libraries/guacd) | [apache-guacd](https://charmhub.io/apache-guacd/) | Defines a relation for charms wishing to set up a native server side proxy for Apache Guacamole. |

<a href="#heading--libraries-that-provide-tools"><h2 id="heading--libraries-that-provide-tools">Libraries that provide tools</h2></a>

These libraries provide re-usable tooling, typically to interact with cloud services, or to perform operations common to several charms.
| Library | Used in | Description |
| --- | --- | --- |
| [cert](https://charmhub.io/kubernetes-dashboard/libraries/cert) | [kubernetes-dashboard](https://charmhub.io/kubernetes-dashboard) | Generates a self signed certificate.  |
| [capture_events](https://discourse.charmhub.io/t/harness-recipe-capture-events/6581) | [traefik-k8s](https://charmhub.io/traefik-k8s), [data-platform-libs](https://github.com/canonical/data-platform-libs/) | Helper for unittesting events.  |
| [networking](https://discourse.charmhub.io/t/harness-and-network-mocks/6633) | <your charm here?> | Provides tools for mocking networks.  |
| [compound-status](https://charmhub.io/compound-status) | <your charm here?> | Provides utilities to track multiple independent statuses in charms.  |
| [resurrect](https://github.com/PietroPasotti/resurrect) | [github-runner-image-builder](https://github.com/canonical/github-runner-image-builder-operator) | Provides utilities to periodically trigger charm hooks.  |


<a href="#heading--libraries-that-provide-tools-for-kubernetes-charms"><h3 id="heading--libraries-that-provide-tools-for-kubernetes-charms">Libraries that provide tools for Kubernetes charms</h3></a>

These libraries provide tooling for charms that run on top of Kubenetes clouds.

| Library | Used in | Description |
| --- | --- | --- |
| [kubernetes_service_patch](https://charmhub.io/observability-libs/libraries/kubernetes_service_patch) | [cos-configuration-k8s](https://charmhub.io/cos-configuration-k8s), [alertmanager-k8s](https://charmhub.io/alertmanager-k8s), [grafana-agent-k8s](https://charmhub.io/grafana-agent-k8s), [prometheus-k8s](https://charmhub.io/prometheus-k8s), [loki-k8s](https://charmhub.io/loki-k8s), [traefik-k8s](https://charmhub.io/traefik-k8s) | Allows charm authors to simply and elegantly define service overrides that persist through a charm upgrade. |
| [ingress](https://charmhub.io/nginx-ingress-integrator/libraries/ingress) | [nginx-ingress-integrator](https://charmhub.io/nginx-ingress-integrator) | Configures nginx to use an existing Kubernetes Ingress. |
| [ingress-per-unit](https://charmhub.io/traefik-k8s/libraries/ingress_per_unit) | [traefik-k8s](https://charmhub.io/traefik-k8s) | Configures traefik to provide per-unit routing. |

<a href="#heading--libraries-that-provide-tools-for-machine-charms"><h3 id="heading--libraries-that-provide-tools-for-machine-charms">Libraries that provide tools for machine charms</h3></a>

These libraries contain tools meant for use in machine charms, e.g., libraries that interact with package managers or other CLI tools that are often not present in containers.

| Library | Used in | Description |
| --- | --- | --- |
| [apt](https://charmhub.io/operator-libs-linux/libraries/apt) | [mysql](https://charmhub.io/mysql), [zookeeper](https://charmhub.io/zookeeper), [cos-proxy](https://charmhub.io/cos-proxy), [kafka](https://charmhub.io/kafka), [ceph-mon](https://charmhub.io/ceph-mon) | Install and manage packages via `apt`. |
| [dnf](https://charmhub.io/operator-libs-linux/libraries/dnf) | | Install and manage packages via `dnf`. |
| [grub](https://charmhub.io/operator-libs-linux/libraries/grub) | | Mange kernel configuration via `grub`. |
| [passwd](https://charmhub.io/operator-libs-linux/libraries/passwd) | | Manage users and groups on a Linux system. |
| [snap](https://charmhub.io/operator-libs-linux/libraries/snap) | [mongodb](https://charmhub.io/mongodb), [mongodb-k8s](https://charmhub.io/mongodb-k8s), [postgresql](https://charmhub.io/postgresql), [grafana-agent-k8s](https://charmhub.io/grafana-agent-k8s), [kafka](https://charmhub.io/kafka) | Install and manage packages via `snapd`. |
| [sysctl](https://charmhub.io/operator-libs-linux/libraries/sysctl) | [kafka](https://charmhub.io/kafka) | Mange sysctl configuration. |
| [systemd](https://charmhub.io/operator-libs-linux/libraries/systemd) | [mongodb](https://charmhub.io/mongodb), [pgbouncer](https://charmhub.io/pgbouncer), [cos-proxy](https://charmhub.io/cos-proxy), [ceph-mon](https://charmhub.io/ceph-mon), [calico](https://charmhub.io/calico) | Interact with services via `systemd`. |


<br>

<small>**Contributors:** @charlie4284, @davigar15, @jnsgruk, @pengale, @ppasotti, @rgildein , @sed-i , @taurus, @tmihoc</small>