**Usage:** `juju model-defaults [options] [[<cloud/>]<region> ]<model-key>[<=value>] ...]`

**Summary:**

Displays or sets default configuration settings for a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-o, --output (= "")`

Specify an output file

`--reset (= )`

Reset the provided comma delimited keys

**Details:**

By default, all default configuration (keys and values) are displayed if a key is not specified. Supplying key=value will set the supplied key to the supplied value. This can be repeated for multiple keys. You can also specify a yaml file containing key values.

By default, the model is the current model.

**Examples:**

       juju model-defaults
        juju model-defaults http-proxy
        juju model-defaults aws/us-east-1 http-proxy
        juju model-defaults us-east-1 http-proxy
        juju model-defaults -m mymodel type
        juju model-defaults ftp-proxy=10.0.0.1:8000
        juju model-defaults aws/us-east-1 ftp-proxy=10.0.0.1:8000
        juju model-defaults us-east-1 ftp-proxy=10.0.0.1:8000
        juju model-defaults us-east-1 ftp-proxy=10.0.0.1:8000 path/to/file.yaml
        juju model-defaults us-east-1 path/to/file.yaml    
        juju model-defaults -m othercontroller:mymodel default-series=yakkety test-mode=false
        juju model-defaults --reset default-series test-mode
        juju model-defaults aws/us-east-1 --reset http-proxy
        juju model-defaults us-east-1 --reset http-proxy
**See also:**

[models](https://discourse.jujucharms.com/t/command-models/1771), [model-config](https://discourse.jujucharms.com/t/command-model-config/1768)

**Aliases:**

model-default
