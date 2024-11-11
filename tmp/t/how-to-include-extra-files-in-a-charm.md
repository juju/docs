(how-to-include-extra-files-in-a-charm)=
# How to include extra files in a charm

To add extra configuration files and/or binaries/libraries in your charm (e.g., to support more functions), in your `charmcraft.yaml`, under the `parts` key, define a part and, in the part properties,  set the `plugin` key to `dump` or `nil`. For example:

```yaml
parts:
  libs:
    plugin: dump
    source: /usr/local/lib/
    organize:
      "libxxx.so*": lib/
    prime:
      - lib/
```

This libs part will copy the locally built libxxx to the charm lib directory. 

```{note}

**If your charm currently uses the `prime` key in a `charm` part to include extra files:** 

Note that, starting with  Charmcraft 3.0, the behaviour of this keyword changes, with changes affecting existing bases.

An example of how to change an existing charm to work may be found [here](https://github.com/canonical/mongodb-operator/pull/449).

While in Charmcraft 2.x this was valid:

```yaml
parts:
  my-charm:
    plugin: charm
    source: .
    prime:
      - charm_version
      - charm_internal_version
      - workload_version
```

Starting in Charmcraft 3.0, these additional files must be primed using the `dump` plugin:

```yaml
parts:
  my-charm:
    plugin: charm
    source: .
  version_data:
    plugin: dump
    source: .
    prime:
      - charm_version
      - charm_internal_version
      - workload_version
```

```{dropdown} Why did this change?

The behaviour in Charmcraft 3 is the intended behaviour of all craft applications. [snapcraft](https://snapcraft.io/docs/snapcraft-parts-metadata#prime) and [rockcraft](https://documentation.ubuntu.com/rockcraft/en/stable/common/craft-parts/reference/part_properties/#prime) both use the behaviour in Charmcraft 3. As Charmcraft 3 contained a major rewrite, the decision was made to change this behaviour.

```


```

> See more: {ref}`File `charmcraft.yaml` > parts <13400md>`

<br>

<small> **Contributors:** @lengau, @syu-w , @tmihoc</small>