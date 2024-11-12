(how-to-add-an-action-to-a-charm)=
# How to add an action to a charm

> See first: [Juju | Action](https://juju.is/docs/juju/action), [Juju | How to manage actions](https://juju.is/docs/juju/manage-actions)

**Contents:**

- [Implement the action](#heading--implement-the-action)
- [Test the action](#heading--test-the-action)


<a href="#heading--implement-the-action"><h2 id="heading--implement-the-action">Implement the action</h2></a>

- [Declare the action in `charmcraft.yaml`](#heading--declare-the-action-in-charmcraft-yaml)
- [Observe the action event and define an event handler](#heading--observe-the-action-event-and-define-an-event-handler)


<a href="#heading--declare-the-action-in-charmcraft-yaml"><h3 id="heading--declare-the-action-in-charmcraft-yaml">Declare the action in `charmcraft.yaml`</h3></a>

To tell users what actions can be performed on the charm, define an `actions` section in `charmcraft.yaml` that lists the actions and information about each action. The actions should include a short description that explains what running the action will do. Normally, all parameters that can be passed to the action are also included here, including the type of parameter and any default value. You can also specify that some parameters are required when the action is run.
For example:
```yaml
actions:
  snapshot:
    description: Take a snapshot of the database.
    params:
      filename:
        type: string
        description: The name of the snapshot file.
      compression:
        type: object
        description: The type of compression to use.
        properties:
          kind:
            type: string
            enum:
            - gzip
            - bzip2
            - xz
            default: gzip
          quality:
            description: Compression quality
            type: integer
            default: 5
            minimum: 0
            maximum: 9
    required:
    - filename
    additionalProperties: false
```
> See more: {ref}`File `charmcraft.yaml` > `actions` <4459md>`


<a href="#heading--observe-the-action-event-and-define-an-event-handler"><h3 id="heading--observe-the-action-event-and-define-an-event-handler">Observe the action event and define an event handler</h3></a>

In the `src/charm.py` file, in the `__init__` function of your charm, set up an observer for the action event associated with your action and pair that with an event handler. For example:

```
self.framework.observe(self.on.grant_admin_role_action, self._on_grant_admin_role_action)
```

> See more: {ref}`Event `<action name>-action` <event-action-name-action>`

Now, in the body of the charm definition, define the action event handler. For example:

```
def _on_grant_admin_role_action(self, event):
    """Handle the grant-admin-role action."""
    # Fetch the user parameter from the ActionEvent params dict
    user = event.params["user"]
    # Do something useful with it
    cmd = ["/usr/bin/myapp", "roles", "system_admin", user]
    # Set a log message for the action
    event.log(f"Running this command: {' '.join(cmd)}")
    granted = subprocess.run(cmd, capture_output=True)
    if granted.returncode != 0:
        # Fail the action if there is an error
        event.fail(
            f"Failed to run '{' '.join(cmd)}'. Output was:\n{granted.stderr.decode('utf-8')}"
        )
    else:
        # Set the results of the action
        msg = f"Ran grant-admin-role for user '{user}'"
        event.set_results({"result": msg})
```

More detail below:

- [Use action params](#heading--use-action-params)
- [Report that an action has failed](#heading--report-that-an-action-has-failed)
- [Return the results of an action](#heading--return-the-results-of-an-action)
- [Log the progress of an action](#heading--log-the-progress-of-an-action)
- [Record the ID of an action task](#heading--record-the-id-of-an-action-task)

<a href="#heading--use-action-params"><h4 id="heading--use-action-params">Use action params</h4></a>

To make use of action parameters, either ones that the user has explicitly passed, or default values, use the `params` attribute of the event object that is passed to the handler. This is a dictionary of parameter name (string) to parameter value. For example:
```python
def _on_snapshot(self, event: ops.ActionEvent):
    filename = event.params["filename"]
    …
```
> See more: [`ops.ActionEvent.params`](https://ops.readthedocs.io/en/latest/#ops.ActionEvent.params)


<a href="#heading--report-that-an-action-has-failed"><h4 id="heading--report-that-an-action-has-failed">Report that an action has failed</h4></a>

To report that an action has failed, in the event handler definition, use the fail() method along with a message explaining the failure to be shown to the person running the action. Note that the `fail()` method doesn’t interrupt code execution, so you will usually want to immediately follow the call to `fail()` with a `return`, rather than continue with the event handler. For example:
```python
def _on_snapshot(self, event: ops.ActionEvent):
    filename = event.params['filename']
    kind = event.params['compression']['kind']
    quality = event.params['compression']['quality']
    cmd = ['/usr/bin/do-snapshot', f'--kind={kind}', f'--quality={quality}', filename]
    subprocess.run(cmd, capture_output=True)
    if granted.returncode != 0:
        event.fail(
            f"Failed to run {' '.join(cmd)!r}. Output was:\n{granted.stderr.decode('utf-8')}"
        )
   …
```
]
> See more: [`ops.ActionEvent.fail`](https://ops.readthedocs.io/en/latest/#ops.ActionEvent.fail)

<a href="#heading--return-the-results-of-an-action"><h4 id="heading--return-the-results-of-an-action">Return the results of an action</h4></a>

To pass back the results of an action to the user, use the `set_results` method of the action event. These will be displayed in the `juju run` output. For example:
```python
def _on_snapshot(self, event: ops.ActionEvent):
    size = self.do_snapshot(event.params['filename'])
    event.set_results({'snapshot-size': size})
```
> See more: [`ops.ActionEvent.set_results`](https://ops.readthedocs.io/en/latest/#ops.ActionEvent.set_results)


<a href="#heading--log-the-progress-of-an-action"><h4 id="heading--log-the-progress-of-an-action">Log the progress of an action</h4></a>

In a long-running action, to give the user updates on progress, use the `.log()` method of the action event. This is sent back to the user, via Juju, in real-time, and appears in the output of the `juju run` command. For example:
```python
def _on_snapshot(self, event: ops.ActionEvent):
    event.log('Starting snapshot')
    self.snapshot_table1()
    event.log('Table1 complete')
    self.snapshot_table2()
    event.log('Table2 complete')
    self.snapshot_table3()
```
> See more: [`ops.ActionEvent.log`](https://ops.readthedocs.io/en/latest/#ops.ActionEvent.log)


<a href="#heading--record-the-id-of-an-action-task"><h4 id="heading--record-the-id-of-an-action-task">Record the ID of an action task</h4></a>

When a unique ID is needed for the action task - for example, for logging or creating temporary files, use the `.id` attribute of the action event. For example:
```python
def _on_snapshot(self, event: ops.ActionEvent):
    temp_filename = f'backup-{event.id}.tar.gz'
    logger.info("Using %s as the temporary backup filename in task %s", filename, event.id)
    self.create_backup(temp_filename)
    ... 
```
> See more: [`ops.ActionEvent.id`](https://ops.readthedocs.io/en/latest/#ops.ActionEvent.id)


<a href="#heading--test-the-action"><h2 id="heading--test-the-action">Test the action</h2></a>

> See first: {ref}`Get started with charm testing <getting-started-with-charm-testing>`

What you need to do depends on what kind of tests you want to write.

- [Write unit tests](#heading--write-unit-tests)
- [Write scenario tests](#heading--write-scenario-tests)
- [Write integration tests](#heading--write-integration-tests)

<a href="#heading--write-unit-tests"><h3 id="heading--write-unit-tests">Write unit tests</h3></a>

> See first: {ref}`How to write unit tests for a charm <how-to-write-unit-tests-for-a-charm>`

When using Harness for unit tests, use the `run_action` method to verify that charm actions have the expected behaviour. This method will either raise an `ActionFailed` exception (if the charm used the `event.fail()` method) or return an `ActionOutput` object. These can be used to verify the failure message, logs, and results of the action. For example:
```python
def test_backup_action():
    harness = ops.testing.Harness()
    harness.begin()
    try:
        out = harness.run_action('snapshot', {'filename': 'db-snapshot.tar.gz'})
    except ops.testing.ActionFailed as e:
        assert "Could not backup because" in e.message
    else:
        assert out.logs == ['Starting snapshot', 'Table1 complete', 'Table2 complete']
        assert 'snapshot-size' in out.results
    finally:
        harness.cleanup()


```
> See more: [`ops.testing.Harness.run_action`](https://ops.readthedocs.io/en/latest/#ops.testing.Harness.run_action)


<a href="#heading--write-scenario-tests"><h3 id="heading--write-scenario-tests">Write scenario tests</h3></a>
> See first: {ref}`How to write scenario tests for a charm <how-to-write-scenario-tests-for-a-charm>`

When using Scenario for unit tests, to verify that the charm state is as expected after executing an action, use the `run_action` method of the Scenario `Context` object. The method returns an `ActionOutput` object that contains any logs and results that the charm set.
For example:
```python
def test_backup_action():
    action = scenario.Action('snapshot', params={'filename': 'db-snapshot.tar.gz'})
    ctx = scenario.Context(MyCharm)
    out = ctx.run_action(action, scenario.State())
    assert out.logs == ['Starting snapshot', 'Table1 complete', 'Table2 complete']
    if out.success:
      assert 'snapshot-size' in out.results
    else:
      assert 'Failed to run' in out.failure
```
> See more: [Scenario action testing](https://github.com/canonical/ops-scenario?tab=readme-ov-file#actions)


<a href="#heading--write-integration-tests"><h3 id="heading--write-integration-tests">Write integration tests</h3></a>
> See first: {ref}`How to write integration tests for a charm <how-to-write-integration-tests-for-a-charm>`

To verify that an action works correctly against a real Juju instance, write an integration test with `pytest_operator`. For example:
```python
async def test_logger(ops_test):
    app = ops_test.model.applications[APP_NAME]
    unit = app.units[0]  # Run the action against the first unit.
    action = await unit.run_action('snapshot', filename='db-snapshot.tar.gz')
    action = await action.wait()
    assert action.status == 'completed'
    assert action.results['snapshot-size'].isdigit()
```

<br>

> <small>**Contributors:**@benhoyt, @danieleprocida, @jnsgruk, @michele-mancioppi, @mmkay, @tmihoc, @tony-meyer, @toto </small>