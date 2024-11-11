(telemetry)=
# Telemetry

Telemetry is the automatic recording and transmission of data from remote sources. In Juju, it specifically refers to the gathering of routine business metrics with the purpose of helping developers improve Juju. This happens automatically once a day, on a per model basis.  For more details, see below.

```{note}

No user information is gathered.

```

- [What data is collected?](#heading--what-data-is-collected)
- [What is the data used for?](#heading--what-is-the-data-used-for)
- [How do I disable data collection?](#heading--how-do-i-disable-data-collection)


<a href="#heading--what-data-is-collected"><h2 id="heading--what-data-is-collected">What data is collected?</h2></a>

* For a controller
  * juju version
  * controller uuid
* For a model
  * number of applications
  * number of units deployed
  * number of machines deployed
  * cloud
  * cloud provider
  * cloud region
  * model uuid
* For a charm
  * number of units
  * names of charms the charm is related to

<span style="background-color: green;">No user information is gathered.</span>

<a href="#heading--what-is-the-data-used-for"><h2 id="heading--what-is-the-data-used-for">What is the data used for?</h2></a>


The data will help us gain a better understanding of how Juju is used in the field:

* Are most configurations using high availability for the controller?
* Are many models with few units more popular than few models with many units?
* How many models are used with a controller?
* Which clouds are the most popular?
* What charms are frequently used together?

For example, we can better design improvements, create new bundles for charms commonly used together, etc.

Eventually, some data, such as the names of the charms an application is related to, will also be available to charm authors for use in improving their charms. 

<a href="#heading--how-do-i-disable-data-collection"><h2 id="heading--how-do-i-disable-data-collection">How do I disable data collection?</h2></a>

To disable telemetry in a juju model, set the `disable-telemetry` model configuration key to `true`:

```text
juju model-config disable-telemetry=true
```
> See more: {ref}`How to manage configuration values for a model <5188md>`