**Usage:** ` juju add-storage [options] <unit name> <charm storage name>[=<storage constraints>] ... `
**Summary:**

Adds unit storage dynamically.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

Details:

Add storage instances to a unit dynamically using provided storage directives. Specify a unit and a storage specification in the same format as passed to juju deploy `--storage=”...”`.

A storage directive consists of a storage name as per charm specification and storage constraints, e.g. pool, count, size.

The acceptable format for storage constraints is a comma separated sequence of: POOL, COUNT, and SIZE, where POOL identifies the storage pool. POOL can be a string starting with a letter, followed by zero or more digits or letters optionally separated by hyphens.

         COUNT is a positive integer indicating how many instances
          of the storage to create. If unspecified, and SIZE is
          specified, COUNT defaults to 1.

          SIZE describes the minimum size of the storage instances to
          create. SIZE is a floating point number and multiplier from
          the set (M, G, T, P, E, Z, Y), which are all treated as
          powers of 1024.
Storage constraints can be optionally omitted.

Model default values will be used for all omitted constraint values.

There is no need to comma-separate omitted constraints.

**Examples:**

Add 3 ebs storage instances for "data" storage to unit u/0:

     juju add-storage u/0 data=ebs,1024,3 
    or
      juju add-storage u/0 data=ebs,3
    or
      juju add-storage u/0 data=ebs,,3
Add 1 storage instances for "data" storage to unit u/0 using default model provider pool:

     juju add-storage u/0 data=1 
    or
      juju add-storage u/0 data
