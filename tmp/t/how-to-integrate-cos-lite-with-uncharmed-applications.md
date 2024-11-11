(how-to-integrate-cos-lite-with-uncharmed-applications)=
# How to integrate `cos-lite` with uncharmed applications

The [`cos-lite` bundle](https://github.com/canonical/cos-lite-bundle) is meant to be run by Juju. However, not all workloads that you may want to monitor do. The good news is that you can use `cos-lite` to monitor workloads that are not charmed (aka 'not managed by Juju'). The bad news is that it's relatively straightforward to do so. Not bad at all.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Contents:**

- [Deploy `cos-lite`](#heading--deploy-cos-lite)
- [Deploy `grafana-agent`](#heading--deploy-grafana-agent)
- [Get the API endpoints from `traefik`](#heading--get-the-api-endpoints-from-traefik)
- [Add custom dashboards and alerts](#heading--add-custom-dashboards-and-alerts)	
- [TLS](#heading--tls)
- [Known limitations and upcoming features](#heading--known-limitations-and-upcoming-features)
    - [Identity](#heading--identity)
    - [Tracing](#heading--tracing)
- [Only export metrics with `prometheus-scrape-target`](#heading--only-export-metrics-with-prometheus-scrape-target)

<!-- markdown-toc end -->


<a href="#heading--deploy-cos-lite"><h2 id="heading--deploy-cos-lite">Deploy `cos-lite`</h2></a>


The first step will be to get a hold of a machine, somewhere, and follow [this guide on how to get started with COS lite on microk8s](https://charmhub.io/topics/canonical-observability-stack/tutorials/install-microk8s).

And be sure to follow the {ref}`best practices <best-practices-for-production-deployments-of-cos-lite>`!

```{note}
 Unless you're also planning to monitor some charmed applications with this cos-lite deployment, you will not need to use [the `offers` overlay](https://charmhub.io/topics/canonical-observability-stack/tutorials/install-microk8s#heading--deploy-the-cos-lite-bundle-with-overlays). 
```


<a href="#heading--deploy-grafana-agent"><h2 id="heading--deploy-grafana-agent">Deploy `grafana-agent`</h2></a>


The Grafana agent will act as an intermediary between the applications you want to monitor and the `cos-lite` stack. It will gather telemetry from your applications and send them to `cos-lite`, where you will be able to inspect them through the Grafana dashboards.

We recommend to host the Grafana agent as close as possible to the workloads you intend to monitor, to minimise the risk of network faults and the resulting gaps in telemetry collection.
Also, we recommend to install the Grafana agent via a handy snap we maintain:

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/grafana-agent)

However, Grafana agent is also available as a single Go binary, and you are free to install it and run it the way you like. See the [official documentation](https://grafana.com/docs/agent/latest/) for the publisher's recommendations and guides.

```{tip}
 Last but not least, we also have it [containerized](http://ghcr.io/canonical/grafana-agent) and [petrified](https://github.com/canonical/grafana-agent-rock/). 
```

Now that you have Grafana Agent up and running, you will need to configure it.

<a href="#heading--get-the-api-endpoints-from-traefik"><h2 id="heading--get-the-api-endpoints-from-traefik">Get the API endpoints from `traefik`</h2></a>

`cos-lite` includes a `traefik` instance that takes care of load balancing and ingressing the various observability components of the stack. Since `cos-lite` runs on Kubernetes, this allows you to talk to them via `traefik` over a stable URL.

```{caution}

Before you can use Traefik from an external service such as Grafana agent, you will need to ensure that the Traefik URL is routable from the service host, and that the address is stable. (e.g. not a dynamic IP)
In other words, Traefik's own URL aso needs to be stable.

```


In the Juju model where `cos-lite` is installed, you can run:

> `juju run traefik/0 show-proxied-endpoints`

Assuming you have [configured the `traefik` charm](https://github.com/canonical/traefik-k8s-operator#configurations) to use an external hostname, for example `"traefik.url"`, you will see something like:

```
proxied-endpoints: '{
    "prometheus/0": {"url": "https://traefik.url/mymodel-prometheus-0"},
    "loki/0": {"url": "https://traefik.url/mymodel-loki-0"},
    "alertmanager": {"url": "https://traefik.url/mymodel-alertmanager"},
    "catalogue": {"url": "https://traefik.url/mymodel-catalogue"},
}'
```

```{tip}
 You can also open `https://traefik.url/mymodel-catalogue` in a browser to see a page with links to all `cos-lite` components' user interfaces. 
```

At this point you will need to follow [the documentation on how to configure the Grafana agent](https://grafana.com/docs/agent/latest/static/configuration/#configure-static-mode).
Use the urls you obtained from traefik to tell the agent where to send its telemetry.


<a href="#heading--add-custom-dashboards-and-alerts"><h2 id="heading--add-custom-dashboards-and-alerts">Add custom dashboards and alerts</h2></a>


In order to add your own dashboards and alerts to `cos-lite` you will need to deploy the [`cos-config` charm](https://github.com/canonical/cos-configuration-k8s-operator) on top of `cos-lite`.

Follow [this guide](https://github.com/canonical/cos-configuration-k8s-operator#deployment) to set up `cos-config` in the same Juju model in which `cos-lite` is deployed.


<a href="#heading--tls"><h3 id="heading--tls">TLS</h3></a>

You can deploy cos-lite with the [tls](https://github.com/canonical/cos-lite-bundle/pull/80) overlay to enable secure communications with and within COS Lite. 

You can follow [this guide](https://charmhub.io/traefik-k8s/docs/tls-termination) to enable TLS in Traefik and COS Lite.


<a href="#heading--known-limitations-and-upcoming-features"><h2 id="heading--known-limitations-and-upcoming-features">Known limitations and upcoming features</h2></a>

<a href="#heading--identity"><h3 id="heading--identity">Identity</h3></a>

We are "working towards"<sup>[citation needed]</sup> an integration with canonical's [IAM bundle](https://github.com/canonical/iam-bundle) to provide a charmed identity solution to support locking down your observability stack behind an identity provider. Stay tuned for updates!

<a href="#heading--tracing"><h3 id="heading--tracing">Tracing</h3></a>

We are "working towards"<sup>[citation needed]</sup> a [tracing overlay](https://github.com/canonical/cos-lite-bundle/pull/79) to add distributed tracing capabilities to cos-lite. Once that work is done, you will be able to add [Grafana Tempo](https://grafana.com/oss/tempo/) to the stack.


<a href="#heading--only-export-metrics-with-prometheus-scrape-target"><h2 id="heading--only-export-metrics-with-prometheus-scrape-target">Only export metrics with `prometheus-scrape-target`</h2></a>


In some rare circumstances, you might prefer to use `prometheus-scrape-target` instead of `grafana-agent`.
Namely:
- when you only need metrics (no logs, traces, etc...)
- when you'd rather make the necessary firewall changes in the workload you want to monitor, than ingress cos-lite
- when you're not able to install anything (or the grafana-agent anyway) on the workload you want to monitor

If this is your situation, we've got you covered. You can deploy [`prometheus-scrape-target`](https://github.com/canonical/prometheus-scrape-target-k8s-operator) and configure it to scrape your workload.