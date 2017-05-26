Title: Setting up private clouds with Simplestreams

#  Set up a Private OpenStack Cloud using Simplestreams


## Overview

When Juju bootstraps a cloud, it needs two critical pieces of information:
  1. The uuid of the image to use when starting new compute instances.
  1. The URL from which to download the correct version of a tools tarball.

This necessary information is stored in a json metadata format
called "simplestreams". For supported public cloud services
such as Amazon Web Services, HP Cloud, Azure, etc, no action is
required by the end user. However, those setting up a private
cloud, or who want to change how things work (eg use a different
Ubuntu image), can create their own metadata.

This page explains how to use Juju and additional tools to generate
this simplestreams metadata and configure OpenStack to use them.


## Requirements

 - python-openstackclient
 - python-swiftclient

### Generating the metadata

To begin, create a directory to hold the generted metadata

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

The region name will be required in a later step.

Next, enter the following command to determine the Image ID of the
cloud image in glance:

```bash
openstack image list -f value -c ID
```

Again, take note of this image ID which we will use in the next step

!!! Note: If you have images for multiple different series of Ubuntu,
make sure you keep track of which series name matches which image ID.
The value $IMAGE_ID will apply to the image ID of the image for the
particular series you are specifying and $OS_SERIES will be the
series name ("trusty", "xenial", etc.).

We can now use Juju to generate the metadata:

``` no-highlight
juju metadata generate-image -d ~/simplestreams -i $IMAGE_ID -s $OS_SERIES -r $REGION -u http://$KEYSTONE_IP:5000/v2.0/
```

substituting in the appropriate values:

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

You should see .json files for the images.

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

Notice the `Objects:` line. You should see that the container does not contain any
objects.

To upload the Simplestreams metadata to the container:

```bash
cd ~/simplestreams
swift upload simplestreams *
```

Check the status of the container:


```bash
swift stat simplestreams
```

Notice the `Objects:` line again. You should see that the container now contains objects
Currently, there are no Read or Write ACLs. This is essentially a private container.

Enter the following command to add a Read ACL that will make the container publicly
accessible:

```bash
swift post simplestreams --read-acl .r:*
```

### Create a simplestream service

Enter the following command to create a new service in the Keystone service catalog
for simplestreams:

```bash
openstack service create --name product-stream --description “Product Simple Stream” product-streams
```

We also need to  register an endpoint with the Simplestreams service.
Enter the following command to determine the project ID for the admin user:

```bash
openstack user show admin -f value -c project_id
```

This value will be used to replace the string $(tenant_id)s when we construct the Swift
URL in a future step.

Enter the following command to determine the URL in Swift for the Simplestreams objects:

```bash
openstack endpoint show object-store
```

Notice the URL for the Object Store. Replace the string $(tenant_id)s with the project
ID obtained in the previous step. We will refer to this modified URL as the '`SWIFT_URL`'.

Enter the following command to register the endpoint with the Simplestreams
service:

```bash
openstack endpoint create --region $REGION --publicurl $SWIFT_URL/simplestreams/images \
   --internalurl $SWIFT_URL/simplestreams/images \
   --publicurl $SWIFT_URL/simplestreams/images product-streams
```

### Bootstrap with Juju

Now the simplestream service is registered and running you can create a controller on
this cloud with the `juju bootstrap` command. The 

```bash
juju bootstrap <cloud> <controller name> --config tools-metadata-url=xxx.xxx.xx.xx
```

The metadata-url specified with the config option should point to the endpoint 
you created in the previous step.

If there are multiple possible networks available to the cloud, it is also necessary to 
specify the network label or UUID for Juju to use:

```bash 
juju bootstrap openstack
--config image-metadata-url=http://xxx.xxx.xxx.xxx/simplestream/images/
--config network=d54a6557-e114-4e26-98b8-55c814fb938a
```

