**Usage:** `juju export-bundle [options]`

**Summary:**

Exports the current model configuration as a reusable bundle.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--filename (= "")`

Bundle file

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Exports the current model configuration as a reusable bundle.

If `--filename` is not used, the configuration is printed to stdout.

      --filename specifies an output file.
**Examples:**

       juju export-bundle
    juju export-bundle --filename mymodel.yaml
