# High Availability of Juju State Servers

Juju provides a `ensure-availability` command to set multiple State Servers.
This means that you can recover from possible failures of a number of Servers.

`ensure-availability` supports (among other common ones) the optional parameter
`-n` which indicates the number of state server to ensure; 
if omitted 3 will be used, the number must be odd, to avoid ties when the
master is voted among all the State Servers; due to constraints of the 
underlying persistence layer the maximum number is 7

For more precise management, it is also possible to specify the machines 
to use for the extra state servers, e.g.:

```bash
juju ensure-availability -n 3 --to name1,name2
```

Once it has been run, every subsequent run (without `-n`) will make juju
ensure that there are at least the last requested number of State Servers;
bare in mind that this number can be increased by calling it again with 
`-n` but currently there is no way to decrease it (planned for a future 
release).

The ability to recover is limited by the remaining amount of State Servers;
to be able to recover half the Servers need to be up, for instance if you
have five servers set as the availability number, you need three up to be
able to recover back to five.
