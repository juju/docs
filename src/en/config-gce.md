# Overview

???


# Prerequisites and installation

 - A Google account is required. See http://google.com.

 - A GCE account is required. See https://cloud.google.com/compute/.

 - The Juju devel PPA (may change) is needed.

 - The Juju client (the host running the below commands) will need the ability
   to contact the GCE infrastructure on TCP ports 22 and 17070.

Proceed to install the software.

```bash
sudo apt-add-repository -y ppa:juju/devel
sudo apt-get update
sudo apt-get install -y juju-core
```

## Google Compute Engine API

The Google Compute Engine API needs to be enabled for your new project in order
for Juju to communicate with it. This is done automatically if you have set up
a "billing method". A trial account typically suffices as a billing method. By
following the below steps you will discover whether you need to do something or
not.

At the top-left of the web UI there is an icon representing 'Product &
services'. It is denoted by this icon:

![Product & services icon](./media/config-gce-product_services_icon.png)

Click through and select 'API Manager'. By default you will be on the 'Overview'
screen, it will show:

![API Manager screen](./media/config-gce-api_manager.png)

Select 'Compute Engine API'. This will show:

![Compute Engine API](./media/config-gce-api_manager_compute_enabled.png)

The API is enabled if the button displays 'Disable API'.


## GCE project credentials file

A collection of credentials-related material will be required. This is obtained
by downloading a file from the UI.

Return to the 'API Manager' and choose the 'Credentials' screen. By default you
will be within the 'Credentials' tab. Click the 'New credentials' button and choose
'Service account key' among the 3 options available:

