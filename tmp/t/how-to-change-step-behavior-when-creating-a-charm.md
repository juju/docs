(how-to-change-step-behavior-when-creating-a-charm)=
# How to change step behavior when creating a charm

> See also:
> * [`charmcraft init`](https://discourse.charmhub.io/t/6124)

Charmcraft supports the definition of a `parts` section in `charmcraft.yaml`, and that allows the charm developer to specify payloads in a very flexible way. Developers can also change the way each part step is executed by writing a scriptlet that replaces the built-in handling for that step by using `override-<step>` entries:
```yaml
parts:
  charm:
    override-build: |
      echo "Running the build step"
```
This however completely replaces the original build step: in this example, the charm source will not be built. To fix that, executing the original step handler is also necessary.

To run the default  processing for a step even if it's overriden, create a new charm project with `charmcraft init`:

```shell
$ mkdir mycharm
$ charmcraft init
Charm operator package file and directory tree initialized.
...
```

Replace the contents of the new charm project's `charmcraft.yaml` file with the following :
```yaml
type: "charm"
bases:
  - build-on:
    - name: "ubuntu"
      channel: "20.04"
    run-on:
    - name: "ubuntu"
      channel: "20.04"

parts:
  charm:
    override-build: |
       echo "Running the build step"
       craftctl default
```
Run `charmcraft pack` to execute the parts lifecycle and package the charm. Charmcraft will run commands from the `override-build` scriptlet and call the default build handler for the charm plugin to create the final charm payload.