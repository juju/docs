(how-to-manage-charm-resources)=
# How to manage charm resources

> See first: [Juju | Resource (charm)](https://juju.is/docs/juju/manage-charm-resources)

**Contents:**

- [Add a resource to a charm](#heading--add-a-resource-to-a-charm)
- [Upload a resource to Charmhub](#heading--upload-a-resource-to-charmhub)
- [List all the resources for a Charmhub charm](#heading--list-all-the-resources-for-a-charmhub-charm)
- [List all the revisions for a resource associated with a Charmhub charm](#heading--list-all-the-revisions-for-a-resource-associated-with-a-charmhub-charm)
- [Set the architectures for a revision of a resource associated with a Charmhub charm](#heading--set-the-architectures-for-a-revision-of-a-resource-associated-with-a-charmhub-charm)	

<a href="#heading--add-a-resource-to-a-charm"><h2 id="heading--add-a-resource-to-a-charm">Add a resource to a charm</h2></a>

In the charm's `charmcraft.yaml file`, add a `resources` block.

> See more: {ref}`File `charmcraft.yaml` > `resources` <4468md>`


<!--COMMENT: MOVE TO HOW TO UPLOAD 
Because resources are defined in a charm’s `charmcraft.yaml`, they are intrinsically linked to a charm. As such, there is no need to register them separately in Charmhub. Other charms may have resources with the same name, but this is not a problem; references to resources always contain the charm name and resource name.
-->

In your charm's `src/charm.py` file, use Ops to fetch the path to the resource and then manipulate it as needed.

For example, consider this simple resource definition:

```yaml
resources:
  my-resource:
    type: file
    filename: somefile.txt
    description: test resource
```

In the charm code, we can now use [`Model.resources.fetch(<resource_name>)`](https://ops.readthedocs.io/en/latest/#ops.Resources.fetch) to get the path to the resource, then manipulate it as we need:

```python
# ...
import logging
import ops
# ...
logger = logging.getLogger(__name__)

def _on_config_changed(self, event):
    # Get the path to the file resource named 'my-resource'
    try:
        resource_path = self.model.resources.fetch("my-resource")
    except ops.ModelError as e:
        self.unit.status = ops.BlockedStatus(
            "Something went wrong when claiming resource 'my-resource; "
            "run `juju debug-log` for more info'"
        ) 
       # might actually be worth it to just reraise this exception and let the charm error out;
       # depends on whether we can recover from this.
        logger.error(e)
        return
    except NameError as e:
        self.unit.status = ops.BlockedStatus(
            "Resource 'my-resource' not found; "
            "did you forget to declare it in charmcraft.yaml?"
        )
        logger.error(e)
        return

    # Open the file and read it
    with open(resource_path, "r") as f:
        content = f.read()
    # do something
```

The [`fetch()`](https://ops.readthedocs.io/en/latest/#ops.Resources.fetch) method will raise a [`NameError`](https://docs.python.org/3/library/exceptions.html#NameError) if the resource does not exist, and returns a Python [`Path`](https://docs.python.org/3/library/pathlib.html#pathlib.Path) object to the resource if it does.


Note: During development, it may be useful to specify the resource at deploy time to facilitate faster testing without the need to publish a new charm/resource in between minor fixes. In the below snippet, we create a simple file with some text content, and pass it to the Juju controller to use in place of any published `my-resource` resource:

```
echo "TEST" > /tmp/somefile.txt
charmcraft pack
juju deploy ./my-charm.charm --resource my-resource=/tmp/somefile.txt
```

<a href="#heading--upload-a-resource-to-charmhub"><h2 id="heading--upload-a-resource-to-charmhub">Upload a resource to Charmhub</h2></a>

Once you've uploaded a charm to Charmhub, to upload the resource defined in its `charmcraft.yaml > resources` to Charmhub as well, run the `charmcraft upload-resource` command followed by the name of the charm, the name of the resource (cf. `charmcraft.yaml`), and `--filepath=<path to file resource>` / `--image=<OCI image>`. For example:

```{note}

The option `--image` must indicate an OCI image's digest, being it in the short or long form (e.g.: `70aa8983ec5c` or `sha256:64aa8983ec5cea7bc143af18829836914fa405184d56dcbdfd9df672ade85249`). When using the "short form" of the digest, the image needs to be present locally so its proper ID (the "long form") can be retrieved.


```


```text
$ charmcraft upload-resource my-super-charm someresource --filepath=/tmp/superdb.bin
Revision 1 created of resource 'someresource' for charm 'my-super-charm'
```

```tex
$ charmcraft upload-resource my-super-charm redis-image --image=sha256:64aa8983ec5cea7bc143af18829836914fa405184d56dcbdfd9df672ade85249
Revision 1 created of resource 'redis-image' for charm 'my-super-charm'
```

Charmcraft will first check if that specific image is available in Canonical's Registry, and just use it if that's the case. If not, it will try to get it from the developer's local OCI repository (needs `dockerd` to be installed and running), push it to the Canonical's Registry, and then use it. 

To update a pre-uploaded resource, run the `upload-resource` command again. The result will be a new revision.


> See more: {ref}``charmcraft upload-resource` <command-charmcraft-upload-resource>`

<a href="#heading--list-all-the-resources-for-a-charmhub-charm"><h2 id="heading--list-all-the-resources-for-a-charmhub-charm">List all the resources for a Charmhub charm</h2></a>

To view all the resources associated with a charm you've uploaded  to Charmhub, run `charmcraft resources` followed by the charm name:

```{important}

**If you're not logged in to Charmhub:** The command will open up a browser window and ask you to log in.

```

```text
charmcraft resources mycharm
```

> See more: {ref}``charmcraft resources` <command-charmcraft-resources>`

<a href="#heading--list-all-the-revisions-for-a-resource-associated-with-a-charmhub-charm"><h2 id="heading--list-all-the-revisions-for-a-resource-associated-with-a-charmhub-charm">List all the revisions for a resource associated with a Charmhub charm</h2></a>

To view all the revisions for a resource associated with a charm you've uploaded to Charmhub, run `charmcraft resource-revisions` followed by the charm name and the resource name. For example:

```text
charmcraft resource-revisions mycharm myresource
```

> See more: {ref}``charmcraft resource-revisions` <command-charmcraft-resource-revisions>`

<a href="#heading--set-the-architectures-for-a-revision-of-a-resource-associated-with-a-charmhub-charm"><h2 id="heading--set-the-architectures-for-a-revision-of-a-resource-associated-with-a-charmhub-charm">Set the architectures for a revision of a resource associated with a Charmhub charm</h2></a>

To set the architectures for a revision of a resource associated with a charm you've uploaded to Charmhub, run `charmcraft set-resource-architectures` followed by the name of the charm, the name of the resource, and the architecture(s), using the `--resources` flag to specify the target resource revision. For example:

```text
charmcraft set-resource-architectures mycharm myresource --revision=1 arm64,armhf
```

> See more: {ref}``charmcraft set-resource-architectures` <command-charmcraft-set-resource-architectures>`

<br>

> **Contributors:** @gfouillet , @tmihoc