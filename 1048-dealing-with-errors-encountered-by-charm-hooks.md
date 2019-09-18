If any of your hooks returns a non-zero exit code, juju will stop managing the unit directly and will wait for user intervention. This is a Bad Thing, and you should make every effort to avoid it, because the average user may not be in a position to diagnose the fault with any great degree of sophistication.

So, in general, you should write your hooks as robustly as possible: if an operation suffers a possibly-transient failure, it's wise to wait a moment and retry a couple of times, to avoid needlessly bothering the user with a decision or call to action that they're not necessarily equipped to make.

However, you will no doubt encounter errors on occasion -- in particular, if the unit agent is aborted while it's running a hook, it'll set an error status for that hook when it comes back up. You will in that case have to deal with users' potentially underinformed responses to those errors.

<h2 id="heading--error-status">Error status</h2>

When a unit agent sets an error status, it stops running hooks and relinquishes control over the charm directory. This means that it's generally safe to `juju ssh` into the unit and use it as though you were the sole administrator; juju will only take back control of the directory when explicitly requested, in response to either `juju resolved` or `juju upgrade-charm --force-units`.

-   `juju resolved` causes the unit to unblock itself and continue as though the hook had completed successfully. The ideal charm will be aware of this possibility and will therefore trust information from its [environment](/t/the-hook-environment-hook-tools-and-how-hooks-are-run/1047) to be more recent and correct than anything it may have previously have recorded in the local [charm directory](/t/components-of-a-charm/1038).
-   `juju resolved` reverts the charm directory's contents to whatever they were at the start of the failed hook, and runs the hook again exactly as before. This, in combination with the [debug-hooks](/t/debugging-charm-hooks/1116) command, is your main entry point for investigating an error in detail. If the hook fails again when retried, it will set an error as before and wait again for user resolution.
-   `juju upgrade-charm --force-units` merges into the charm directory the contents of the newer charm version, and continues blocking in the original hook error state. Each time a new upgrade is forced, the charm directory is rolled back to the state from which it was originally upgraded before proceeding; this means that a forced upgrade back to the original charm will always be a no-op, regardless of what other upgrade attempts have been made in the interim.

Once you have issued one of the above commands, the charm directory should once again be treated as inaccessible.

<h2 id="heading--charm-upgrade-errors">Charm upgrade errors</h2>

Finally, there's another reason a unit might set an error status: a [charm upgrade](/t/upgrading-a-charm/1131) conflict, which should never happen except during development.

They can be resolved either by forcing an upgrade to a different charm version, or by manually resolving the conflicts in the charm directory and running `juju resolved` to cause the unit agent to continue.

<h2 id="heading--charm-integrity-errors">Charm integrity errors</h2>

Some charms use symlinks to redirect hook execution to a common file. Naturally these symlinks must be preserved to allow proper operation of the charm. If you are developing a charm and manually copy it over to a system, you should verify that the hook symlinks are preserved as expected. For example, `scp` will follow symlinks, not replicate them, which can lead to a broken charm.

We recommend using either `rsync` or generating a tarball of your charm first if you're going to use `scp`.
