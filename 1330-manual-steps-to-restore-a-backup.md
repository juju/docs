Manually Restoring a Backup from an HA Controller
=================================================

Currently there are a couple of bugs around restoring a backup that was generated from an HA controller. They mostly revolve around the fact that the restored controller needs to change its identity to that of the old controller, which may be a different machine agent.

This should be an appropriate set of steps to test out taking a backup that was created from an HA controller, and restoring it on a newly bootstrapped controller.
The steps are given as how to set this up for testing purposes, but it should be fairly obvious how to adapt it for a production environment.
We will likely keep this document around for people who want to have the manual steps for older controllers, but we should end up incorporating all of these steps into 'juju restore-backup' in the future.

Setting up the initial HA controller
====================================

1. Bootstrap
  
```console
  $ juju bootstrap --no-gui lxd lxd-original --bootstrap-series=xenial \
    --debug --model-default "logging-config=<root>=INFO"
```

2. HA

```console
  $ juju enable-ha
```

3. Deploy

```console
  $ juju deploy cs:~jameinel/ubuntu-lite
  ```

4. Create backup

```console
  $ juju create-backup -m controller
```

5. Stop the controllers

```console
  $ lxc list
  $ lxc stop juju-????-{0,1,2}
```


Explicit manual steps
=====================

1. Bootstrap a similar controller, note that it needs a different name:

```console
  $ juju bootstrap --no-gui lxd lxd-backup --bootstrap-series=xenial \
    --debug --model-default "logging-config=<root>=INFO"
```

2. Copy the backup to the new machine

```console
  $ juju scp -m controller juju-backup-*.tar.gz 0:/tmp
```

3. SSH onto the new machine

```console
  $ juju ssh -m controller 0
  $$ sudo su -
```

4. Grab a copy of the new agent.conf, lookup the state password, make sure you
   can connect to mongo.

```console
  # cp /var/lib/juju/agents/machine-0/agent.conf /tmp
  # grep "statepassword" /tmp/agent.conf
  # /usr/lib/juju/mongo3.2/bin/mongo --ssl \
    -u `grep tag: /tmp/agent.conf | cut -d' ' -f2` \
    -p `grep statepassword: /tmp/agent.conf | cut -d' ' -f2` \
    --authenticationDatabase admin --sslAllowInvalidHostnames --sslAllowInvalidCertificates \
    localhost:37017/juju
```

5. Unpack the backup and the root files

```console
  # cd /var/lib/juju
  # tar xzf /tmp/juju-backup*.tar.gz
  # cd juju-backup
  # tar xf root.tar
```

6. Stop the new agents, copy the old agent files in its place. Also cleanup any 'raft' folder that the new agent created (only relevant for Juju 2.5+)

```console
  # cd /var/lib/juju
  # systemctl stop jujud-machine-0
  # systemctl stop juju-db
  # rm -rf agents raft
  # cp -r juju-backup/var/lib/juju/{agents,nonce.txt,server.pem,shared-secret,system-identity} .
```

7. Update agents.conf for the new IP. (and upgradedToVersion if you are changing it.)

```console
  # ls /var/lib/juju/agents
  machine-2
  # vi agents/machine-2/agent.conf
  # <edit> apiaddresses:
  # <edit> upgradedToVersion:
```

8. Make sure to have the tools created for the restored agent

```console
  # ls /var/lib/juju/agents
  machine-2
  # (cd tools; ln -s 2.5.* machine-2)
```

9. Change the systemd configuration to point to the restored agent

```console
  # cd /lib/systemd/system
  # mv jujud-machine-0 jujud-machine-2
  # cd jujud-machine-2
  # mv jujud-machine-0.service jujud-machine-2.service
```

10. Edit `exec_start.sh` and `jujud-machine-2.service` replacing 'machine-0'
    with 'machine-2'. Also make sure to change the `--machine-id 0` field to
    `--machine-id 2`

```console
  # vi exec_start.sh jujud-machine-2.service
```

