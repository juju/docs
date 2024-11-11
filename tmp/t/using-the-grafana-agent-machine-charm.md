(using-the-grafana-agent-machine-charm)=
# Using the Grafana Agent Machine Charm

```{dropdown} Metadata

| Key | Value |
| --- | --- |
| Summary | Using the Grafana Agent Machine Charm |
| Categories | integrations |
| Difficulty | 3 |
| Author | {ref}`Jose Massón <8896md>` |

```

<!-- TOC start -->
- {ref}`Preview <8896md>`
  * {ref}`Initial situation <8896md>`
  * {ref}`Desired situation <8896md>`
- {ref}`About Grafana Agent machine charm <8896md>`
- {ref}`**Step 0**: Understanding the desired situation <8896md>`
- {ref}`**Step 1**: Make sure COS Lite is up and running. <8896md>`
- {ref}`**Step 2**: Instrument Grafana Agent in our Application's Charmed Operator <8896md>`
- {ref}`**Step 3**: Deploy Zookeeper and Grafana Agent in our VM Juju model. <8896md>`
- {ref}`**Step 4**: Relate Grafana Agent to COS-Lite (Prometheus, Loki and Grafana) <8896md>`
- {ref}`**Step 5**: Verify that metrics and logs reach Prometheus and Loki <8896md>`
<!-- TOC end -->



<!-- TOC --><a name="preview"></a>
## Preview
<!-- TOC --><a name="initial-situation"></a>
### Initial situation

