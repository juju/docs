 <ul>
<!--- SECTION --->
    <li class="section"><h4 class="header toggle-target">User Guide</h4>
        <ul>
        <li><a href="about-juju.html">About Juju</a></li>
        <li><a href="introducing-2.html">Introducing Juju 2.0!</a></li>
        <li><a href="getting-started.html">Getting Started</a></li>
        <li><a href="juju-concepts.html">Juju concepts</a></li>
        <li><a href="getting-started-general.html">Install &amp; Configure</a></li>
        <li class="section"><a class="header" href="clouds.html">Clouds</a>
            <ul class="sub">
                <li><a href="credentials.html">Credentials</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="controllers.html">Controllers</a>
            <ul class="sub">
                <li><a href="controllers-creating.html">Creating</a></li>
                <li><a href="juju-ha.html">Juju HA</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="models.html">Models</a>
            <ul class="sub">
                <li><a href="models-config.html">Configuring</a></li>
                <li><a href="models-upgrade.html">Upgrading</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="charms.html">Charms & Services</a>
            <ul class="sub">
                <li><a href="charms-deploying.html">Deploying Services</a></li>
                <li><a href="charms-constraints.html">Using constraints</a></li>
                <li><a href="charms-config.html">Service configuration</a></li>
                <li><a href="charms-relations.html">Service Relations</a></li>
                <li><a href="charms-exposing.html">Exposing Services</a></li>
                <li><a href="charms-scaling.html">Scaling Services</a></li>
                <li><a href="charms-destroy.html">Removing Services &amp; Units</a></li>
                <li><a href="charms-service-groups.html">Groups of Services</a></li>
                <li><a href="charms-ha.html">Charm high availability</a></li>
                <li><a href="charms-bundles.html">Using bundles</a></li>
                <li><a href="charms-working-with-units.html">Working with Units</a></li>
                <li><a href="actions.html">Working with Actions</a></li>
                <li><a href="charms-storage.html">Using storage</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="users.html">Users</a>
            <ul class="sub">
                <li><a href="users-auth.html">Authentication</a></li>
                <li><a href="users-creating.html">Creating users</a></li>
                <li><a href="users-models.html">Users and models</a></li>
                <li><a href="users-manage.html">User management</a></li>
                <li><a href="users-sample-commands.html">Sample commands</a></li>
                <li><a href="users-workflows.html">Workflow scenarios</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="juju.html">Managing Juju</a>
            <ul class="sub">
                <li><a href="juju-block.html">Restrict/block Juju commands</a></li>
                <li><a href="juju-backups.html">Backup and restore</a></li>
                <li><a href="juju-gui-management.html">Using the Juju GUI</a></li>
                <li><a href="juju-offline-charms.html">Deploy charms offline</a></li>
                <li><a href="juju-centos.html">CentOS support</a></li>
                <li><a href="network-spaces.html">Network spaces</a></li>
                <li><a href="juju-misc.html">Miscellaneous</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="howto.html">How to...</a>
            <ul class="sub">
                <li><a href="howto-node.html">Deploy a Node.js app</a></li>
                <li><a href="howto-rails.html">Test and deploy on Rails</a></li>
                <li><a href="howto-privatecloud.html">Set up a Private Cloud</a></li>
                <li><a href="howto-vagrant-workflow.html">Vagrant Workflow</a></li>
                <li><a href="howto-drupal-iis.html">Deploy Drupal Windows charm</a></li>
            </ul>
        </li>
        <li><a href="troubleshooting.html">Troubleshooting</a></li>
    </ul>
