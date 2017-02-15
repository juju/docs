 <ul>
    <li><a href="about-juju.html">About Juju</a></li>
    <li><a href="introducing-2.html">Introducing Juju 2.0!</a></li>
    <li><a href="whats-new.html">What's new in Juju 2.1</a></li>
<!-- SECTION -->
    <li class="section"><h4 class="header toggle-target">Get Started</h4>
        <ul>
        <li class="section"><a class="header" href="getting-started.html">First use!</a>
            <ul class="sub">
                <li><a href="getting-started-general.html">Install for non-16.04</a></li>
            </ul>
        </li>
        <li><a href="tut-google.html">Controllers and Models</a></li>
        <li><a href="tut-users.html">Sharing and Users</a></li>
        </ul>
    </li>
    <li class="section"><h4 class="header toggle-target">User Guide</h4>
        <ul>
        <li class="section"><a class="header" href="clouds.html">Clouds</a>
            <ul class="sub">
                <li><a href="credentials.html">Cloud credentials</a></li>
                <li><a href="help-aws.html">Amazon AWS</a></li>
                <li><a href="help-azure.html">Microsoft Azure</a></li>
                <li><a href="help-google.html">Google GCE</a></li>
                <li><a href="help-joyent.html">Joyent</a></li>
                <li><a href="clouds-LXD.html">LXD</a></li>
                <li><a href="clouds-maas.html">MAAS</a></li>
                <li><a href="clouds-manual.html">Manual</a></li>
                <li><a href="help-openstack.html">OpenStack</a></li>
                <li><a href="help-rackspace.html">Rackspace</a></li>
                <li><a href="help-vmware.html">VMware vSphere</a></li>

            </ul>
        </li>
        <li class="section"><a class="header" href="controllers.html">Controllers</a>
            <ul class="sub">
                <li><a href="controllers-creating.html">Create/Bootstrap</a></li>
                <li><a href="controllers-gui.html">Juju GUI</a></li>
                <li><a href="controllers-ha.html">High Availability</a></li>
                <li><a href="controllers-backup.html">Backups</a></li>
            </ul>
        </li>
        <li><a href="models.html">Models</a></li>
        <li class="section"><a class="header" href="charms.html">Charms & applications</a>
            <ul class="sub">
                <li><a href="charms-deploying.html">Deploying applications</a></li>
                <li><a href="charms-constraints.html">Using constraints</a></li>
                <li><a href="charms-config.html">Application configuration</a></li>
                <li><a href="charms-relations.html">Application Relations</a></li>
                <li><a href="charms-exposing.html">Exposing applications</a></li>
                <li><a href="charms-scaling.html">Scaling applications</a></li>
                <li><a href="charms-destroy.html">Removing applications &amp; Units</a></li>
                <li><a href="charms-service-groups.html">Groups of applications</a></li>
                <li><a href="charms-ha.html">Charm high availability</a></li>
                <li><a href="charms-working-with-units.html">Working with Units</a></li>
                <li><a href="actions.html">Working with Actions</a></li>
                <li><a href="charms-storage.html">Using storage</a></li>
                <li><a href="charms-metrics.html">Viewing utilization with metrics</a></li>
            </ul>
        </li>
        <li><a href="charms-bundles.html">Charm bundles</a></li>
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
        <li class="section"><a class="header" href="juju-managing.html">Managing Juju</a>
            <ul class="sub">
                <li><a href="juju-block.html">Disable Juju commands</a></li>
                <li><a href="juju-centos.html">CentOS support</a></li>
                <li><a href="network-spaces.html">Network spaces</a></li>
                <li><a href="juju-plugins.html">Juju plugins</a></li>
            </ul>
        </li>
        <li class="section"><a class="header" href="howto.html">How to...</a>
            <ul class="sub">
                <li><a href="howto-privatecloud.html">Set up a Private Cloud</a></li>
            </ul>
        </li>
        <li><a href="troubleshooting.html">Troubleshooting</a></li>
    </ul>
   </li>
<!-- SECTION -->
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
        <li><a href="developer-terms.html">Juju Terms</a></li>
        <li><a href="developer-metrics.html">Juju Metrics</a></li>
        <li><a href="developer-resources.html">Juju Resources</a></li>
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
                <li><a href="developer-debug-layers.html">Debugging Layers</a></li>
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
   </li>
<!-- SECTION -->
    <li class="section"><h4 class="header toggle-target">Tools</h4>
        <ul>
        <li><a href="tools-charm-tools.html">Charm Tools</a></li>
        <li><a href="tools-charm-helpers.html">Charm Helpers</a></li>
        <li><a href="tools-amulet.html">Amulet</a></li>
    </ul>
    </li>
<!-- SECTION -->
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
        <li><a href="juju-concepts.html">Glossary/Concepts</a></li>
        <li><a href="reference-reviewers.html">Charm Review Criteria</a></li>
    </ul>
   </li>
<li><a href="contributing.html">Help improve these docs</a></li>
<li><a href="https://github.com/juju/docs/issues/new">Report a docs issue</a></li>
</ul>
