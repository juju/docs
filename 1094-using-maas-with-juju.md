[MAAS](https://maas.io/) treats physical servers (or KVM guests) as a public cloud treats cloud instances. From the [website](https://maas.io/):

> Self-service, remote installation of Windows, CentOS, ESXi and Ubuntu on real servers turns your data center into a bare-metal cloud.

[note]
The Juju 2.x series is compatible with both the 1.x and 2.x series of MAAS.
[/note]

<a id="steps-in-brief"></a>
## Steps in Brief

- [Add a MAAS cloud](#add-a-maas-cloud)
- [Add a credential](#add-a-credential)
- [Bootstrap a controller](#bootstrap-a-controller)

<a id="heading--adding-a-maas-cloud"></a><a id="add-a-maas-cloud"></a>
## Adding a MAAS cloud

There are two methods to define a cloud for Juju. 

1. Use an interactive prompt
2. Define a YAML file and provide that to Juju as a command-line argument

Both methods make use of the `juju add-cloud` command. You will need to supply a name you wish to call your cloud and the unique MAAS API endpoint.

To access detailed help about all of its options, use this command:

```text
juju help add-cloud
```

[note]
**What does --local do?**

Using the `--local` option instructs Juju to store the cloud definition on the machine that you're executing the command from.

Omitting it will store the cloud definition on the controller machine. This enables controllers to control models on multiple clouds, but isn't recommended while you are creating your first model.
[/note]


[note]
**Using an old version of Juju?**

If you are using a Juju version earlier than  `v.2.6.1`, omit the `--local` option. Prior to `v.2.6.1`, all cloud definitions are local.  
[/note]

### Using an interactive prompt

Using the `add-cloud` command without providing its name or an API endpoint will begin an interactive session.

```text
juju add-cloud --local
```

Example user session specifing `maas-cloud` as the cloud name and `http://10.55.60.29:5240/MAAS` as its API endpoint :

```text
Cloud Types
  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: maas

Enter a name for your maas cloud: maas-cloud

Enter the API endpoint url: http://10.55.60.29:5240/MAAS

Cloud "maas-cloud" successfully added

You will need to add credentials for this cloud (`juju add-credential maas-cloud`)
before creating a controller (`juju bootstrap maas-cloud`).
```

We've called the new cloud `maas-cloud` and used an endpoint of `http://10.55.60.29:5240/MAAS`.

<h3 id="heading--manually-adding-maas-clouds">Manually adding MAAS clouds</h3>

The manual method makes use of configuration files defined in [YAML](http://www.yaml.org/spec/1.2/spec.html). To define a configuration file that mimics the parameters provided by the interactive example, use this: 

```yaml
clouds:         # clouds key is required.
  maas-cloud:   # cloud's name
    type: maas
    auth-types: [oauth1]
    endpoint: http://10.55.60.29:5240/MAAS
```

Assuming that we've saved this YAML snippet as `maas-cloud.yaml`, adding it to Juju looks like this:

```bash
juju add-cloud --local maas-cloud maas-cloud.yaml
```

#### Adding multiple clouds from the same file

A single configuration file can define multiple clouds. They can be loaded into Juju one at a time.

Here is an example defines that three MAAS clouds, `devmaas`, `testmaas` and `prodmaas`:

``` yaml
clouds:
  devmaas:
    type: maas
    auth-types: [oauth1]
    endpoint: http://devmaas/MAAS
  testmaas:
    type: maas
    auth-types: [oauth1]
    endpoint: http://172.18.42.10/MAAS
  prodmaas:
    type: maas
    auth-types: [oauth1]
    endpoint: http://prodmaas/MAAS
```

To add clouds 'devmaas' and 'prodmaas', assuming the configuration file is `maas-clouds.yaml` in the current directory, we would run:

``` text
juju add-cloud --local devmaas maas-clouds.yaml
juju add-cloud --local testmaas maas-clouds.yaml
juju add-cloud --local prodmaas maas-clouds.yaml
```

[note]
See the [Adding clouds manually](/t/clouds/1100#heading--adding-clouds-manually) page for further information.
[/note]

### Confirm that you've added the cloud correctly

Ask Juju to report the clouds that it has registered:

```bash
juju clouds --local
```

## Adding credentials

Use the `add-credential` command to interactively add your credentials to the new cloud:

``` text
juju add-credential maas-cloud
```

Example user session:

``` text
Enter credential name: maas-cloud-creds

Using auth-type "oauth1".

Enter maas-oauth:

Credentials added for cloud maas-cloud.
```

We've called the new credential 'maas-cloud-creds'. When prompted for 'maas-oauth', you should paste your [MAAS API key](https://docs.ubuntu.com/maas/en/manage-account#api-key). It will not be echoed back to the screen.

The MAAS API key can be found on your user preferences page in the MAAS web UI, or by using the [MAAS CLI](https://docs.ubuntu.com/maas/en/manage-cli), providing you have sudo access:

``` text
sudo maas-region apikey --username=<username>
```
[note]
For more information about credentials, read through the [Credentials](/t/credentials/1112) page.
[/note]


### Confirm that you've added the credential correctly

To view the credentials that Juju knows about, use the `credentials` command and inspect both remote and locally stored credentials:

```plain
juju credentials
juju credentials --local
```

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for `maas-cloud`:

``` text
juju bootstrap maas-cloud maas-controller
```

Above, the name given to the new controller is 'maas-controller'. MAAS will allocate a node from its pool to run the controller on.


[note]
For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) and [Configuring Controllers](/t/configuring-controllers/1107) pages.
[/note]


<a id="next-steps"></a><a id="heading--next-steps"></a>
## Next steps

You're now able to deploy workloads. A good place to start is with a bundle.

* `juju deploy hadoop-spark`
* `juju deploy charmed-kubernetes`

To learn more about how Juju works, you should read these two pages next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
