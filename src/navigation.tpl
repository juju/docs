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
                      <li><a href="charms-config.html">Service Configuration</a></li>
                      <li><a href="charms-relations.html">Service Relationships</a></li>
                      <li><a href="charms-exposing.html">Exposing Services</a></li>
                      <li><a href="charms-scaling.html">Scaling Services</a></li>
                      <li><a href="charms-service-groups.html">Groups of Services</a></li>
                      <li><a href="charms-destroy.html">Destroying Services</a></li>
                      <li><a href="charms-environments.html">Managing environments</a></li>
                      <li><a href="charms-ha.html">Charm High Availability</a></li>
                      <li><a href="juju-ha.html">Juju High Availability</a></li>
                      <li><a href="charms-bundles.html">Using bundles</a></li>
                      <li><a href="charms-working-with-units.html">Working with Units</a></li>
                      <li><a href="actions.html">Working with Actions</a></li>
                    </ul>
                  </li>
                  <li class="section">Managing Juju systems</a>
                    <ul class="sub">
                      <li><a href="juju-block.html">Restrict/block Juju commands</a></li>
                      <li><a href="juju-backup-restore.html">Backup and Restore</a></li>
                      <li><a href="juju-gui-management.html">Manage Juju with the GUI</a></li>
                      <li><a href="juju-proxies.html">Configure Proxy Access</a></li>
                      <li><a href="juju-offline-charms.html">Deploying charms offline</a></li>
                      <li><a href="juju-authorised-keys.html">Manage Authorised Keys</a></li>
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
              <li class="section"><h4 class="header toggle-target">Charm Authors</h4>
                <ul>
                  <li><a href="authors-intro.html">Getting started</a></li>
                  <li class="section"><a class="header" href="authors-charm-components.html">Components of a charm</a>
                    <ul class="sub">
                      <li><a href="authors-charm-metadata.html">metadata.yaml</a></li>
                      <li><a href="authors-charm-hooks.html">/hooks</a></li>
                      <li><a href="authors-charm-actions.html">/actions and actions.yaml</a></li>
                      <li><a href="authors-charm-benchmarks.html">Benchmarks (optional)</a></li>
                      <li><a href="authors-charm-config.html">config.yaml</a></li>
                    </ul>
                  </li>
                  <li class="section"><a class="header" href="authors-charm-writing.html">Charm walkthrough</a>
                    <ul class="sub">
                      <li><a href="authors-hook-environment.html">How hooks are run (Hook API)</a></li>
                      <li><a href="authors-relations-in-depth.html">Relations lifecycle</a></li>
                      <li><a href="authors-relations.html">Implementing relations</a></li>
                      <li><a href="authors-hook-errors.html">Hook Errors</a></li>
                      <li><a href="authors-hook-debug.html">Hook Debugging</a></li>
                      <li><a href="authors-hook-debug-dhx.html">Hook Debugging with DHX</a></li>
                      <li><a href="authors-subordinate-services.html">Subordinate services</a></li>
                      <li><a href="authors-implicit-relations.html">Implicit Relations</a></li>
                      <li><a href="authors-testing.html">Charm Testing</a></li>
                    </ul>
                  </li>
                  <li class="section"><a class="header" href="authors-charm-store.html">The Juju Charm Store</a>
                    <ul class="sub">
                      <li><a href="authors-charm-store.html#submitting">Submit a charm</a></li>
                      <li><a href="authors-charm-policy.html">Charm store policy</a></li>
                      <li><a href="charm-review-process.html">Charm review process</a></li>
                      <li><a href="authors-charm-best-practice.html">Best practices</a></li>
                      <li><a href="authors-charm-icon.html">Charm Icons</a></li>
                    </ul>
                  </li>
                </ul>
              <li>
              <li class="section"><h4 class="header toggle-target">Experimental</h4>
                <ul>
                  <li><a href="wip-storage.html">Storage</a></li>
                  <li><a href="wip-centos.html">CentOS support</a></li>
                  <li><a href="wip-numbering.html">Machine/unit numbering</a></li>
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
                  <li><a href="reference-releases.html">Releases</a></li>
                  <li><a href="reference-release-notes.html">Release notes</a></li>
                  <li><a href="reference-status.html">Status values</a></li>
                  <li><a href="glossary.html">Glossary</a></li>
                  <li><a href="reference-reviewers.html">Charm Review Criteria</a></li>
                  <li><a href="contributing.html">Contribute to the Docs!</a></li>
                </ul>
              </li>
            </ul>
