# Unmaintained charms

As charms go through the software lifecycle there comes a time where a charm has
not been properly kept up-to-date. Specifically, a charm may fail to deploy,
relate, or execute defined config options. When this occurs this process to
follow.  We always strive to keep charms in the Charm Store as we value the
work it takes to author a charm and pass review. Having a rich set of charms is
the primary mission of the Juju community.

## Identifying charms that are unmaintained

The following process should be executed in order, and each point must be
address ending with a bug report detailing the process taken to arrive at the
conclusion of a charm being unmaintained.

- Does the charm have any of the following conditions?
  - Fail `charm proof`, or lint
  - Fail unit, functional, or integration tests
  - Fail to deploy
  - Fail to relate to defined relations
  - Fail to respond to defined config options
  - Fail to properly go through the Juju lifecycle (deploy, scale up/down,
    relation join/depart, destroy)
      - If a core hook is broken (install, config-changed, start, stop,
        upgrade-charm), is this fixable by the reviewer?
  - [Automated Charm testing](http://reports.vapour.ws/charm-tests-by-charm)
    attempts to flag any policy issues. A `FAIL` in automated Charm testing is
    an indication the Charm is no longer following policy and should be
    considered to be moved out of the recommended status.  

If any of the above conditions exist, follow the unmaintained charm process.  

##  Unmaintained charm process

1. Contact any of the charmers via IRC in #juju@freenode.net or if you would
like confirmation on your findings.  

2. [Report a bug](https://bugs.launchpad.net/charms/) against the charm if
   there is not already one  

    - When filing a bug in Launchpad check the following:
      - Is the charm bug tracker completely barren?
      - How many bugs are there for this charm? (expired or current)
        - Are any of the bugs related to the problem you found?
      - Has the active maintainer triaged the bug filed?
    - Is there an active maintainer listed in the `metadata.yaml` file?
      - Attempt to contact the maintainer to address issues identified.
      - If no maintainer:
        - Create the bug against the charm with subject = “Maintainer needed”
        - Tag the bug with “maintainer-needed”
        - If you can address the failure, and there is no maintainer, please
          consider listing yourself as the maintainer.  

3. Email <juju@lists.ubuntu.com> for assistance in resolving the issue
   identified.  This email is intended to let interested parties know the given
   charm is a candidate for removal from recommended status referencing
   critical bugs (bugs that cause the charm to fail policy).  

  - If a maintainer is needed, use the subject of "[maintainer-needed] - charm
    name"  
  - Reference the problem that is failing policy and thus should be considered
    for removal.
  - List the number of bugs against this charm.
  - List attempts to contact the maintainer.

4. After 1 month of no response to email or resolutions to the bug that cause
   the charm to fail policy, the charm should no longer be recommended. Contact
   a charmer to move the charm to unmaintained.

### Consequences of unmaintaned charms

Moving the charm to unmaintained means moving the charm from `lp:~charmers` to
`lp:~unmaintained-charms`.  Since it involves the `charmers` group, this process
can only be done by a charmer.  

Moving to unmaintained-charms affects the charm's listing as recommended,
code reviews, automated charm testing for merge proposals, and deploy
commands.  

  - Unmaintained charms:  `juju deploy cs:~unmaintained-charms/<series>/<charm-name>`
  - Recommended charms:  `juju deploy series/<charm-name>`  

## Steps for charmers to take for unmaintained charms

1. Verify the unmaintained process has been followed.
2. Unpromuglate the charm.
3. Put charm into “unmaintained-charms” branch
4. Remove the current maintainer from metadata.yaml