Let's assume we have an application that:
  - Is running in a virtual machine or in a regular machine.
  - Is managed with  [Juju](https://juju.is) by its own [Charmed Operator](https://juju.is/docs/sdk/charmed-operators).
  - Needs to be observed (monitored).

<!-- TOC --><a name="desired-situation"></a>
### Desired situation

We would like to collect telemetry from the charmed application into [COS Lite](https://charmhub.io/cos-lite), but COS Lite runs in Kubernetes and the application in a machine.

So the question arises: How can we connect both worlds? The answer is simple: use this Grafana Agent machine charm!


<!-- TOC --><a name="about-grafana-agent-machine-charm"></a>
## The Grafana Agent machine charm

The Grafana Agent machine charm handles installation, configuration, and Day 2 operations specific to [Grafana Agent](https://grafana.com/oss/agent/), using [Juju](https://juju.is) and the [Charmed Operator Lifecycle Manager (OLM)](https://juju.is/docs/olm).

This charm was designed to run in virtual machines as a [subordinate](https://discourse.charmhub.io/t/subordinate-applications/1053). Application units are typically run in an isolated container on a machine with no knowledge or access to other applications deployed onto the same machine. With subordinate charms, units of different applications to be deployed into the same container and to have knowledge of each other. Subordinate units scale together with their principal.


<!-- TOC --><a name="step-0-understanding-the-desired-situation"></a>
## **Step 0**: Understanding the desired situation

As we said before, we are going to use COS Lite to monitor our application, and Grafana Agent machine charm to send application's telemetry (metris, logs and dashboards)

For that we will have two Juju models:

- `applications`, on a lxd controller, for our application and grafana agent
- `cos`, on a k8s controller, for COS Lite

[![](https://mermaid.ink/img/pako:eNp9kstuwyAQRX8FsckmVrusvG27arNJdhWSNTHjGAVmEA_1Eeffi52HrCitWABzz4VhmINsWaOs5S6A78X7WtFpxLw9hRbgvTUtJMMUF8IV3ApDAkjYLy1aphTYWgwzzw_zHtFjeHhUdN0oKmoHBBXskJIiJD2TRVVVQ8uxmdRB3MBn_OaQyfS8WotK-MAOU485NgEdJ2w-g0k4zIQxnb_slvem8Tn2DXgzTNv_8HO80RD7LUPQ14RH17x-5Unzsom3p3i_agWsJk4VEbAz-_Gou9mPy0uG57JMk1xKh8GB0eVLD4qEULJ4HSpZl6XGDrJNSio6FjR7DQlftUkcZN2BjbiUkBNvvqmVdQoZL9CLgXK1u1I4mVan3plaaCk90AfzhTn-AhMU2ws?type=png)](https://mermaid.live/edit#pako:eNp9kstuwyAQRX8FsckmVrusvG27arNJdhWSNTHjGAVmEA_1Eeffi52HrCitWABzz4VhmINsWaOs5S6A78X7WtFpxLw9hRbgvTUtJMMUF8IV3ApDAkjYLy1aphTYWgwzzw_zHtFjeHhUdN0oKmoHBBXskJIiJD2TRVVVQ8uxmdRB3MBn_OaQyfS8WotK-MAOU485NgEdJ2w-g0k4zIQxnb_slvem8Tn2DXgzTNv_8HO80RD7LUPQ14RH17x-5Unzsom3p3i_agWsJk4VEbAz-_Gou9mPy0uG57JMk1xKh8GB0eVLD4qEULJ4HSpZl6XGDrJNSio6FjR7DQlftUkcZN2BjbiUkBNvvqmVdQoZL9CLgXK1u1I4mVan3plaaCk90AfzhTn-AhMU2ws)



<!-- TOC --><a name="step-1-make-sure-cos-lite-is-up-and-running"></a>
## **Step 1**: Make sure COS Lite is up and running.

We have to make sure that the observability stack is up and running in our `cos` model (follow the instructions in [COS Lite](https://charmhub.io/prometheus-k8s/docs/deploy-cos-lite?channel=edge)) in a K8s controller, like this:

![imagen|690x556](upload://q1bU8XzBVMjUH6uyrQysvRtPdRl.png)

[quote]
At the time of writing this documentation, it is recommended to use the `edge` version of COS-Lite as it resolves some bugs present in `stable`. This will not be necessary in the short term.
[/quote]

Note that [COS Lite](https://charmhub.io/cos-lite) is offering several interfaces so we can create [cross-model relations](https://juju.is/docs/olm/manage-cross-model-integrations) with applications that are running in different controllers/models:

```shell
Offer                            Application   Charm             Rev  Connected  Endpoint              Interface                Role
alertmanager-karma-dashboard     alertmanager  alertmanager-k8s  73   0/0        karma-dashboard       karma_dashboard          provider
grafana-dashboards               grafana       grafana-k8s       80   0/0        grafana-dashboard     grafana_dashboard        requirer
loki-logging                     loki          loki-k8s          87   0/0        logging               loki_push_api            provider
prometheus-receive-remote-write  prometheus    prometheus-k8s    125  0/0        receive-remote-write  prometheus_remote_write  provider
prometheus-scrape                prometheus    prometheus-k8s    125  0/0        metrics-endpoint      prometheus_scrape        requirer
```


<!-- TOC --><a name="step-2-instrument-grafana-agent-in-our-applications-charmed-operator"></a>
## **Step 2**: Instrument Grafana Agent in our Application's Charmed Operator

In this example we use COS Lite to observe [Zookeeper](https://github.com/canonical/zookeeper-operator).

In order to instrument it, we will have to:

- Obtain `cos_agent` lib from `grafana-agent` charm:

    ```shell
    charmcraft fetch-lib charms.grafana_agent.v0.cos_agent
    ```

- Modify only 2 files in your machine charm code: `metadata.yaml`, `src/charm.py`.


    In `metadata.yaml` we need to add to `provides` section:

    ```yaml
      cos-agent:
        interface: cos_agent
    ```

    In `src/charm.py` we import the library:

    ```python
    from charms.grafana_agent.v0.cos_agent import COSAgentProvider
    ```

    and instantiate `COSAgentProvider` object in `__init__` method. For [zookeeper](https://github.com/canonical/zookeeper-operator) it may look like this:

    ```python
            self._grafana_agent = COSAgentProvider(
                self,
                metrics_endpoints=[
                    {"path": "/metrics", "port": NODE_EXPORTER_PORT},
                    {"path": "/metrics", "port": JMX_PORT},
                    {"path": "/metrics", "port": METRICS_PROVIDER_PORT},
                ],
                metrics_rules_dir="./src/alert_rules/prometheus",
                logs_rules_dir="./src/alert_rules/loki",
                dashboard_dirs=["./src/grafana_dashboards"],
                log_slots=["charmed-zookeeper:logs"],
            )
    ```

    Note that you can specify the paths where metrics and logs alert rules and dashboards files are stored. In order to know how alert rules and dashboards are written, check [these examples](https://github.com/canonical/cos-configuration-k8s-operator/tree/main/tests/samples).

- Re-pack the charm:

    ```shell
    charmcraft pack
    ```

and voilà!

<!-- TOC --><a name="step-3-deploy-zookeeper-and-grafana-agent-in-our-vm-juju-model"></a>
## **Step 3**: Deploy Zookeeper and Grafana Agent in our VM Juju model.

In order to deploy these applications make sure you already have a [VM Juju controller bootstrapped](https://juju.is/docs/olm/manage-controllers#heading--create-a-controller).

In this controller we will create a new model named for instance `applications`
and deploy (and relate) `zookeeper` and `grafana-agent`.


- Create the model:
    ```shell
    $ juju add-model applications
    Added 'applications' model on localhost/localhost with credential 'localhost' for user 'admin'
    ```
- Deploy Zookeeper using the previous packed `*.charm` file:

    ```shell
    $ pwd
    /home/ubuntu/repos/zookeeper-operator

    $ juju deploy ./*.charm zookeeper
    Located local charm "zookeeper", revision 0
    Deploying "zookeeper" from local charm "zookeeper", revision 0 on jammy
    ```
- Deploy Grafana Agent machine charm

    ```shell
    juju deploy grafana-agent --channel edge
    ```

    After running these commands the status of the model will be active/idle for both units:

  ![imagen|690x333](upload://iFC75QUFgGZuoF3bp9mIPJ7E85c.png)

    At this point we have one `zookeeper` unit in `active` state, and there is no `grafana-agent` units. This is because `grafana-agent` is a [subordinate application](https://discourse.charmhub.io/t/subordinate-applications/1053).

- Relate `zookeeper` to `grafana-agent`over the `cos-agent` relation:

    ```shell
    juju relate zookeeper:cos-agent grafana-agent
    ```

    Once the relation is established, and `grafana-agent` is deployed inside `zookeeper` unit, the status of the model will be:

  ![imagen|690x226](upload://5L8RgOCna30bBEZ03Zt97Dd5vpx.png)

    Note that despite of the fact at this point `grafana-agent` is collecting telemetry data from `zookeeper` it is not forwarding them to the COS Lite deployment we have in the K8s controller.

<!-- TOC --><a name="step-4-relate-grafana-agent-to-cos-lite-prometheus-loki-and-grafana"></a>
## **Step 4**: Relate Grafana Agent to COS-Lite (Prometheus, Loki and Grafana)

Since Grafana Agent is meant to send telemetry to COS-Lite, the next step is to relate Grafana Agent to the COS Lite components: Prometheus, Loki and Grafana. This charm need these three relations.


From the model our application is running, we can verify the [`offers`](https://juju.is/docs/olm/manage-cross-model-integrations) COS Lite is exposing:

```shell
$ juju find-offers -m microk8s:cos

Store     URL                                        Access  Interfaces
microk8s  admin/cos.loki-logging                     admin   loki_push_api:logging
microk8s  admin/cos.prometheus-receive-remote-write  admin   prometheus_remote_write:receive-remote-write
microk8s  admin/cos.prometheus-scrape                admin   prometheus_scrape:metrics-endpoint
microk8s  admin/cos.alertmanager-karma-dashboard     admin   karma_dashboard:karma-dashboard
microk8s  admin/cos.grafana-dashboards               admin   grafana_dashboard:grafana-dashboard
```
As we said before, we will use only three of these `offers`:

- Prometheus: `admin/cos.prometheus-receive-remote-write`
- Loki: `admin/cos.loki-logging `
- Grafana: `admin/cos.grafana-dashboards`

The first step to use these `offers` is to `consume` them:

```shell
$ juju consume microk8s:admin/cos.prometheus-receive-remote-write
Added microk8s:admin/cos.prometheus-receive-remote-write as prometheus-receive-remote-write
```
```shell
$ juju consume microk8s:admin/cos.loki-logging
Added microk8s:admin/cos.loki-logging as loki-logging
```
```shell
$ juju consume microk8s:admin/cos.grafana-dashboards
Added microk8s:admin/cos.grafana-dashboards as grafana-dashboards
```

Once these commands are executed, the status of our model will change slightly:

![imagen|690x278](upload://4JpRmK6dGZ92HcKTramhMmWMUfX.png)


Note that in the status we now have a new section named `SAAS`. In that section we can see all the interfaces offered by other applications running in other models that we can integrate to.

So now let's relate Grafana Agent with these 3 applications:

```shell
 juju relate grafana-agent prometheus-receive-remote-write
 ```
```shell
 juju relate grafana-agent loki-logging
  ```

```shell
juju relate grafana-agent grafana-dashboards
```

And the three new relations are established, see the relations sections of the model status:

![imagen|690x333](upload://wSvddmiSXdKAvgjxtamC94JGeLP.png)


```{note}

Note that because of [this bug](https://bugs.launchpad.net/juju/+bug/2048870) you can't create a new offer after relating an existing one. So first create all offers you intend to consume, and then relate all endpoints. Otherwise juju will complain with: `ERROR cannot update application offer "<app>": application endpoint "<endpoint>" has active consumers`

```

<!-- TOC --><a name="step-5-verify-that-metrics-and-logs-reach-prometheus-and-loki"></a>
## **Step 5**: Verify that metrics and logs reach Prometheus and Loki

Now that the Cross Model Relations are established between our application model and our Observability model, we can easily verify that the metrics `zookeeper` exposes reaches Prometheus:

![imagen|690x437](upload://tIrMyJr6qGkM3Mb91JBdUd842Df.png)


```shell
$ curl -s http://192.168.122.10/cos-prometheus-0/api/v1/query\?query\=zookeeper_DataDirSize | jq
{
  "status": "success",
  "data": {
    "resultType": "vector",
    "result": [
      {
        "metric": {
          "__name__": "zookeeper_DataDirSize",
          "instance": "applications_f201dfb6-896c-4d5e-83c0-55e6bb8b08f3_zookeeper_zookeeper/0",
          "job": "zookeeper_1",
          "juju_application": "zookeeper",
          "juju_model": "applications",
          "juju_model_uuid": "f201dfb6-896c-4d5e-83c0-55e6bb8b08f3",
          "juju_unit": "zookeeper/0",
          "memberType": "Leader",
          "replicaId": "1"
        },
        "value": [
          1678971938.463,
          "67108880"
        ]
      }
    ]
  }
}
```

We can also check that the logs are being sent to Loki, in this case using Grafana:

![imagen|690x690](upload://yQEWrNc9ymW9wWn3eDRnUae72WE.png)

And finally, we can verify the dashboards Zookeepers provides:

![image|690x624](upload://fIrF6VcZwysYZGiBgbjLQIy4yGm.png)