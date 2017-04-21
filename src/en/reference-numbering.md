Title: Machine and unit numbering  

# Machine and Unit numbering

Within an environment Juju keeps track of sequences for machines and units.
(Prior to 1.25 just machines). This means that for the life of a model,
the number associated with a machine will only ever increase. For example:

```bash
juju add-machine # Add machine 0
juju add-machine # Add machine 1
juju terminate-machine # Remove machine 1
juju add-machine # Add machine 2
```

From 1.25 onwards unit numbering follows the same scheme. For each application 
name the number will only every increase. For example:
```bash
juju deploy mongodb -n 2 # Adds units 0,1
juju remove-application mongodb # Removed units 0,1
juju deploy mongodb -n 2 # Adds units 2,3
```

Prior to 1.25 units would only ever increase for a single application. If you
removed the application and created a new one of the same name the numbering
would start again from 0.