![Create credentials dialog #1](./media/config-gce-api_manager_create_credentials-1.png)

In the ensuing dialog, select 'Compute Engine default service account' and 'JSON'
key type:

![Create credentials dialog #2](./media/config-gce-api_manager_create_credentials-2.png)

Once the 'Create' button is pressed you will be prompted to download a file.
This is the file we're after. Store it safely as this file cannot be
regenerated (although a new one can easily be created).

Place this file where the Juju client can find it. This may or may not be on
the computer you downloaded the file to. We recommend the `~/.juju` directory.
For the current example, the file is called, based on our project name of
'Juju-GCE', `Juju-GCE-f33a6cdbd8e3.json`. Let it be put here:

`/home/ubuntu/.juju/Juju-GCE-f33a6cdbd8e3.json`

!!! Warning: Due to
[LP #1533790](https://bugs.launchpad.net/juju-core/+bug/1533790) make a copy of
the original file and put it in another location. Edit the original file by
removing the lines containing these keywords: 'project-id', 'auth-uri',
'token_uri', 'auth_provider_x509_cert_url', and 'client-x509-cert-url'.


# Configuring for GCE

If this is a new Juju install then you do not yet have a
`~/.juju/environments.yaml` file. Create one with

```bash
juju generate-config
```

If it does exist (but it was created with an older version of Juju), first move
it out of the way (back it up) and *then* generate a new one. Alternatively,
you can output a generic file to screen (STDOUT) and paste the Azure parts into
your existing file:

```bash
juju generate-config --show
```

The file will contain a section for the Azure provider.


## Configure and bootstrap

Values will need to be found for the following parameters:

 - auth-file
 - project-id

### `auth-file`

The value of `auth-file` is the path to the credentials file downloaded previously.

  "type": "service_account",
  "private_key_id": "f33a6cdbd8e3df4510ebb97cb866f72ac3497306",
CkC2si4Rvz0NYZal63WKcqn8\nrgeIhrGPhfQ7y8i939CY2AZvEnbS0xetpIc15UUpMQKBgQDvZxYzij3rlPJaHW1x\nCOe3fe/qWrctdWRhPbEpmUWB3R6RFv8GFpigozAt41bPDYYMc0SXYKkJKm5szcE6\nTvWsAnaKx+X81Zz3jzo2+EVI2fM+CpYSdWl9OVzQQ2NMY4kgEdBW0CWCnNJAdCck\nxBPm1Pbhpinj8EyOe5+OMcaYKwKBgQCwvGAsn8bcSoHTT35c1HFe6qhj8+WZP6WT\nc21V4T0/a+Ud7JaxN4Saw8NyYjEsGRmQFrtHr2/AhRYdSq5fpD5/aXZ8hN8mIRMo\n59aiu0/bvlOMOFTCrYDELOEHQr9v3pC2oiyyp86BLBklEC6ubZkN+c2cSLA4TCU9\nrWiYoNL5FQKBgGmzklHfT8ecVAUFyTSHQgf6StumggpIMrHck0RSsCXOg5h8Fs2R\nXIJQiw03uzRgPDdzDW3o97lcSrUvg4lDI6V20PAlop4nks6bJpDuvWiVEpjqA6jS\nvmjT0u8BUe6AZCMMungaHvW0WACtSDsrd74LeZXXz9ccWjDu1FvsDktRAoGBAJYX\nlLGxC2hAGltDsnPRs2pBbLpeAkoQhGRh7aO2gpZe4hh0uVFNbd8li9GTVGE3+76j\nn270rbpZC/vaVZZB3RXFkeuTyBMQmb3ujhhrbRmYXEnD+S/Pu4BfAMhyxjOSV2HS\n/pTG8BhBRCV2xb46s3XsBNLJ5GYbPLFRmHeudR01AoGAPAxUmIP0E3RTkC3EdeZY\nfrwDAKj3NBLI6oDu83NizaFXA4l7VKH0sesWk9EmapSsRCI+E6l99ti5hbBDrEqT\nNGuQja/RKZHbm35eSf2as4HDHGZNGEMib1ZVETyyo8xqOKqNZ+t2M/qM1c38noQA\neWjQE2W5OGJNHguxRcvx7ew=\n-----END PRIVATE KEY-----\n",
  "client_email": "juju-gce-service-account@juju-gce-1202.iam.gserviceaccount.com",
  "client_id":
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQClRwjoIFo6qdX+\n7EtxOW983Xf9J26dP9K6a1GzQd5Pd/9MSDFwQDBiHQVI7CjsI4Iu3pJPbE/6rBmZ\n5fyZuVETdm9gqpC09d4AcFMABOqAiYIouS8OOeuekScUfplJcFMNDTUwxXkfZCiL\nABzvgXS3T46sS86gkVna+2SUovSfGFsdeNMuMP86+Hy5A9QbJTQOn7wsT+64QXW1\nr7ugngm17yUeuHjxmTKnAh/EaF8a7VSPDFVNFjv/2yFN1adHQmRJZLzNiJLD0389\nA0pRGxfK3busNDfd/xDo56bbo3zKB5tIpDflYb8/HkVULcsH2T9PcSzso7yKU//h\nKp/ykk6HAgMBAAECggEAJoy5ARt6sDAo37rRpekVnfQyJnPqEvdt+VlKxxrX9YUx\noOM91MbEAj5umyGqMdneZXw4eBn1VayKlCDWmCxnQrjfJZbjBbJLQ6LvWRPMdoqc\nN09qMFFGKcgFa3xT2JNAa8zm2SdWJwI/ipxOI3b4eEEwL/PGkCEW6kK0pQ6VK/4r\nQmEL3q9JgikMLd10pzlSuQUGlS1Sad2qVBxkASdf7zfEZnPm4nDprKE1D6za44K1\nJ0hO087xuNdZkXTqKu7eSJnBVfU/wIM9ecIg

According to all the above, the GCE section of file `environments.yaml` for
this example would look like this (comments removed for simplicity):

```yaml
        storage-account-type: Standard_LRS
        location: East US
        subscription-id: f717c8c1-8e5e-4d38-be7f-ed1e1c879e1a
        application-password: some_password
        application-id: f6ab7cbd-5029-43ef-85e3-5c4442a00ba8
        tenant-id: daff614b-725e-4b9a-bc57-7763017c1cfb
```

Finally, switch to the Azure provider and bootstrap:

```bash
juju switch azure
juju bootstrap --debug
```

A successful bootstrap will result in the controller being visible in the
[Azure portal](http://portal.azure.com):

![bootstrap machine 0 in Azure portal](./media/azure_portal-machine_0.png)


# Additional notes

See [General configuration options](https://jujucharms.com/docs/stable/config-general)
for additional and advanced customization of your environment.



++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++









The minimal configuration will look
something like this:

```yaml
    gce:
      type: gce
      auth-file: /home/ubuntu/.juju/Juju-GCE-f33a6cdbd8e3.json
      project-id: juju-gce-1202
```

## 1. Create a Google Compute Engine project

If this is the first time you have used GCE, you will be prompted to set up a 
project with this screen:

![image showing prompt](media/config-gce01.png)

**OR:**

If you already have a GCE account, login to the main GCE page at:
[https://console.developers.google.com/project](https://console.developers.google.com/project)
... and select `Create a project` from the pull-down menu:

![image showing menu](media/config-gce02.png)


## 2. Enter details for the project


## 3. Enable the Google Compute Engine API


## 4. Generate OAuth credentials for the project


## 5. Retrieve the credentials


## 6. Enter the credentials into your environments.yaml file

Juju can decipher the contents of the JSON file you downloaded from GCE. In this
case it is necessary to store the actual file somewhere where Juju can access it
directly. The recommended place for this is in the Juju users' `.juju/`
directory, where it will accessible and presumably included in any backup
procedures in place.


## 7. Add the Project ID


## 8. Optional configuration

The default value for `region` is `us-central1`. This may be changed to any
valid available GCE zone (e.g. `us-central1-b`, `europe-west1-d`,`asia-east1-a`
...). A complete and up to date list of the zones, and what using them may
entail is explained on the relevant GCE page at 
[https://cloud.google.com/compute/docs/zones](https://cloud.google.com/compute/docs/zones)

You may also wish to check out the 
[additional general configuration options](config-general)
for additional settings which can be configured for this environment.
