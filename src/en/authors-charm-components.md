Title:Components of a Charm

# What makes a Charm?

Each charm is a structured bundle of files. Conceptually, charms are composed of
metadata, configuration data, and hooks with some extra support files.

## Required files

A charm requires only a single file in order to be considered valid by juju:

 - `metadata.yaml` [describes the charm](./authors-charm-metadata.html) and the
    relations it can participate in.

Of course, a charm which consists solely of metadata may be valid, but it can't
actually do anything. For that, some additional files will be required.

## Special files

The following files will be treated specially, if present:

 - `/hooks` must be a directory holding executables with specific names, that
   will be invoked by juju at the relevant times. A charm needs to implement at
   least one hook in order to do anything at all. How to implement hooks is
   covered more thoroughly in the [Hooks section](./authors-charm-hooks.html)
 - `/actions` must be a directory holding executables with specific names, which
   the user may invoke through Juju as desired.
   [Adding actions to a charm is described here.](./authors-charm-actions.html)
 - `actions.yaml` specifies charm actions and their schemas, and must be defined
   if `/actions` is used.
   [See here for more on creating charm actions.](./authors-charm-actions.html)
 - `config.yaml` defines service configuration options.
   [The config.yaml file is descibed more fully here](./authors-charm-config.html).
 - `icon.svg` is used to identify your charm in the GUI and in the charm store.
   [See the walkthrough for creating an icon.](authors-charm-icon.html)
 - `README` is made available in the charm store. It should be comprehensible to
   a reasonably ignorant user.
 - `revision` is now deprecated.
 - files matching `.juju*` should **not** be used.

## Other files

Any other files you know you'll need can be placed in the charm for convenience.
It is recommended to leave the hooks directory for the executable hooks alone -
library code may be included elsewhere in the charm.

When hooks are actually running, they can read and write to the charm directory
freely, but should carefully observe the caveats in the next section...

## Charm files at runtime

The files you store with your charm should _not_ be used directly by the
software installed by your charm. If the files are really needed by the software
at runtime, copy them on the system alongside the software and reference those
instead.

This is because the software does _not_ have control over the charm directory;
_juju_ has control over the charm directory, which it temporarily cedes to the
charm only when running a hook. Juju will occasionally do things to the contents
of that directory that assume it is neither read nor written outside a hook, and
the results of such interactions can only be undefined.

The only files you should be writing into the charm directory should be written
by hooks and accessed only by hooks. If everything in your charm directory went
away, that should be considered a _management_ failure only; the software
installed should continue to run, using its last known good configuration, and
should do this by virtue of never having had the opportunity to observe the
change.

Finally, any file written at runtime constrains all future implementations of
the charm. When [upgrading a charm](./developer-upgrade-charm.html), any change
that would cause runtime state to be overwritten will cause juju to abort the
operation and hand over to the user for resolution. This is inconvenient for the
users and undermines confidence in the charm.

**Note:** You need to be especially aware of the following when writing python
code: Python packages run without bytecode suppression will write `.pyc` files
into the package, and subsequent attempts to move or remove the package will
fail: the .pyc files are treated as important hook-relevant runtime state
information, to be recorded and tracked, and the loss of their directory will
put the unit into an upgrade error state as referenced above.
