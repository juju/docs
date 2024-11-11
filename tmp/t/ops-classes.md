(ops-classes)=
# `ops` classes

> See also:
> - {ref}`Ops (`ops`) <ops-ops>`

This is a list of all the Ops (`ops`) classes.

**Contents:**
- [charm.py](#heading--charmpy)
- [framework.py](#heading--frameworkpy)
- [jujuversion.py](#heading--jujuversionpy)
- [log.py](#heading--logpy)
- [model.py](#heading--modelpy)
- [pebble.py](#heading--pebblepy)
- [testing.py](#heading--testingpy)


<a href="#heading--charmpy"><h2 id="heading--charmpy">charm.py</h2></a>

- [charm.ActionEvent](https://ops.readthedocs.io/en/latest/#ops.charm.ActionEvent)
- [charm.ActionMeta](https://ops.readthedocs.io/en/latest/#ops.charm.ActionMeta)
- [charm.CharmBase](https://ops.readthedocs.io/en/latest/#ops.charm.CharmBase)
- [charm.CharmEvents](https://ops.readthedocs.io/en/latest/#ops.charm.CharmEvents)
- [charm.CharmMeta](https://ops.readthedocs.io/en/latest/#ops.charm.CharmMeta)
- [charm.CollectMetricsEvent](https://ops.readthedocs.io/en/latest/#ops.charm.CollectMetricsEvent)
- [charm.ConfigChangedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.ConfigChangedEvent)
- [charm.ContainerMeta](https://ops.readthedocs.io/en/latest/#ops.charm.ContainerMeta)
- [charm.ContainerStorageMeta](https://ops.readthedocs.io/en/latest/#ops.charm.ContainerStorageMeta)
- [charm.HookEvent](https://ops.readthedocs.io/en/latest/#ops.charm.HookEvent)
- [charm.InstallEvent](https://ops.readthedocs.io/en/latest/#ops.charm.InstallEvent)
- [charm.LeaderElectedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.LeaderElectedEvent)
- [charm.LeaderSettingsChangedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.LeaderSettingsChangedEvent)
- [charm.PayloadMeta](https://ops.readthedocs.io/en/latest/#ops.charm.PayloadMeta)
- [charm.PebbleReadyEvent](https://ops.readthedocs.io/en/latest/#ops.charm.PebbleReadyEvent)
- [charm.PostSeriesUpgradeEvent](https://ops.readthedocs.io/en/latest/#ops.charm.PostSeriesUpgradeEvent)
- [charm.PreSeriesUpgradeEvent](https://ops.readthedocs.io/en/latest/#ops.charm.PreSeriesUpgradeEvent)
- [charm.RelationBrokenEvent](https://ops.readthedocs.io/en/latest/#ops.charm.RelationBrokenEvent)
- [charm.RelationChangedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.RelationChangedEvent)
- [charm.RelationCreatedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.RelationCreatedEvent)
- [charm.RelationDepartedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.RelationDepartedEvent)
- [charm.RelationEvent](https://ops.readthedocs.io/en/latest/#ops.charm.RelationEvent)
- [charm.RelationJoinedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.RelationJoinedEvent)
- [charm.RelationMeta](https://ops.readthedocs.io/en/latest/#ops.charm.RelationMeta)
- [charm.RelationRole](https://ops.readthedocs.io/en/latest/#ops.charm.RelationRole)
- [charm.RemoveEvent](https://ops.readthedocs.io/en/latest/#ops.charm.RemoveEvent)
- [charm.ResourceMeta](https://ops.readthedocs.io/en/latest/#ops.charm.ResourceMeta)
- [charm.StartEvent](https://ops.readthedocs.io/en/latest/#ops.charm.StartEvent)
- [charm.StopEvent](https://ops.readthedocs.io/en/latest/#ops.charm.StopEvent)
- [charm.StorageAttachedEvent](https://ops.readthedocs.io/en/latest/#ops.charm.StorageAttachedEvent)
- [charm.StorageDetachingEvent](https://ops.readthedocs.io/en/latest/#ops.charm.StorageDetachingEvent)
- [charm.StorageEvent](https://ops.readthedocs.io/en/latest/#ops.charm.StorageEvent)
- [charm.StorageMeta](https://ops.readthedocs.io/en/latest/#ops.charm.StorageMeta)
- [charm.UpdateStatusEvent](https://ops.readthedocs.io/en/latest/#ops.charm.UpdateStatusEvent)
- [charm.UpgradeCharmEvent](https://ops.readthedocs.io/en/latest/#ops.charm.UpgradeCharmEvent)
- [charm.WorkloadEvent](https://ops.readthedocs.io/en/latest/#ops.charm.WorkloadEvent)


<a href="#heading--frameworkpy"><h2 id="heading--frameworkpy">framework.py</h2></a>

- [framework.BoundEvent](https://ops.readthedocs.io/en/latest/#ops.framework.BoundEvent)
- [framework.BoundStoredState](https://ops.readthedocs.io/en/latest/#ops.framework.BoundStoredState)
- [framework.CommitEvent](https://ops.readthedocs.io/en/latest/#ops.framework.CommitEvent)
- [framework.EventBase](https://ops.readthedocs.io/en/latest/#ops.framework.EventBase)
- [framework.EventSource](https://ops.readthedocs.io/en/latest/#ops.framework.EventSource)
- [framework.FrameworkEvents](https://ops.readthedocs.io/en/latest/#ops.framework.FrameworkEvents)
- [framework.Framework](https://ops.readthedocs.io/en/latest/#ops.framework.Framework)
- [framework.HandleKind](https://ops.readthedocs.io/en/latest/#ops.framework.HandleKind)
- [framework.Handle](https://ops.readthedocs.io/en/latest/#ops.framework.Handle)
- [framework.NoTypeError](https://ops.readthedocs.io/en/latest/#ops.framework.NoTypeError)
- [framework.ObjectEvents](https://ops.readthedocs.io/en/latest/#ops.framework.ObjectEvents)
- [framework.Object](https://ops.readthedocs.io/en/latest/#ops.framework.Object)
- [framework.PreCommitEvent](https://ops.readthedocs.io/en/latest/#ops.framework.PreCommitEvent)
- [framework.PrefixedEvents](https://ops.readthedocs.io/en/latest/#ops.framework.PrefixedEvents)
- [framework.StoredDict](https://ops.readthedocs.io/en/latest/#ops.framework.StoredDict)
- [framework.StoredList](https://ops.readthedocs.io/en/latest/#ops.framework.StoredList)
- [framework.StoredSet](https://ops.readthedocs.io/en/latest/#ops.framework.StoredSet)
- [framework.StoredStateData](https://ops.readthedocs.io/en/latest/#ops.framework.StoredStateData)
- [framework.StoredState](https://ops.readthedocs.io/en/latest/#ops.framework.StoredState)


<a href="#heading--jujuversionpy"><h2 id="heading--jujuversionpy">jujuversion.py</h2></a>

- [jujuversion.JujuVersion](https://ops.readthedocs.io/en/latest/#ops.jujuversion.JujuVersion)

<a href="#heading--logpy"><h2 id="heading--logpy">log.py</h2></a>

- [log.JujuLogHandler](https://ops.readthedocs.io/en/latest/#ops.log.JujuLogHandler)

<a href="#heading--modelpy"><h2 id="heading--modelpy">model.py</h2></a>

- [model.ActiveStatus](https://ops.readthedocs.io/en/latest/#ops.model.ActiveStatus)
- [model.Application](https://ops.readthedocs.io/en/latest/#ops.model.Application)
- [model.BindingMapping](https://ops.readthedocs.io/en/latest/#ops.model.BindingMapping)
- [model.Binding](https://ops.readthedocs.io/en/latest/#ops.model.Binding)
- [model.BlockedStatus](https://ops.readthedocs.io/en/latest/#ops.model.BlockedStatus)
- [model.CheckInfoMapping](https://ops.readthedocs.io/en/latest/#ops.model.CheckInfoMapping)
- [model.ConfigData](https://ops.readthedocs.io/en/latest/#ops.model.ConfigData)
- [model.ContainerMapping](https://ops.readthedocs.io/en/latest/#ops.model.ContainerMapping)
- [model.Container](https://ops.readthedocs.io/en/latest/#ops.model.Container)
- [model.InvalidStatusError](https://ops.readthedocs.io/en/latest/#ops.model.InvalidStatusError)
- [model.LazyMapping](https://ops.readthedocs.io/en/latest/#ops.model.LazyMapping)
- [model.MaintenanceStatus](https://ops.readthedocs.io/en/latest/#ops.model.MaintenanceStatus)
- [model.ModelError](https://ops.readthedocs.io/en/latest/#ops.model.ModelError)
- [model.Model](https://ops.readthedocs.io/en/latest/#ops.model.Model)
- [model.NetworkInterface](https://ops.readthedocs.io/en/latest/#ops.model.NetworkInterface)
- [model.Network](https://ops.readthedocs.io/en/latest/#ops.model.Network)
- [model.Pod](https://ops.readthedocs.io/en/latest/#ops.model.Pod)
- [model.RelationDataContent](https://ops.readthedocs.io/en/latest/#ops.model.RelationDataContent)
- [model.RelationDataError](https://ops.readthedocs.io/en/latest/#ops.model.RelationDataError)
- [model.RelationData](https://ops.readthedocs.io/en/latest/#ops.model.RelationData)
- [model.RelationMapping](https://ops.readthedocs.io/en/latest/#ops.model.RelationMapping)
- [model.RelationNotFoundError](https://ops.readthedocs.io/en/latest/#ops.model.RelationNotFoundError)
- [model.Relation](https://ops.readthedocs.io/en/latest/#ops.model.Relation)
- [model.Resources](https://ops.readthedocs.io/en/latest/#ops.model.Resources)
- [model.ServiceInfoMapping](https://ops.readthedocs.io/en/latest/#ops.model.ServiceInfoMapping)
- [model.StatusBase](https://ops.readthedocs.io/en/latest/#ops.model.StatusBase)
- [model.StorageMapping](https://ops.readthedocs.io/en/latest/#ops.model.StorageMapping)
- [model.Storage](https://ops.readthedocs.io/en/latest/#ops.model.Storage)
- [model.TooManyRelatedAppsError](https://ops.readthedocs.io/en/latest/#ops.model.TooManyRelatedAppsError)
- [model.Unit](https://ops.readthedocs.io/en/latest/#ops.model.Unit)
- [model.UnknownStatus](https://ops.readthedocs.io/en/latest/#ops.model.UnknownStatus)
- [model.WaitingStatus](https://ops.readthedocs.io/en/latest/#ops.model.WaitingStatus)


<a href="#heading--pebblepy"><h2 id="heading--pebblepy">pebble.py</h2></a>

- [pebble.APIError](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.APIError)
- [pebble.ChangeError](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ChangeError)
- [pebble.ChangeID](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ChangeID)
- [pebble.ChangeState](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ChangeState)
- [pebble.Change](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Change)
- [pebble.CheckInfo](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.CheckInfo)
- [pebble.CheckLevel](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.CheckLevel)
- [pebble.CheckStatus](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.CheckStatus)
- [pebble.Check](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Check)
- [pebble.Client](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Client)
- [pebble.ConnectionError](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ConnectionError)
- [pebble.Error](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Error)
- [pebble.ExecError](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ExecError)
- [pebble.ExecProcess](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ExecProcess)
- [pebble.FileInfo](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.FileInfo)
- [pebble.FileType](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.FileType)
- [pebble.Layer](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Layer)
- [pebble.PathError](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.PathError)
- [pebble.Plan](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Plan)
- [pebble.ProtocolError](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ProtocolError)
- [pebble.ServiceInfo](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ServiceInfo)
- [pebble.ServiceStartup](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ServiceStartup)
- [pebble.ServiceStatus](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ServiceStatus)
- [pebble.Service](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Service)
- [pebble.SystemInfo](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.SystemInfo)
- [pebble.TaskID](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.TaskID)
- [pebble.TaskProgress](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.TaskProgress)
- [pebble.Task](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Task)
- [pebble.TimeoutError](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.TimeoutError)
- [pebble.WarningState](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.WarningState)
- [pebble.Warning](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.Warning)


<a href="#heading--testingpy"><h2 id="heading--testingpy">testing.py</h2></a>

- [testing.Harness](https://ops.readthedocs.io/en/latest/harness.html#ops.testing.Harness)
- [testing.NonAbsolutePathError](https://ops.readthedocs.io/en/latest/harness.html#ops.testing.NonAbsolutePathError)