This page offers specific troubleshooting tips when you try to add a Juju object and it doesn't go the way you expect.

<h2 id="heading--juju-retry-provisioning">Juju retry-provisioning</h2>

You can use the `retry-provisioning` command in cases where deploying applications, adding units, or adding machines fails. It allows you to specify machines which should be retried to resolve errors reported with `juju status`.

For example, after having deployed 100 units and machines, status reports that machines '3', '27' and '57' could not be provisioned because of a 'rate limit exceeded' error. You can ask Juju to retry:

``` text
juju retry-provisioning 3 27 57
```
