(how-to-manage-charm-bundles)=
# How to manage charm bundles

> See also: {ref}`Bundle <bundle>`

**Contents:**

- [Create a bundle](#heading--create-a-bundle)
- [Pack a bundle](#heading--pack-a-bundle)
- [Publish a bundle on Charmhub](#heading--publish-a-bundle-on-charmhub)	


<a href="#heading--create-a-bundle"><h2 id="heading--create-a-bundle">Create a bundle</h2></a>


To create a bundle, create a `<bundle>.yaml` file with your desired configuration.

```{tip}

If you don't want to start from scratch, export the contents of your model to a `<bundle>.yaml` file via `juju export-bundle --filename <bundle>.yaml` or download the `<bundle>.yaml` of an existing bundle from Charmhub.

> See more: [Juju | How to compare and export the contents of a model to a bundle](https://juju.is/docs/juju/manage-models#heading--compare-and-export-the-contents-of-a-model-to-a-bundle)


```

> See more: {ref}`File `<bundle>.yaml` <file-bundleyaml>`

<a href="#heading--pack-a-bundle"><h2 id="heading--pack-a-bundle">Pack a bundle</h2></a>

To pack a bundle,  in the directory where you have your `bundle.yaml` file (and possibly other files, e.g., a `README.md` file), create a `charmcraft.yaml` file suitable for a bundle (at the minimum: `type: bundle`), then run `charmcraft pack` to pack the bundle. The result is a `.zip` file.

> See more: {ref}``charmcraft pack` <command-charmcraft-pack>`


<a href="#heading--publish-a-bundle-on-charmhub"><h2 id="heading--publish-a-bundle-on-charmhub">Publish a bundle on Charmhub</h2></a>

The process is identical to that for a simple charm except that, at the step where you register the name, for bundles the command is `register-bundle`.


> See more: {ref}`How to publish a charm on Charmhub <how-to-publish-your-charm-on-charmhub>`