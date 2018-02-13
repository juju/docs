Title: Audit logging

# Audit logging

Juju audit logging provides a chronological account of all events by capturing
invoked user commands. These logs reside on the controller involved in the
transmission of commands affecting the Juju client, Juju machines, and the
controller itself.

See [Juju log][logs] documentation to learn about standard Juju logging.

The audit log filename is `/var/log/juju/audit.log` and contains records which
are either:

 - a *Conversation*, a collection of API methods associated with a single
   top-level CLI command
 - a *Request* , a single API method
 - a *ResponseErrors*, errors resulting from an API method

Information can be filtered out of the audit log to prevent its file(s) from
growing without bounds and making it difficult to read. See
[Excluding information from the audit log][excluding-information-from-the-audit-log].


<!-- LINKS -->

[logs]: ./troubleshooting-logs.html
[excluding-information-from-the-audit-log]: ./controllers-config.html#excluding-information-from-the-audit-log
