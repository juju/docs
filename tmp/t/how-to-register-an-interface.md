(how-to-register-an-interface)=
# How to register an interface

> Also see:
> - {ref}`Interface tests <interface-tests>`
> - {ref}`How to write interface tests <how-to-write-interface-tests>`
> - {ref}`How to test interface tests <12689md>`

Suppose you have determined that you need to create a new relation interface called `my_fancy_database`. 

Suppose that your interface specification has the following data model:
- the requirer app is supposed to forward a list of tables that it wants to be provisioned by the database provider
- the provider app (the database) at that point will reply with an API endpoint and, for each replica, it will provide a separate secret ID to authenticate the requests

These are the steps you need to take in order to  register it with {ref}``charm-relation-interfaces` <charm-relation-interfaces>`.

---
```{dropdown} Expand to preview some example results

- [A bare-minimum example](https://github.com/IronCore864/charm-relation-interfaces/tree/my-fancy-database/interfaces/my_fancy_database/v0)
- [A more realistic example](https://github.com/canonical/charm-relation-interfaces/tree/main/interfaces/ingress/v1): 
   - As you can see from the [`interface.yaml`](https://github.com/canonical/charm-relation-interfaces/blob/main/interfaces/ingress/v1/interface.yaml) file, the [`canonical/traefik-k8s-operator` charm](https://github.com/canonical/traefik-k8s-operator) plays the provider role in the interface.
   - The schema of this interface is defined in [`schema.py`](https://github.com/canonical/charm-relation-interfaces/blob/main/interfaces/ingress/v1/schema.py).
   - You can find out more information about this interface in the [README](https://github.com/canonical/charm-relation-interfaces/blob/main/interfaces/ingress/v1/README.md).


```

---

## 1. Clone (a fork of) [the `charm-relation-interfaces` repo](https://github.com/canonical/charm-relation-interfaces) and set up an interface specification folder

```bash
git clone https://github.com/canonical/charm-relation-interfaces
cd /path/to/charm-relation-interfaces
```

## 2. Make a copy of the template folder
Copy the template folder to a new folder called the same as your interface (with underscores instead of dashes).

```bash
cp -r ./interfaces/__template__ ./interfaces/my_fancy_database
```

At this point you should see this directory structure:

```
# tree ./interfaces/my_fancy_database
./interfaces/my_fancy_database
└── v0
    ├── README.md
    ├── interface.yaml
    ├── interface_tests
    └── schema.py                                     
2 directories, 3 files
```

## 3. Edit `interface.yaml`

Add to `interface.yaml` the charm that owns the reference implementation of the `my_fancy_database` interface. Assuming your `my_fancy_database_charm` plays the `provider` role in the interface, your `interface.yaml` will look like this:

```yaml
# interface.yaml
providers:                                                  
  - name: my-fancy-database-operator  # same as metadata.yaml's .name
    url: https://github.com/your-github-slug/my-fancy-database-operator
```

## 4. Edit `schema.py`

Edit `schema.py` to contain:

```python
# schema.py

from interface_tester.schema_base import DataBagSchema
from pydantic import BaseModel, AnyHttpUrl, Field, Json
import typing


class ProviderUnitData(BaseModel):
    secret_id: str = Field(
        description="Secret ID for the key you need in order to query this unit.",
        title="Query key secret ID",
        examples=["secret:12312323112313123213"],
    )


class ProviderAppData(BaseModel):
    api_endpoint: AnyHttpUrl = Field(
        description="URL to the database's endpoint.",
        title="Endpoint API address",
        examples=["https://example.com/v1/query"],
    )


class ProviderSchema(DataBagSchema):
    app: ProviderAppData
    unit: ProviderUnitData


class RequirerAppData(BaseModel):
    tables: Json[typing.List[str]] = Field(
        description="Tables that the requirer application needs.",
        title="Requested tables.",
        examples=[["users", "passwords"]],
    )


class RequirerSchema(DataBagSchema):
    app: RequirerAppData
    # we can omit `unit` because the requirer makes no use of the unit databags
```

To verify that things work as they should, you can `pip install pytest-interface-tester` and then run `interface_tester discover --include my_fancy_database` from the `charm-relation-interfaces` root.

You should see:
```yaml
- my_fancy_database:
  - v0:
   - provider:
     - <no tests>
     - schema OK
     - charms:
       - my_fancy_database_charm (https://github.com/your-github-slug/my-fancy-database-operator) custom_test_setup=no
   - requirer:
     - <no tests>
     - schema OK
     - <no charms>
```

In particular pay attention to `schema`. If it says `NOT OK` then there is something wrong with the pydantic model.

## 5. Edit `README.md`

Edit the `README.md` file to contain:
```markdown
# `my_fancy_database`

## Overview
This relation interface describes the expected behavior between of any charm claiming to be able to interface with a Fancy Database and the Fancy Database itself.
Other Fancy Database-compatible providers can be used interchangeably as well.

## Usage

Typically, you can use the implementation of this interface from [this charm library](https://github.com/your_org/my_fancy_database_operator/blob/main/lib/charms/my_fancy_database/v0/fancy.py), although charm developers are free to provide alternative libraries as long as they comply with this interface specification.

## Direction
The `my_fancy_database` interface implements a provider/requirer pattern.
The requirer is a charm that wishes to act as a Fancy Database Service consumer, and the provider is a charm exposing a Fancy Database (-compatible API).

/```mermaid
flowchart TD
    Requirer -- tables --> Provider
    Provider -- endpoint, access_keys --> Requirer
/```

## Behavior

The requirer and the provider must adhere to a certain set of criteria to be considered compatible with the interface.

### Requirer

- Is expected to publish a list of tables in the application databag


### Provide

- Is expected to publish an endpoint URL in the application databag
- Is expected to create and grant a Juju Secret containing the access key for each shard and publish its secret ID in the unit databags.

## Relation Data

See the {ref}`\[Pydantic Schema\] <12689md>`


### Requirer

The requirer publishes a list of tables to be created, as a json-encoded list of strings.

#### Example
\```yaml
application_data: {
   "tables": "{ref}`'users', 'passwords']"
}
\```

### Provider

The provider publishes an endpoint url and access keys for each shard.

#### Example
\```
application_data: {
   "api_endpoint": "https://foo.com/query"
},
units_data : {
  "my_fancy_unit/0": {
     "secret_id": "secret:12312321321312312332312323"
  },
  "my_fancy_unit/1": {
     "secret_id": "secret:45646545645645645646545456"
  }
}
\```
```

## 6. Add interface tests

See [How to write interface tests <how-to-write-interface-tests>`.

## 7. Open a PR to [the `charm-relation-interfaces` repo](https://github.com/canonical/charm-relation-interfaces) 

Finally, open a pull request to the `charm-relation-interfaces` repo and drive it to completion, addressing any feedback or concerns that the maintainers may have.

> Contributors: @ironcore864, @ppasotti