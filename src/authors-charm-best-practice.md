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

## Juju Best Practices and Tips from Canonical's Infrastructure Team

Since Canonical IS uses Juju in production they have certain requirements from
charms in order for them to run on a production OpenStack deployment. Though
these are requirements for use inside Canonical, charms are not required to meet
these criteria to be in the Charm Store, they are included here to share with
the devops community.

Tips for production usage:

  - Provide an overview of the service in the README and metadata. 
  - Use packaged software (i.e. debian packages) where possible, and "backport" any packages needed outside of the archives from whatever PPA you have them to an internal accessible repository.
  - Do not duplicate any service components for which there are pre-existing charms.
  - Follow the coding guidelines for charms (see below).
  - Assemble code for your application outside of the Charm.
  - Create a `/srv/${external-service-name}/${instance-type}/${service-name}` directory for the code itself, and `/srv/${external-service-name}/{${instance-type}-logs,scripts,etc,var}` as needed.
  - Ensure the owner of the code isn't the same user than runs the code
  - Create monitoring checks for your application.
  - Which checks are prompt-critical (in other words, constitutes a user-affecting outage that would warrant waking an "oncall" sysadmin over a weekend)?
  - Confirm what data/logs from the application needs to be made visible to developers, and in what format?
  - Some organizations use proxies, do not assume that every port is available, consider using common ports like 80/443 to ensure your charm can run in as many environments as possible. For added flexibility we recommend exposing port configuration in the charm as a config option.

## Charm Coding Guidelines

If written in Bash:

  - Use `set -e` for all hooks written in Bash. This option tells bash to exit the script if a command returns a non true result. This option prevents the script from continuing when the script is known to be in an error state.
  - `${variable}-value` rather than `$variable-value`?
  - `$(COMMAND)` vs. `COMMAND`?
  - Use `install` rather than `mkdir; chown`

If written in Python:

  - Has `pep8` been run against the relevant scripts?
  - Separation of code from content (i.e. all external files/templates are in the "files" or "templates" directory)?
As an example, this populates a template from any variables in the current
environment: `cheetah fill --env -p templates/celerymon_conf.tmpl >
/etc/init/celerymon.conf`

In this example, the template looks like this:

                start on started celeryd
                stop on stopping celeryd
                
                env CODEDIR=$CODE_LOCATION
                env
                PYTHONPATH=$CODE_LOCATION/apps:$CODE_LOCATION:$CODE_LOCATION/lib/python2.7/site-packages
                
                exec sudo -u $USER_CODE_RUNNER sh -c "cd \$CODEDIR;
                PYTHONPATH=\$PYTHONPATH ./certification-manage.py celerycam --pidfile
                /srv/${BASEDIR}/var/celeryev.pid"
                respawn
  - Do all config options have appropriate descriptions?
  - Are all hooks idempotent?
  - No hard coded values for things that may need changing - exposed via config.yaml options
  - No hard coding of full paths for system tools/binaries - we should ensure $PATH is set appropriately.
  - Has `charm proof` been run against the charm?
  - Has testing of adding units and removing units been done?
  - Has testing of changing all config options and verifying they get changed in the application (and applied, i.e. service reloaded if appropriate) been done?
  - Any cron entries should be in `/etc/cron.d` rather than stored in user crontabs.
  - This allows for easier visibility of active cronjobs across the whole system, as well as making editing things much easier.
