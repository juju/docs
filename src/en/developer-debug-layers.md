# Debugging Building Layers

While building from charm layers is a quick and easy process most of the time,
occasionally things surface which are not immediately obvious to us as the end
user. Thankfully layers are really straight forward and pretty simple to debug.

### Environment Variables

Often times, unexpected behavior can come from not having the proper Environment
variables set on your workspace. The three required environment variables to
have a consistent working path for your local assets are:

- [`JUJU_REPOSITORY`](reference-environment-variables.html#juju_repository)

- [`LAYER_PATH`](developer-layer-example.html#prepare-your-workspace)

- [`INTERFACE_PATH`](developer-layer-example.html#prepare-your-workspace)

### `charm build` complains about modifications?

In most cases these warnings are simply a convenience keeping the tool from
being destructive. `charm build` is an iterative phase, and should you make
changes in the charm that have not yet been updated in the originating layer
`charm build` will do it's best to not clobber any of those files. In fact
you'll notice that after the initial generation, you will often have to build
with the `--force` flag in order to in-place update a constructed charm.

```
$ charm build
build: Composing into /home/ubuntu/charms/
build: Added unexpected file, should be in a base layer: my-file
ValueError: Unable to continue due to unexpected modifications (try --force)
```


### A file isn't present in my layer?

When building from charm layers, it's important to understand that layers work
with an overlapping file policy that states: Any file in the top most charm layer
that collides with a file provided by a lower layer, shall override that file in
place.

There are a few notable exceptions:

- config.yaml
- metadata.yaml

These two files are special cases and are instead merged into a single file in
the top most charm layer. Allowing the developer to define only fragments
of information in their respective files.

Given this behavior, it can be extremely difficult to assemble from layers,
charms written in other frameworks/technologies other than Reactive. As Hooks
would contain the majority of the code this can be problematic as hooks will
overwrite one another.

### Where did this file come from?

 [`charm layers`](reference-hook-tools.html#charm-layers)
is the first step to understanding our charm artifact we've built. If you have
an ANSII compliant terminal, you have a color coded map available to you
listing all the available files in the charm, color coordinated with its origin
layer.


![ charm-layers-illustration.png](../../media/charm-layers-illustration.png)


### Where do I file bugs?

Bugs relating to building charms, and anything going awry with the `charm build`
or `charm layers` commands should be filed against the `charm-tools` package on
GitHub.  [github.com/juju/charm-tools](http://github.com/juju/charm-tools)
