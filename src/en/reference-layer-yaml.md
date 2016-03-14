Title: Charm Layer.yaml Reference  

# Layer.yaml

Each layer used to build a charm can have a `layer.yaml` file. The top layer
(the one actually invoked from the command line) must. These tell the generator
what do, ranging from which base layers, to which interfaces to include. They
also allow for the inclusion of specialized directives for processing some
types of files.


## Layer Options

Any layer can define options in its `layer.yaml`. Those options can then be set
by other layers to change the behavior of your layer. The options are defined
using [jsonschema](http://json-schema.org/), which is the same way that action
parameters are defined.

For example, the foo layer could include the following option definitions:

```yaml
includes: ['layer:basic']
defines:  # define some options for this layer (the layer "foo")
  enable-bar:  # define an "enable-bar" option for this layer
    description: If true, enable support for "bar".
    type: boolean
    default: false
```

A layer using foo could then set it:

```yaml
includes: ['layer:foo']
options:
  foo:  # setting options for the "foo" layer
    enable-bar: true  # set the "enable-bar" option to true
```


## Yaml Modifications

Config and metadata take optional lists of keys to remove from `config.yaml`
and `metadata.yaml` when generating their data. This allows for charms to,
for example, narrow what they expose to clients.

```yaml
Keys:
  includes: ["layer:basic", "interface:mysql"]
  config:
    deletes:
        - key names
  metadata:
    deletes:
        - key names
```


## Custom Tactics

This is an advanced topic - or a "Low Level Build interface". If you need to
customize how certain file(s)/file types are handled during the charm build
process your layer can include Tactics. Tactics represent how various build
targets are assembled between layers. Usually you can ignore this entirely,
but if you have very specific needs charm build can be customized by
including custom tactics.

Normally the default tactics are fine but you have the ability in the
`layer.yaml` to list a set of Tactics objects that will be checked before
the default and control how data moves from one layer to the next.

To view more about tactics - you can look at the source in
[charmtools/build/tactics.py](https://github.com/juju/charm-tools/blob/master/charmtools/build/tactics.py#L14)
