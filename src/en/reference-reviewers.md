Title: Reviewing charms and bundles  

# Reviewing Charms and Bundles

### Review Tips and Criteria

The goal is to _welcome_ the contributor and help them have a good experience
getting fixes into Ubuntu; your first response should be to _thank them
profusely_. By making collaboration easier, we can hope to see more contributors
and thus lighten the development workload on everyone.

- Start your review by saying "Thanks", no matter what the outcome of the review is going to be.
- If you recognise somebody you've worked with on IRC, thank them.
- Run juju charm proof first. If there are serious problems with the charm based on the output of proof feel free to just stop the review there and tell them. You shouldn't promulgate a charm that has anything that’s a “WARNING” or more severe.
- If the merge proposal or patch requires more work, encourage the contributor to join #juju and discuss the solution there.
- Follow [these instructions](http://wiki.bazaar.canonical.com/PatchPilot) as well as you can.
- If this is your first time patch piloting, you may feel more comfortable being a co-pilot your first few runs. Find a pilot in your timezone and reschedule your time to coincide with theirs.
- Be super thorough, don’t be afraid to be firm with people. However, respect that charms are opinionated - just don’t be afraid to be opinionated yourself.
- Please use the official [Charm Store Policy](./authors-charm-policy.html) document.
- Use your best judgement.
- Send a brief mail after your stint, to say what you did and how it worked out. If you have feedback on the review system or the process, speak up.
- You're not obliged to deal with all the open patches. We appreciate what you do do.
- You can prioritize whichever you think best achieves the goal of helping
  people enjoy getting things done in Juju. That might be the newest ones,
neglected patches, easy patches, or those from new contributors. The [Review
Queue](http://review.juju.solutions) sorts by age.
- If you are unfamiliar with the package, make sure you review everything you can, it's not necessarily your job to merge/promulgate it. If, after you did your review, you can get the contributor in touch with somebody who knows the codebase better, you already helped out a lot.
- Consider blogging about a particularly nice contribution. This will not only make the contributor feel valued, but also inspire others with a good example of great work.
- Encourage contributors to apply for ~charmers if you think they're ready.

Sponsorship is organized into:

  - [https://launchpad.net/~charmers](https://launchpad.net/~charmers):

If something needs review, subscribe ~charmers.

You can see the currently pending requests at:

- [https://bugs.launchpad.net/charms/+bugs?field.subscriber=charmers](https://bugs.launchpad.net/charms/+bugs?field.subscriber=charmers)
- [https://bugs.launchpad.net/charms/+bugs?field.subscriber=charmers&field.component=3&field.component=4](https://bugs.launchpad.net/charms/+bugs?field.subscriber=charmers&field.component=3&field.component=4)
- The [Review Queue](http://review.juju.solutions/) at
<http://review.juju.solutions/> 

### Updating the store with new Charms

There are two methods of updating the store. One is promulgation of new charms,
the other is updates to charms which already exist in the store:

#### New Charms

So the charm has passed all criteria and is ready to land in the store. Before
you can promulgate, you’ll need to run the following commands. (This is only
needed if you don’t have charm-tools >= 1.1 - This is being fixed in charm tools and will be landing soon).

```bash
bzr init lp:~charmers/charms/precise/<CHARM_NAME>/trunk
bzr push lp:~charmers/charms/precise/<CHARM_NAME>/trunk
```

Without this, LP will automatically stack on top of the user’s branch which will make it really really hard to delete from the store in the future. Now you can promulgate:

```bash
juju charm promulgate
```

#### Updating existing charms in the store

Make sure you thank them profusely for fixing something or adding something, no matter who they work for!

Grab the charm from the store either with charm-tools or just bzr branch it.

```bash
juju charm get
```

**Note:** Backwards compatibility is important! Any changes that would change the structure of the charm, data, configuration options, etc and doesn’t perform due diligence to make sure the charm does what it needs to, should be rejected.

Pay particular attention to interface providers that have extant clients/users.

Eventually, magic should take over this process and it should be done via
jenkins and QA. Until then deploy the charm from `local:`, change config values, make relations, do what the charm needs to get setup. bzr merge the change, check the changes and make sure there are no obvious glaring things that break backwards compatibility (or just break the charm). Then `juju upgrade` the charm. Make sure nothing breaks in the service.

Other than that, just follow normal charm review process.

When you’re ready just `bzr commit` the merge, then `bzr push :parent` to update the store.

If you find anything that's lacking in the charm feel free to open bugs against
that charm. This will help us curb the amount of charms to review during our
audit.

### Updating the store with Bundles

Bundles are simpler to push to the store:

```bash
bzr init lp:~charmers/charms/bundles/$BUNDLES_NAME/bundle
bzr push lp:~charmers/charms/bundles/$BUNDLES_NAME/bundle
```

There is no promulgation step for bundles.

## Join Us!

We also need help reviewing and testing charms. The Charmers team is granted
write access to the Charm Collection and charm-tools. If you'd like to join that
group, here are some tips:

- Join [charm-contributors](https://launchpad.net/~charm-contributors) ! You will immediately be able to help out with bug prioritization.
- Join the discussion on IRC (Freenode) in #juju and on [https://lists.ubuntu.com/mailman/listinfo/juju](https://lists.ubuntu.com/mailman/listinfo/juju)
- Test charms and report your successes or file bugs.
- Write charms - pick a web app or a backend technology and write a charm.
- Review new charms [https://bugs.launchpad.net/charms/+bugs?field.tag=new-charm](https://bugs.launchpad.net/charms/+bugs?field.tag=new-charm)

Upon getting involved with these activities, we'll probably ask you if you'd
like to join charmers. If not, go ahead and apply for membership to the team,
and _send an email to the list letting us know about your reasons for wanting to be a member of charmers_.
