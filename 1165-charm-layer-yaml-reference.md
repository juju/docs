Each layer used to build a charm can have a `layer.yaml` file. The top layer (the one actually invoked from the command line) must. These tell the generator what do, ranging from which base layers, to which interfaces to include. They also allow for the inclusion of specialized directives for processing some types of files.

<h2 id="heading--layer-options">Layer Options</h2>

Any layer can define options in its `layer.yaml`. Those options can then be set by other layers to change the behavior of your layer. The options are defined using [jsonschema](http://json-schema.org/), which is the same way that action parameters are defined.

For example, the foo layer could include the following option definitions:

``` yaml
includes: ['layer:basic']
defines:  # define some options for this layer (the layer "foo")
  enable-bar:  # define an "enable-bar" option for this layer
    description: If true, enable support for "bar".
    type: boolean
    default: false
```

A layer using foo could then set it:

``` yaml
includes: ['layer:foo']
options:
  foo:  # setting options for the "foo" layer
    enable-bar: true  # set the "enable-bar" option to true
```

<h2 id="heading--yaml-modifications">Yaml Modifications</h2>

`config` and `metadata` take optional lists of keys to remove from `config.yaml` and `metadata.yaml` when generating their data. This allows for charms to, for example, narrow what they expose to clients.

``` yaml
includes: ["layer:basic", "interface:mysql"]
config:
  deletes:
      - key names
metadata:
  deletes:
      - key names
```

<h2 id="heading--ignoring-files">Ignoring files</h2>

If a layer contains files that you do not want included in the built charm, use `ignore` and `exclude` to achieve this. These use the same format as `.gitignore` and `.bzrignore` files.

-   `ignore` is a list of files or directories to ignore from a lower layer. In the example below, all `tests` directories from `layer:basic` and `layer:apt` will not be included in the built charm. However, `tests` directories from this layer and higher layers will still be included, using the same compositing rules as normal.
-   `exclude` is a list of files or directories to exclude from this layer. In the example below, the `unit_tests` directory and the `README.md` file from this layer will not be included in the built charm. However, any `unit_tests` directory or `README.md` file in either a lower or higher level layer will be included, using the same compositing rules as normal.

<!-- -->

``` yaml
includes: ["layer:basic", "layer:apt"]
ignore:
    - tests
exclude:
    - unit_tests
    - README.md
```

<h2 id="heading--custom-tactics">Custom Tactics</h2>

This is an advanced topic - or a "Low Level Build interface". If you need to customize how certain file(s)/file types are handled during the charm build process your layer can include Tactics. Tactics represent how various build targets are assembled between layers. Usually you can ignore this entirely, but if you have very specific needs charm build can be customized by including custom tactics.

Normally the default tactics are fine but you have the ability in the `layer.yaml` to list a set of Tactics objects that will be checked before the default and control how data moves from one layer to the next.

To view more about tactics - you can look at the source in [charmtools/build/tactics.py](https://github.com/juju/charm-tools/blob/master/charmtools/build/tactics.py#L14)
