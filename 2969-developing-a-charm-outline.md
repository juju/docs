We've had several calls for improved documentation. Let's fix that.

One area that's quite weak is our charming documentation. Lots of it is fairly old.

Here is a rough outline of a guide that I will be working to produce:

- Why Juju and Charms<br>Motivational chapter that explains Juju's unique position in the devops ecosystem.<br>
-- Simplicity
-- Operator pattern
-- Relations
-- Multi-cloud
-- Upgrades

- What Juju is<br>Describes lots of the concepts behind Juju and its operations.<br>
-- Event-driven operators
-- Hook model
-- Terminology

- Getting Set up
-- Installing `juju`
-- Installing `charm`

- First charm
-- `charm create -t operator-python`
-- Explain core classes from the operator framework: `Framework`, `Charm` and `Model`
-- Explain events

- Debugging Charms
-- Introduce `juju debug-log`
-- Introduce `juju show-status-log`
-- Introduce `juju debug-hooks` 

- Relations
-- Relate to a database
-- Provide `http`

- Actions
-- Add an action to refresh a cache

- Providing information to users deploying your charm
-- Updating status (incl. discussion of status codes)
-- Report the application's version
-- Logging

- Resources
-- Support offline deployments behind the firewall

- Storage

- Network

- Clustered Applications
-- Peer relations
-- Leadership

- Metrics
-- Enable automated monitoring
