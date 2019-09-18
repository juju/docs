The major new features in this release are summarised below. See the Release Notes for full details.

<h2 id="heading--kubernetes-cloud-enhancements">Kubernetes cloud enhancements</h2>

- Kubernetes models are detected automatically and provisioner 'kubernetes' is assumed in the `create-storage-pool` command. This means shorter commands for operators.

- A MicroK8s installation is detected automatically and added as a known cloud ('microk8s'). Being a known cloud, a controller may now be created per usual (`juju bootstrap microk8s`). MicroK8s takes advantage of the previous enhancement as well. All this makes MicroK8s super easy to use with Juju. The [Using Juju with MicroK8s](/t/using-juju-with-microk8s-tutorial/1194) tutorial has been updated to include these new features.

- Kubernetes clusters from the below sources can be added as known clouds via the `add-k8s` command:

  - Azure Kubernetes Service (AKS)
  - Google Kubernetes Engine (GKE)
  - CDK (with an integrator charm) deployed to Amazon AWS, Microsoft Azure, Google GCE
  - CDK or kubernetes-core deployed to LXD

  Like MIcroK8s, these being known clouds a controller may be created, per usual, with the `bootstrap` command. 

- Kubernetes clusters are queried automatically when `add-k8s` is invoked and storage classe defaults are set up where possible. This removes the heartache out of figuring out what type of dynamic storage to use and then to set it up. If Juju does not succeed in this then the operator will be guided via an informational message.

<h2 id="heading--controller-context-for-commands">Controller context for commands</h2>

The context for several commands change from the local client cache to an existing controller.

This change amounts to a better user experience since most commands already use a controller as context by default. For example, when a model is added with `add-model` the model is added remotely, on a controller. When an application is deployed with the `deploy` command the application is deployed remotely. 

The below commands become remote by default:

- `add-cloud` (yet interactive mode is always local)
- `list-clouds`
- `add-k8s`
- `show-cloud`
- `remove-cloud`
- `update-cloud`

They each grow a `--local` option for when the operator wishes to explicitly apply a command locally.

Note that the `add-cloud` command only makes sense in a remote context when a cloud is being added to an existing controller. This makes use of the equally new multi-controller feature.

A caveat is when a client is first installed. In this state, it is not aware of any controllers and issuing the `list-clouds` command would therefore lead to a null output. This foreseeable situation is awkward and so the output includes explanatory text and displays local context output instead.

A related enhancement is that the `update-credential` command can update a remote credential directly from a local YAML file. Previously, a credential needed to be updated locally and then use that to update the credential remotely.

<h2 id="heading--model-migration-enhancements">Model migration enhancements</h2>

- When a model is migrated to another controller and a user (who had been previously granted access to the model) attempts to access it through the controller it was previously hosted on, they will get back an error with advisory information on how to access the model on its new location.

    - if the new location is an already known controller, the user will be guided to connect to it using the standard method (`juju switch -c <controller-name>)`.
    - if the new location is not a known controller, the user will be shown a fingerprint for the new controller's CA certificate and asked to log in to it (`juju login <IP address>:<port>`). Upon running the `login` command, the client will display the server's CA fingerprint and ask the user to trust it before the login attempt can proceed.

- When a model is attempted to be migrated to a controller that is missing some of the users that have been granted access to the model then the migration will be safely aborted. The operator will be guided on next steps (either remove the model users or add the users to the controller).

<h2 id="heading--better-removal-support">Better removal support</h2>

There is better support for the removal of Juju objects.

Juju object removal commands do not succeed when there are errors in the multiple steps that are required to remove the underlying object. For instance, a unit will not remove properly if it has a hook error or a model cannot be removed if application units are in an error state. This is a conservative approach to the deletion of things, which is good.

However, this policy can also be a source of frustration for users in certain situations (i.e. "I don't care, I just want my model gone!"). Because of this, several commands have grown a `--force` option.

Secondly, even when utilising the `--force` option the process may take more time than an operator is willing to accept (i.e. "Just go away as quickly as possible!").  Because of this, several commands that support the `--force` option have, in addition, been given a `--no-wait` option.

[note type=caution status=Caution]
The `--force` and `--no-wait` options should be regarded as tools to wield as a last resort. Using them introduces a chance of associated parts (e.g. relations) not being cleaned up, which can lead to future problems.
[/note]

As of `v.2.6.0`, this is the state of affairs for those commands that support at least the `--force` option:

command | `--force` | `--no-wait`
---------------|---------------|---------------
`destroy-model` | yes | yes
`detach-storage` | yes | no
`remove-application` | yes | yes
`remove-machine` | yes | yes
`remove-offer` | yes | no
`remove-relation` | yes | no
`remove-storage` | yes | no
`remove-unit` | yes | yes

When a command has `--force` but not `--no-wait` it indicates that the combination of those options simply does not apply.
