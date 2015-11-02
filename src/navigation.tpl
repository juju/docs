            <ul>
              <li class="section"><h4 class="header toggle-target">User Guide</h4>
                <ul>
                  <li><a href="about-juju.html">About Juju</a></li>
                  <li class="section"><a class="header" href="getting-started.html">Install &amp; Configure</a>
                    <ul class="sub">
                      <li><a href="config-aws.html">Amazon Web Service</a></li>
                      <li><a href="config-azure.html">Windows Azure</a></li>
                      <li><a href="config-digitalocean.html">DigitalOcean</a></li>
                      <li><a href="config-gce.html">Google Compute Engine</a></li>
                      <li><a href="config-hpcloud.html">HP Public Cloud</a></li>
                      <li><a href="config-joyent.html">Joyent</a></li>
                      <li><a href="config-local.html">Local</a></li>
                      <li><a href="config-maas.html">MAAS (bare metal)</a></li>
                      <li><a href="config-openstack.html">OpenStack</a></li>
                      <li><a href="config-scaleway.html">Scaleway</a></li>
                      <li><a href="config-vagrant.html">Vagrant</a></li>
                      <li><a href="config-vmware.html">VMWare vSphere</a></li>
                      <li><a href="config-manual.html">Manual Provisioning</a></li>
                      <li><a href="config-general.html">General config options</a></li>
                      <li><a href="getting-started.html#testing-your-setup">Testing your setup</a></li>
                    </ul>
                  </li>
                  <li class="section"><a class="header" href="charms.html">Using Juju Charms</a>
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
                      <li><a href="storage.html">Using storage</a></li>
                    </ul>
                  </li>
                  <li class="section"><a class="header" href="juju-managing.html">Managing Juju</a>
                    <ul class="sub">
                      <li><a href="juju-ha.html">Juju high availability</a></li>
                      <li><a href="juju-multiuser-environments.html">Multi-user environments</a></li>
                      <li><a href="juju-systemd.html">Juju and systemd</a></li>
                      <li><a href="charms-environments.html">Managing environments</a></li>
                      <li><a href="juju-block.html">Restrict/block Juju commands</a></li>
                      <li><a href="juju-backups.html">Backup and restore</a></li>
                      <li><a href="juju-upgrade.html">Upgrading Juju</a></li>
                      <li><a href="juju-gui-management.html">Using the Juju GUI</a></li>
                      <li><a href="juju-offline-charms.html">Deploy charms offline</a></li>
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
              </li>
              <li class="section"><h4 class="header toggle-target">Developer Guide</h4>
                <ul>
                  <li class="section"><a class="header" href="developer-tools-prerequisites.html">Tools &amp; Prerequisites</a>
                    <ul class="sub">
                      <li><a href="developer-tools-prerequisites.html#subtarget">subtarget</a></li>
                    </ul>
                  </li>
                  <li class="section"><a class="header" href="developer-design-charm.html">Designing your charm</a>
                    <ul class="sub">
                      <li><a href="developer-design-charm.html#juju-model">Juju model</a></li>
                      <li><a href="developer-design-charm.html#relations">Relations</a></li>
                      <li><a href="developer-design-charm.html#configuration">Configuration</a></li>
                    </ul>
                  </li>
                  <li class="section"><a class="header" href="developer-writing-charm.html">Writing your charm</a>
                    <ul class="sub">
                      <li><a href="developer-writing-charm.html#create-layer">Creating a layer</a></li>
                      <li><a href="developer-writing-charm.html#charm-build">Charm build</a></li>

                    </ul>
                  </li>
                  <li class="section"><a class="header" href="developer-writing-tests.html">Writing Tests</a>
                    <ul class="sub">
                      <li><a href="developer-writing-tests.html#charm-test">Testing a charm with amulet</a></li>
                      <li><a href="developer-writing-tests.html#bundle-test">Testing a bundle with amulet</a></li>
                    </ul>
                  </li>
                </ul>
              <li>
              <li class="section"><h4 class="header toggle-target">Experimental</h4>
                <ul>
                  <li><a href="wip-spaces.html">Network spaces</a></li>
                  <li><a href="wip-centos.html">CentOS support</a></li>
                  <li><a href="wip-numbering.html">Machine/unit numbering</a></li>
                  <li><a href="wip-charm-leadership.html">Charm leadership</a></li>
                  <li><a href="wip-systems.html">Juju Environment System (DRAFT)</a></li>
                  <li><a href="wip-users.html">Managing Users (DRAFT)</a></li>
                </ul>
              </li>
              <li class="section"><h4 class="header toggle-target">Tools</h4>
                <ul>
                  <li><a href="tools-charm-tools.html">Charm Tools</a></li>
                  <li><a href="tools-charm-helpers.html">Charm Helpers</a></li>
                  <li><a href="tools-amulet.html">Amulet</a></li>
                </ul>
              </li>
              <li class="section"><h4 class="header toggle-target">Reference</h4>
                <ul>
                  <li><a href="commands.html">Juju commands</a></li>
                  <li><a href="reference-constraints.html">Juju constraints</a></li>
                  <li><a href="reference-environment-variables.html">Juju environment variables</a></li>
                  <li><a href="reference-hook-tools.html">Juju 'Hook Tools'</a></li>
                  <li><a href="http://godoc.org/github.com/juju/juju/api">Juju API docs</a></li>
                  <li><a href="reference-releases.html">Releases</a></li>
                  <li><a href="reference-release-notes.html">Release notes</a></li>
                  <li><a href="reference-status.html">Status values</a></li>
                  <li><a href="reference-numbering.html">Machine/unit numbering</a></li>
                  <li><a href="glossary.html">Glossary</a></li>
                  <li><a href="reference-reviewers.html">Charm Review Criteria</a></li>
                  <li><a href="contributing.html">Contribute to the Docs!</a></li>
                </ul>
              </li>
            </ul>
