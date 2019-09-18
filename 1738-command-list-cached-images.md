**Usage:** `juju cached-images [options]`

**Summary:**

Shows cached os images.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--arch (= "")`

The architecture of the image to list eg amd64

`--format (= yaml)`

Specify output format (`json|yaml`)

`--kind (= "")`

The image kind to list eg lxd

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--series (= "")`

The series of the image to list eg xenial

**Details:**

List cached os images in the Juju model.

Images can be filtered on:

       Kind         eg "lxd"
        Series       eg "xenial"
        Architecture eg "amd64"
The filter attributes are optional.

**Examples:**

List all cached images.

` juju cached-images`

List cached images for xenial.

` juju cached-images --series xenial`

List all cached lxd images for xenial amd64.

` juju cached-images --kind lxd --series xenial --arch amd64`

**Aliases:**

list-cached-images
