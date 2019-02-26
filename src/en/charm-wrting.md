Title: Charm writing

# Charm writing

    children:
    - title: Getting Started
      location: developer-getting-started.md

      children:
        - title: Prerequisites and Tools
          location: developer-getting-started#install-libraries-and-tools.md
        - title: Designing your Charm
          location: developer-getting-started#designing-your-charm.md
        - title: Writing your Charm
          location: developer-getting-started#writing-your-charm.md
        - title: Testing your Charm
          location: developer-getting-started#testing-your-charm.md
        - title: Next steps
          location: developer-getting-started#next-steps.md

    - title: Event Cycle
      location: developer-event-cycle.md

      children:
      - title: Handling Reactive States
        location: developer-event-cycle#handling-reactive-states.md

    - title: Charm Layers
      location: developer-layers.md

      children:
        - title: What are Layers
          location: developer-layers#what-are-layers?.md
        - title: States
          location: developer-layers#states.md
        - title: How to Write a Layer
          location: developer-layer-example.md

    - title: Interface Layers
      location: developer-layers-interfaces.md

      children:
        - title: Design Considerations
          location: developer-layers-interfaces#design-considerations.md
        - title: Communication Scopes
          location: developer-layers-interfaces#communication-scopes.md
        - title: Writing an Interface
          location: developer-layers-interfaces#writing-an-interface-layer.md

    - title: Upgrading
      location: developer-upgrade-charm.md
    - title: Juju Terms
      location: developer-terms.md
    - title: Juju Metrics
      location: developer-metrics.md
    - title: Juju Resources
      location: developer-resources.md
    - title: Network Primitives
      location: developer-network-primitives.md
    - title: Implementing Leadership
      location: developer-leadership.md

      children:
        - title: Leadership Hooks
          location: developer-leadership#leadership-hooks.md
        - title: Leadership Tools
          location: developer-leadership#leadership-tools.md
        - title: Leadership Howtos
          location: developer-leadership-howtos.md

    - title: Implementing Actions
      location: developer-actions.md

      children:
        - title: Defining Actions
          location: developer-actions#implementing-actions.md
        - title: Action Tools
          location: developer-actions#action-tools.md

    - title: Implementing Storage
      location: developer-storage.md

      children:
        - title: Adding Storage
          location: developer-storage#adding-storage.md
        - title: Storage Hooks
          location: developer-storage#storage-hooks.md

    - title: Writing Tests
      location: developer-testing.md

      children:
        - title: Charm Proof
          location: developer-testing#charm-proof.md
        - title: Amulet
          location: developer-testing#amulet.md
        - title: BundleTester
          location: developer-testing#bundletester.md

    - title: Debugging
      location: developer-debugging.md

      children:
        - title: Debugging Layers
          location: developer-debug-layers.md
        - title: debug-hooks
          location: developer-debugging#the-'debug-hooks'-command.md
        - title: debug-log
          location: developer-debugging#the-'debug-log'-command.md
        - title: DHX
          location: developer-debug-dhx.md

    - title: How to...
      location: developer-howto.md

      children:
        - title: Charm with Docker
          location: howto-charm-with-docker.md

    - title: Charm Authors
      location: authors-intro.md

      children:
        - title: How hooks are run (Hook API)
          location: authors-hook-environment.md
        - title: Relations lifecycle
          location: authors-relations-in-depth.md
        - title: Implementing relations
          location: authors-relations.md
        - title: Charm leadership
          location: authors-charm-leadership.md
        - title: Hook Errors
          location: authors-hook-errors.md
        - title: Subordinate applications
          location: authors-subordinate-applications.md

    - title: The Juju Charm Store
      location: authors-charm-store.md

      children:
        - title: Submit a charm
          location: authors-charm-store#submitting-a-new-charm.md
        - title: Charm store policy
          location: authors-charm-policy.md
        - title: Best practices
          location: authors-charm-best-practice.md
        - title: Charm Icons
          location: authors-charm-icon.md
