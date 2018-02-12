Title: Audit logging

# Audit logging

Juju audit logging provides a chronological account of all events. These logs
are captured on the controller that was involved in the transmission of
associated commands affecting the Juju client, any Juju machine, and the
controller itself.

See [Juju log][logs] documentation to learn about standard Juju logging.

The audit log filename is `/var/log/juju/audit.log` and contains records which
are either:

 - a Conversation, which corresponds to a top-level CLI command
 - a Request (a call to an API method)
 - a ResponseErrors, which has details of any errors from calling the method


<!-- LINKS -->

[logs]: ./troubleshooting-logs.html

