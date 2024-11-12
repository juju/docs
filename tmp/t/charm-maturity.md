(charm-maturity)=
# Charm maturity

Charms are built for reuse. Having reuse in mind, the design and implementation of a charm needs to  be independent from particular use cases or domains. But how can you ensure reuse?

The best way to enable reuse is to start an open source project. Open source brings experts together; they can participate in the development and contribute their knowledge from their different backgrounds. In addition, the open source approach offers transparency and lets users and developers freely use, modify, analyse and redistribute the software. Read more about [reasons to publish your charm in our documentation](https://juju.is/docs/sdk/reasons-to-publish-your-charm-on-charmhub).

- [Two stages of maturity](#heading--two-stages-of-maturity)
- [Requirements for public listing](#heading--requirements-for-public-listing)

<a href="#heading--two-stages-of-maturity"><h2 id="heading--two-stages-of-maturity">Two stages of maturity</h2></a>


An open source project is the suitable foundation for reuse. However, providing a reusable charm is also a matter of maturity: high-quality software development and relevant capabilities for operating applications. Accordingly, the development of a charm follows a two-stage approach:

1. {ref}`Stage 1: Important qualities <stage-1-important-qualities>`: A quality open source project, implements state-the-art documentation, testing and automation - this is the foundation for sharing and effective collaboration.

2. {ref}`Stage 2: Important capabilities <stage-2-important-capabilities>` are about implementing the most relevant capabilities to ensure effective operations.

For both stages, the reference documents above provide two parts: a first part explains the goals and a second part lists references to the documentation or example code for implementation. The points listed in the stages prioritise the development and explain how to implement the qualities and capabilities using the [Charm SDK](https://juju.is/docs/sdk). For general best practices for developing a charm, please read the [Charm development best practices](https://juju.is/docs/sdk/styleguide).

<a href="#heading--requirements-for-public-listing"><h2 id="heading--requirements-for-public-listing">Requirements for public listing</h2></a>

Everyone can publish charms to [https://charmhub.io/](https://charmhub.io/). Then, the charm can be accessed for deployments using Juju or via a web browser by its URL. If a charm is published in Charmhub.io and included in search results, the charm entry needs to be switched into the listed mode. To bring your charm into the listing, [reach out to the community](https://discourse.charmhub.io/c/charmhub-requests/46) to announce your charm and ask for a review by an experienced community member. 

The [Stage 1- Important qualities](https://juju.is/docs/sdk/charm-publication-checklist) reference is the requirement for switching a charm into the *listed* mode. The points listed in the first stage ensure a useful charm project is suitable for presentation on [https://charmhub.io/](https://charmhub.io/) and for testing by others.