<!--- SECTION --->
    <li class="section"><h4 class="header toggle-target">Developer Guide</h4>
        <ul>
        <li class="section"><a class="header" href="developer-getting-started.html">Getting Started</a>
            <ul class="sub">
                <li><a href="developer-getting-started.html#install-libraries-and-tools">Prerequisites and Tools</a></li>
                <li><a href="developer-getting-started.html#designing-your-charm">Designing your Charm</a></li>
                <li><a href="developer-getting-started.html#writing-your-charm">Writing your Charm</a></li>
                <li><a href="developer-getting-started.html#testing-your-charm">Testing your Charm</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-event-cycle.html">Event Cycle</a>
            <ul class="sub">
                <li><a href="developer-event-cycle.html#handling-reactive-states">Handling Reactive States</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-layers.html">Charm Layers</a>
            <ul class="sub">
                <li><a href="developer-layers.html#what-are-layers?">What are Layers</a></li>
                <li><a href="developer-layers.html#states">States</a></li>
                <li><a href="developer-layer-example.html">How to Write a Layer</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-layers-interfaces.html">Interface Layers</a>
            <ul class="sub">
                <li><a href="developer-layers-interfaces.html#design-considerations">Design Considerations</a></li>
                <li><a href="developer-layers-interfaces.html#communication-scopes">Communication Scopes</a></li>
                <li><a href="developer-layers-interfaces.html#writing-an-interface-layer">Writing an Interface</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-leadership.html">Implementing Leadership</a>
            <ul class="sub">
                <li><a href="developer-leadership.html#leadership-hooks">Leadership Hooks</a></li>
                <li><a href="developer-leadership.html#leadership-tools">Leadership Tools</a></li>
                <li><a href="developer-leadership.html#leadership-howtos">Leadership Howtos</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-actions.html">Implementing Actions</a>
            <ul class="sub">
                <li><a href="developer-actions.html#implementing-actions">Defining Actions</a></li>
                <li><a href="developer-actions.html#action-tools">Action Tools</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-storage.html">Implementing Storage</a>
            <ul class="sub">
                <li><a href="developer-storage.html#adding-storage">Adding Storage</a></li>
                <li><a href="developer-storage.html#storage-hooks">Storage Hooks</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-testing.html">Writing Tests</a>
            <ul class="sub">
                <li><a href="developer-testing.html#charm-proof">Charm Proof</a></li>
                <li><a href="developer-testing.html#amulet">Amulet</a></li>
                <li><a href="developer-testing.html#bundletester">BundleTester</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-debugging.html">Debugging</a>
            <ul class="sub">
                <li><a href="developer-debug-layers.html">Debugging Layers</li></a></li>
                <li><a href="developer-debugging.html#the-'debug-hooks'-command">debug-hooks</a></li>
                <li><a href="developer-debugging.html#the-'debug-log'-command">debug-log</a></li>
                <li><a href="developer-debug-dhx.html">DHX</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="developer-howto.html">How to...</a>
            <ul class="sub">
                <li><a href="howto-charm-with-docker.html">Charm with Docker</a></li>
                <li><a href="howto-vagrant-workflow.html">Work with Vagrant</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="authors-intro.html">Charm Authors</a>
            <ul class="sub">
                <li><a href="authors-hook-environment.html">How hooks are run (Hook API)</a></li>
                <li><a href="authors-relations-in-depth.html">Relations lifecycle</a></li>
                <li><a href="authors-relations.html">Implementing relations</a></li>
                <li><a href="authors-charm-leadership.html">Charm leadership</a></li>
                <li><a href="authors-hook-errors.html">Hook Errors</a></li>
                <li><a href="authors-hook-debug.html">Hook Debugging</a></li>
                <li><a href="authors-hook-debug-dhx.html">Hook Debugging with DHX</a></li>
                <li><a href="authors-subordinate-services.html">Subordinate services</a></li>
                <li><a href="authors-implicit-relations.html">Implicit Relations</a></li>
                <li><a href="authors-testing.html">Charm Testing</a></li>
                <li><a href="authors-charm-building.html">Building a Charm from Layers</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="authors-charm-store.html">The Juju Charm Store</a>
            <ul class="sub">
                <li><a href="authors-charm-store.html#submitting-a-new-charm">Submit a charm</a></li>
                <li><a href="authors-charm-policy.html">Charm store policy</a></li>
                <li><a href="charm-review-process.html">Charm review process</a></li>
                <li><a href="authors-charm-best-practice.html">Best practices</a></li>
                <li><a href="authors-charm-icon.html">Charm Icons</a></li>
            </ul>
        </li>
    </ul>
<!--- SECTION --->
    <li class="section"><h4 class="header toggle-target">Tools</h4>
        <ul>
        <li><a href="tools-charm-tools.html">Charm Tools</a></li>
        <li><a href="tools-charm-helpers.html">Charm Helpers</a></li>
        <li><a href="tools-amulet.html">Amulet</a></li>
    </ul>
<!--- SECTION --->
    <li class="section"><h4 class="header toggle-target">Reference</h4>
        <ul>
        <li><a href="commands.html">Juju commands</a></li>
        <li><a href="reference-constraints.html">Juju constraints</a></li>
        <li><a href="reference-charm-hooks.html">Juju Charm Hooks</a></li>
        <li><a href="reference-environment-variables.html">Juju environment variables</a></li>
        <li><a href="reference-hook-tools.html">Juju Hook Tools</a></li>
        <li><a href="reference-layer-yaml.html">Layer.yaml</a></li>
        <li><a href="http://godoc.org/github.com/juju/juju/api">API docs</a></li>
        <li><a href="reference-releases.html">Releases</a></li>
        <li><a href="reference-release-notes.html">Release notes</a></li>
        <li><a href="reference-status.html">Status values</a></li>
        <li><a href="reference-numbering.html">Machine/unit numbering</a></li>
        <li><a href="glossary.html">Glossary</a></li>
        <li><a href="reference-reviewers.html">Charm Review Criteria</a></li>
    </ul>
<li><a href="contributing.html">Help improve these docs</a></li>
<li><a href="https://github.com/juju/docs/issues/new">Report a docs issue</a></li>
</ul>
