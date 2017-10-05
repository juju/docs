Title: Change an application's series (prior to 2.3)

#  Change an application's series (prior to 2.3)

## Overview

When deploying an application with Juju you can specify the series it
will use, or use the default series for the model. Prior to Juju 2.3,
any units which are subsequently added to the application always use
the series specified at deployment

With version 2.3 or later it's possible let juju know you'd like to add
units with a different series moving forward by running the command:
`juju update-series <application> <series>`

Here we'll cover the manual steps on how to do this with earlier versions of the software.

## Prerequisites

  1. Check that the current charm revision in use for the application supports the
  series you wish to use in the future.  This checked on in the Juju Charm Store.

  2. Name of the application.

  3. Name of the model where the application lives.

  4. Admin privilages to the controller where the model lives.

## Update

Start by switching to the juju controller where the changes will happen using
`juju switch`.

Next, the database on the controller will need to be modified.  You'll need to
know which model the application is deployed to, the application name and the
series you'd like to use moving forward.

An example script can be found [here][appendix].

```bash
mongo-update-app-series.sh -m default -a ghost -s xenial
```
```no-highlight
MongoDB shell version: 3.2.12
connecting to: 127.0.0.1:37017/juju
2017-08-23T16:17:57.249+0000 W NETWORK  [thread1] SSL peer certificate validation failed: unable to get local issuer certificate
2017-08-23T16:17:57.249+0000 W NETWORK  [thread1] The server certificate does not match the host name 127.0.0.1
Connection to 10.106.28.244 closed.
```

Verify by checking the status of the application, getting the output in
yaml format.  Output from: `juju status ghost --format yaml` will look similar to:
```yaml
...
applications:
  ghost:
    charm: cs:ghost-20
    series: xenial
    os: ubuntu
...
```

## Appendix: example script to update juju database

```bash
#!/bin/bash

cntlr_model="controller"
machine=0
tmpfile="/tmp/series.js"
usemsg="Usage: mongo-update-series -m <model> -a <application> -s <series>"

while getopts "hm:a:s:" option; do
	case $option in
		a)
			application=$OPTARG
			;;
		m)
			appmodel=$OPTARG
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

if [[ $application == "" || $appmodel == "" || $series == "" ]]; then
	echo $usemsg
	exit
fi

/bin/cat << EOM > $tmpfile
var model = db.models.find({"name":"$appmodel"},{"_id":1}).map(function(u) {return u._id;})
db.applications.update({"model-uuid":model[0], "name":"$application"},{\$set: {"series":"$series"}})
EOM

juju scp -m $cntlr_model $tmpfile $machine:.

read -d '' -r cmds <<'EOF'
conf=/var/lib/juju/agents/machine-*/agent.conf
user=`sudo grep tag $conf | cut -d' ' -f2`
password=`sudo grep statepassword $conf | cut -d' ' -f2`
/usr/lib/juju/mongo*/bin/mongo 127.0.0.1:37017/juju --authenticationDatabase admin --ssl \
--sslAllowInvalidCertificates --username "$user" --password "$password" series.js
EOF

juju ssh -m $cntlr_model $machine "$cmds"  2>&1
```
[appendix]:#appendix:-example-script-to-update-juju-database
