### Grant model access
The administrator grants the user write access to the previously created model:

```bash
juju grant --acl=write tom lxd-model-1
```

### Juju usage
Because the regular user has been provided write access to the model
he/she can begin to utilise Juju:

```bash
juju deploy mysql mysql-staging
```
