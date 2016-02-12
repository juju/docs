Title: Best practice for charm authors  

# Best Practice for Charm Authors

This document is to capture charm best practices from the community. We expect
devops to be strongly opinionated, therefore some strong opinions don't make
sense as policy, but do make sense to share with others to disseminate
expertise.

If you'd like to share some best practice and have it added to this page we
recommend you [post to the mailing
list](https://lists.ubuntu.com/mailman/listinfo/juju) with some ideas on what
you'd like to see added. Ideally we'd like to document all sorts of great ideas
on how people are using Juju.

## Best Practice Tips for using Juju in general

- Check out the [Juju cheat sheet](https://github.com/juju/cheatsheet)
- Check out the [Juju plugins](https://github.com/juju/plugins)
- if you run under "local" environment and your LXC machine get unexpected
  network errors try
  [disabling IPv6](http://askubuntu.com/questions/440649/how-to-disable-ipv6-in-ubuntu-14-04)
  on the main host.

## Best Practice Tips for Charm Authors

- Avoid symlinks if you can, people can use Windows for charms. If you prefer
  having your hook code in one file you can achieve the same affect by stubbing
  hooks which import your hooks.py file and invoke the methods that are wrapped
  with the Hook decorator.
- Juju can also run on other Linuxes, so if you want to make something more
  agnostic, you can leverage configuration management tools for things like the
  installation hooks to abstract those bits.
- If you need to deploy things offline or on a network restricted network,
  consider using [Juju resources](http://pythonhosted.org/jujuresources/).
- Implement a pattern that can be easily unit testable, and submit unit tests
  with your charm.

## Examples of Best Practice Charms

Here is a list of charms that leverage a particular technology that you might
want to look at as examples:

- Ansible integration - The [ElasticSearch charm](https://jujucharms.com/elasticsearch)
- Chef integration - The [Rails charm](https://jujucharms.com/rails)
- Puppet integration - Work in Progress with someone at Puppet Labs.
- Charm written in Python - Any of the [Zabbix charms](https://jujucharms.com/q/zabbix)
- Tomcat integration - The [OpenBook charm](https://jujucharms.com/openbook) or the [OpenMRS charm](https://jujucharms.com/openmrs)
- Choosing a Java SDK based on target platform (useful for POWER8) - Check out the big data branch of [charm tools](http://bazaar.launchpad.net/~bigdata-dev/bigdata-data/trunk/view/head:/common/noarch/java-installer.sh). (Temporary location, this will be incorporated into charm tools soon.)
- Example cinder charm - The [cinder-vnx charm](https://jujucharms.com/cinder-vnx), use this if you're interested in adding support for your specific storage hardware to Ubuntu OpenStack.
- Example neutron charm - The [neutron-openvswitch charm](https://jujucharms.com/neutron-openvswitch), use this if you're interested in adding support for your specific networking hardware to Ubuntu OpenStack.

## Juju Best Practices and Tips from Canonical's Infrastructure Team

Since Canonical IS uses Juju in production they have certain requirements from
charms in order for them to run on a production OpenStack deployment. Though
these are requirements for use inside Canonical, charms are not required to meet
these criteria to be in the Charm Store, they are included here to share with
the devops community.

Tips for production usage:

  - Provide an overview of the service in the README and metadata.
  - Use packaged software (i.e. Debian packages) where possible, and "backport"
    any packages needed outside of the archives from whatever PPA you have them
    to an internal accessible repository.
  - Do not duplicate any service components for which there are pre-existing
    charms.
  - Follow the coding guidelines for charms (see below).
  - Assemble code for your application outside of the Charm.
  - Create a `/srv/${external-service-name}/${instance-type}/${service-name}`
    directory for the code itself, and
    `/srv/${external-service-name}/{${instance-type}-logs,scripts,etc,var}` as
    needed.
  - Ensure the owner of the code isn't the same user than runs the code
  - Create monitoring checks for your application.
  - Which checks are prompt-critical (in other words, constitutes a
    user-affecting outage that would warrant waking an "oncall" sysadmin over
    a weekend)?
  - Confirm what data/logs from the application needs to be made visible to
    developers, and in what format?
  - Some organizations use proxies, do not assume that every port is available,
    consider using common ports like 80/443 to ensure your charm can run in as
    many environments as possible. For added flexibility we recommend exposing
    port configuration in the charm as a config option.
  - The configuration should not be 
    [immutable](http://en.wikipedia.org/wiki/Immutable_object). 
    This means that the charm should react to all configuration options as they
    are changed throughout the lifecycle of that service. Immutable
    configuration breaks the user experience, and should only be used to prevent
    data loss. If a user deploys a charm and later sets the configuration values
    the user would expect the charm to react to those changes accordingly.

## Charm Coding Guidelines

If written in Bash:

  - Use `set -e` for all hooks written in Bash. This option tells bash to exit
    the script if a command returns a non true result. This option prevents the
    script from continuing when the script is known to be in an error state.
  - `{variable}-value` rather than `$variable-value`?
  - `$(COMMAND)` vs. `COMMAND`?
  - Use `install` rather than `mkdir; chown`

If written in Python:

  - Has `pep8` been run against the relevant scripts?
  - Separation of code from content (i.e. all external files/templates are in
    the "files" or "templates" directory)?

As an example, this populates a template from any variables in the current
environment: `cheetah fill --env -p templates/celerymon_conf.tmpl >
/etc/init/celerymon.conf`

In this example, the template looks like this:

```bash
start on started celeryd
stop on stopping celeryd
env CODEDIR=$CODE_LOCATION
env
PYTHONPATH=$CODE_LOCATION/apps:$CODE_LOCATION:$CODE_LOCATION/lib/python2.7/site-packages
exec sudo -u $USER_CODE_RUNNER sh -c "cd \$CODEDIR;
PYTHONPATH=\$PYTHONPATH ./certification-manage.py celerycam --pidfile
/srv/${BASEDIR}/var/celeryev.pid"
respawn
```

  - Do all config options have appropriate descriptions?
  - Are all hooks idempotent?
  - No hard coded values for things that may need changing - exposed via 
    config.yaml options
  - No hard coding of full paths for system tools/binaries - we should ensure 
    `$PATH` is set appropriately.
  - Has `charm proof` been run against the charm?
  - Has testing of adding units and removing units been done?
  - Has testing of changing all config options and verifying they get changed in
    the application (and applied, i.e. service reloaded if appropriate) been
    done?
  - Any cron entries should be in `/etc/cron.d` rather than stored in user
    crontabs.
  - This allows for easier visibility of active cronjobs across the whole
    system, as well as making editing things much easier.
