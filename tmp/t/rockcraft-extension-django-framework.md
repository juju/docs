(rockcraft-extension-django-framework)=
# Rockcraft extension 'django-framework'

The `django-framework` Rockcraft {ref}`extension <extension>` includes configuration options customised for a Django application. This document describes all the keys that a user may interact with.

```{tip}

**If you'd like to see the full contents contributed by this extension:** <br>See {ref}`How to manage extensions <manage-extensions>`.

```


## `rockcraft.yaml` > `parts` > `django-framework/dependencies:` > `stage-packages`

You can use this key to specify any dependencies required for your Django application. For example, below we use it to specify `libpq-dev`:

```text
parts:
    django-framework/dependencies:
      stage-packages:
        # list required packages or slices for your Django application below.
        - libpq-dev
```