11. Update /etc to point to the new service.

 **Note: juju restore-backup seems to set up the new service but not get rid of the old one**

```console
  # cd /etc/systemd/system
  # rm jujud-machine-0.service
  # ln -s /lib/systemd/system/jujud-machine-2/jujud-machine-2.service
```

12. Check that it is lined up. It is expected it will be `Active: inactive (dead)`. We just want to make sure it is a known serivce.

```console
  # systemctl status jujud-machine-2
  ? jujud-machine-2.service - juju agent for machine-2
    Loaded: loaded (/lib/systemd/system/jujud-machine-2/jujud-machine-2.service; linked; vendor preset: enabled)
    Active: inactive (dead)
```

13. Restart mongo, and confirm it is using the right certificate. Read
    `agent.conf` to copy the contents of `cacert:` to a file `ca.pem`. Then
    connect to mongo using that as the sslCACert and the **old** password 
    and make sure mongo is happy.

 **Note: we should always create ca.pem rather than just server.pem. It would
 mean we could redo our scripts to connect to mongo to use --sslCAFile rather
 than --sslAllowInvalidCertificates.**

```console
  # cd /var/lib/juju
  # systemctl start juju-db
  # cp /var/lib/juju/agents/machine-2/agent.conf ca.pem
  # edit ca.pem removing everything but --BEGIN down to --END under the cacert: section, also dedent the certificate.
  # cat /var/lib/juju/agents/machine-2/agent.conf \
    | sed -n -e '/cacert:/,/  -----END/p; / -----END/q' \
    | sed -e 's/^[ ]*//' \
    | tail -n+2 > ca.pem
 # /usr/lib/juju/mongo3.2/bin/mongo --ssl \
   -u `grep tag: /tmp/agent.conf | cut -d' ' -f2` \
   -p `grep statepassword: /tmp/agent.conf | cut -d' ' -f2` \
    --authenticationDatabase admin --sslCAFile ./ca.pem \
    localhost:37017/juju
```

14. Get the new InstanceID for the newly bootstrapped machine. You will use this later
    when we update the information about the restored controller.
    Note that the `_id` here is the model-uuid+machine-id of the newely boostrapped controller.

```
  juju:PRIMARY> db.machines.find({"jobs": 2}, {_id: 1})
  juju:PRIMARY> db.instanceData.find({_id: "6cbbd092-0950-43fc-8482-7fdf42ff3cc2:0"}, {"instanceid": 1})
```

15. Restore the mongo dump using the replacement credentials

```console
  # /usr/lib/juju/mongo3.2/bin/mongorestore --ssl \
   -u `grep tag: /tmp/agent.conf | cut -d' ' -f2` \
   -p `grep statepassword: /tmp/agent.conf | cut -d' ' -f2` \
    --authenticationDatabase admin --sslAllowInvalidCertificates \
    --drop --oplogReplay --host localhost:37017 --batchSize 10 \
    /var/lib/juju/juju-backup/dump
```

  **Note: I tried to use --sslCAFile ca.pem, but I consistently got:**
  ```runtime: newstack sp=0xc820053630 stack=[0x7f1b1c014200, 0xc820053fc0]
        morebuf={pc:0x671a6d sp:0xc820053640 lr:0x0}
        sched={pc:0x6677e0 sp:0xc820053638 lr:0x0 ctxt:0x0}
runtime: gp=0xc8200de600, gp->status=0x4
 runtime: split stack overflow: 0xc820053630 < 0x7f1b1c014200
fatal error: runtime: split stack overflow
```
  Even though that line worked fine with 'mongo' itself.
  
