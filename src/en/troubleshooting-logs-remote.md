Title: Remote logging
TODO:  Strongly consider adding a sub-page (rsyslog TLS tutorial)
       Need to state whether server-side and/or client-side auth is a requirement


# Remote logging

On a per-model basis log messages can optionally be forwarded to a remote
syslog server over a secure TLS connection.

See [Rsyslog documentation][upstream-rsyslog-tls-tutorial] for help with
security-related files (certificates, keys) and the configuration of the
remote syslog server.

## Configuring

Remote logging is configured during the controller-creation step by supplying
a YAML format configuration file:

```bash
juju bootstrap <cloud> --config logconfig.yaml
```

The contents of the YAML file is of the form:

```no-highlight
syslog-host: <host>:<port>
syslog-ca-cert: |
-----BEGIN CERTIFICATE-----
 <cert-contents>
-----END CERTIFICATE-----
syslog-client-cert: |
-----BEGIN CERTIFICATE-----
 <cert-contents>
-----END CERTIFICATE-----
syslog-client-key: |
-----BEGIN PRIVATE KEY-----
 <cert-contents>
-----END PRIVATE KEY-----
```

## Enabling

To actually enable remote logging for a model a configuration key needs to be
set for that model:

`juju model-config -m <model> logforward-enabled=True`

An initial 100 (maximum) existing log lines will be forwarded.

See [Configuring models][models-config] for extra help on configuring a model.

Note that it is possible to configure *and* enable forwarding on *all* the
controller's models in one step:

`juju bootstrap <cloud> --config logforward-enabled=True --config logconfig.yaml`


<!-- LINKS -->

[upstream-rsyslog-tls-tutorial]: http://www.rsyslog.com/doc/v8-stable/tutorials/tls_cert_summary.html
[models-config]: ./models-config.html
