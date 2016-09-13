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

### 

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

juju metadata generate-image -d ~/simplestreams -i $IMAGE_ID -s $OS_SERIES -r $REGION -u http://$KEYSTONE_IP:5000/v2.0/

substituting in the appropriate values:

  - **$IMAGE_ID** - The image ID we are creating metadata for.
  - **$OS_SERIES** - The appropriate series this image relates to (e.g. Xenial)
  - **$REGION** - The region name of the cloud.

Note:

If you have images for multiple series of Ubuntu, run this command again for

each series substituting OS_SERIES with the series name and IMAGE_ID with

the image ID that matches that series.

2. Enter the following command to view the metadata files:

ls ~/simplestreams/*/streams/*

You should see .json files for the images.

14| 2 Upload Simplestreams Metadata into Swift

Description:

In this exercise, you upload the Simplestreams metadata as objects into Swift.

Note: You should have generated the Simplestreams metadata in the

~/simplestreams directory before performing this exercise.

Task 1: Upload the Simplestreams Metadata to Swift

1. If it the python-swiftclient package is not already installed, enter the following

command to install it:

sudo apt-get install -y python-swiftclient

2. Enter the following command to source in the nova.rc file:

. ~/nova.rc

Note:

We need to source in the nova.rc file rather the then project specific .rc file

because we will be uploading the Simplestreams metadata to the Admin project

131

Install and Configure an Ubuntu OpenStack Cloud

and then make it publicly accessible. This way it is available to all tenants in the

private cloud.

3. Enter the following command to create a new container for the Simplestreams

metadata:

openstack container create simplestreams

4. Enter the following command to display the newly created container

openstack container list

You should see the new container listed

5. Enter the following command to view the status of the container:

openstack container show simplestreams

Notice the Objects: line. You should see that the container does not contain any

objects.

6. Enter the following commands to upload the Simplestreams metadata to the

container:

cd ~/simplestreams

swift upload simplestreams *

7. Enter the following command to view the status of the container:

swift stat simplestreams

Notice the Objects: line again. You should see that the container now contains objects

8. Enter the following command to list the objects in the container:

swift list simplestreams

You should see the files listed.

Task 2: Set ACLs on a Container

1. Enter the following command to display information about the Simplestreams

container:

swift stat simplestreams

Notice that there are no Read or Write ACLs. This is essentially a private container.

2. Enter the following command to add a Read ACL that will make the container publicly

accessible:

swift post simplestreams --read-acl .r:*

3. Enter the following command to display information about the container again:

swift stat simplestreams

You should see the Read ACL listed now.


Summary:

In this exercise, you used the swift command to create a new container and then

uploaded the Simplestreams metadata into the container. Lastly you added a Read

ACL to the container to make it publicly accessible.

(End of Exercise)

14| 3 Create Simplestreams Service and Endpoint

Description:

In this exercise, you upload the create a simplestreams service in the Keystone

service registry and then register an endpoint for the service.

Task 1: Create Simplestreams Service

1. Enter the following command to create a new service in the Keystone service catalog

for simplestreams:

openstack service create --name product-stream \

--description “Product Simple Stream” product-streams

Task 2: Register an Endpoint with the Simplestreams Service

1. Enter the following command to determine the project ID for the admin user:

openstack user show admin -f value -c project_id

This value will be used to replace the string $(tenant_id)s when we construct the Swift

URL in a future step.

2. Enter the following command to determine the URL in Swift for the Simplestreams

objects:

openstack endpoint show object-store

Notice the URL for the Object Store. Replace the string $(tenant_id)s with the project

ID obtained in the previous step. We will refer to this modified URL as the

SWIFT_URL

3. Enter the following command to register the endpoint with the Simplestreams

service:

openstack endpoint create \

--region RegionOne \

133

Install and Configure an Ubuntu OpenStack Cloud

--publicurl SWIFT_URL/simplestreams/images \

--internalurl SWIFT_URL/simplestreams/images \

--publicurl SWIFT_URL/simplestreams/images product-streams

Summary:

In this exercise, you used the swift command to create a new container and then
uploaded the Simplestreams metadata into the container. Lastly you added a Read
ACL to the container to make it publicly accessible.


