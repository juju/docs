Title: Setting up private clouds with Simplestreams

#  Set up a Private OpenStack Cloud using Simplestreams


## Overview

When Juju bootstraps a cloud, it needs two critical pieces of information:

  1. The UUID of the image to use when starting new compute instances.
  1. The URL from which to download the correct version of a tools tarball.

This necessary information is stored in a json metadata format
called "Simplestreams". For supported public cloud services
such as Amazon Web Services, HP Cloud, Azure, etc, no action is
required by the end user. However, those setting up a private
cloud, or who want to change how things work (eg use a different
Ubuntu image), can create their own metadata.

This page explains how to use Juju and additional tools to generate
this Simplestreams metadata and configure OpenStack to use them.


## Requirements

 - python-openstackclient
 - python-swiftclient

### Generating the metadata

To begin, create a directory to hold the generted metadata:

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

!!! Note: If you have images for multiple different series of Ubuntu, make sure
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

If you have images for multiple series of Ubuntu, run this command again for
each series substituting **$OS_SERIES** with the series name and **$IMAGE_ID** with
the image ID that matches that series.

To verify that the correct metadata files have been generated, you may run:

```bash
ls ~/simplestreams/*/streams/*
```

You should see .json files containing the details we just added on the images.

### Upload the Simplestreams Metadata to Swift

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

Notice the `ojects_count` line. You should see that the container does not contain any
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

The URL for the Object Store is listed against the `internalurl` field above
and we refer to this as **$SWIFT_URL** in the following commands.

Enter the following command to register the endpoint with the Simplestreams
service:

```bash
openstack endpoint create --region $REGION --publicurl $SWIFT_URL/simplestreams/images \
   --internalurl $SWIFT_URL/simplestreams/images product-streams
```

### Bootstrap with Juju

Now the Simplestream service is registered and running you can create a controller on
this cloud with the `juju bootstrap` command. 

```bash
juju bootstrap <cloud> <controller name> --config tools-metadata-url=$SWIFT_URL
```

If there are multiple possible networks available to the cloud, it is also necessary to 
specify the network label or UUID for Juju to use. Both the network label and
UUID can be retrieved with the following command:

```bash
openstack network list
```

Finally, use either the network label or the UUID with the 'network' configuration
option when bootstrapping a new controller:


```bash 
juju bootstrap openstack --config tools-metadata-url=$SWIFT_URL --config network=<network id>
```

