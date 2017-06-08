Title: What's new in 2.2
TODO: Needs KVM details?
      Needs new networking details?

# What's new in 2.2

This release of Juju 2.2 makes creating and managing cloud deployments faster
and easier, thanks to several new and significant features:

- Cloud updates: new support for Oracle's public cloud and big improvements to
  VMware's vSphere.
- Performance: greatly enhanced memory and storage consumption, helping Juju run
  more efficiently for longer.

We're going to look at these new features in more detail below. If you're new
to Juju, we recommend taking a look at our [Getting started][first] guide
first.

## Cloud updates

### Oracle cloud

Oracle's public cloud, [Oracle Compute][compute], becomes our latest cloud
addition.

Prior to deployment, you will need to associate Oracle's Ubuntu images within
the dashboard of your Oracle Compute service because Juju uses these with its
own deployments. 

This can be done easily by signing in to Oracle's domain dashboard, creating a
new `Compute` instance, selecting `Marketplace` and searching for 'ubuntu':

![Ubuntu image search](./media/oracle_create-instance-ubuntu.png)

Select the images you want, Ubuntu 16.04 and Ubuntu 14.04 are good choices, and
head back to Juju.

You now need to simply add credentials and bootstrap. 

!!! Note:
    If you're using an Oracle cloud trial account, you will need to enter your
    endpoint details manually using `juju add-cloud`. See our 
    [Oracle documentation][helporacle] for help on the process.

Using Juju's interactive authentication, importing Oracle credentials into Juju
is an easy process. You will just need the following information:

- **Username**: usually the email address for your Oracle account.
- **Password**: the password for this specific Compute domain.
- **Identity domain**: the ID for the domain, e.g. `a476989`.

To add these details, type `juju add-credential <credential-name> <cloud-name>`:

```bash
juju add-credential oracle
```

You will be asked for each detail in turn.

```no-highlight
Enter credential name: mynewcredential
Using auth-type "userpass".
Enter username: javier
Enter password: ********
Enter identity-domain: a476989
Credentials added for cloud oracle.
```

You have now added everything needed to bootstrap your new Oracle Compute cloud
with Juju:

```bash
juju boostrap oracle
```

You can now start deploying Juju [charms and bundles][charms] to your Oracle cloud.

See our [Using the Oracle public cloud][helporacle] documentation for further help.

### VMware vSphere

Our [vSphere][vmwarevsphere] support has been much improved. It now requires
very little configuration prior to bootstrap and performs much better than with
previous versions of Juju.

Additionally, to help with vSphere machine management, machines are now
organised into folders on your cloud. See our [vSphere][helpvmware]
documentation to get started.
 
## Performance 

Juju now handles transactions more efficiently and has better support for
longer running controllers.

Logs are compressed when rotated, separated by model, and can be pruned to a
specific age and size. These options are configured through the controller -
see our [Controller documentation][logs] for more details. 

## Next Steps

For further details, see the [Controller documentation][logs], the 
[Oracle compute][helporacle] documentation and the Juju 2.2 [release
notes][rnotes].

[first]: ./getting-started.html
[logs]: ./controllers-config.html
[vmwarevsphere]: http://www.vmware.com/products/vsphere.html
[helpvmware]: ./help-vmware.html
[compute]: https://cloud.oracle.com/en_US/compute
[charmstore]: https://jujucharms.com/store
[helporacle]: ./help-oracle.html
[rnotes]: ./reference-release-notes.html#juju_2.2.0
