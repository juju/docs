(scenario)=
# Scenario

> Source: [GitHub](https://github.com/canonical/ops-scenario)
> 
> See also: {ref}`How to write a functional test with Scenario <how-to-write-scenario-tests-for-a-charm>`


Scenario (`scenario`) is a testing framework for charms written with  {ref}`Ops (`ops`) <ops-ops>`. It excels at **functional** testing of charm code, making it ideal to write:

- **state-transition** tests
- **contract** tests

The core idea of Scenario is that a charm is best conceived of as an opaque input-output function, where:
- the input is a monolithic data structure called {ref}`State <state-scenario>`, representing the data that Juju makes available to the charm (as represented by the {ref}`Context <context-scenario>` object) at runtime
- the output is the State after the charm has been triggered to execute by some {ref}`Event <event-scenario>` and has had a chance to interact with the input State.

![image|690x384](upload://4neRbaEchNEyQroSuSfm0q9UFmB.png)

Scenario tests are written by declaring an initial state, then running the charm context with that state and an event as parameters to obtain the output state. You can then write assertions to verify that the output state looks like you expect it to; e.g. that a databag has been updated to contain a certain piece of data, or that the application status has been set to `blocked`, etc...


# Example

An example scenario test using  {ref}``Relation` <10583md>` might look like:

```python
import ops

from scenario import Relation, State, Context


# This charm copies over remote app data to local unit data
class MyCharm(ops.CharmBase):
    ...

    def _on_event(self, e):
        rel = e.relation
        assert rel.app.name == 'remote'
        assert rel.data[self.unit]['abc'] == 'foo'
        rel.data[self.unit]['abc'] = rel.data[e.app]['cde']


def test_relation_data():   
    # use scenario.Context to declare what charm we are testing 
     ctx = Context(MyCharm,
                  meta={"name": "foo"})

    # ARRANGE: declare the input state
    state_in = State(relations=[
        Relation(
            endpoint="foo",
            interface="bar",
            remote_app_name="remote",
            local_unit_data={"abc": "foo"},
            remote_app_data={"cde": "baz!"},
        ),
    ])

    # ACT: run an event in the context and pass the input state to it
    state_out = ctx.run('start', state_in)
  
    # ASSERT that the output state looks the way you expect it to
    assert state_out.relations[0].local_unit_data == {"abc": "baz!"}
    # you can directly compare State data structures to assert a certain delta
    assert state_out.relations == [
        Relation(
            endpoint="foo",
            interface="bar",
            remote_app_name="remote",
            local_unit_data={"abc": "baz!"},
            remote_app_data={"cde": "baz!"},
        ),
    ]
```