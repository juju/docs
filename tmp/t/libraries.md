(libraries)=
# Libraries

Charm authors need a way to easily share and reuse logic, this is particularly important given the two-sided nature of relations. That is, a given `interface` type needs logic both on the providing and requiring side which is best handled when that responsibility lies on the same entity (and original author!).

The [`charmcraft`](https://github.com/canonical/charmcraft) tool supports a first-class mechanism to reuse charm logic. This is essentially a form of Python modules named ‘libraries’ which are published on [Charmhub](https://charmhub.io) for easy consumption. This model diverges from generic versioning systems (such as `git`/Github) and package repositories (like [PyPI](https://pypi.org/)) by providing a simpler mechanism for sharing code. When working with charm libraries, there is no need to utilise external tools to build, distribute or install libraries, nor the requirement for users to register with other platforms.

Charm libraries are directly integrated with Charmhub, increasing the discoverability of relevant libraries (including their documentation) when exploring available charms.

Fundamentally, charm libraries provide a means for charm developers to make the implementation of any relation they define as simple as possible for other developers.

**Contents:**
- [Library creation](#heading--library-creation)
- [Library documentation](#heading--library-documentation)
    - [Header example](#heading--header-example)
- [Defining custom events](#heading--defining-custom-events)
    - [Simple events](#heading--simple-events)
    - [Complex events](#heading--complex-events)
- [Library example](#heading--library-example)
    - [Implement requires-side](#heading--implement-requires-side)
    - [Implement provides-side](#heading--implement-provides-side)
    - [Using the example library](#heading--using-the-example-library)


 <a href="#heading--library-creation"><h2 id="heading--library-creation">Library creation</h2></a>

Charm libraries should always be initialised using the `charmcraft` tool.  There are more details about finding, creating and publishing libraries with `charmcraft` in the [Publishing Libraries](https://juju.is/docs/sdk/charmcraft-libraries) section.  

To quickly create a new charm library with `charmcraft`:

```bash
# Initialise a charm library named 'demo'
$ charmcraft create-lib demo
```

This will create the library at: `lib/charms/demo/v0/demo.py` in your charm project directory

Libraries are generally a single Python file that encapsulates some specific functionality; there are three fields that must be defined in a charm library file:

|   Field   |              Example               | Description                                                                                                                                                                                                                                                                                         |
| :--------: | :--------------------------------: | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  `LIBID`   | `2d35a009b0d64fe186c99a8c9e53c6ab` | A unique identifier for the library across the entire universe of charms. This is assigned by Charmhub/`charmcraft` automatically at library creation time.<br/><br/>This identifier enables Charmhub and `charmcraft` to track the library uniquely even if the charm or the library are renamed. |
|  `LIBAPI`  |                `3`                 | Major version of the library. Must match the major version in the import path.                                                                                                                                                                                                                      |
| `LIBPATCH` |                `4`                 | Current patch version of the library. Must be updated each time a new version of the library is published to Charmhub.                                                                                                                                                                              |

In addition to pre-populating these fields, the `charmcraft create-lib` command will also template a library docstring into the resulting file. See below for the complete file created by the above example:

```python
"""TODO: Add a proper docstring here.
This is a placeholder docstring for this charm library. Docstrings are
presented on Charmhub and updated whenever you push a new version of the
Library.

See `charmcraft push-lib` and `charmcraft fetch-lib` for details of how to
share and consume charm libraries. They serve to enhance collaboration
between charmers. Use a charmer's libraries for classes that handle
integration with their charm.

Bear in mind that new revisions of the different major API versions (v0, v1,
v2 etc) are maintained independently.  You can continue to update v0 and v1
after you have pushed v3.

Markdown is supported, following the CommonMark specification.
"""

# The unique Charmhub library identifier, never change it
LIBID = "4e70405e1ec34590ad4a3b0654d1f721"

# Increment this major API version when introducing breaking changes
LIBAPI = 0

# Increment this PATCH version before using `charmcraft push-lib` or reset
# to 0 if you are raising the major API version
LIBPATCH = 1

# TODO: add your code here! Happy coding!
```

 <a href="#heading--library-documentation"><h2 id="heading--library-documentation">Library documentation</h2></a>


Library documentation is critical to enable other charm developers to discover and use your library correctly. There are two key sections to author when creating library documentation:

- Library header: A Python multiline comment using the `"""triple-quote syntax"""`. This section should be written in Markdown, following the [CommonMark](https://commonmark.org/) specification.
- Python docstrings: Each class, method and function should be documented using Python docstrings. For best results on your library’s page on Charmhub, conform to the [Google Python Docstring](https://github.com/google/styleguide/blob/gh-pages/pyguide.md#38-comments-and-docstrings) format.


 <a href="#heading--header-example"><h3 id="heading--header-example">Header example</h3></a>


The following shows an example library documentation header using [CommonMark](https://commonmark.org/):

````python
"""

# My Super Awesome Library

This library is super awesome. It is published as part of the [super-
awesome charm](https://charmhub.io/super-awesome) and has some really
cool features:

- Awesome feature
- Rad feature
- Neat feature

A typical example of including this library might be:

```python
# ...
from charms.super_awesome.v1.awesomelib import AwesomeClass

class SomeApplication(CharmBase):
  def __init__(self, *args):
    # ...
    self.awesome = AwesomeClass(self)
    # ...
\```

You can file bugs [here](https://github.com/awesomedev/super-awesome/issues)!
"""
````

<h3 id="heading--docstring-example">Docstring example</h3>

Explain each function using [Google Python Docstring](https://github.com/google/styleguide/blob/gh-pages/pyguide.md#38-comments-and-docstrings).

```python
def function():
	"""This sentence is a summary of the function.

	This section gives more details about the function and what
	it does. In this case the function returns foo.

	Returns:
    		A string containing "foo"
 	"""
	return "foo"


class Example:
	"""A one sentence summary of the class.

	This section gives more details about the class and what
	it does.

	Arguments:
    		foo (int): the argument foo
    		bar (str): the argument bar

	Attributes:
    		foo (int): the attribute foo
    		bar (str): the attribute bar
	"""
	def __init__(self, foo, bar):
    		self.foo = foo
    		self.bar = bar

	def info(self, add=1):
    	"""Return foo plus add.

    	This function adds add to foo

    	Arguments:
        	add (int, optional): The number to add to foo. Defaults to 1.

    	Returns:
        	self.foo plus add
    	"""
    		return add + self.foo
```

 <a href="#heading--defining-custom-events"><h2 id="heading--defining-custom-events">Defining custom events</h2></a>



In the context of regular charms that do not offer libraries, charm authors should not define their own events. This is because most charms have no reason to consume their own custom events, and no downstream charms to consume them either. In the context of libraries however, the definition of custom events provides a convenient mechanism for downstream charm authors to respond to certain conditions that are met within your library.


 <a href="#heading--simple-events"><h3 id="heading--simple-events">Simple events</h3></a>


Custom events in their simplest form can be defined in just a couple of lines. Such definitions should be made in a library file at `$CHARMDIR/lib/charms/<charm_name>/v<API>/<library_name>.py`:

```python
from ops.framework import EventBase

# All custom events must inherit from EventBase (or some derivative of EventBase)
class SimpleCustomEvent(EventBase):
    pass
```

With the event defined, the library must now enable other charms to respond to that event by defining a derivative of the `CharmEvents` class, which can be instantiated and used to replace a charm’s `on` class attribute. This will enable the charm to bind callbacks to our custom event with `self.framework.observe(self.on.simple_custom, self._callback)`:

```python
# ...
from ops.charm import CharmEvents
from ops.framework import EventSource
# ...

# A CharmEvents object is usually bound to a Charm's
# 'on' class attribute. Here we create a custom
# version including an EventSource for our custom event
class CustomEventCharmEvents(CharmEvents):
    simple_custom = EventSource(SimpleCustomEvent)
```

Note that `CustomEventCharmEvents` inherits from [`CharmEvents`](https://ops.readthedocs.io/en/latest/#ops.charm.CharmEvents), which is the class that defines a charm’s regular lifecycle events (`install`, `config-changed`, etc.). In this case, we inherit the usual lifecycle events and create an additional event. The [`EventSource`](https://ops.readthedocs.io/en/latest/#ops.framework.EventSource) class wraps events with a suitable descriptor that facilitates emission and observation of the event. In this case specifically, it is used to define a [`BoundEvent`](https://ops.readthedocs.io/en/latest/#ops.framework.BoundEvent) attribute named `simple_custom` on the `CustomEventCharmEvents` class.

Finally, we need to define an object that emits our new event:

```python
from ops.framework import Object

# This is the object that will emit our "SuperCustomEvent"
# A common use for this might be to emit a custom event
# in response to valid relation data being provided by a
# remote unit
class SimpleCustomEmitter(Object):
    # Define a constructor that takes the charm and it's StoredState
    def __init__(self, charm, _stored):
        super().__init__(charm, None)
        self.framework.observe(charm.on.some_relation_changed, self._on_relation_changed)
        # This references the StoredState of the charm consuming the library
        self._stored = _stored
        self.charm = charm

    def _on_relation_changed(self, event):
        # Do some stuff
        self._stored.update({"emitted": "yes"})
        # Emit our custom event so that charm authors using the library can respond
        self.charm.on.simple_custom.emit()
```

This is a trivial example that responds to a `relation-changed` event. It could be used, for example, to validate that the correct data was provided by a remote unit, before emitting our custom event to let downstream charms know that it’s okay to proceed with the information provided - essentially implementing a relation interface.

Now, in the charm providing the library and ultimately responding to our custom event, we need to make sure that it is aware of the `CustomEventCharmEvents` class, and replace its `on` class attribute so that it can respond to `SimpleCustomEvent`s:

```python
from charms.demo.v0.demo import CustomEventCharmEvents, SimpleCustomEmitter

class CustomEventCharm(CharmBase):
    # ...
    on = CustomEventCharmEvents()
    # ...
    def __init__(self, *args):
        super().__init__(*args)
        # ...
        self.emitter = SimpleCustomEmitter(self, self._stored)
        self.framework.observe(self.on.simple_custom, self._on_config_changed)
        # ...
```

Because the `CustomEventCharm` class has its `on` attribute replaced with an instance of `CustomEventCharmEvents`, the developer can access the usual lifecycle events, but also bind callbacks to the `self.on.simple_custom` event to respond to emissions by the `SimpleCustomEmitter` implementation.

 <a href="#heading--complex-events"><h3 id="heading--complex-events">Complex events</h3></a>


There are certain cases where events may need to carry some data. An example of this in the Charmed Operator Framework is the [`WorkloadEvent`](https://ops.readthedocs.io/en/latest/#ops.charm.WorkloadEvent), which carries a [`workload`](https://ops.readthedocs.io/en/latest/#ops.charm.WorkloadEvent.workload) attribute denoting the [`Container`](https://ops.readthedocs.io/en/latest/#ops.model.Container) that is related to the event.

Custom events can also define attributes, but in order for them to be serialised correctly, they must also define a suitable `snapshot` and `restore` method. An simple example is below:

```python
# ...
from ops.framework import EventBase

class ComplexCustomEvent(EventBase):
    """Event that carries a 'data' attribute"""

    def __init__(self, handle, data=None):
        super().__init__(handle)
        self.data = data

    def snapshot(self):
        return {"data": self.data}

    def restore(self, snapshot):
        self.data = snapshot["data"]
```

All of the other details from the simple custom event implementation remain the same, with the exception that when the event is emitted, the associated data must be provided:

```python
# ...
def _on_some_event(self, event):
        # Define some arbitrary data....
        some_data = { "id": 1, "action": "save" }
        # Emit our custom event with associated data
        self.charm.on.complex_custom.emit(some_data)
# ...
```

 <a href="#heading--library-example"><h2 id="heading--library-example">Library example</h2></a>


If we take the example we used to demonstrate provides/requires relations in the [relations section](https://juju.is/docs/sdk/relations#heading--requires-provides-example), we could choose to implement the relation functionality using a charm library. We will do this by providing two key classes in the library: `DemoProvides` and `DemoRequires`, that implement either side of the relation.

 <a href="#heading--implement-requires-side"><h3 id="heading--implement-requires-side">Implement requires-side</h3></a>


We’ll start by implementing `RelationRequires` which will essentially move some of the original charm code from `src/charm.py` into the library at `lib/charms/demo/v0/demo.py`:

```python
# ...
from ops.framework import EventBase, EventSource, Object
from ops.charm import CharmEvents
# ...

# Define a custom event "DemoRelationUpdatedEvent" to be emitted
# when relation change has completed successfully, and handled
# by charm authors.
# See "Notes on defining events" section in docs
class DemoRelationUpdatedEvent(EventBase):
    pass


# Define an instance of CharmEvents to allow our initial charm to override
# its 'on' class attribute and respond to self.on.demo_relation_updated
class DemoRelationCharmEvents(CharmEvents):
    demo_relation_updated = EventSource(DemoRelationUpdatedEvent)


class DemoRequires(Object):
    def __init__(self, charm, _stored):
        # Define a constructor that takes the charm and it's StoredState
        super().__init__(charm, None)
        self.framework.observe(charm.on.demo_relation_changed, self._on_relation_changed)
        self.framework.observe(charm.on.demo_relation_broken, self._on_relation_broken)
        self._stored = _stored
        self.charm = charm

    def _on_relation_changed(self, event: RelationChangedEvent):
        # Do nothing if we're not the leader
        if not self.model.unit.is_leader():
            return

        # Check if the remote unit has set the 'leader-uuid' field in the
        # application data bucket
        leader_uuid = event.relation.data[event.app].get("leader-uuid")
        # Store some data from the relation in local state
        self._stored.apps.update({event.relation.id: {"leader_uuid": leader_uuid}})

        # Fetch data from the unit data bag if available
        if event.unit:
            unit_field = event.relation.data[event.unit].get("special-field")
            logger.info("Got data in the unit bag from the relation: %s", unit_field)

        # Set some application data for the remote application
        # to consume. We can do this because we're the leader
        event.relation.data[self.model.app].update({"token": f"{uuid4()}"})

        # Emit an event so that charm authors using the library can respond
        self.charm.on.demo_relation_updated.emit()

    def _on_relation_broken(self, event: RelationBrokenEvent):
        # Remove the unit data from local state
        self._stored.apps.pop(event.relation.id, None)
        # Emit an event so that charm authors using the library can respond
        self.charm.on.demo_relation_updated.emit()
```

The above code sample defines a new event `DemoRelationUpdatedEvent` that inherits from `EventBase`, as described in [Event handling](https://juju.is/docs/sdk/events). It also defines `DemoRelationCharmEvents`, which will be instantiated and used to replace the `on` class attribute of any consuming charm, so that it can respond to `DemoRelationUpdatedEvents` with `self.on.demo_relation_updated`.

Now that we've refactored this into the library, we need to adjust the `__init__` method of our existing demo charm to use this part of the library. Where previously, we were calling the `_on_config_changed` handler at the end of the `_on_demo_relation_changed` handler, we now respond to our new `demo_relation_updated` event and assign the `_on_config_changed` callback to it:

```python
# ...
from charms.demo.v0.demo import DemoProvides, DemoRelationCharmEvents
#...

class SpecialCharm(CharmBase):
    # ...
    on = DemoRelationCharmEvents()
    # ...
    def __init__(self, *args):
        super().__init__(*args)
        # ...
        self.demo = DemoRequires(self, self._stored)
        self.framework.observe(self.on.demo_relation_updated, self._on_config_changed)
        # ...
```

 <a href="#heading--implement-provides-side"><h3 id="heading--implement-provides-side">Implement provides-side</h3></a>


Next, we’ll implement `RelationProvides` which in this case, would usually require an equivalent implementation by an application charm author:

```python
# ...
from ops.framework import Object
# ...

class DemoProvides(Object):
    # Define a constructor that takes the charm and it's StoredState
    def __init__(self, charm, _stored):
        super().__init__(charm, "demo")
        self.framework.observe(charm.on.demo_relation_changed, self._on_relation_changed)
        self._stored = _stored

    def _on_relation_changed(self, event):
        # `self.unit` isn't available in this context, so use `self.model.unit`.
        if self.model.unit.is_leader():
            event.relation.data[self.model.app].update({"leader-uuid": self._stored.uuid})

        # Set a field in the unit data bucket
        event.relation.data[self.model.unit].update({"special-field": self.model.unit.name})
        # Log if we've received data over the relation
        if self._stored.token == "":
            logger.info("Got a new token from '%s'", event.app.name)
            # Get some info from the relation and store it in state
            self._stored.token = event.relation.data[event.app].get("token")

```

 <a href="#heading--using-the-example-library"><h3 id="heading--using-the-example-library">Using the example library</h3></a>


One the above library is published, any charm author could simply make use of our charm library. A developer would first need to identify and fetch our charm library from Charmhub using `charmcraft`:

```bash
# Make sure you're in the charm directory
cd $CHARMDIR

# List charms - search by name
$ charmcraft list-lib demo
Library name    API    Patch
demo            0      0

# Fetch the library and place it in our codebase
$ charmcraft fetch-lib charms.demo.v0.demo
Library charms.demo.v0.demo version 0.0 downloaded.

# See where charmcraft has put the library
$ ls -l lib/charms/demo/v0/demo.py
-rw-rw-r-- 1 user user 1061 Dec 17 15:24 lib/charms/demo/v0/demo.py
```

Now we’ve included the charm library with `charmcraft`, we can start using it in our application code:

```python
# ...
from charms.demo.v0.demo import DemoProvides
# ...
class SomeApplicationCharm(CharmBase):
    # ...
    def __init__(self, *args):
        # ...
        self.demo = DemoProvides(self, self._stored)
        # ...
```

While only a trivial example, you can see that a charm developer can effectively implement the relation by adding just two lines of code to their charm.