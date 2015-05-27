Title: Configuring Juju for Google Compute Engine

# Configuring Juju for Google Compute Engine

This process requires you to have a Google Compute Engine (GCE) account. If you
do not yet have one, log into your Google account and sign up at:
[cloud.google.com/compute/](https://cloud.google.com/compute/)

If you have not run Juju before, you should start by generating a generic 
configuration file for Juju, using the command:

```
juju generate-config
```

This will generate a file, `environments.yaml`, which will be put in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

**Note:** The above command will not overwrite your existing environments.yaml
file, or output to stdout. In order to see the boilerplate environments.yaml on
stdout you need to append the `--show` option. This is helpful if you have an
existing environments.yaml and just need to add a section. E.g. 
`juju generate-config --show`. You can then copy and paste the needed section.

The generic configuration section generated for Windows Azure will look
something like this:

```
    gce:
      type: gce
    
      # Google Auth Info
      # The GCE provider uses OAuth to authenticate. This requires that
      # you set it up and get the relevant credentials. For more information
      # see https://cloud.google.com/compute/docs/api/how-tos/authorization.
      # The key information can be downloaded as a JSON file, or copied, from:
      #   https://console.developers.google.com/project/<projet>/apiui/credential
      # Either set the path to the downloaded JSON file here:
      auth-file:
    
      # ...or set the individual fields for the credentials. Either way, all
      # three of these are required and have specific meaning to GCE.
      # private-key:
      # client-email:
      # client-id:
    
      # Google instance info
      # To provision instances and perform related operations, the provider
      # will need to know which GCE project to use and into which region to
      # provision. While the region has a default, the project ID is
      # required. For information on the project ID, see
      # https://cloud.google.com/compute/docs/projects and regarding regions
      # see https://cloud.google.com/compute/docs/zones.
      project-id:
      # region: us-central1
    
      # The GCE provider uses pre-built images when provisioning instances.
      # You can customize the location in which to find them with the
      # image-endpoint setting. The default value is the a location within
      # GCE, so it will give you the best speed when bootstrapping or adding
      # machines. For more information on the image cache see
      # https://cloud-images.ubuntu.com/.
      # image-endpoint: https://www.googleapis.com
```

In order to find out the necessary values to add to the configuration, you will
first have to set up a compatible project in GCE, by following these steps:

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

In either case above, you will be prompted to enter some details for the
project, specifically a name and a project ID. They will both be pre-populated
with random names, but as it will be useful to distinguish between multiple 
possible Juju projects, and any other projects you may create, it is a good idea
to create recognisable names. The `Project ID` needs to be unique, so adding
some random numbers or a UUID to the end is useful (though you will need to copy
this elsewhere, so don't make it too unwieldy)

![image showing project details](media/config-gce03.png)

## 3. Generate OAuth credentials for the project

Once you have created a project, you will be returned to the main console
screen. In order to let Juju have access to the environment, you will need to
generate and retrieve some credentials. In the navigation on the left, you
should select `APIs & auth`, and then select `Credentials` from the panel which
will appear.

![image showing main screen](media/config-gce04.png)

On the credentials page itself, select 'Create new Client ID'

![image showing API page](media/config-gce05.png)

A pop-up will appear asking which type of credential to generate. You *must* 
select the `Service account` option - Juju needs these credentials to be able to
create new instances.

![image showing account popup](media/config-gce06.png)

## 4. Retrieve the credentials

Once you have clicked on the `Create Client ID` button, the GCE website will
automatically generate a JSON file containing the credentials and download it
through your browser. This file contains all the information required for Juju
to connect to the GCE project.
This can be used in two ways as described below.
If for any reason you lose this information, you *cannot* regenerate the
private key. You can however generate a new key by returning to the credentials
page and clicking on the `Generate new JSON key` button, after which you may
want to delete the original fingerprint entry from the list on the same page.

## 5. Enter the credentials into your environments.yaml file

There are two ways to add this information to the environments.yaml file used by
Juju, both of which are explained here:

### 5.a Use the JSON file directly

Juju can decipher the contents of the JSON file you downloaded from GCE. In this
case it is necessary to store the actual file somewhere where Juju can access it
directly. The recommended place for this is in the Juju users' `.juju/`
directory, where it will accessible and presumably included in any backup
procedures in place.

In this case, the `Auth` section of the gce part of the `environments.yaml`
configuration should contain the *full path* to the file, e.g.:

```
 # The key information can be downloaded as a JSON file, or copied, from:
 #   https://console.developers.google.com/project/<projet>/apiui/credential
 # Either set the path to the downloaded JSON file here:
 auth-file: /home/juju-user/.juju/Juju-GCE-7e04ea455a2d.json
```

### 5.b Use the information in the JSON file to edit the configuration

In cases where you don't want to rely on an extra file to authorise access, it
is possible to extract the key pieces of information from the downloaded JSON
file, though be warned that it may be messy!
The values needed are the `private-key`, `client-email` and `client-id`. The
latter two are easy enough to extract from the JSON file, but in order to format
the private-key string into valid yaml, you will need to do some editing.
Remember that 
[you can use the `|` character](http://www.yaml.org/spec/1.2/spec.html#id2760844)
as the first line of a YAML value to interpret all subsequent indented text as a
continuous string. You will need to strip out line endings and translate any 
unicode characters in the string. A simple way to pre-format some of this
information is to run something like:

```
python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < gce-auth-file.json 
```

In any case, the auth section of the config file should look something like
this:

```
client_email: 1875876080463-bsssadkian8h395vc11kl@developer.gserviceaccount.com
client_id: 1875876080463-bsssadkian8h395vc11kl.apps.googleusercontent.com
private_key: |
  -----BEGIN PRIVATE KEY-----
  MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAOqasd71HPJPzekB
  /0OiLIZ64Xc5oMoknrxmuhtbfzsNbom5o61K2INGWCS7zzhPRKgTV2+Im0ov4c7H
  VF5BbxbstLvH8zaWj7sgt2CoAf35MH6HBTby09qa5v0aPhmod2vMBnGY7TQBSO1L
  DpJcRcxljV11QqP9JRSkJ0D5VXt5AgMBAAECgYEAvYgwfyGjOxfCEKauZSOVuSd5
  E2sZPXYMT8TmQnat35f4+h4FT5MYPHpr/OS27kejHLjxpWkbz3Dziqx6upM+fMiY
  ...
```

## 6. Add the Project ID

The credentials do not include the ID of the project you created for Juju to
use, and this needs to be added to the `environments.yaml` configuration too, 
under the section commented with `"# Google instance info"`. The project ID is 
whatever you entered when you created the project. If, by this stage, you have 
forgotten that ID, you can retrieve it from the 
[main project page on GCE - https://console.developers.google.com/project](https://console.developers.google.com/project)

![image showing project page](media/config-gce07.png)


this section of the config should then look like this, for example:

```
      # Google instance info
      # To provision instances and perform related operations, the provider
      # will need to know which GCE project to use and into which region to
      # provision. While the region has a default, the project ID is
      # required. For information on the project ID, see
      # https://cloud.google.com/compute/docs/projects and regarding regions
      # see https://cloud.google.com/compute/docs/zones.

      project-id: juju-gce-0202030

```

Obviously, you should replace `juju-gce-0202030` above with your own project id.

## 7. Optional configuration

The default value for `region` is `us-central1`. This may be changed to any
valid available GCE zone (e.g. `us-central1-b`, `europe-west1-d`,`asia-east1-a`
...). A complete and up to date list of the zones, and what using them may
entail is explained on the relevant GCE page at 
[https://cloud.google.com/compute/docs/zones](https://cloud.google.com/compute/docs/zones)

You may also wish to check out the 
[additional general configuration options](config-general)
for additional settings which can be configured for this environment.

