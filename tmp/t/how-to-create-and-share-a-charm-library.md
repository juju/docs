(how-to-create-and-share-a-charm-library)=
# How to create and share a charm library

> See also: 
> - {ref}`Library <library>`
> - {ref}`How to register an interface <how-to-register-an-interface>`

<!--THIS DOC INTEGRATES CONTENT FROM https://discourse.charmhub.io/t/how-to-manage-charm-libraries/4058 AND https://discourse.charmhub.io/t/how-to-interact-with-libraries/4742/2)-->

This document details how to build and share your own charm libraries.

**Contents:**

- [Create a charm library](#heading--create-a-charm-library)
- [Publish a charm library](#heading--publish-a-charm-library)
- [Update a charm library](#heading--update-a-charm-library) 
- [Share a charm library](#heading--share-a-charm-library)

<a href="#heading--create-a-charm-library"><h2 id="heading--create-a-charm-library">Create a charm library</h2></a>
> See also: {ref}``charmcraft create-lib` <command-charmcraft-create-lib>`

You've been unable to find an existing library with the intended functionality for your charm. As such, it's time to learn how to create your own. 

Let's start from a charm that has no libraries at all:

```bash
$ ll lib
ls: cannot access 'lib': No such file or directory
```

<!-- 
    jdoe@machine:/home/john/blogsystem$ ll lib
    ls: cannot access 'lib': No such file or directory

The library we will be creating belongs to a charm, so we will not only be working inside a charm's directory, but this needs to be {ref}`registered in Charmhub <5781md>` (later we'll see that we can ask Charmhub to list all libraries belonging to a given charm).
-->

The first step is create the bare library template using `charmcraft create-lib`:

```bash
# Initialise a charm library named 'demo'
$ charmcraft create-lib demo
```
<!--
    jdoe@machine:/home/john/blogsystem$ charmcraft create-lib superlib
    Library charms.blogsystem.v0.superlib created with id e76db596f4bb44fd9c0ce068669fc2ac.
    Consider 'git add lib/charms/blogsystem/v0/superlib.py'.
-->

```{note}

Before creating a library, you must first register ownership of your charm’s name. See {ref}`How to publish your charm to Charmhub <how-to-publish-your-charm-on-charmhub>`.

```
    
This will create a file at `$CHARMDIR/lib/charms/demo/v0/demo.py`.

Developers can import the library from within their charm code using its fully-qualified path minus the `lib` part:

```python
import charms.demo.v0.demo
```

> See also: {ref}`Library > Location <5781md>`


<!--
That command created a file on disk, inside the proper directory structure. 

It's a good idea to incorporate this new file now to your code versioning system.

    jdoe@machine:/home/john/blogsystem$ ll lib/charms/blogsystem/v0/superlib.py 
    -rw-rw-r-- 1 jdoe jdoe 1048 Dec 17 13:46 lib/charms/blogsystem/v0/superlib.py

-->

That file is just a template we must fill, though. For guidance see {ref}`Library > Structure <5781md>`, which also links to some excellent examples that you can follow.

    
<a href="#heading--publish-a-charm-library"><h2 id="heading--publish-a-charm-library">Publish a charm library</h2></a>
> See also: {ref}``charmcraft  publish-lib` <command-charmcraft-publish-lib>`
 

You've created your library and you'd like to share it with the world. To publish your library, run `charmcraft publish-lib` followed by the full library path. This will upload the library content and also make it available for consumption by other charm authors.

```bash
$ charmcraft publish-lib charms.demo.v0.demo
Library charms.demo.v0.demo sent to the store with version 0.1
```
```{caution}

In order to be able to publish a charm library, you need to be signed into Charmcraft as a user that has permissions to publish libraries to this charm. In particular you need to be the owner of this charm or registered as a contributor to the charm—a status that can be requested via [Discourse](https://discourse.charmhub.io/).

```

<a href="#heading--update-a-charm-library"><h2 id="heading--update-a-charm-library">Update a charm library</h2></a>

You will eventually need to evolve the library's content (new functionalities, bug fixing, documentation improvements, etc.). Every time you want to offer a new version of your library, call the `publish-lib` command again.

However, before publishing new versions, make sure to update the `LIBAPI`/`LIBPATCH` metadata fields inside the library file. Most times it is enough to just increment `LIBPATCH` but, if you're introducing breaking changes, you must work with the major API version. 

Additionally, be mindful of the fact that users of your library will update it automatically to the latest PATCH version with the same API version. To avoid breaking other people's library usage, make sure to increment the `LIBAPI` version but reset `LIBPATCH` to `0`. Also,  before adding the breaking changes and updating these values, make sure to copy the library to the new path; this way you can maintain different major API versions independently, being able to update, for example, your v0 after publishing v1.

<!--
After this step, our library is ready to be used by other developers. 

We would eventually need to evolve the library's content (new functionalities, bug fixing, documentation improvements, etc.). Every time we want to offer a new version of our library, we will need to call the `publish-lib` command.

However, before publishing new versions, we need to update the `LIBAPI`/`LIBPATCH` metadata fields inside the library file. Most times it is enough to just increment `LIBPATCH`, but if we're introducing breaking changes we must work with the major API version. 

    jdoe@machine:/home/john/blogsystem$ charmcraft publish-lib charms.blogsystem.v0.superlib
    Library charms.blogsystem.v0.superlib sent to the store with version 0.2

We need to take in consideration that users of our library will update it automatically to the latest PATCH version with the same API version. 

To avoid breaking other people's library usage we should increment the `LIBAPI` version and reset `LIBPATCH` to `0`. But before adding the breaking changes and updating these values, we should copy the library to the new path:

    jdoe@machine:/home/john/blogsystem$ mkdir lib/charms/blogsystem/v1
    jdoe@machine:/home/john/blogsystem$ cp lib/charms/blogsystem/v0/superlib.py lib/charms/blogsystem/v1/

This way we can maintain different major API versions independently, being able to update our v0 after we published v1.

    jdoe@machine:/home/john/blogsystem$ charmcraft publish-lib charms.blogsystem.v1.superlib
    Library charms.blogsystem.v1.superlib sent to the store with version 1.0
-->

<a href="#heading--share-a-charm-library"><h2 id="heading--share-a-charm-library">Share a charm library</h2></a>

To share your charm library with developers:

*   Access your charm page on charmhub.io. 
*   Go to the Libraries tab.
![image|495x72](upload://kw1Gpf2LOZsnaKcDYv6Kwz4L4qM.png) 
*  Click on your library.
![image|690x788](upload://1jk05FKBqqLlkdEKcI9LG0XsGtw.png) 
*   Use the URL to share your library with other charm developers.