16. Connect as the replacement agent, to recreate the restored agent's
    passwords in the DB. You can crib the roles for the new user from the
    existing user when looking at `db.getUsers()`
    
    Note that if the backup is using the same user agent as the newly
    bootstrapped controller (machine-0), then you'll want to just update the
    password, rather than creating the user and deleting the old user. (see
    [https://docs.mongodb.com/manual/reference/method/db.changeUserPassword/](changeUserPassword))

 **Note: juju restore-backup seems to get this wrong. It creates the user, but dosen't give it roles**

```console
  # grep statepassword /var/lib/juju/agents/machine-2/agent.conf
  # /usr/lib/juju/mongo3.2/bin/mongo --ssl \
   -u `grep tag: /tmp/agent.conf | cut -d' ' -f2` \
   -p `grep statepassword: /tmp/agent.conf | cut -d' ' -f2` \
    --authenticationDatabase admin --sslCAFile ./ca.pem \
    localhost:37017/juju

  juju:PRIMARY> use admin
  juju:PRIMARY> db.getUsers()
  juju:PRIMARY> db.createUser({
    user: "machine-2",
    pwd: "$PASSWORD_FROM_RESTORED_AGENT_CONF",
    roles: [{
        "role" : "dbAdminAnyDatabase",
        "db" : "admin"
      }, {
        "role" : "userAdminAnyDatabase",
        "db" : "admin"
      }, {
        "role" : "clusterAdmin",
        "db" : "admin"
      }, {
        "role" : "readWriteAnyDatabase",
        "db" : "admin"
      }]})
  Successfully added user: {
  ...
```

17. Exit out and make sure you can connect as the new database user,
    then remove the rebootstrapped user from the database.
    Note, you won't do this step if the username is reused.

```
  # /usr/lib/juju/mongo3.2/bin/mongo --ssl \
   -u `grep tag: /var/lib/juju/agents/machine*/agent.conf | cut -d' ' -f2` \
   -p `grep statepassword: /var/lib/juju/agents/machine*/agent.conf | cut -d' ' -f2` \
    --authenticationDatabase admin --sslCAFile ./ca.pem \
    localhost:37017/juju
  juju:PRIMARY> use admin
  juju:PRIMARY> db.dropUser("machine-0", {"w": "majority"})
```

18. Update rs.conf so that we properly flag the identity of *this* machine agent.

 You can use the value from rs.conf() to set up the values to rs.reconfig().
 You only really need to change the tag of who `"_id": 1` is. That way the
 peergrouper won't think it is a different machine it doesn't know about.

 **Note: juju restore-backup does not do this**

```console
  juju:PRIMARY> rs.conf()
  {
          "_id" : "juju",
          "version" : 1,
          "protocolVersion" : NumberLong(1),
          "members" : [
                  {
                          "_id" : 1,
                          "host" : "10.210.24.139:37017",
                          "arbiterOnly" : false,
                          "buildIndexes" : true,
                          "hidden" : false,
                          "priority" : 1,
                          "tags" : {
                                  "juju-machine-id" : "0"
                          },
                          "slaveDelay" : NumberLong(0),
                          "votes" : 1
                  }
          ],
          "settings" : {
                  "chainingAllowed" : true,
                  "heartbeatIntervalMillis" : 2000,
                  "heartbeatTimeoutSecs" : 10,
                  "electionTimeoutMillis" : 10000,
                  "getLastErrorModes" : {
  
                  },
                  "getLastErrorDefaults" : {
                          "w" : 1,
                          "wtimeout" : 0
                  },
                  "replicaSetId" : ObjectId("5c9caaa7dd578d49f351d0e9")
          }
  }
  juju:PRIMARY> rs.reconfig({
        "_id" : "juju",
        "version" : 1,
        "protocolVersion" : NumberLong(1),
        "members" : [
                {
                        "_id" : 1,
                        "host" : "10.210.24.139:37017",
                        "arbiterOnly" : false,
                        "buildIndexes" : true,
                        "hidden" : false,
                        "priority" : 1,
                        "tags" : {
                                "juju-machine-id" : "2"
                        },
                        "slaveDelay" : NumberLong(0),
                        "votes" : 1
                }
        ],
        "settings" : {
                "chainingAllowed" : true,
                "heartbeatIntervalMillis" : 2000,
                "heartbeatTimeoutSecs" : 10,
                "electionTimeoutMillis" : 10000,
                "getLastErrorModes" : {

                },
                "getLastErrorDefaults" : {
                        "w" : 1,
                        "wtimeout" : 0
                },
                "replicaSetId" : ObjectId("5c9caaa7dd578d49f351d0e9")
        }
  })
```

19. Demote the HA controller machines that *aren't* being restored. That way
    Peergrouper and Raft don't think they should be waiting for other agents to
    come up before they are happy. You look for machines with Job #2 (JobManageModel),
    that aren't the machine you are restoring. Then cleanup the 'controllers' document,
    for what machines are part of the controller.

    **Note: juju restore-backup does not do this**

```console
  juju:PRIMARY> use juju
  juju:PRIMARY> db.machines.find({"jobs": 2}).pretty()
  juju:PRIMARY> db.machines.find({"jobs": 2}, {"_id": 1})
  juju:PRIMARY> db.machines.update({"_id": "6cbbd092-0950-43fc-8482-7fdf42ff3cc2:0"},
    {$set: {jobs: [1], hasvote: false}})
  WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
  juju:PRIMARY> db.machines.update({"_id": "6cbbd092-0950-43fc-8482-7fdf42ff3cc2:1"},
    {$set: {jobs: [1], hasvote: false}})
  WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
  juju:PRIMARY> db.controllers.find({"_id": "e"}).pretty()
  juju:PRIMARY> db.controllers.update({"_id": "e"}, {$set: {"machineids": ["2"]}})
```

20. Cleanup the IP addresses for the restored agent. The Machiner is supposed
    to do this, but doesn't seem to remove IP addresses that used to exist for
    a machine correctly. Theoretically these should all be automatically determined,
    some of these steps may not be necessary. Note that `10.210.24.139` is the IP of
    the replacement controller.

    First update the controllers collection for apiHostPorts and apiHostPortsForAgents.
    (These *should* get updated automatically when the controller starts up and sees that
    machine-0/1 are no longer listed as controller machines)
    Also, update the "e" (environ) field to list only the new controller.

    **Note: juju restore-backup does not do this. But it shouldn't need to be done**

```console
  juju:PRIMARY> db.controllers.find({"_id": "apiHostPorts"}).pretty()
  juju:PRIMARY> db.controllers.update({"_id": "apiHostPorts"},
	{$set: {"apihostports": [{
	  	"value" : "10.210.24.139",
	  	"addresstype" : "ipv4",
	  	"networkscope" : "local-cloud",
	  	"port" : 17070
	  }, {
	  	"value" : "127.0.0.1",
	  	"addresstype" : "ipv4",
	  	"networkscope" : "local-machine",
	  	"port" : 17070
	  }, {
	  	"value" : "::1",
	  	"addresstype" : "ipv6",
	  	"networkscope" : "local-machine",
	  	"port" : 17070
	  }
	]}})
  WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
  juju:PRIMARY> db.controllers.update({"_id": "apiHostPortsForAgents"},
	{$set: {"apihostports": [{
	  	"value" : "10.210.24.139",
	  	"addresstype" : "ipv4",
	  	"networkscope" : "local-cloud",
	  	"port" : 17070
	  }, {
	  	"value" : "127.0.0.1",
	  	"addresstype" : "ipv4",
	  	"networkscope" : "local-machine",
	  	"port" : 17070
	  }, {
	  	"value" : "::1",
	  	"addresstype" : "ipv6",
	  	"networkscope" : "local-machine",
	  	"port" : 17070
	  }
	]}})
  WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
```

21. Update the instance-id for the restored controller. It should use the instanceData
    that we looked up earlier with the machine-id that we are restoring.

```
  juju:PRIMARY> db.machines.find({"jobs": 2}, {_id: 1})
  juju:PRIMARY> db.instanceData.update({_id: "6cbbd092-0950-43fc-8482-7fdf42ff3cc2:2"}, {$set: {"instanceid": "juju-c6a309-0"}})
  WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })  
```

22. Next update the machine record with its provider addresses (`addresses` the
    addresses found by probing the machine directly `machineaddresses` and the
    preferred addresses, public and private). You can do a find() first, to
    make sure that the IP address to be updated is the first entry in the array
    (offset '.0'). It should generally be true, though.

    **Note: juju restore-backup does not do this. But it shouldn't need to be done**

```console
  juju:PRIMARY> db.machines.find({"jobs": 2}).pretty()
  juju:PRIMARY> db.machines.update({"_id": "6cbbd092-0950-43fc-8482-7fdf42ff3cc2:2"},
    {$set: {
      "addresses.0.value": "10.210.24.139",
      "machineaddresses.0.value": "10.210.24.139",
      "preferredpublicaddress.value": "10.210.24.139",
      "preferredprivateaddress.value": "10.210.24.139"
    }})
  juju:PRIMARY> db.machines.find({"jobs": 2}).pretty()
```

23. Now cleanup the ip.addresses collection. This is the main step that the
    Machiner gets wrong.  It will create the new IP address, but it *doesn't*
    remove the old addresses. (Which then confuses the peergrouper because it
    sees multiple possible addresses to setup the peer group.)

    Note the translation of the ID `<model-uuid>:<machine-id>` into a regex of
    the form `/^<model-uuid>:m#<machine-id>#.*/`.
    We just delete the IP address that should no longer be applied to this machine.

    **Note: juju restore-backup does not do this. But it shouldn't need to be done**

```console
  juju:PRIMARY> db.machines.find({"jobs": 2}, {"_id": 1})
  { "_id" : "6cbbd092-0950-43fc-8482-7fdf42ff3cc2:2" }
  juju:PRIMARY> db.ip.addresses.find({"_id": /^6cbbd092-0950-43fc-8482-7fdf42ff3cc2:m#2#.*/}).pretty()
  juju:PRIMARY> db.ip.addresses.remove({"_id": "6cbbd092-0950-43fc-8482-7fdf42ff3cc2:m#2#d#eth0#ip#10.210.24.146"})
  WriteResult({ "nRemoved" : 1 })
```

24. You should be done with DB manipulations, and can now start the restored controller.

```console
  juju:PRIMARY> exit
  # systemctl start jujud-machine-2
  # tail -f /var/log/juju/machine\*.log
```

25. On your client machine, edit ~/.local/share/controllers.yaml to add the new IP address to the original cloud. You can also remove the 'lxd-backup' cloud at this time:

```console
  # vim ~/.local/share/controllers.yaml
  # juju unregister lxd-backup
```

26. At this point, we will need to go to all the workloads and update their
    agent.conf to point to the new controller. It should sufficient to just add
    the new IP address into the list of apiaddresses. (once the agent
    successfully connects, it should then clean out the other addresses from
    that list.)


```console
$ juju switch default
$ for m in `juju status --format=json | jq -r '.machines | keys | join("\n")'`; do
  echo machine-$m
  juju ssh $m 'cd /var/lib/juju/agents; for a in `ls -d *`; do echo jujud-$a; sudo sed -i "s/apiaddresses:/apiaddresses:\n- 10.210.24.104:17070/" $a/agent.conf; sudo systemctl restart jujud-$a; done'
done
```

27. **Note: apicertupdater still has a bogus address that needs cleanup**.

    Only one of these is valid.

```
2019-03-31 08:12:15 INFO juju.worker.apiservercertwatcher manifold.go:182 new certificate addresses: 10.210.24.104, 10.210.24.146, 127.0.0.1, ::1
```

28. **Note: instancepoller won't work correctly without renaming the instance-id**.

 `provider/lxd` won't find instances that don't start with the right model prefix. `lxd.Provider.AllInstances`
 filters by `juju-MODEL-*` before finding the list of instances. So after rebootstrap,
 the new machine is, eg `juju-NEWMODEL-0`, while restoring the old controller which is `juju-OLDMODEL-2`.
 `lxc rename` should be sufficient to get it into the right model, and then update the database to match.
 But just setting the instance-id in the controller won't do the right thing. eg step ~18 for lxd provider
 would be better served by using `lxd rename` rather than updating the database.
