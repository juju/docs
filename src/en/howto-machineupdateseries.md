Title: Change a machine's series (prior to 2.3)

#  Update juju's understanding of a machine's series (prior to 2.3)

## Overview

If you want to let juju know that you've upgraded the series on an existing
machine, and using juju 2.3 or later, you can run the command:
`juju update-series <machine> <series>` 

The update-series command will update the series saved for the given machine,
as well as any units on that machine.  When a unit's series is updated, the
config-changed hook will be triggered for that unit.

Here we'll cover the manual step on how to do this prior to juju 2.3. Not
covered is how to trigger the config-changed hook.

!!! Note: 
    Charms may have to be upgraded to take advantage series change.

## Prerequisites

1. Upgrade the juju machine to the series (version) you require.

2. Check that the current revision of the charm(s) in use for on the machine
supports the series you wish to use in the future.  This can be checked in the
Juju Charm Store.

3. Name of the machine.

4. Name of the model where the machine lives.

5. Admin privilages to the controller where the model lives.

## Update

Start by switching to the juju controller where the changes will happen.

```bash
juju switch localhost-test:admin/default
```

Next the database on the controller will need to be modified.  An example script
can be found [here][appendix]. In the example, ``testing`` is the model, ``0`` is
the machine name, and ``xenial`` is the series.

```bash
mongo-update-mach-series.sh -m testing -a 0 -s xenial
```
```no-highlight
MongoDB shell version: 3.2.12
connecting to: 127.0.0.1:37017/juju
2017-08-31T01:14:48.300+0000 W NETWORK  [thread1] SSL peer certificate validation failed: unable to get local issuer certificate
2017-08-31T01:14:48.300+0000 W NETWORK  [thread1] The server certificate does not match the host name 127.0.0.1
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
Connection to 10.0.28.234 closed.
```

Verify by running checking the status of the machine.  Output of
`juju status -m testing 0` will look similar to:
```no-highlight
...
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.0.28.166    juju-60fd45-0  xenial      Running
...
```

## Appendix: example script to update juju database

```bash
#!/bin/bash

cntlr_model="controller"
cntlr_machine=0
tmpfile="/tmp/series.js"
usemsg="Usage: mongo-update-series -m <model> -a <machine> -s <series>"

while getopts "hm:a:s:" option; do
	case $option in
		a)
			machine=$OPTARG
			;;
		m)
			machmodel=$OPTARG
			;;
		s)
			series=$OPTARG
			;;
		h)
			echo $usemsg
			exit
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit
			;;
	esac
done

if [[ $machine == "" || $machmodel == "" || $series == "" ]]; then
	echo $usemsg
	exit
fi

rm $tmpfile

/bin/cat << EOM > $tmpfile
db.models.find({"name":"$machmodel"}).forEach(
    function(modelDoc){
        db.machines.find({"machineid":"$machine", "model-uuid":modelDoc._id}).forEach(
            function(mach){
                mach.principals.forEach(
                    function(p){
                        print(db.units.update({"name":p,"model-uuid":modelDoc._id},{\$set:{"series":"$series"}}));
                        db.units.find({"name":p,"model-uuid":modelDoc._id}).forEach(
                            function(u){
                                u.subordinates.forEach(
                                    function(s){
                                        print(db.units.update({"name":s,"model-uuid":modelDoc._id},{\$set:{"series":"$series"}}));
                                    })
                            })
                    })
            })
        print(db.machines.update({"machineid":"$machine", "model-uuid":modelDoc._id},{\$set:{"series":"$series"}}));
    })
EOM

juju scp -m $cntlr_model $tmpfile $cntlr_machine:.

read -d '' -r cmds <<'EOF'
conf=/var/lib/juju/agents/machine-*/agent.conf
user=`sudo grep tag $conf | cut -d' ' -f2`
password=`sudo grep statepassword $conf | cut -d' ' -f2`
/usr/lib/juju/mongo*/bin/mongo 127.0.0.1:37017/juju --authenticationDatabase admin --ssl \
--sslAllowInvalidCertificates --username "$user" --password "$password" series.js
EOF

juju ssh -m $cntlr_model $cntlr_machine "$cmds"  2>&1

```
[appendix]:#appendix:-example-script-to-update-juju-database
