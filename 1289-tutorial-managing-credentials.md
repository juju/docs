The goal of this tutorial is to provide some practical information for managing credentials. It tries to not reiterate what is already provided on the [Credentials](/t/credentials/1112) page but approaches the subject from a more practical level where often misunderstood concepts are reinforced and field-reported scenarios are looked at.

*The contents of this tutorial was presented on the Juju Show (April 10 2019), in abridged form, with a slide deck. PDF available here:* <a class="attachment" href="/uploads/default/original/1X/02942d3045fce0066f58158e97a7fe0cc5dc6dfb.pdf">Lets-talk-about-credentials.pdf</a> (238.7 KB).

## Prerequisites

The following prerequisites are assumed as a starting point for this tutorial:

- You're using Ubuntu 18.04 LTS (Bionic).
- Juju (`v.2.5.2`) is installed. See the [Installing Juju](/t/installing-juju/1164) page.
- You have chosen a backing cloud and have created a controller for it. Refer to the [Clouds](/t/clouds/1100) page to get started with a cloud and controller.
 
This guide uses [Google GCE](/t/using-google-gce-with-juju/1088) as a backing cloud.

## Credential operations

This is the list of the discreet operations that are possible when managing credentials:

- Add a local credential
- Remove a local credential
- List local credentials
- List remote credentials
- Set a default local credential
- Relate a remote credential to a model
- Change a local credential
- Change a remote credential

There are all covered on the [Credentials][credentials] page. 

## Topics covered in this tutorial

