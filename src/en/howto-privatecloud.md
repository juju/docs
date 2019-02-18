Title: Cloud image metadata
TODO:  Critical: review required
       Consider renaming this file (e.g. cloud-image-metadata)

# Cloud image metadata

## Overview

When Juju creates a controller it needs two critical pieces of information:

 1. The UUID of the image to use when spawning a new machine (instance).
 1. The URL from which to download the correct Juju agent.

This "metadata" is stored in a JSON format called *Simplestreams*. It is
built-in for most clouds Juju is aware of but needs to be configured if you're
setting up your own cloud.

There are a few ways to do this based on the design of the OpenStack cloud and
your level of permissions with Juju and the OpenStack deployment:

* If you are a general user start with [Create image metadata with Juju][general].
* If you have admin or operator permissions in the OpenStack deployment, start
with [Create image metadata with Juju][general] and continue with
[Upload the Simplestreams Metadata to an object store][object-store].
* If the OpenStack deployment was done with Juju and you have permissions to
deploy charms alongside the OpenStack charms then use the [glance-simplestreams-sync charm][gsscharm].


## Create image metadata with Juju

### Requirements

 - Ubuntu images previously uploaded to Glance.
 - python-openstackclient

### Generating the metadata

To begin, create a directory to hold the generated metadata:

```bash
mkdir -p ~/simplestreams/images
```
Now, if necessary, source the nova.rc file for your cloud:

```bash
. ~/nova.rc
```

We can now determine the region name for the cloud by running:

```bash
openstack endpoint list
```

The output from the above command will be similar to the following:

```no-highlight
+----------------------------------+-----------+--------------+--------------+
| ID                               | Region    | Service Name | Service Type |
+----------------------------------+-----------+--------------+--------------+
| 3cd5449e46c2427985c2ee4810241066 | RegionOne | nova         | compute      |
| 893e4cb67060462d9f2049f0be709587 | RegionOne | keystone     | identity     |
| 14c35ba5b03d44f48724ff53b4762136 | RegionOne | neutron      | network      |
| b3808463bcdd488a800c6025cb8b7bcc | RegionOne | glance       | image        |
| d16a01e7abca4b0c9124c3f13beec5af | RegionOne | swift        | object-store |
+----------------------------------+-----------+--------------+--------------+
```
Make a note of the region name (RegionOne in the above example). This will be
required in a later step.

Next, enter the following command to determine the Image ID of the
cloud image in glance:

```bash
openstack image list -f value
```

The following example output shows two images listed, Ubuntu 16.04
(Xenial) and Ubuntu 14.04 (Trusty). 


```no-highlight
e9df831d-9632-4e06-bd21-d047e4c5ef4e xenial active
6911e505-3610-4f42-b339-994cfe373174 trusty active
```
Take a note of the image IDs for the images you want added to Simplestreams.
These will be used in the next step.

!!! Note: 
    If you have images for multiple different series of Ubuntu, make sure
    you keep track of which series name matches which image ID.  The value
    $IMAGE_ID, used below, will apply to the image ID of the image for the
    particular series you are specifying and $OS_SERIES will be the series name
    ("trusty", "xenial", etc.).

We can now use Juju to generate the metadata:

``` no-highlight
juju metadata generate-image -d ~/simplestreams -i $IMAGE_ID -s $OS_SERIES -r $REGION -u http://$KEYSTONE_IP:5000/v2.0/
```

Replace these values with your own in the above command:

  - **$IMAGE_ID** - The image ID we are creating metadata for.
  - **$OS_SERIES** - The appropriate series this image relates to (e.g. Xenial).
  - **$REGION** - The region name of the cloud.
  - **$KEYSTONE_IP** - The address of the cloud's keystone server.

!!! Note:
    You can also specify, via the `--stream` option, an image stream (see
    [Image streams][image-streams]) that is not 'released' (i.e.
    'daily'). However, doing so will require you to specify this stream
    explicitly when using this metadata to create any subsequent controllers.

If you have images for multiple series of Ubuntu, run this command again for
each series substituting **$OS_SERIES** with the series name and **$IMAGE_ID** with
the image ID that matches that series.

To verify that the correct metadata files have been generated, you may run:

```bash
ls ~/simplestreams/*/streams/*
```

You should see .json files containing the details we just added on the images.

### Use of a local directory for image metadata

Stop here and return to the [bootstrap instructions][bootstrap].

## Upload the image metadata to an object store

!!! Note:
    Only those with admin privileges or who are operators in the OpenStack
    environment will be able to create a service and view endpoints used by the
    following instructions.

These instructions use Swift, however other object stores may be used as well.

### Requirements

 - [image metadata has been created with Juju][general].
 - python-openstackclient
 - python-swiftclient

### Create a Swift container and upload image metatdata

Enter the following command to create a new container for the Simplestreams
metadata:

```bash
openstack container create simplestreams
```

You can verify the container has been created by running:

```bash
openstack container list
```

Enter the following command to view the status of the container:

```bash
openstack container show simplestreams
```

