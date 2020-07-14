## Usage

### Common

Add the interface declaration within your charm's `metadata.yaml` file:

```plain
requires:
  cert-provider:
    interface: tls-certificates
```

### charms.reactive

Include the interface's name within your charm's `layer.yaml`. During the `charm build` step, the Python code that implements this interface will be included into your charm code.

```
includes:
  - interface:tls-certificates
```

#### Trust the root CA certificate on the machine

To accept certificates from a (self-signed) CA in our cluster, we start by downloading the root certificate. That is then loaded on the machine's operating system with the help of the [`charmhelpers`](https://charm-helpers.readthedocs.io/) library.  

The core of the functionality looks like this:

```python
from charmhelpers.core import hookenv, host
from charms.reactive import endpoint_from_flag

def install_root_ca_cert():
    cert_provider = endpoint_from_flag('cert-provider.ca.available')
    host.install_ca_cert(cert_provider.root_ca_cert)
```

An "endpoint" is one end of a relation. The `endpoint_from_flag()` function connects this charm to the server, resolving the `tls-certificates` interface.

Now that the functionality is defined, we need to add some boilerplate to ensure that   `install_root_ca_cert()` is called when CA authorities appear. This _should_ only happen once, but might happen many times if the model is updated over time.

```python
@when('cert-provider.ca.changed')          # <1>
def install_root_ca_cert():
    cert_provider = endpoint_from_flag('cert-provider.ca.available')
    host.install_ca_cert(cert_provider.root_ca_cert)
    clear_flag('cert-provider.ca.changed') # <2>
```

1. Call this function when the CA authority appears
2. Unset the changed flag, preventing spurious calls in the future

#### Requesting certificates

_Example 1_: request a client certificate to access a database in the model 

```python
from charmhelpers.core import hookenv, host
from charms.reactive import endpoint_from_flag

@when('cert-provider.available')
def request_client_cert():
    cert_provider = endpoint_from_flag('cert-provider.available')

    db_address = hookenv.network_get('db')['ingress-addresses']
    client_common_name, client_sans = db_address[0], db_address[:1]
    cert_provider.request_client_cert(client_common_name, client_sans)

    client_cert = cert_provider.client_certs[0]  # only requested one
    myclient.update_client_cert(client_cert.cert, client_cert.key)
```

_Example 2_: request a server certificate for clients that are accessing a service my charm provides

This example makes use of an extra flag, `cert-provider.certs.changed`. Destructuring charm hooks into smaller functions is considered good practice as only one hook can be executed at a time.

```python
from charmhelpers.core import hookenv, host
from charms.reactive import endpoint_from_flag

@when('cert-provider.available')
def request_server_cert():
    client_addresses = hookenv.network_get('clients')['ingress-addresses']

    cert_provider.request_server_cert(client_addresses[0], client_addresses[:1])


@when('cert-provider.certs.changed')
def update_certs():
    cert_provider = endpoint_from_flag('cert-provider.available')
    server_cert = cert_provider.server_certs[0]
    myserver.update_server_cert(server_cert.cert, server_cert.key)
    clear_flag('cert-provider.certs.changed')
```

See the [github.com/juju-solutions/interface-tls-certificates](https://github.com/juju-solutions/interface-tls-certificates/blob/master/requires.py) repository for further details.
