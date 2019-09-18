Juju accepts a "`jsonfile`" credential type for the `google` cloud. This page demonstrates how to generate that file.

> **Note**
>
> Authoritative instructions are provided by Google. Please refer to the official documentation if these instructions become out of date.
> * [ Creating and enabling service accounts for instances ](https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances)

### Create a Service Account

![gce-service-accounts|456x500](upload://xkLVpPlwtz7QIhH5IpHqogXI5Ys.png)

![gce-create-service-account|456x500](upload://k6niISOlXGdbA8iKIEpkVS189xs.png)

### Add Service Account Details

![gce-account-details|456x500](upload://xcgiASz4ILetvZWd42zi9oxqAbI.png)


### Grant Compute Admin role

Grant your account the role: **Compute Engine > Compute Admin**

![gce-grant-compute-admin|456x500](upload://8CZJUlPdguP9Zo2K9qC6EwJtwr7.png)

![gce-role-ok|456x500](upload://rkVXBoVTxe4L2VPXmCz0JLo0zlm.png)

  [sa]: https://cloud.google.com/compute/docs/access/service-accounts

### Create key

![gce-create-key|456x500](upload://nZQkgMnt4r8F7eQC0gQ7hCOIYyc.png)

### Download key in JSON format

The key file can be generated in 2 formats. Juju understands the JSON format for the `jsonfile` credential type.

![GCE-USE-JSON|456x500](upload://38oCPanvteEvkWIQ7oafiml021y.png)

Keys can also be downloaded from the console menu, once the key has been saved.

### Save the key in GCP

![gce-done|456x500](upload://olOxJM1YA3StVyumoyq5gpJEES6.png)

To verify that generating the key was successful, your console should present the new key for you:

![gce-ok|456x500](upload://6vyXqRMvMjq9SaECgiHd9Kb96hA.png)



## Questions?

Please add a question as a comment in this thread if anything is unclear.
