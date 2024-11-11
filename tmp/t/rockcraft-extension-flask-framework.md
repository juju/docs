(rockcraft-extension-flask-framework)=
# Rockcraft extension 'flask-framework'

The `flask-framework` Rockcraft {ref}`extension <extension>` includes configuration options customised for a Flask application. This document describes all the keys that a user may interact with.

```{tip}

**If you'd like to see the full contents contributed by this extension:** <br>See {ref}`How to manage extensions <manage-extensions>`.

```


## `rockcraft.yaml` > `parts` > `flask-framework/dependencies:` > `stage-packages`

You can use this key to specify any dependencies required for your Flask application. For example, below we use it to specify `libpq-dev`:

```text
parts:
    flask-framework/dependencies:
      stage-packages:
        # list required packages or slices for your flask application below.
        - libpq-dev
```

## `rockcraft.yaml` > `parts` > `flask-framework/install-app:` > `prime`

You can use this key to specify the files to be included in your rock upon `rockcraft pack`, in `flask/app/<filename>` notation. For example:

```text
parts:
  flask-framework/install-app:
    prime:
       - flask/app/.env
       - flask/app/app.py
       - flask/app/webapp
       - flask/app/templates
       - flask/app/static
```

Some files, if they exist, are included by default. These include: `app`, `app.py`, `migrate`, `migrate.sh`, `migrate.py`, `static`, `templates`. 

**Regarding the `migrate.sh` file:** 

If your app depends on a database it is common to run a database migration
script before app startup which, for example, creates or modifies tables. This
can be done by including the `migrate.sh` script in the root of your project. It
will be executed with the same environment variables and context as the Flask
application.

If the migration script fails, the app won't be started and the app charm will
go into blocked state. The migration script will be run on every unit and it is
assumed that it is idempotent (can be run multiple times) and that it can be run
on multiple units at the same time without causing issues. This can be achieved
by, for example, locking any tables during the migration.