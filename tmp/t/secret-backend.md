(secret-backend)=
# Secret backend

> <small>{ref}`Secret <secret>` >  Secret backend </small>
>
> See also: {ref}`How to manage secret backends <how-to-manage-secret-backends>`

A **secret backend** is a service that is used to store sensitive content which Juju manages as {ref}`secrets <secret>`.

Secret backends are per model.

A secret backend is identified by a name and a type, and admits various configuration options, some of them generic and some backend-type-specific. 

**Contents:**

- [Name](#heading--name)
- [Type](#heading--type)
- [Configuration options](#heading--configuration-options)

<a href="#heading--name"><h2 id="heading--name">Name</h2></a>

The name of a secret backend can be: 

- `auto` (i.e., `internal` for machine models and `local` for Kubernetes models)
- `internal`
- `<some custom name>`

The name is set via the `secret-backend` model configuration key.

> See more: {ref}`List of model configuration keys <list-of-model-configuration-keys>`

<a href="#heading--type"><h2 id="heading--type">Type</h2></a>

The type of a secret backend can be:

- [`controller`](#heading--controller)
- [`kubernetes`](#heading--kubernetes)
- [`vault`](#heading--vault)

For production use, we recommend Vault.

<a href="#heading--controller"><h3 id="heading--controller">`controller`</h3></a>

The `controller` backend is the Juju model database. 

It is the default secret backend for machine (VM) models. 


<a href="#heading--kubernetes"><h3 id="heading--kubernetes">`kubernetes`</h3></a>

The `kubernetes` backend is the model's Kubernetes namespace. 

It is the default secret backend for container (Kubernetes) models. 

Available starting with Juju 3.1.


<a href="#heading--vault"><h3 id="heading--vault">`vault`</h3></a>

The `vault` backend refers to the Hashicorp Vault. 

It is available as an opt-in to both machine (VM) and container (Kubernetes) models.

Available starting with Juju 3.1.


<a href="#heading--configuration-options"><h2 id="heading--configuration-options">Configuration options</h2></a>



- [Generic](#heading--generic)
- [Backend-specific](#heading--backend-specific)

<a href="#heading--generic"><h3 id="heading--generic">Generic</h3></a>

The generic configuration keys currently include just the following:

|||
|-|-|
|`token-rotate` | The maximum period for which an access token is valid for. Some time prior to the token expiring Juju will generate a new one. Possible values: standard Go duration (e.g., 2h, 7d). The minimum is 1h.|

The `vault` backend is the only one that supports it for now.

<a href="#heading--backend-specific"><h4 id="heading--backend-specific">Backend-specific</h4></a>

The `vault` backend is the only one that supports specific configuration keys. These are:

|||
|---|---|
|`ca-cert`|The path to a PEM-encoded CA certificate file on the local disk. This file is used to verify the Vault server's SSL certificate.|
|`client-cert`|The path to a PEM-encoded client certificate on the local disk. This file is used for TLS communication with the Vault server.|
|`client-key`|The path to an unencrypted, PEM-encoded private key on disk which corresponds to the matching client certificate.|
|`endpoint`||
|`namespace`|The namespace to use for the command. Setting this is not necessary but allows using relative paths.|
|`tls-server-name`|The name to use as the SNI host when connecting via TLS.|
|`token`|The vault authentication token.|

> See more: [Vault | `vault server`](https://fig.io/manual/vault/server), [Hashicorp | Vault commands](https://developer.hashicorp.com/vault/docs/commands#args). <br> (You will see more options there as we currently support only support a subset.)

A minimum configuration must include the `endpoint` and `token`. However, just that would not be insecure, as it wouldn't establish an encrypted TLS connection to Vault. For production you should configure your Vault securely, following recommendations in the upstream Vault documentation.