- [Credential definition](#heading--credential-definition)
- [Local credentials](#heading--local-credentials)
- [Default local credential](#heading--default-local-credential)
- [Remote credentials](#heading--remote-credentials)
- [Credential used when creating a controller](#heading--credential-used-when-creating-a-controller)
- [Credential used when adding a model](#heading--credential-used-when-adding-a-model)
- [Tracking what remote credential is used by a model](#heading--tracking-what-remote-credential-is-related-to-a-model)
- [Managing credentials with multiple users](#heading--managing-credentials-with-multiple-users)
- [Dealing with expired credentials](#heading--dealing-with-expired-credentials)
- [Dealing with a reanimated cloud account](#heading--dealing-with-a-reanimated-cloud-account)
- [Dealing with inert credentials](#heading--dealing-with-inert-credentials)

<h3 id='heading--credential-definition'>Credential definition</h3>

A Juju *credential* represents a collection of authentication material (like username & password, or client id & secret key) that is specific to a cloud and to a Juju user. This bundle of data is managed by means of a user-defined string: the *credential name*. This name is not a Juju user nor is it the username of the underlying cloud account. It is an arbitrary label that is assigned when the credential was created with the `add-credential` command.

Every credential is born (created) from a specific Juju client, which, in turn, is bound to an independent  computer host ("device"). There is thus no central way to constrain what credential names get used nor oversee what authentication material they represent. Because of this, different devices can associate the same name with different material, or the opposite, a different name with the same material. This is something to keep in mind, especially in a multi-user context.

<h3 id='heading--local-credentials'>Local credentials</h3>

When a credential is created it is local to the Juju client that created it. It is therefore known as a *local credential* and can be listed with the `credentials` command. Specifying YAML formatted output makes things explicit:

```bash
juju credentials --format yaml
```

Sample output:

```yaml
local-credentials:
  google:
    gandalf:
      auth-type: oauth2
      client-email: 524443925537-compute@developer.gserviceaccount.com
      client-id: "112674610382273922048"
      project-id: juju-gce-1725
```

Notice how the output says 'local-credentials'.

Here, 'gandalf' is the credential name for cloud 'google' for the currently logged in Juju user.

<h3 id='heading--default-local-credential'>Default local credential</h3>

When a Juju operation is in need of a local credential it is either specified implicitly, via a defined default local credential, or explicitly, via the `--credential` option.

A credential can be defined as the default local credential in two ways:

1. Manually by using the `set-default-credential` command
1. Automatically when the `bootstrap` command is invoked

The automatic method is applied when a sole local credential exists when a controller is created.

The default local credential is annotated with an asterisk in the output for the `credentials` command. Below, credential 'tharkun' is the default local credential for cloud 'google' for the currently logged in Juju user:

```no-highlight
Cloud   Credentials
google  tharkun*, gandalf, mithrandir
```

[note type="important" status="Remember"]
The `--credential` option always refers to a local credential.
[/note]

<h3 id='heading--remote-credentials'>Remote credentials</h3>

In order for Juju to make use of a cloud it must first authenticate with that cloud, and does so via the Juju  controller. Therefore, a local credential must first get uploaded from the client to the controller. Once this happens the credential become known as a *remote credential*. The `show-credentials` command lists all remote credentials for the currently logged in Juju user:

```bash
juju show-credentials
```

Sample output:

```yaml
controller-credentials:
  google:
    gandalf:
      content:
       auth-type: oauth2
       client-email: 524443925537-compute@developer.gserviceaccount.com
       client-id: "112674610382273922048"
       project-id: juju-gce-1725
      models:
        controller: admin
        default: admin
```

Notice how the output says 'controller-credentials'.

Here we see that credential 'gandalf' is associated with cloud 'google' and two models: 'controller' and 'default'. The currently logged in user (the owner of credential 'gandalf') is shown to have 'admin' model access to both of the aforementioned models.

A remote credential is required whenever a model is created. There are two cases:

1. a model is created implicitly via the `bootstrap` command
1. a model is created with the `add-model` command

In the first case a local credential is solicited to become a remote credential and in the second case either a local credential or an existing remote credential is solicited.

[note type="important" status="Recall"]
Besides creating a new controller, the `bootstrap` command also sets up models 'controller' and 'default'.
[/note]

A remote credential is associated with one cloud, one Juju user, and one or more models.

Note that it is possible for a remote credential to not be related to a model (the model was removed or a private cloud, although very rare, may not require authentication).

Since `v.2.6.0`, a credential needs to be added to a cloud before adding that cloud to an existing (multi-cloud) controller.

<h3 id='heading--credential-used-when-creating-a-controller'>Credential used when creating a controller</h3>

When a controller is created a local credential is uploaded to the controller and related to models `controller` and `default`. The local credential that gets used is selected according to the following rules, in the order given:

1. the one that has been explicitly chosen via the `--credential` option
1. the one that has been defined as the default local credential
1. the sole existing one

The `bootstrap` command will error out if a credential cannot be found using the above rules. This would occur when the following is true: there are multiple local credentials; the `--credential` option was not used; and a default local credential was not set.

[note type="important" status="Remember"]
Only local credentials are considered when creating a controller.
[/note]

<h3 id='heading--credential-used-when-adding-a-model'>Credential used when adding a model</h3>

When a model is added a remote credential is related to that model. The remote credential that gets used (for the current Juju user and the given cloud) is selected according to the following rules, in the order given:

1. an uploaded local credential, chosen via the `--credential` option
1. the sole existing one

Recall that the `--credential` option always refers to a local credential. Therefore, in this context, the local credential is first uploaded to the controller, thereby becoming a remote credential, and *then* related to the model.

The `add-model` command will error out if a credential cannot be found using the above rules. This would occur when the following is true: there are multiple remote credentials and the `--credential` option was not used.

[note type="important" status="Note"]
There is no concept of an actual default remote credential.
[/note]

<h3 id='heading--tracking-what-remote-credential-is-related-to-a-model'>Tracking what remote credential is related to a model</h3>

To determine what remote credential is related to a model examine the output of the `show-model` command. It will include the model's credential name, the credential owner (the Juju user who uploaded it), and the cloud:

```bash
juju show-model default
```

Sample output:

```yaml
default:
  name: admin/default
  short-name: default
  .
  .
  .
  credential:
    name: jlaurin
    owner: admin
    cloud: aws
```

Above, remote credential 'jlaurin' is related to model 'default'.

As we saw earlier, the `show-credentials` command can be used to determine what model (or models) a credential is related to:

```bash
juju show-credentials
```

Sample output:

```yaml
controller-credentials:
  google:
    saruman:
      content:
  .
  .
  .
      models:
        isengard: admin
        orthanc: admin
```

Above, remote credential 'saruman' is related to models 'isengard' and 'orthanc'.

If there were multiple remote credentials they would have all been shown. To target a single cloud:credential combination, use the `show-credential` command:

```bash
juju show-credential google saruman
```

<h3 id='heading--managing-credentials-with-multiple-users'>Managing credentials with multiple users</h3>

Let's set up a multi-user context by adding a user and granting that user 'add-model' permissions:

```bash
juju add-user frodo
juju grant frodo add-model
```

Once this user has registered the controller (`register` command) that user may attempt to add a model:

```bash
juju add-model shire
```

This will generate a message indicating that a credential has not been found. This is due to user 'frodo' being devoid of both a remote credential and a local credential:

```no-highlight
ERROR detecting credentials for "google" cloud provider: gce credentials not
found
```

If multiple local credentials are added, say 'potatoes' and 'beer', and the operation is re-attempted an error is once again emitted. This time it's due to not having selected a credential from among the multiple ones available:

```no-highlight
ERROR more than one credential is available. List credentials with:

    juju credentials

and then run the add-model command again with the --credential option.
```

This user can therefore add a model in this way:

```bash
juju add-model --credential potatoes shire
```

<h3 id='heading--dealing-with-expired-credentials'>Dealing with expired credentials</h3>

There have been reports of cloud vendors expiring account credentials. The effect of an expired credential is the inability for Juju to administer any models associated with that credential. Note that workloads will continue to run.

To rectify the situation, first contact the cloud vendor and update your existing credential or re-issue a new one. Once that's done, you will need to do one of the following:

1. update the existing Juju credential on the controller
1. create a new credential and relate it to affected models

We'll look at each of these options in greater detail below.

[note]
You can simulate an expired credential by deactivating the corresponding account on your cloud's dashboard or via its API. 
[/note]

**Option 1: Update the existing remote credential**

To change the remote credential the `update-credential` command is used. It does this by uploading the  identically named local credential to the controller. Therefore, the local credential first needs to be changed.

The local credential contents are changed with the `add-credential` command, where the `--replace` option is needed because the credential is already existing.

```bash
juju add-credential --replace google -f credentials-gandalf-changed.yaml
juju update-credential google gandalf
```

Here, the contents of credential 'gandalf' was modified in file `credentials-gandalf-changed.yaml`.

In `v.2.6.0`, the `update-credential` command supports the consumption of a YAML file. So here we bypass the local client cache:

```text
juju update-credential google gandalf -f credentials-gandalf-changed.yaml
```

**Option 2: Create a new credential and related it to affected models**

To add an entirely new local credential the `add-credential` command is used. To relate a remote credential to a model the `set-credential` command is used. Here we presume that affected models are 'shire' and 'rohan':

```bash
juju add-credential google -f credentials-mithrandir.yaml
juju set-credential -m shire google mithrandir
juju set-credential -m rohan google mithrandir
```

Above, the contents for remote credential 'mithrandir' were added to file `credentials-mithrandir.yaml`.

[note type="important"]
A credential targeted with the `set-credential` command will upload the identically-named local credential if it is not found remotely.
[/note]

<h3 id='heading--dealing-with-a-reanimated-cloud-account'>Dealing with a reanimated cloud account</h3>

Closely related to the previous case of credentials expired by the cloud vendor is the scenario where the cloud account was deactivated by the cloud account administrator. Every cloud vendor has the functionality to do this and it can be accomplished via the cloud's API or via its web dashboard.

A deactivated cloud account will naturally also result in an invalid credential on the Juju side. A reasonable way forward would be to simply reactivate the account, but this is insufficient. This is because Juju has already invalidated the credential. The solution is as before: "update" the existing Juju credential on the controller with the `update-credential` command. However, you do not need to actually replace the credential's contents. You just need to announce to the controller that the credential is a good one.

Assuming, therefore, that the account has been made active again and it is associated with Juju credential 'tharkun', simply proceed as follows:

```bash
juju update-credential google tharkun
```

<h3 id='heading--dealing-with-inert-credentials'>Dealing with inert credentials</h3>

Closely related to the previous case of credentials not working as a result of a deactivated cloud account is the case where the cloud account credentials inexplicably stop working. This has been reported with vSphere, for instance, and whose cause is probably due to a glitch in the vendor software.

The solution is as before: "update" the existing Juju credential on the controller with the `update-credential` command. However, you do not need to actually replace the credential's contents. You just need to announce to the controller that the credential is a good one.

Assuming, therefore, that the account is associated with Juju credential 'goblins', simply proceed as follows:

```text
juju update-credential vsphere goblins
```