Output will look similar to the following:

```no-highlight
+--------------+---------------+
| Field        | Value         |
+--------------+---------------+
| account      | v1            |
| bytes_used   | 0             |
| container    | simplestreams |
| object_count | 0             |
+--------------+---------------+
```

Notice the `objects_count` line. You should see that the container does not contain any
objects.

To upload the Simplestreams metadata to the container, enter the following:

```bash
cd ~/simplestreams
swift upload simplestreams *
```

The output to the previous command will list the json files imported into
Swift. Now check the status of the container:


```bash
swift stat simplestreams
```

This will produce output similar to the following:

```no-highlight
                      Account: v1
                    Container: simplestreams
                      Objects: 3
                        Bytes: 14261
                     Read ACL:
                    Write ACL:
                      Sync To:
                     Sync Key:
                Accept-Ranges: bytes
             X-Storage-Policy: default-placement
X-Container-Bytes-Used-Actual: 20480
                  X-Timestamp: 1484915544.60265
                   X-Trans-Id: tx00000000000000000000b-0058820665-1084-default
                 Content-Type: text/plain; charset=utf-8
```

Notice the `Objects:` line is showing multiple objects after uploading the
Simplestreams metadata.

Currently, there are no values for Read or Write ACLs, making this essentially a
private container. Enter the following command to add a Read ACL that will make
the container publicly accessible:

```bash
swift post simplestreams --read-acl .r:*
```
If you run the `swift stat simplestreams` command again, you will now see
`.r:*` adjacent to the 'Read ACL' field.

### Create a Simplestream service

Enter the following command to create a new service in the Keystone service catalog
for Simplestreams:

```bash
openstack service create --name product-stream --description "Product Simple Stream" product-streams
```

Next, enter the following command to determine the URL in Swift for the Simplestreams objects:

```bash
openstack endpoint show object-store
```

The output from the previous command will be similar to the following:

```no-output
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| adminurl     | http://10.9.21.62:80/swift       |
| enabled      | True                             |
| id           | d16a01e7abca4b0c9124c3f13beec5af |
| internalurl  | http://10.9.21.62:80/swift/v1    |
| publicurl    | http://10.9.21.62:80/swift/v1    |
| region       | RegionOne                        |
| service_id   | d4dff1dd2e4540f18714703379ea5015 |
| service_name | swift                            |
| service_type | object-store                     |
+--------------+----------------------------------+
```

There are two URLs for the Object Store is listed.  We will refer to the
`publicurl` field above as **$SWIFT_PUBLIC_URL** in the following commands
and the `internalurl` field as **$SWIFT_INTERNAL_URL**.

!!! Note: 
    You can verify the url before bootstrap with
    `wget $SWIFT_PUBLIC_URL/simplestreams/images/streams/v1/index.json`

Enter the following command to register the endpoint with the Simplestreams
service, when using Identity v3:

```bash
openstack endpoint create --region $REGION product-streams public $SWIFT_URL/simplestreams/images
openstack endpoint create --region $REGION product-streams internal $SWIFT_URL/simplestreams/images
```

Using Identity v2:

```bash
openstack endpoint create --region $REGION \
   --publicurl $SWIFT_PUBLIC_URL/simplestreams/images \
   --internalurl $SWIFT_INTERNAL_URL/simplestreams/images product-streams
```

!!! Note: 
    Juju will automatically look for a product-streams service during
    bootstrap to use for image streams.

## Using the Glance Simplestreams Sync charm to configure image streams.

The Glance Simplestreams Sync charm will do all of the above work for you and
provide customizeable syncing for automatic image updates.

### Requirements

 - OpenStack deployment by Juju

!!! Note: 
    You must have permissions to deploy charms in the Juju model running
    OpenStack to utilize this method for image metatdata management.


### Deploying the Glance simplestreams charm to your OpenStack Cloud

[Glance Simplestreams Sync][glance-simplestreams-sync]

It is recommended to set the charm's configuration variable use_swift to true
as Juju will automatically look for a product-streams service during bootstrap
to use for image streams.

!!! Note: 
    As of 6 June 2017, keystone v3 is not supported with this charm.
    Check [bug 1611987][lp1611987] for resolution.


!!! Note:
    An image stream will need to be explicitly stated, via the 'image-stream'
    model config option, if a non-default image stream was chosen during the
    metadata-creation step above.

See [Creating a controller][controllers-creating] for details on creating a
controller.


<!-- LINKS -->

[bootstrap]: ./clouds-openstack.md#bootstrap-with-juju
[glance-simplestreams-sync]: https://jujucharms.com/glance-simplestreams-sync/
[gsscharm]: #using-the-glance-simplestreams-sync-charm-to-configure-image-streams.
[lp1611987]: https://bugs.launchpad.net/charm-glance-simplestreams-sync/+bug/1611987
[general]: #create-image-metadata-with-juju
[object-store]:#upload-the-simplestreams-metadata-to-an-object-store
[image-streams]: #image-streams
[controllers-creating]: ./controllers-creating.md
