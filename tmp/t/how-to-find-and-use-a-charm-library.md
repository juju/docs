(how-to-find-and-use-a-charm-library)=
# How to find and use a charm library

<!--THIS DOC INTEGRATES CONTENT FROM https://discourse.charmhub.io/t/how-to-manage-charm-libraries/4058 AND https://discourse.charmhub.io/t/how-to-interact-with-libraries/4742/2)-->


This document shows how to take advantage of existing charm libraries.

**Contents:**
<!-- - [Locate a charm library inside a charm](#heading--locate-a-charm-library-inside-a-charm)-->

- [Discover a charm library](#heading--discover-an-existing-charm-library)
- [Fetch a charm library](#heading--fetch-a-charm-library)
- [Import a charm library](#heading--import-a-charm-library)
- [Update a charm library](#heading--update-a-charm-library) 

<a href="#heading--discover-an-existing-charm-library"><h2 id="heading--discover-an-existing-charm-library">Discover an existing charm library</h2></a>

You've come to the conclusion that you'd like a charm library. The first thing to do is check if there is already an existing one that you can use. For example, if the charm you're writing needs to interact with another service, you should check if that service provides any library that would help in that interaction.

The easiest way to find an existing library for a given charm is via `charmcraft list-lib`, as shown below. This will query Charmhub and show which libraries are published for the specified charm, along with API/patch versions.

    jdoe@machine:/home/jane/autoblog$ charmcraft list-lib blogsystem
    Library name    API    Patch
    superlib        1      0

The listing will not show older API versions; this ensures that new users always start with the latest version. 

Another good way to search for libraries is to explore the charm collection on [Charmhub](https://charmhub.io/).

> See more: {ref}``charmcraft list-lib` <command-charmcraft-list-lib>`

<!--
<a href="#heading--locate-a-charm-library-inside-a-charm"><h2 id="heading--locate-a-charm-library-inside-a-charm">Locate a charm library inside a charm</h2></a>


You've found an existing charm library. But to use it you'll often need to be able to specify its full path inside the charm project. 

To find a library's path inside a charm project, you need to know that libraries are located in a specific directory with the following structure:

    $CHARMDIR/lib/charms/<charm>/v<API>/<libname>.py

where `$CHARMDIR` is the project's root (contains `src/`, `hooks/`, etc.), and the `<charm>` placeholder represents the charm responsible for the library named as `<libname>.py` with API version `<API>`. 

For example, inside a charm `mysql`, the library `db` with major version 3 will be in a directory with the structure below:

   $CHARMDIR/lib/charms/mysql/v3/db.py

As such, the path to the library is `charms.mysql.v3.db`.
-->

<!--This file may be used both by the author and by any other charm authors that are interested in the offered functionality.-->


<a href="#heading--fetch-a-charm-library"><h2 id="heading--fetch-a-charm-library">Fetch a charm library</h2></a>

1. In your charm's `charmcraft.yaml`, use the `charm-libs` key to declare all the libraries you want to fetch. For example:

```text
charm-libs:
    # Fetch postgres_client lib with API version 1 and latest patch:
    - lib: postgresql.postgres_client
      version: "1"

    # Fetch mysql lib with API version 0 and patch version 5:
    - lib: mysql.mysql
      version: "0.5"

```

> See more: {ref}`File `charmcraft.yaml` > `charm-libs` <5780md>`

2. Run `charmcraft fetch-libs`. Charmcraft will fetch the libraries. 

If a library already exists on your machine, and you only specify the API version, Charmcraft will check for the latest patch version. 

Either way, the library will be placed in your charm's `lib/charms` directory and become part of your charm's project -- that is, it will be packed inside your charm and distributed with it when the charm is packaged and published with `charmcraft`. 

```{note}

 Charm libraries are always located according to the pattern: `$CHARMDIR/lib/charms/<charm_name>/v<API>/<library_name>.py`. See {ref}`The location of a charm library inside a charm <5780md>`.

```

> See more: {ref}``charmcraft fetch-libs` <command-charmcraft-fetch-libs>`

<a href="#heading--import-a-charm-library"><h2 id="heading--import-a-charm-library">Import a charm library</h2></a>

You've fetched a library---it's now time to use it! To use the library, you need to import it in your charm's code, as shown below. (Note that the charm automatically has the `lib` directory as part of the Python import paths.)

```python
from charms.demo.v0 import demo
```


<!-- NEED TO SEE HOW THIS FITS WITH THE LINES ON IMPORTING ABOVE
You've fetched a charm library you'd like to use.  Now, to import the library,  execute `import` followed by its full path inside the charm project:

    import charms.mysql.v3.db

Note that this will only work for a `db.py` with the following fields defined:

    LIBID = "abcdef1234"
    LIBAPI = 3    # Must match the major version in the import path.
    LIBPATCH = 2  # The current patch version. Must be updated when changing.

```{note}

`LIBID` is a unique identifier for the library across the entire universe of charms that is assigned by Charmhub to this particular library automatically at library creation time.  It enables Charmhub and `charmcraft` to track the library uniquely even if the charm or the library are renamed, which allows updates to warn and guide users through the process.

```
-->

<a href="#heading--update-a-charm-library"><h2 id="heading--update-a-charm-library">Update a charm library</h2></a>

1. Update your charm's `charmcraft.yaml`'s `charm-libs` key with the desired library version.

> See more: {ref}`File `charmcraft.yaml` > `charm-libs` <5780md>`


2. Run `charmcraft fetch-libs`. Charmcraft will update the libraries.

> See more: {ref}``charmcraft fetch-libs` <command-charmcraft-fetch-libs>`