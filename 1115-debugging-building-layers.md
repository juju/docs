While building from charm layers is a quick and easy process most of the time, occasionally things surface which are not immediately obvious to us as the end user. Thankfully layers are straightforward and simple to debug.

<h3 id="heading--environment-variables">Environment Variables</h3>

Often times, unexpected behavior comes from not having the proper environment variables set on your workspace. The three required environment variables to have a consistent working path for your local assets are:

-   [`JUJU_REPOSITORY`](/t/juju-environment-variables/1162#juju_repository)

-   [`LAYER_PATH`](/t/writing-a-layer-by-example/1120#heading--prepare-your-workspace)

-   [`INTERFACE_PATH`](/t/writing-a-layer-by-example/1120#heading--prepare-your-workspace)

<h3 id="heading--charm-build-complains-about-modifications">`charm build` complains about modifications?</h3>

In most cases these warnings are simply a convenience keeping the tool from being destructive. `charm build` is an iterative phase, and should you make changes in the charm that have not yet been updated in the originating layer, `charm build` will do it's best to not clobber any of those files. In fact, you'll notice that after the initial generation, you will often have to build with the `--force` flag in order to in-place update a constructed charm.

    $ charm build
    build: Composing into /home/ubuntu/charms/
    build: Added unexpected file, should be in a base layer: my-file
    ValueError: Unable to continue due to unexpected modifications (try --force)

<h3 id="heading--a-file-isnt-present-in-my-layer">A file isn't present in my layer?</h3>

When building from charm layers, it's important to understand that layers work with an overlapping file policy that states: Any file in the topmost charm layer that collides with a file provided by a lower layer shall override that file in place.

There are a few notable exceptions:

-   config.yaml
-   metadata.yaml

These two files are special cases, and are merged into a single file in the top most charm layer, allowing the developer to define only fragments of information in their respective files.

Given this behavior, it can be extremely difficult to assemble layer-based charms written in frameworks other than Reactive, leading to situations where hooks (containing the majority of the code) can be overwritten.

<h3 id="heading--where-did-this-file-come-from">Where did this file come from?</h3>

[`charm layers`](/t/hook-tools/1163#heading--charm-layers) is the first step to understanding the charm artifacts we've built. If you have an ANSI-compliant terminal, you have a color coded map available to you listing all the available files in the charm, color coordinated with its origin layer.

![charm-layers-illustration.png](/uploads/default/original/1X/856bc4614283018f92c9c70f574c8d17f4544a15.png)

<h3 id="heading--charm-proof-build-exit-status">`charm proof` or `charm build` returns exit status 100</h3>

`charm proof`, when run manually or automatically as part of the `charm build` command, may return an exit status of 100. This indicates that the static analysis of the charm structure has found potential issues and may not be compatible with [Charm Store policy](authors-charm-policy.html).

<h3 id="heading--where-do-i-file-bugs">Where do I file bugs?</h3>

Bugs relating to building charms, and anything going awry with the `charm build` or `charm layers` commands should be filed against the `charm-tools` package on GitHub. [github.com/juju/charm-tools](http://github.com/juju/charm-tools)
